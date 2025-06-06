# Dockerfile para servir Flutter web con Nginx
# IMPORTANTE: Ejecuta 'flutter build web' antes de construir la imagen
FROM nginx:alpine

# Permite inyectar la URL base de la API en tiempo de build
ARG API_BASE_URL=http://localhost:8000
ENV API_BASE_URL=${API_BASE_URL}

COPY build/web /usr/share/nginx/html

# Reemplaza la URL base en el JS generado si se define API_BASE_URL
RUN if [ -n "$API_BASE_URL" ]; then \
    sed -i "s|http://localhost:8000|$API_BASE_URL|g" /usr/share/nginx/html/main.dart.js; \
  fi

EXPOSE 80 