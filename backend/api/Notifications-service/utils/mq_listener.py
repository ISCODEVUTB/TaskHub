import threading
import pika


def callback(ch, method, properties, body):
    print(f"Received message: {body}")


def start_listener():
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
