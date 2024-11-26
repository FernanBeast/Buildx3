# Usar una imagen base de Node.js
FROM node:16

# Crear y definir el directorio de trabajo
WORKDIR /app

# Copiar el archivo package.json y hacer npm install
COPY package.json ./
RUN npm install

# Copiar el resto del código
COPY . .

# Exponer el puerto que usará la app
EXPOSE 3000

# Comando para ejecutar la app
CMD ["npm", "start"]
