# INTRODUCTION

This is my docker compose use for my workspace develop environment

## Setup

- copy .env.example to .env
- update .env, adjust for you need
- run
```bash
docker compose -f docker-compose.yml --env-file=.env up -d --build
```
- set your local domain in nginx conf folder (nginx/conf.d/dbconfig.conf)
- in windows, edit C:/Windows/System32/driver/etc/hosts for register local domain as a container nginx configuration, then restart first
- in linux/mac edit in /etc/hosts file for register local domain
- access localdomain in your browser
