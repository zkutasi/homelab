# Redis

Redis is an in-memory Key Value store, that is usually used for caching.

## Requirements

- Free and Open source, preferably 0$ cost
- Fully compatible with the Redis APIs and a drop-in replacement for any client expecting Redis
- Fully cloud Native, preferably with an Operator to manage the Redis deployments via CRs

## Contenders

- [Valkey](https://valkey.io/) - A fork of Redis 7.2.4
- [DragonFly DB](https://www.dragonflydb.io/) - A fully REDIS API wire-compatible solution that offers sub-millisecond reads.
- [KeyDB](https://docs.keydb.dev/)- A full drop-in replacement for Redis, that offers 1million ops/sec
- [Garnet](https://github.com/microsoft/garnet) - A Redis-API-compatible implementation from Microsoft Research

### Actual Redis charts

- [Cloudpirates](https://github.com/CloudPirates-io/helm-charts/tree/main/charts/redis)
- [Bitnami](https://github.com/bitnami/charts/tree/main/bitnami/redis)
- [Dandy Developer](https://github.com/DandyDeveloper/charts/tree/master/charts/redis-ha)
- [OpsTree Redis Operator](https://redis-operator.opstree.dev/)
