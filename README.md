Yet Another Useless [Saturn] `Dockerfile`
===

## Usage

### Pulling or building the docker image

The easiest way to get started is to simply pull the docker image.

    docker pull ijacquez/yaul:latest

Otherwise, if building the docker image is desired,

    docker build --tag my-yaul .

### Starting a new project

After the image has been installed, copy any example from Yaul as the starting
point of the project.

    make copy-template

The directory `_template` will be copied to the current directory. From here,
rename `_template` to the name of your project.

### Building the project

First, the `BUILD_PATH` needs to be set to the path to your project. There are
two ways to set `BUILD_PATH`:

1. Edit the `Makefile` and change the default value to the name of your project; or

2. Pass the name of your project as an environment variable:

       BUILD_PATH=<project-name> make ...

The following targets are available for working with your project:

1. `clean` will clean your project.

2. `build` will build your project.

### Updating packages

There are two ways to update Yaul packages:

1. Pull the latest image,

       docker pull ijacquez/yaul:latest

2. Or update the packages directly in your container.

       CONTAINER_ID="<container-id>" docker-utils/update-packages.sh

   The latter will require that you pass in the container ID to run an existing
   container.
