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

3. Edit the `Makefile` and change the default value to the name of your project; or

After setting `BUILD_PATH`, copy the template as the starting point of the
project.

    make copy-template

### Building the project

The following targets are available for working with your project:

1. `clean` will clean your project.

2. `build` will build your project.

### Updating packages

There are two ways to update Yaul packages:

1. Pull the latest image,

       docker pull ijacquez/yaul:latest

2. Or update the packages directly in your container.

       CONTAINER_ID="update-packages"
       docker run -t -d --name "$CONTAINER_ID" ijacquez/yaul:latest
       cat << EOF | docker exec -i "$CONTAINER_ID" bash -x -e
       sudo pacman -Syy
       pacman -Sl yaul-linux | \
           awk '/\[installed.*]/ { print \$2 }' | xargs sudo pacman --noconfirm -S
       EOF
       docker stop "$CONTAINER_ID"
       docker rm "$CONTAINER_ID"
