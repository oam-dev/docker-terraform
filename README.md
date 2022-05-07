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

# oam-dev/docker-terraform

- tag: 1.0.7

Update base image

- tag: 1.0.6

Update base image

- tag: 1.0.5

Update base image

- tag: 1.0.3

Sped up the build of this image.

- tag: 1.0.2

Terraform binary version is v1.0.2.

- tag: 0.14.11

Terraform version is 0.14.10, and azurerm provider is built-in.

- tag: 0.14.10

Terraform version is 0.14.10, and alibaba/null/template providers are built-in.

- tag: 0.14.9

Terraform version is 0.14.9, and it's a long-running container.
