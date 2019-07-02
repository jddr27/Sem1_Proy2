
# Docker-Compose
## Instalación de Docker

**1. Actualizar paquetes con:**
```
  $sudo apt-get update
```

**2. Se instala Docker con el comando:**
```
  $sudo apt-get install docker.io
```

**3. Configurar el siguiente archivo:**
```
  $sudo nano /etc/group
```

**4. Agregar lo siguiente:**
```
  docker:x:115:ubuntu
```

**5. Crear la carpeta donde se copiara la imagen del contenedor:**
```
  $mkdir [nombre_carpeta]
  ```

**6. Entrar a la carpeta para bajar la imagen del contenedor:**
```
  $cd [nombre_carpeta]
```
  
## Bajar la imagen de los distintos contenedores de desde DockerHub.com:
  
 **1. Hacer login con la cuenta de dockerHub con el comando:**
```
   $docker login
   ingresar usuario y password posteriormente
```
  
**2. Descargar las imagenes con el comando:**
```
   $docker pull [Nombre_repositorio]/[nombre_cont]:[nombre_tag]
```

**3. Se crea el archivo docker-compose.yml con:**
```
  $nano docker-compose.yml
```

**4. Se abre una nueva ventana en consola donde se escribe el contenido del archivo:**
```
version: '3'
services:

  #nodejs
  app:
    image: jdgk27/proyecto1:api
    container_name: app
    restart: unless-stopped
    tty: true
    environment:
      SERVICE_NAME: app
      SERVICE_TAGS: dev
    working_dir: /var/www
    depends_on:
      - db
    networks:
      - app-network

  #Nginx Service
  webserver:
    image: jdgk27/proyecto1:nginxS2
    container_name: webserver
    restart: unless-stopped
    tty: true
    ports:
      - "8080:8080"
    depends_on:
      - db
    networks:
      - app-network

  #MySQL Service
  db:
    image: jdgk27/proyecto1:bd2
    container_name: db2
    restart: unless-stopped
    tty: true
    ports:
      - "3306:3306"
    environment:
      MYSQL_DATABASE: daniel
      MYSQL_ROOT_PASSWORD: daniel
    networks:
      - app-network

#Docker Networks
networks:
  app-network:
    driver: bridge

```
**5. Guardamos y salimos con:**
```
  $ctrl+o
  $ctrl+x
```

**6. Se despliegan los contenedores con el comando:**
```
  $docker-compose up -d
```

**7. Revisar que contenedores se han creado con:**
```
  $docker ps
```

**8. Correr las imagenes con:**
```
  $docker exec -it [id_contenedor] bash
```

**9. Detener imagenes de los contenedores con:**
```
  $docker-compose down
```

