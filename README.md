# Docker Terraform

The project is the Docker image, which includes a Terraform binary, common Terraform plugins.

This repo was original forked from [broadinstitute/docker-terraform](https://github.com/broadinstitute/docker-terraform), and then copied into this repo as a
non-forked repo due to the reason that [LFS don't allow large files to be uploaded into public forked project](https://github.com/git-lfs/git-lfs/issues/1906).

This is a sub-project of [Terraform Controller](https://github.com/oam-dev/terraform-controller)

# Build the image

```shell
$ docker build -t oamdev/docker-terraform:$TAG .

$ docker push oamdev/docker-terraform:$TAG
```

# Additional integration of provider into the image
Specify -build-arg PROVIDERS=$GROUP/$NAME/$VERSION
```shell
$ docker build --build-arg PROVIDERS=tencentcloudstack/tencentcloud/1.72.0,hashicorp/aws/4.13.0 -t oamdev/docker-terraform:$TAG .
```

# Image tags

Images are published as `oamdev/docker-terraform:<tag>` on Docker Hub. Each `vX.Y.Z` git tag publishes the image
`X.Y.Z`; `latest` is built from `master`. Releases are made from the `release-x.y` branches: see
[RELEASE.md](RELEASE.md).

| Tag | Branch | Terraform | Bundled providers | Base image | Architectures |
| --- | --- | --- | --- | --- | --- |
| `1.3.0-alpha.1` | `release-1.3` | OpenTofu 1.13.9 (`terraform` links to `tofu`) | `random` 3.9.1 | Alpine 3.24 | `linux/amd64`, `linux/arm64` |
| `1.2.1` | `release-1.2` | 1.5.5 | `random` 3.1.0, `alicloud` 1.187.0 | Alpine 3.24 | `linux/amd64` |
| `1.1.6` | `release-1.1` | 1.1.9 | `random` 3.1.0, `alicloud` 1.187.0 | Alpine 3.24 | `linux/amd64` |
| `1.2.0` | – | 1.5.5 | `random` 3.1.0, `alicloud` 1.187.0 | Alpine 3.13 | `linux/amd64` |
| `1.1.4`, `1.1.5` | – | 1.1.9 | `random` 3.1.0, `alicloud` 1.187.0 | Alpine 3.13 | `linux/amd64` |
| `1.1.3` | – | 1.1.9 | `random` 3.1.0, `alicloud` 1.140.0 | Alpine 3.13 | `linux/amd64` |
| `1.1.0`, `1.1.2` | – | 1.0.2 | `random` 3.1.0, `alicloud` 1.140.0 | Alpine 3.13 | `linux/amd64` |

`1.1.6` and `1.2.1` fix CVE-2026-111497 (Brotli) and the eMudhra CA compromise found in `1.1.5` and `1.2.0`; use them
instead. The release notes of each version are on the [releases page](https://github.com/oam-dev/docker-terraform/releases).

Older tags, no longer maintained:

- `1.0.7`, `1.0.6`, `1.0.5`: base image updates.
- `1.0.3`: a faster build of the image.
- `1.0.2`: Terraform 1.0.2.
- `0.14.11`: Terraform 0.14.10 with the `azurerm` provider built in.
- `0.14.10`: Terraform 0.14.10 with the `alibaba`, `null` and `template` providers built in.
- `0.14.9`: Terraform 0.14.9, as a long-running container.
