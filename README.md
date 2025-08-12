# 200ok

Tiny NGINX-based image that exposes five **POST-only** endpoints and returns 200 `OK`. Built on `nginx:alpine-slim`.

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
# Pull
docker pull riot5576/200ok:latest

# Run
docker run -d   --name 200ok-server   -p 80:80   --restart unless-stopped   riot5576/200ok:latest
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
# /etc/nginx/conf.d/default.conf
server {
    listen 80;
    server_name _;          # catch-all host

    default_type text/html;

    ### Register2.aspx -----------------------------------------------
    location = /Register2.aspx {
        add_header Allow "POST" always;
        if ($request_method != POST) { return 405; }
        return 200 "OK";
    }

    ### CheckRuntimePerpetual.aspx -----------------------------------
    location = /CheckRuntimePerpetual.aspx {
        add_header Allow "POST" always;
        if ($request_method != POST) { return 405; }
        return 200 "OK";
    }

    ### CheckRuntimeNetwork.aspx -------------------------------------
    location = /CheckRuntimeNetwork.aspx {
        add_header Allow "POST" always;
        if ($request_method != POST) { return 405; }
        return 200 "OK";
    }

    ### CheckLicense.aspx --------------------------------------------
    location = /CheckLicense.aspx {
        add_header Allow "POST" always;
        if ($request_method != POST) { return 405; }
        return 200 "OK";
    }

    ### CheckRuntimeNetworkSecure.aspx -------------------------------
    location = /CheckRuntimeNetworkSecure.aspx {
        add_header Allow "POST" always;
        if ($request_method != POST) { return 405; }
        return 200 "OK";
    }
}

```

- Default content type: `text/html`
- Listens on port **80**

---

## Build it yourself (optional)

```dockerfile
FROM nginx:alpine
COPY default.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
```

```bash
docker build -t <your-tag> .
docker run -d -p 80:80 --name 200ok-server <your-tag>
```

---

## Docker Compose (optional)

```yaml
services:
  license:
    image: riot5576/200ok:latest
    container_name: 200ok-server
    ports:
      - "80:80"
    restart: unless-stopped
```

---

## Notes & tips

- If a container with the same name already exists, remove it first:  
  `docker rm -f 200ok-server`
- Want TLS? Put this behind your existing reverse proxy/ingress, or extend the image with your own server block that listens on 443.
- Rate limiting or IP allowlists can be added with standard NGINX directives (`limit_req`, `allow`/`deny`) per `location`.

---

## License

**The Unlicense**

This is free and unencumbered software released into the public domain.

Anyone is free to copy, modify, publish, use, compile, sell, or
distribute this software, either in source code form or as a compiled
binary, for any purpose, commercial or non-commercial, and by any
means.

In jurisdictions that recognize copyright laws, the author or authors
of this software dedicate any and all copyright interest in the
software to the public domain. We make this dedication for the benefit
of the public at large and to the detriment of our heirs and
successors. We intend this dedication to be an overt act of
relinquishment in perpetuity of all present and future rights to this
software under copyright law.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

For more information, please refer to <https://unlicense.org/>
