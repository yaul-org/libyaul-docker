Yet Another Useless [Saturn] `Dockerfile`
===

## Usage

### Pulling or building the docker image

The easiest way to get started is to simply pull the docker image.

    docker pull ijacquez/yaul:latest

### Starting a new project

After the image has been installed, the `BUILD_PATH` needs to be set to the path
to your project. There are two ways to set `BUILD_PATH`:

1. Set the environment variable

       export BUILD_PATH=<project-name>

2. Pass the name of your project as an environment variable to `make`:

       BUILD_PATH=<project-name> make ...

After setting `BUILD_PATH`, copy the template as the starting point of the
project.

    make copy-template

### Building the project

The following targets are available for working with your project:

1. `clean` will clean your project.

2. `build` will build your project.

### Updating packages

Pull the latest image:

    docker pull ijacquez/yaul:latest
