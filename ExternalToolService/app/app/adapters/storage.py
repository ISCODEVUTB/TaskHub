from .manager import ExternalTool


class CloudStorageAdapter(ExternalTool):
    def execute(self, data):
        # Logica simulada de URL de almacenamiento
        filename = data.get("filename", "file.txt")
        return {"url": f"https://storage.example.com/{filename}"}
