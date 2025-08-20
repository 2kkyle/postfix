# 📬 Postfix Docker Relay

Minimal Dockerized **Postfix** SMTP relay with:

- `myhostname`, `mynetworks` and `relayhost` configuration via environment variables  
- Outbound **TLS support** using system CA certificates  
- Logging to **stdout** (`maillog_file = /dev/stdout`)  
- Runs in foreground via `postfix start-fg`  

---

## Features

- Lightweight image based on `debian:stable-slim`
- TLS encryption via `smtp_use_tls` and system CA bundle
- Logs delivered to Docker logging drivers (stdout)
- Runtime config via environment variables

---

## Configuration

### Environment Variables

| Variable     | Description                          | Example                         |
|--------------|--------------------------------------|----------------------------------|
| `RELAYHOST`  | SMTP relay server and port           | `[smtp.example.com]:587`        |
| `MYNETWORKS` | Networks allowed to relay            | `127.0.0.0/8 172.18.0.0/16`     |

These are substituted into the `main.cf` at container startup via `envsubst`.

---

## Usage

### 1. Clone the Repository

```bash
git clone https://github.com/yourname/postfix-docker-relay.git
cd postfix-docker-relay
```

### 2. Start the Container

```bash
docker-compose up --build
```

Postfix will start in the foreground and log to stdout.

---

## Sending Test Mail

Run inside the container:

```bash
docker exec -it postfix sendmail recipient@example.com
```

Or use:

```bash
docker exec postfix bash -c 'echo "Test body" | mail -s "Test Subject" recipient@example.com'
```

---

## Logs

Logs are directed to `stdout` via Postfix config:

```postconf
maillog_file = /dev/stdout
```

View them using:

```bash
docker logs -f postfix
```

---

## Networking

The provded docker-compose uses host networking. You'll have to do what you need to do with that, different use cases will need different configuration.

```yaml
network_mode: host
```

---

## TLS Configuration

TLS is enabled by default in `main.cf`:

```postconf
smtp_use_tls = yes
smtp_tls_security_level = encrypt
smtp_tls_CAfile = /etc/ssl/certs/ca-certificates.crt
```

No additional setup is needed for standard public SMTP servers with valid certs.

For SMTPD TLS Suppport create files:
```
certs/postfix.key
certs/postfix.crt
```

Use OpenSSL to make them:
```
openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -sha256 -days 3650 -nodes -subj "/C=<YOUR COUNTRY>/ST=<YOUR STATE>/L=<YOUR TOWN>/O=<YOUR ORG>/OU=<YOUR OU>/CN=<YOUR NAME>"

---

## Project Structure

```
.
├── Dockerfile
├── docker-compose.yml
├── postfix/
│   ├── main.cf
│   └── entrypoint.sh
└── README.md
```

---

## SMTP Authentication (TODO)

To authenticate with relay servers (like Gmail, SendGrid), you'll need to:

1. Enable SASL in `main.cf`
2. Mount a `sasl_passwd` file
3. Hash it with `postmap`
4. Update Postfix to use the map
