FROM debian:unstable
RUN apt update && apt upgrade -y git fakeroot build-essential make ncurses-dev xz-utils libssl-dev bc flex libelf-dev bison curl wget
WORKDIR /app
COPY ./kernel.bash /app/
CMD ["sh", "kernel.bash"]