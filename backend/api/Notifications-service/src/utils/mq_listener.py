import threading
import pika


def callback(ch, method, properties, body):
    """
    Callback function to process messages from the RabbitMQ queue.

    Args:
        ch: The channel object.
        method: Delivery method.
        properties: Message properties.
        body: The message body.
    """
    print(f"Received message: {body}")


def start_listener():
    """
    Starts a RabbitMQ listener in a separate thread.

    The listener connects to a RabbitMQ server, declares a queue, and consumes
    messages from the 'notification_queue'. Messages are processed using the
    `callback` function.
    """
    def run():
        connection = pika.BlockingConnection(
            pika.ConnectionParameters('localhost'))
        channel = connection.channel()
        channel.queue_declare(queue='notification_queue')

        channel.basic_consume(
            queue='notification_queue',
            on_message_callback=callback,
            auto_ack=True)

        print('RabbitMQ listener running...')
        channel.start_consuming()

    thread = threading.Thread(target=run)
    thread.start()
