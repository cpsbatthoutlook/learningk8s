### [ActiveMQ](https://www.digitalocean.com/community/tutorials/how-to-install-and-manage-rabbitmq)
####  Installing Ubuntu

```
apt-get    update 
apt-get -y upgrade
echo "deb http://www.rabbitmq.com/debian/ testing main" >> /etc/apt/sources.list
curl http://www.rabbitmq.com/rabbitmq-signing-key-public.asc | sudo apt-key add -
apt-get update
sudo apt-get install rabbitmq-server
sudo nano /etc/default/rabbitmq-server ## Uncomment the limit
```

#### Managing
```
sudo rabbitmq-plugins enable rabbitmq_management
service rabbitmq-server start  # To start the service:
service rabbitmq-server stop   # To stop the service:
service rabbitmq-server restart   # To restart the service:
service rabbitmq-server status  # To check the status:
```
#### [Configuration](https://www.rabbitmq.com/configure.html)
