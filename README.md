## Image details

1. Based on debian:stretch
1. Key-Features:
   - solidmatter
   - MySQL
   - Apache2
1. No SSH. Use docker [exec](https://docs.docker.com/engine/reference/commandline/exec/) or [nsenter](https://github.com/jpetazzo/nsenter)

## build

```
docker build --build-arg GITREF_SOLIDMATTER=develop -t solidmatter .
```

| Build Argument                 | Default Value | Description                            |
| ------------------------------ | ------------- | -------------------------------------- |
| `GITREF_SOLIDMATTER`           | develop       | Set to GIT TREE-ISH                    |

## run
```
docker run -p 8080:80 -d solidmatter
```

## manual start
```
docker run -i -t -p 8099:80 solidmatter /bin/bash
```

# Reference

## Environment variables Reference

| Environmental Variable         | Default Value | Description                            |
| ------------------------------ | ------------- | -------------------------------------- |
| `SOLIDMATTER_SERVERNAME`       | dev           | Set the VirtualHost Servername         |
| `SOLIDMATTER_SERVERALIAS1`     | dev           | Set the VirtualHost Servername         |
| `SOLIDMATTER_SERVERALIAS2`     | dev.frontend  | Set the VirtualHost Servername         |
| `SOLIDMATTER_SERVERALIAS3`     | dev.backend   | Set the VirtualHost Servername         |
| `SOLIDMATTER_MYSQL_USER`       | solidmatter   | The MySQL user to access the database  |
| `SOLIDMATTER_MYSQL_PASS`       | solidmatter   | The password for the MySQL user        |
| `SOLIDMATTER_MYSQL_DATABASE`   | solidmatter   | The database for solidmatter           |

## Volume Reference

These folders are configured and able to get mounted as volume.

| Volume          | ro/rw | Description & Usage    |
| --------------- | ----- | ---------------------- |
| /media          | ro    | music                  |
| /var/lib/mysql  | rw    | MySQL/MariaDB Database |
