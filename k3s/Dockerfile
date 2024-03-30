# Usar la imagen base de Ubuntu 20.04
FROM ubuntu:20.04

# Actualizar el índice de paquetes e instalar software básico
RUN apt-get update && apt-get install -y \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Descargar e instalar k3s
RUN curl -sfL https://get.k3s.io | sh -

# Exponer los puertos necesarios para k3s
EXPOSE 6443 80 443

# Iniciar el servidor k3s
CMD ["k3s", "server"]
