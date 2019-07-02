
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

## Crear docker-compose.yml y creación de varios contenedores con este único archivo:

**3. Se crea el archivo docker-compose.yml con:**
```
  $nano docker-compose.yml
```

**4. Se abre una nueva ventana en consola donde se escribe el contenido del archivo:**
```
version: '3'
services:
  db:
    build: ./BD
    environment:
      MYSQL_DATABASE: company
      MYSQL_ROOT_PASSWORD: 123456789
      DATABASE_HOST: db
  web:
    build: ./API
    environment:
      DATABASE_HOST: db
      MYSQL_PORT: 3306
      MYSQL_DATABASE: company
      MYSQL_USER: daniel
      MYSQL_PASSWORD: daniel
    ports:
      - "3000:3000"
    depends_on:
      - db
restart: on-failure
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

