# pressio-containers

This repository holds all of the Dockerfiles that create the containers used throughout the Pressio ecosystem for testing.
These containers allow us to, e.g., not rebuild Trilinos every time we test Pressio in CI.

Contents:
- [List of Containers](#list-of-containers)
- [Adding a New Container](#adding-a-new-container)
  - [Adding a New Version of Trilinos](#adding-a-new-version-of-trilinos)
- [Pushing Containers](#pushing-containers)

## List of Containers

The following table shows the current container configurations maintained by the `pressio-containers` repository.
Click on a container to see its corresponding dockerfile with all dependencies.

| TPLs           | Image |
| :------------- | :---- |
| None           | [`ubuntu-01`](https://github.com/Pressio/pressio-containers/blob/main/docker_scripts/ubuntu-01.dockerfile) |
|                | [`ubuntu-03`](https://github.com/Pressio/pressio-containers/blob/main/docker_scripts/ubuntu-03.dockerfile) |
| MPI            | [`ubuntu-02`](https://github.com/Pressio/pressio-containers/blob/main/docker_scripts/ubuntu-02.dockerfile) |
|                | [`ubuntu-04`](https://github.com/Pressio/pressio-containers/blob/main/docker_scripts/ubuntu-04.dockerfile) |
| Kokkos         | [`ubuntu-05`](https://github.com/Pressio/pressio-containers/blob/main/docker_scripts/ubuntu-05.dockerfile) |
|                | [`ubuntu-06`](https://github.com/Pressio/pressio-containers/blob/main/docker_scripts/ubuntu-06.dockerfile) |
| Trilinos + MPI | [`ubuntu-07`](https://github.com/Pressio/pressio-containers/blob/main/docker_scripts/ubuntu-07.dockerfile) |
|                | [`ubuntu-08`](https://github.com/Pressio/pressio-containers/blob/main/docker_scripts/ubuntu-08.dockerfile) |

## Adding a New Container

To add a new container you will need to create a new Dockerfile (see the `docker_scripts` directory for existing Dockerfiles).

Once the dockerfile has been made, simply add it to the configuration matrix of the `ci-docker.yml`.

For example, if the new file is called `ubuntu-09.dockerfile`, and uses MPI, you would add to the matrix:

```yaml
jobs:
  CI:
    strategy:
      matrix:
        include:
          #
          # Current containers...
          #
          - name: ubuntu-09
            display_name: ubuntu-09, <description>
            tpl_flags: "${MPI_FLAGS} <any other flags>"
```

The `tpl_flags` are used when configuring Pressio to test with the new image.

### Adding a New Version of Trilinos

To add a new version of Trilinos, create a new Dockerfile that runs the `install_trilinos.sh` script with the desired version or commit.

For example, this dockerfile creates a container from the `0dc4553` commit:

```docker
ARG UBUNTU_VERSION=22.04
FROM ubuntu:${UBUNTU_VERSION}

ARG TRILINOS_VERSION=0dc4553

COPY ../scripts/install_trilinos.sh /install_trilinos.sh
RUN chmod +x /install_trilinos.sh && \
    /install_trilinos.sh ${TRILINOS_VERSION}
```

## Pushing Containers

The `ci-docker.yml` GitHub workflow runs on all pushes or pull requests. For every image provided in the `matrix` (see [Adding a New Container](#adding-a-new-container)), the workflow will perform three steps:

1. Build the image
2. Build and test [Pressio](https://github.com/Pressio/pressio) (`develop` branch) inside of the container
3. If everything passes, push the image to the [Pressio container registry](https://github.com/orgs/Pressio/packages).
