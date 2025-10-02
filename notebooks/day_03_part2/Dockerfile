# this is the base image the container is built on. In this case, it is a slim version of the Debian operating system.
FROM debian:bullseye-slim

# these are the labels that are added to the image. They are metadata that can be used to identify the author of the image.
LABEL image.author.name "Raffael Rack"
LABEL image.author.email "Raffael.rack@web.de"

# !TODO: add the command that is run to install the dependencies for the image. In this case, it should be updating the package list and installing curl and cowsay.
RUN apt-get update -y
RUN apt-get install curl -y
RUN apt-get install cowsay -y

# !TODO: add an ENV line to set environmental variables. In this case, it should set the PATH variable to /usr/games. Explain in the notebook why this is necessary.
ENV PATH=$PATH:/usr/games

CMD cowsay hello