# Notification-Service

## Descripción General

El `notification-service` es un microservicio responsable de gestionar el envío de notificaciones por correo electrónico y notificaciones push. Utiliza FastAPI para la capa de API y se integra con servicios externos para el envío de notificaciones.

---

## Estructura de Carpetas

📁 notification-service  
├── 📁 models  
│   ├── 📄 schemas.py  
├── 📁 utils  
│   ├── 📄 email_sender.py  
│   ├── 📄 push_sender.py  
│   ├── 📄 mq_listener.py  
├── 📄 notification_service.py  
├── 📄 main.py  

---

## Descripción de Archivos

### 1. `models/schemas.py`

- Contiene modelos de Pydantic para la validación de solicitudes y respuestas.
- Ejemplo:

  ```python
  class EmailRequest(BaseModel):
      to: str
      subject: str
      body: str
  ```

### 2. `utils/email_sender.py`

- Maneja el envío de correos electrónicos utilizando un servidor SMTP.
- Ejemplo:

  ```python
  def send_email(to: str, subject: str, body: str) -> bool:
      """Envía un correo electrónico al destinatario especificado."""
  ```

### 3. `utils/push_sender.py`

- Maneja el envío de notificaciones push utilizando Firebase Cloud Messaging.
- Ejemplo:

  ```python
  def send_push_notification(user_id: str, title: str, message: str) -> bool:
      """Envía una notificación push al usuario especificado."""
  ```

### 4. `utils/mq_listener.py`

- Escucha mensajes de una cola de mensajes (RabbitMQ) para procesar notificaciones.
- Ejemplo:

  ```python
  def start_listener():
      """Inicia un listener para procesar mensajes de la cola."""
  ```

### 5. `notification_service.py`

- Implementa la lógica principal para el envío de notificaciones, incluyendo correos electrónicos y notificaciones push.
- Ejemplo:

  ```python
  def send_email(self, to: str, subject: str, body: str) -> bool:
      """Envía una notificación por correo electrónico."""
  ```

### 6. `main.py`

- Define la aplicación FastAPI y las rutas para el servicio de notificaciones.
- Ejemplo:

  ```python
  @router.post("/email")
  def send_email(request: EmailRequest):
      """Punto de entrada para enviar notificaciones por correo electrónico."""
  ```

---

## Funcionalidades

- **Notificaciones por Correo Electrónico**: Envía correos electrónicos a los destinatarios especificados.
- **Notificaciones Push**: Envía notificaciones push a dispositivos utilizando Firebase.
- **Procesamiento de Mensajes**: Escucha y procesa mensajes de una cola de mensajes (RabbitMQ).

---

## Flujo de Datos

1. El cliente envía una solicitud para enviar una notificación (correo electrónico o push).
2. El servicio valida la solicitud utilizando los modelos de Pydantic.
3. Dependiendo del tipo de notificación, se utiliza el servicio correspondiente (`email_sender` o `push_sender`).
4. Si se utiliza una cola de mensajes, el listener procesa los mensajes y envía las notificaciones.

---

## Consideraciones

- **Configuración**: Asegúrate de configurar correctamente las credenciales del servidor SMTP y Firebase.
- **Escalabilidad**: El servicio puede escalar horizontalmente para manejar un alto volumen de notificaciones.
- **Extensibilidad**: Es fácil agregar nuevos métodos de notificación o integraciones con otros servicios.
