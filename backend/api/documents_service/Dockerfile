# Usa la imagen base de Python 3.13 en Alpine
FROM python:3.13.3-alpine3.21

# Establece la variable de entorno para evitar archivos .pyc y asegurar que los logs salgan inmediatamente
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Instala las dependencias del sistema operativo necesarias antes de instalar los paquetes de Python.
# Esto incluye herramientas de compilación y librerías de desarrollo.
RUN apk add --no-cache \
    # Herramientas básicas de compilación
    build-base \
    # Para grpcio o alguna otra librería que lo requiera
    c-ares-dev \
    # Para compilar extensiones escritas en Rust (usado por cryptography, pydantic_core)
    cargo \
    # Para la librería graphviz de Python, si necesitas generar gráficos
    graphviz \
    # Para cryptography y otras librerías que usan CFFI
    libffi-dev \
    # Si usaras Pillow y necesitaras soporte JPEG
    libjpeg-turbo-dev \
    # Si usaras Pillow y necesitaras soporte PNG
    libpng-dev \
    # Cabeceras de desarrollo para musl libc
    musl-dev \
    # Para cryptography, requests, y otras librerías que manejan SSL/TLS
    openssl-dev \
    # pkg-config es útil para que las herramientas de compilación encuentren librerías
    pkgconfig \
    # Para psycopg2 (adaptador de PostgreSQL)
    postgresql-dev \
    # Cabeceras de desarrollo para Python (necesarias para compilar extensiones C)
    python3-dev \
    # Para aiosqlite (si se compila desde fuente o necesita enlazarse)
    sqlite-dev \
    # Dependencias que a veces son necesarias para grpcio
    zlib-dev \
    && pip install --no-cache-dir --upgrade pip

# Establece el directorio de trabajo en /app
WORKDIR /app

# Copia el archivo de requisitos al directorio de trabajo
# Asegúrate de que tu requirements.txt NO contenga psycopg2-binary, usa psycopg2 en su lugar.
COPY requirements.txt .

# Instala las dependencias de Python desde el archivo de requisitos
# --no-cache-dir reduce el tamaño de la imagen al no almacenar el caché de pip
RUN pip install --no-cache-dir -r requirements.txt

# Copia el resto del código de la aplicación al directorio de trabajo
COPY . .

# Expone el puerto en el que la aplicación se ejecutará (ajusta según sea necesario)
# Esta línea es informativa para el usuario del Dockerfile;
# necesitas usar -p al ejecutar `docker run` para mapear el puerto.
EXPOSE 8004  
# Descomenta y ajusta si sabes el puerto de antemano

# Comando para ejecutar la aplicación
# Usa variables de entorno HOST y PORT que se deben pasar al ejecutar el contenedor.
# El --reload y --reload-dir son para desarrollo; considera quitarlos para producción.
CMD ["sh", "-c", "uvicorn main:app --host=${HOST:-0.0.0.0} --port=${PORT:-8002} --reload --reload-dir=/app"]