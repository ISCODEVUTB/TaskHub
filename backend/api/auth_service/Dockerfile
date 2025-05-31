# Usa la imagen base de Python 3.13 en Alpine
FROM python:3.13-alpine

# Establece las variables de entorno para el host y el puerto
ENV PYTHONUNBUFFERED=1

# Establece el directorio de trabajo en /app
WORKDIR /app

# Copia el archivo de requisitos
COPY requirements.txt .

# Instala las dependencias del sistema operativo necesarias para la instalación de las dependencias de Python
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt


COPY . .
# Expande HOST y PORT desde las variables de entorno ya cargadas
CMD ["sh", "-c", "uvicorn main:app --host=$HOST --port=$PORT --reload --reload-dir=/app"]