Using Your PHP Application in docker

1. Copy .env.example to .env
2. fill .env with your spec application
3. open cmd/terminal and build with this command

```bash
docker compose -f {file_docker_compose} -f {file_docker_network} --env-file={"location .env file"} up -d --build
```

4. after build complete, copy nginx config example to nginx conf folder and setup with your spec.
5. reload/restart nginx
6. open your etc/hosts file and fill
```
127.0.0.1       yourdomain.local or something else
```
7. save etc/hosts and access into your browser