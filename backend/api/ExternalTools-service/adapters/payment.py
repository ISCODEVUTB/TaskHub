from .manager import ExternalTool


class PaymentAdapter(ExternalTool):
    def execute(self, data):
        # Logica simulada de procesamiento de pago
        amount = data.get("amount", 0)
        return {"status": "success", "charged": amount}
