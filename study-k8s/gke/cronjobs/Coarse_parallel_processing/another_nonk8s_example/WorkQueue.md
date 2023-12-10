### [WorkQueues using Pika](https://www.rabbitmq.com/tutorials/tutorial-one-python.html)
* RabbitMQ is installed as a SVC and running on publicIP on the standard port (5672). 


#### [Using distroless images](https://github.com/GoogleContainerTools/distroless/blob/main/examples/python3/Dockerfile)
```
 sudo docker pull gcr.io/distroless/python3:latest
 sudo docker pull python:3-slim
 sudo docker run -it --rm --name py3slim -v `pwd`:/app python:3-slim sh

python -m  pip install --upgrade pip
python -m pip install pika --upgrade

python send.py  #to 'Hello' queue
```

Checking the messages in queue
```
sudo rabbitmqctl list_queues
```

#### [WorkQueues](https://www.rabbitmq.com/tutorials/tutorial-two-python.html)
For multiple parallel jobs

#### [Pub/Sub](https://www.rabbitmq.com/tutorials/tutorial-three-python.html)


####  [Topics](https://www.rabbitmq.com/tutorials/tutorial-five-python.html)
