## Installation

- Installs RabbitMQ & Redis
- Adds user to RabbitMQ
- Installs dashboard

```bash
git clone https://github.com/tkjef/vagrant_rabbitmq_server.git rabbitmq_server
cd rabbitmq_server
vagrant up
vagrant status
vagrant ssh rabbitmq-server
```

You can then test the install from your local computer
```bash
curl -IL 192.168.56.20:15672
```

Navigate to `192.168.56.20:15672` to manage RabbitMQ
```yaml
username: matchmaker
password: correct-horse-battery-staple
```
