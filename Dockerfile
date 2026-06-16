
# Dockerfile — Portfolio Website

# Stage 1 – Base image
# Use the lightweight Alpine variant of the official Nginx image.
# Alpine is a minimal Linux distribution (~5 MB), keeping the final image small
# and reducing the attack surface.
FROM nginx:alpine

# Stage 2 – Metadata
# LABEL adds searchable metadata to the image.
LABEL maintainer="Egwu Chidiebere Agha <vickilance50@gmail.com>"
LABEL description="Egwu's portfolio website — containerised with Docker and served by Nginx"
LABEL version="1.0"

# Stage 3 – Remove Nginx's default placeholder page
# The official image ships with a default index.html in /usr/share/nginx/html.
# Removing it ensures our files are the only ones being served.
RUN rm -rf /usr/share/nginx/html/*

# Stage 4 – Copy website files into the container
# COPY <source on host> <destination in container>
# Everything in the current directory (.) is copied into Nginx's web root.
COPY . /usr/share/nginx/html

# Stage 5 – Expose the port Nginx listens on
# Nginx inside the container listens on port 80 by default.
# EXPOSE documents this for users and orchestration tools; it does NOT
# publish the port to the host (that is done at runtime with -p).
EXPOSE 80

# Stage 6 – Start Nginx in the foreground
# Docker requires the main process to stay in the foreground.
# "daemon off;" prevents Nginx from forking into the background,
# which would cause the container to exit immediately.
CMD ["nginx", "-g", "daemon off;"]
