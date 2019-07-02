# Sem1_Proy2

##Instalación  de terraform en sistema operativo Linux

**Vamos a la página oficial https://www.terraform.io/downloads.html. En ella encontramos los binarios.


**Seleccionamos el sistema operativo y la arquitectura, en nuestro caso elegiremos Linux 64­bit puesto que lo instalaremos en una maquina Ubuntu 18.04.

**Creamos un directorio para los binarios de Terraform.
```mkdir terraform
```

**Moveremos el fichero descargado anteriormente al interior de la carpeta terraform

**Nos situamos en el directorio terraform.
```
cd terraform/
```
**Descomprimimos los binarios de Terraform con el comando unzip.
```unzip terraform_0.9.2_linux_amd64.zip
```
**Exportamos las variables de entorno de Terraform.

```export PATH=/home/ubuntu/terraform:$PATH
```

**Por último comprobamos que se ha instalado bien ejecutando el comando siguiente:

```terraform --version
```
**El paso siguiente es tener un archivo.tf y ejecutarlo dentro de la carpeta terraform con el siguiente comando
```
terraform int
```
**Luego 

```terraform apply #Para correr nuestra insfraestructura
terraform destroy # Para eliminar nuestra insfraestructura```
