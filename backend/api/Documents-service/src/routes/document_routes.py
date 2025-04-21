import os
import shutil
import requests
from fastapi import APIRouter, UploadFile, File, Depends, HTTPException, Form
from sqlalchemy.orm import Session
from datetime import datetime
from database import SessionLocal
from src.models.document import Document as DocumentModel
from src.models.document_schema import Document

router = APIRouter()
UPLOAD_DIR = "uploads"

if not os.path.exists(UPLOAD_DIR):
    os.makedirs(UPLOAD_DIR)


def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


def notify(action: str, doc_id: int):
    try:
        requests.post("http://notification-service/notify", json={
            "action": action,
            "document_id": doc_id
        })
    except requests.RequestException as e:
        print(f"No se pudo notificar la acción {action} \
              del documento {doc_id}: {e}")


@router.post("/", response_model=Document)
def subir_documento(
    nombre: str = Form(...),
    proyecto_id: int = Form(...),
    archivo: UploadFile = File(...),
    db: Session = Depends(get_db)
):
    timestamp = datetime.now(datetime.timezone.utc).timestamp()
    filename = f"{timestamp}_{archivo.filename}"
    path = os.path.join(UPLOAD_DIR, filename)

    with open(path, "wb") as buffer:
        shutil.copyfileobj(archivo.file, buffer)

    db_doc = DocumentModel(
        nombre=nombre,
        proyecto_id=proyecto_id,
        archivo=path
    )
    db.add(db_doc)
    db.commit()
    db.refresh(db_doc)

    notify("subido", db_doc.id)
    return db_doc


@router.get("/", response_model=list[Document])
def listar_documentos(db: Session = Depends(get_db)):
    return db.query(DocumentModel).all()


@router.delete("/{doc_id}")
def eliminar_documento(doc_id: int, db: Session = Depends(get_db)):
    doc = db.query(DocumentModel).filter(DocumentModel.id == doc_id).first()
    if not doc:
        raise HTTPException(status_code=404, detail="Documento no encontrado")

    if os.path.exists(doc.archivo):
        os.remove(doc.archivo)

    db.delete(doc)
    db.commit()

    notify("eliminado", doc_id)
    return {"msg": "Documento eliminado"}
