import pika, os, threading, json


class Consumer(threading.Thread):  #
    def __init__(self, callback, queue_name="wandb_queue"):
        threading.Thread.__init__(self)
        # Access the CLODUAMQP_URL environment variable and parse it (fallback to localhost)
        url = os.environ.get('AMQP_URL', 'amqp://guest:guest@localhost:5672/%2f')
        params = pika.URLParameters(url)
        self.callback = callback
        self.queue_name = queue_name
        #self.connection = pika.BlockingConnection(params)
        self.connection = pika.BlockingConnection(params)
        self.channel = self.connection.channel()  # start a channel
        self.channel.queue_declare(queue=self.queue_name)  # Declare a queue
        # self.channel.basic_consume(self.queue_name,
        #                   callback,
        #                   auto_ack=True)

    def start_consuming(self):
        i = 0
        method_frame, header_frame, body = self.channel.basic_get(queue=self.queue_name)
        while method_frame is not None:
            # print(method_frame, header_frame, body)
            #if i % 10000 == 0:
            payload = json.loads(body)
            pretty_print("Consuming {}.{}".format(payload, i), Colors.FAIL)
            self.callback(payload)
            # i += 1

            method_frame, header_frame, body = self.channel.basic_get(queue=self.queue_name)
        # pretty_print(' [*] Waiting for messages:', Colors.FAIL)
        # self.channel.start_consuming()

    def run(self):
        self.start_consuming()

    def close_connection(self):
        self.connection.close()
