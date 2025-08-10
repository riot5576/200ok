# nginx-license-server

Tiny NGINX-based image that exposes five **POST-only** endpoints and returns `OK` for license checks. Built on `nginx:alpine`.

## What it does

- Responds with `200 OK` and body `OK` (`text/html`) **only** to `POST` requests.
- Returns `405 Method Not Allowed` (with `Allow: POST`) for any other method.

### Endpoints

| Path |
|------|
| `/Register2.aspx` |
| `/CheckRuntimePerpetual.aspx` |
| `/CheckRuntimeNetwork.aspx` |
| `/CheckLicense.aspx` |
| `/CheckRuntimeNetworkSecure.aspx` |

---

## Quick start

```bash
# Pull (replace with your repo/tag)
docker pull <your-dockerhub-username>/nginx-license-server:latest

# Run
docker run -d   --name license-endpoints   -p 80:80   --restart unless-stopped   <your-dockerhub-username>/nginx-license-server:latest
```

### Verify

```bash
# Should return: OK
curl -X POST http://localhost/Register2.aspx

# Should return: 405 and Allow: POST
curl -i http://localhost/Register2.aspx
```

---

## Configuration

This image ships a single config at `/etc/nginx/conf.d/default.conf` with **one `location` per endpoint**, e.g.:

```nginx
location = /Register2.aspx {
    add_header Allow "POST" always;
    if ($request_method != POST) { return 405; }
    return 200 "OK";
}
```

- Default content type: `text/html`
- Listens on port **80**

If you need different bodies, headers, or content types, override the image with your own `default.conf`.

---

## Build it yourself (optional)

```dockerfile
FROM nginx:alpine
COPY default.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
```

```bash
docker build -t <your-tag> .
docker run -d -p 80:80 --name license-endpoints <your-tag>
```

---

## Docker Compose (optional)

```yaml
services:
  license:
    image: <your-dockerhub-username>/nginx-license-server:latest
    container_name: license-endpoints
    ports:
      - "80:80"
    restart: unless-stopped
```

---

## Notes & tips

- If a container with the same name already exists, remove it first:  
  `docker rm -f license-endpoints`
- Want TLS? Put this behind your existing reverse proxy/ingress, or extend the image with your own server block that listens on 443.
- Rate limiting or IP allowlists can be added with standard NGINX directives (`limit_req`, `allow`/`deny`) per `location`.

---

## License

Same as the repository this image is published from. If unspecified, all rights reserved by the publisher.

