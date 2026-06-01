# S3 object Storage

Since Amazon S3, it is a pretty convenient way to store files/objects, like backups, blob data, logs.
For a long time [Minio](https://www.min.io/) was the de-facto standard and nobody else was in play. But now Minio went in a different direction. Other solutions also solve issues Minio was never intended.

## Requirements

- Free and Open source, preferably 0$ cost

## Contenders

- [Ceph Object Gateway](https://docs.ceph.com/en/reef/radosgw/#object-gateway)
- [Garage](https://garagehq.deuxfleurs.fr/) - S3-compatible object store for small self-hosted geo-distributed deployments.
- [RustFS](https://rustfs.com/) - 2.3x faster than MinIO for 4KB object payloads. RustFS is an open-source, S3-compatible high-performance object storage system supporting migration and coexistence with other S3-compatible platforms such as MinIO and Ceph.
- [SeaweedFS](https://github.com/seaweedfs/seaweedfs) - A distributed storage system for object storage (S3), file systems, and Iceberg tables, designed to handle billions of files with O(1) disk access and effortless horizontal scaling.
- [CubeFS](https://cubefs.io/) - cloud-native distributed storage
- [Zenko CloudServer](https://www.zenko.io/cloudserver) - An open-source Node.js implementation of the Amazon S3 protocol on the front-end and backend storage capabilities to multiple clouds, including Azure and Google.
- [Apache Ozone](https://ozone.apache.org/) - Scalable, reliable, distributed storage system optimized for data analytics and object store workloads.
- [Versity Gateway](https://www.versity.com/products/versitygw/) - A simple to deploy but feature rich S3 object storage server for your filesystem
