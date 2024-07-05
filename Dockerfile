# Étape de build
FROM node:latest AS build
WORKDIR /app

# Copier package.json et package-lock.json
COPY package*.json ./

# Installer les dépendances
RUN npm install

# Copier le reste de l'application
COPY . .

# Compiler et packager les fichiers css/js avec webpack
RUN npm run build

# Étape de serveur
FROM nginx:latest AS server

# Copier les fichiers construits depuis l'étape de build vers le répertoire nginx
COPY --from=build /app/dist /usr/share/nginx/html

# Exposer le port sur lequel nginx servira l'application
#EXPOSE 80

# Démarrer nginx
#CMD ["nginx", "-g", "daemon off;"]
