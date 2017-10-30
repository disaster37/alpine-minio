alpine-minio
===============

This image permit run Minio Cloud Storage as standalone or as a cluster.

## How use it

### standalone

With only one disk:
```bash
docker run --rm --name minio-standalone \
  -e 'MINIO_CONFIG_accesskey=my_key' \
  -e 'MINIO_CONFIG_secretkey=my_long_secret_key' \
  -v $PWD/data/minio:/data \
  -p 9000:9000 \
  webcenter/alpine-minio:latest
```

Or use docker-compose:
```bash
docker-compose up
```

With many disks:
```bash
docker run --rm --name minio-standalone \
  -e 'MINIO_CONFIG_accesskey=my_key' \
  -e 'MINIO_CONFIG_secretkey=my_long_secret_key' \
  -e 'MINIO_DISKS_1=disk1' \
  -e 'MINIO_DISKS_2=disk2' \
  -e 'MINIO_DISKS_3=disk3' \
  -e 'MINIO_DISKS_4=disk4' \
  -v /disk1:/data/disk1 \
  -v /disk2:/data/disk2 \
  -v /disk3:/data/disk3 \
  -v /disk4:/data/disk4 \
  -p 9000:9000 \
  webcenter/alpine-minio:latest
```

### Cluster
You need to have a minimal of 3 nodes and 4 disks. So if you use only one disk per nodes, you need to have 4 nodes.

```bash
docker run --rm --name minio1 \
  -e 'MINIO_CONFIG_accesskey=my_key' \
  -e 'MINIO_CONFIG_secretkey=my_long_secret_key' \
  -e 'MINIO_SERVERS_1=minio1' \
  -e 'MINIO_SERVERS_2=minio2' \
  -e 'MINIO_SERVERS_3=minio3' \
  -e 'MINIO_SERVERS_4=minio4' \
  -v /mnt/minio:/data \
  --links minio2:minio2 \
  --links minio3:minio3 \
  --links minio4:minio4 \
  -p 9000:9000 \
  webcenter/alpine-minio:latest

docker run --rm --name minio2 \
  -e 'MINIO_CONFIG_accesskey=my_key' \
  -e 'MINIO_CONFIG_secretkey=my_long_secret_key' \
  -e 'MINIO_SERVERS_1=minio1' \
  -e 'MINIO_SERVERS_2=minio2' \
  -e 'MINIO_SERVERS_3=minio3' \
  -e 'MINIO_SERVERS_4=minio4' \
  -v /mnt/minio:/data \
  --links minio1:minio1 \
  --links minio3:minio3 \
  --links minio4:minio4 \
  webcenter/alpine-minio:latest

docker run --rm --name minio3 \
  -e 'MINIO_CONFIG_accesskey=my_key' \
  -e 'MINIO_CONFIG_secretkey=my_long_secret_key' \
  -e 'MINIO_SERVERS_1=minio1' \
  -e 'MINIO_SERVERS_2=minio2' \
  -e 'MINIO_SERVERS_3=minio3' \
  -e 'MINIO_SERVERS_4=minio4' \
  -v /mnt/minio:/data \
  --links minio1:minio1 \
  --links minio2:minio2 \
  --links minio4:minio4 \
  webcenter/alpine-minio:latest

docker run --rm --name minio4 \
  -e 'MINIO_CONFIG_accesskey=my_key' \
  -e 'MINIO_CONFIG_secretkey=my_long_secret_key' \
  -e 'MINIO_SERVERS_1=minio1' \
  -e 'MINIO_SERVERS_2=minio2' \
  -e 'MINIO_SERVERS_3=minio3' \
  -e 'MINIO_SERVERS_4=minio4' \
  -v /mnt/minio:/data \
  --links minio1:minio1 \
  --links minio2:minio2 \
  --links minio3:minio3 \
  webcenter/alpine-minio:latest
```


### Parameters

#### Confd

The Minio setting is managed by Confd. So you can custom it:
- **CONFD_BACKEND**: The Confd backend that you should use. Default is `env`.
- **CONFD_NODES**: The array of Confd URL to contact the backend. No default value.
- **CONFD_PREFIX_KEY**: The Confd prefix key. Default is `/minio`


#### Minio

The following parameter permit to config minio server:
- **MINIO_CONFIG_accesskey**: The access key to connect on Minio.
- **MINIO_CONFIG_secretkey**: The secret key to connect on Minio.
- **MINIO_DISKS_X**: The list of disks to use by Minio. For example `-e MINIO_DISKS_1=disk1` and `-e MINIO_DISKS_2=disk2`. Minio will inialize storage `/data/disk1` and `/data/disk2`.
- **MINIO_SERVERS_X**: The list of server to create a Minio cluster. For example `-e MINIO_SERVERS_1=10.0.0.1` and `-e MINIO_SERVERS_2=10.0.0.2`



> The default disk called `disk0`is use if you not specify any disk.