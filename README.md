# pressio-containers

This repository holds all of the Dockerfiles that create the containers used throughout the Pressio ecosystem for testing.
These containers allow us to, e.g., not rebuild Trilinos every time we test Pressio in CI.

When a Dockerfile is modified or added to this repository, the `ci-docker.yml` GitHub workflow will automatically build and push the image to the [Pressio container registry](https://github.com/orgs/Pressio/packages).

Contents:
- [List of Containers](#list-of-containers)
- [Adding a New Container](#adding-a-new-container)
  - [Adding a New Version of Trilinos](#adding-a-new-version-of-trilinos)

## List of Containers

The following table shows the current container configurations maintained by the `pressio-containers` repository.

| OS       | Compiler  | TPL (Optional)                                           |
| :------- | :-------- | :-------------------------------------------------       |
| `ubuntu` | `gnu11`   | `mpi` `trilinos` `kokkos-cpu-openmp` `kokkos-cpu-serial` |
|          | `clang14` | `mpi`                                                    |
| `fedora` | `gnu13`   | `mpi`                                                    |
|          | `clang17` | `mpi`                                                    |

The images are named like: `os-compiler[-tpl]`.

For example: `ubuntu-clang14`, `fedora-gnu13-mpi`, `ubuntu-gnu11-kokkos-cpu-openmp`.

## Adding a New Container

Generally, to add a new container you will need to create a new Dockerfile (see the `docker_scripts` directory for existing Dockerfiles).

Once the dockerfile has been made, simply add it to the configuration matrix of the `ci-docker.yml`.

For example, if the new file is called `macos-clang.dockerfile`, you would add to the matrix:

```yaml
jobs:
  CI:
    strategy:
      matrix:
        config:
          #
          # Current containers...
          #
          - {dockerfile: 'macos-clang', compiler-version: '14', tag: 'latest'}
```

### Adding a New Version of Trilinos

To add a new version of Trilinos,  you **do not** need to create a new Dockerfile.
Instead, use the existing `ubuntu-gnu-trilinos.dockerfile` file in the configuration matrix of `ci-docker.yml` and add the desired tag or commit hash to the `tag` field.

For example, to add an image with Trilinos 15.0.0 (tagged in GH with `trilinos-release-15-0-0`):

```yaml
jobs:
  CI:
    strategy:
      matrix:
        config:
          #
          # Current containers...
          #
          - {dockerfile: 'ubuntu-gnu-trilinos', compiler-version: '11', tag: 'trilinos-release-15-0-0'}
```

See how Trilinos `702aac5` was added in https://github.com/Pressio/pressio/pull/651.
