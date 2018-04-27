# Docker DB SSH Tunnel

Create a tunnel to connect to remote databases (MySQL, SQL Server, PostgreSQL).

#### Disclaimer

> It used `sshpass` that considered as insecure because exposing plain password. Use this with your own risk!

## Build Image

Provide this parameter on build you don't need to feed *environment* variables on running. Or if you don't want to rebuild the image for specific purpose, you cann pass it by passing *environment* variables.

```console
docker build -t vendor/name:version \
    --build-arg SSH_HOST=tunnel_ssh_host \
    --build-arg SSH_USER=tunnel_ssh_user \
    --build-arg SSH_PASSWORD=tunnel_ssh_password \ 
    --build-arg DB_HOST=tunneled_db_host \
    --build-arg DB_PORT=tunneled_db_host \
    .
```

The default value of `DB_HOST` is `localhost` and default value of `DB_PORT` is `3306` (MySQL).

If you're using SQL Server or PostgreSQL, just point the `DB_PORT` to `1433` (SQL Server) or `5432` (PostgreSQL).

### Example Build

Fore example, MySQL database on 10.1.2.3 and we have to connect to host 10.1.2.10, the SSH user for host 10.1.2.10 is `user` and the password is `secret`. We want to tunnel the connection to local on port `3333`.

We give them name `matriphe/tunnel:mysql1` so when we want to use this tunnel, we just create the container.

So we can build the image like this.

```console
docker build -t matriphe/tunnel:mysql1 \
    --build-arg SSH_HOST=10.1.2.10 \
    --build-arg SSH_USER=user \
    --build-arg SSH_PASSWORD=secret \ 
    --build-arg DB_HOST=10.1.2.3 \
    --build-arg DB_PORT=3306 \
    .
```

### Example Usage

To use the image, just run as usual. For example above, run this command.

```console
docker run -d \
    --name=mysql1 \
    -p 3333:3306 \
    matriphe/tunnel:mysql1 
```

Now you can access MySQL on 10.1.2.3 from your host via tunnel.

```console
mysql -u mysqlusername -p -P 3333 -h 127.0.0.1
```

## Using Environment

If you don't want to rebuild images, you can use *environment* on running. For example, with same image, we want to connect to other server located on 192.168.1.123 with user `newuser` and password `newsecret` on SSH port `2222`. We can use this command.

```console
docker run -d \
    --name=mysql2 \
    -p 3333:3306 \
    -e SSH_HOST=192.168.1.123 \
    -e SSH_USER=newuser \
    -e SSH_PASSWORD=newsecret \
    -e SSH_PORT=2222 \
    -e DB_HOST=localhost \
    matriphe/tunnel:mysql1 
```
