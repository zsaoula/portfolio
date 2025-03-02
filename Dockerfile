# Étape de build
FROM node:16.18.1 AS build
WORKDIR /app

# Copier package.json et package-lock.json depuis src dans le répertoire de travail
COPY src/package.json src/package-lock.json ./

# Installer les dépendances
RUN npm install

RUN npx update-browserslist-db@latest

# Copier le reste de l'application depuis src
COPY src ./

# Compiler et packager les fichiers css/js avec webpack
RUN npm run build

# Étape de serveur
FROM nginx:latest AS server

RUN mkdir -p /usr/share/nginx/html

# Copier les fichiers construits depuis l'étape de build vers le répertoire nginx
# Copier index.html spécifiquement
COPY --from=build /app/dist/img /usr/share/nginx/html/img
COPY --from=build /app/dist/css /usr/share/nginx/html/css 
COPY --from=build /app/dist/docs /usr/share/nginx/html/docs 
COPY --from=build /app/dist/js /usr/share/nginx/html/js
COPY --from=build /app/dist/index.html /usr/share/nginx/html/index.html
#COPY --from=build /app/dist /usr/share/nginx/html
#COPY --from=build /app/dist /usr/share/nginx/html/dist
#COPY --from=build /app/src /usr/share/nginx/html/src
#COPY --from=build /app/src /usr/share/nginx/html/src

# Exposer le port sur lequel nginx servira l'application
#EXPOSE 80

# Démarrer nginx
#CMD ["nginx", "-g", "daemon off;"]
