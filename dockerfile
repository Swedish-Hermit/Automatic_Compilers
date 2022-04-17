FROM debian:unstable-slim
WORKDIR /app
COPY ./kernel.bash /app/
CMD ["sh", "kernel.bash"]