# Example Docker based container application with Nulecule support

This repository contains a very simple Hello World python application packaged in a Docker container. It also contains a directory `nulecule` where application and deployment definition is stored.

_I created this repository to provide an example of how the project carrying Nulecule can be structured and what information need to be provided._

## Build app

To build the application you need 2 `docker build` calls:

```
docker build -t hello .
```

The above command builds the "binary" image that contains the hello application (Python code). It's easily runnable with

```
docker run hello
```

Second build command is

```
docker build -t hello-app nulecule/
```

to build the Nulecule/Atomic app. To run the application using Atomic App call:

```
mkdir hello-app
cp answers.conf hello-app/
cd hello-app/
atomic run hello-app
```

## Build using atomicapp-builder

To install and prepare [`atomicapp-builder`](https://github.com/bkabrda/atomicapp-builder/), please run following commands

_This HOW-TO uses my (hacked;) ) fork of @bkabrda's repo to show the potential in building binary images (images run by orchestrator) as part of the process to build meta images._

```
git clone https://github.com/vpavlin/atomicapp-builder/
cd atomicapp-builder
sudo python setup.py install
docker pull slavek/atomic-reactor
```

To run an actual build go back to the `example-nulecule-repo` directory and call

```
atomicapp-builder build -v --cccp-index file://mock-index/index.yml --build-binary-images nulecule/
```

This command should succeed and provide you with `hello` and `hello-app` images

```
$ docker images hello*
REPOSITORY          TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
hello-app           latest              1b5bf036176a        11 minutes ago      246.4 MB
hello               latest              3125c43dbcb6        11 minutes ago      188 MB
```

In @bkabrda's version, you can add `--check-binary-images` option which will fail the `atomicapp-builder` run if the image `hello` does not exist. This is based on [`images` section](nulecule/Nulecule) in Nulecule component (see [the proposal](https://github.com/bkabrda/nulecule-images/)).

```
    images:
      - name: hello
        source: https://github.com/vpavlin/example-nulecule-repo
        scm_type: git
        build_configs:
          latest:
            branch: master
        image_type: docker
        image_buildfile: Dockerfile
```

This piece of information should later let us build the binary images (as described above) during the app build.
