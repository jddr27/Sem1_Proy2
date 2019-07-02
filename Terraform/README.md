# TERRAFORM

## Instalación  de terraform en sistema operativo Linux :

**Vamos a la página oficial https://www.terraform.io/downloads.html. En ella encontramos los binarios.**


**1. Seleccionamos el sistema operativo y la arquitectura, en nuestro caso elegiremos Linux 64­bit puesto que lo instalaremos en una maquina Ubuntu 18.04.**

**2. Creamos un directorio para los binarios de Terraform.**
```
mkdir terraform
```

**3. Moveremos el fichero descargado anteriormente al interior de la carpeta terraform**

**4. Nos situamos en el directorio terraform.**
```
cd terraform/
```
**5. Descomprimimos los binarios de Terraform con el comando unzip.**
```
unzip terraform_0.9.2_linux_amd64.zip
```
**6. Exportamos las variables de entorno de Terraform.**

```
export PATH=/home/ubuntu/terraform:$PATH
```

**7. Por último comprobamos que se ha instalado bien ejecutando el comando siguiente:**

```
terraform --version
```
**8. El paso siguiente es tener un archivo.tf y ejecutarlo dentro de la carpeta terraform con el siguiente comando**
```
terraform int
```
**9. Luego**

```
terraform apply #Para correr nuestra insfraestructura
terraform destroy # Para eliminar nuestra insfraestructura
```

