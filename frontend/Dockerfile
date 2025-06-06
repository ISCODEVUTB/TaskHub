# Dockerfile para servir Flutter web con Nginx
# IMPORTANTE: Ejecuta 'flutter build web' antes de construir la imagen
FROM nginx:alpine
COPY build/web /usr/share/nginx/html
EXPOSE 80 