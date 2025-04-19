from .manager import ExternalTool


class AIServiceAdapter(ExternalTool):
    def execute(self, data):
        # Lógica de IA simulada
        content = data.get("content", "")
        return {"summary": content[:100], "sentiment": "positive"}
