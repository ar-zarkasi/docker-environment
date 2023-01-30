This is a place put your nginx web config
after that, please reload nginx in container

```bash
docker exec -it {container_id_or_name} /bin/bash "service nginx reload"
```