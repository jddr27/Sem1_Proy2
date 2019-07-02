  variable "aws_access_key" {
  default = "AKIAU6CRM5EAXTAZGLXW"
  }
  
  variable "aws_secret_key" {
  default = "9QRCJ9AfU9sHGPPjzARwgy/auiRHbwsiOhzMyMNZ"
  }
  
  variable "aws_region" {
  default = "us-east-2"
  }
  
  variable "shared_cred_file" {
  default = "/home/ubuntu/.aws/credentials"
  }


  provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  #shared_credentials_file = "${var.shared_cred_file}"
    region     = "${var.aws_region}"   
  }
  resource "aws_key_pair" "instance-key" {
    key_name   = "MiPrimeraClaveA"
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDIk1ru+mZ/zR7LkmpAcsiA0qRGYfH4lIpebi05F33dbC8pKfM+LYivnLLypPldwHu16mkEnT3F11HLSbgxnS365ZvFQYuFEenMvC8ErzVjJtnObvlYCJ9Avk4sNhnCu3OtUtqgAiW9KZqCZcsR3U4y3GesLlQ0X4cpOOO175/e5Gmh/plYN2Vg3Yr+Mjv7xtF3+G+Ik+81fJ2A4eSBvDjPforN9aCQDy4r+sMwCGmu5NQ5tS+zmppws2Gd5Z/ByQpQLPDVBadfyLQSLOEYoBsePn7Kq+XwAMzpqAqcgsUnGZYl31p6edGpR3unuUNlqLdR8HpLY7j1D0aj2zSoWTFF ubuntu@ip-172-31-24-94"
  }



  resource "aws_security_group" "instance_rules" {
    name        = "instance_rules"
    description = "Rules for instance created in terraform"
  #  vpc_id      = "${aws_vpc.main.id}"
  #  vpc_id     = "${module.vpc.vpc_id}"

    ingress {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
      from_port       = 0
      to_port         = 65535
      protocol        = "tcp"
      cidr_blocks     = ["0.0.0.0/0"]
  #    prefix_list_ids = ["pl-12c4e678"]
    }
    egress {
      from_port       = 0
      to_port         = 65535
      protocol        = "udp"
      cidr_blocks     = ["0.0.0.0/0"]
  #    prefix_list_ids = ["pl-12c4e678"]
    }


    tags={
      Name = "instance_rules"
    }

  }



  resource "aws_instance" "ubuntu" {
  #west-2
  #  ami           = "ami-0bbe6b35405ecebdb"
  #east-2
    ami           = "ami-0c55b159cbfafe1f0" 
    instance_type = "t2.micro"
    key_name = "MiPrimeraClave"
    
    root_block_device {
      volume_type           = "gp2"
      volume_size           = 50
      delete_on_termination = true
    }

    tags={
      Name = "Ubuntu_Seminario1"
    }


  #  vpc_id     = "${module.vpc.vpc_id}"


  #  instance_tags = "rancher_fw_rules"



    provisioner "remote-exec" {
      inline = [
        "export PATH=$PATH:/usr/bin:/bin/sbin",
        "sudo echo 'Waiting for the network'",
        "sudo sleep 15s",
        "sudo apt-get update",
        "sudo apt-get install -y docker.io",
        "sudo sleep 15s",
        "sudo docker login --username=brandonsoto3 --password=Darekamormio13579",
        "sudo sleep 2s",
        "sudo docker pull brandonsoto3/proyecto1:db",
        "sudo docker run --name some-mysql -e MYSQL_ROOT_PASSWORD=123456789 -d  brandonsoto3/proyecto1:db",
        "sudo sleep 10s",        
        "sudo docker pull brandonsoto3/proyecto1:api",        
        "sudo docker run -d -p 3000:3000 --name mi-api -e USR=\"daniel\" -e PASS=\"daniel\" -e IP=\"172.17.0.2\" brandonsoto3/proyecto1:api",
        "sudo sleep 10s",        
        "sudo docker pull brandonsoto3/proyecto1:server",
        "sudo docker run -it -d -p 80:80 --name=Server brandonsoto3/proyecto1:server",        
        "sudo sleep 10s",
        "sudo docker exec -it Server bash -c 'cd /ejemplo/; exec pm2 start pagina.js'",
        
      ]

      connection {
        type     = "ssh"
  #      private_key = "${file("~/.ssh/id_rsa")}"
        host="${aws_instance.ubuntu.public_ip}"
        private_key = "${file("MiPrimeraClave.pem")}"
        user     = "ubuntu"
        timeout  = "5m"
        agent = false
      }
    }

  #  depends_on = ["aws_autoscaling_group.k8s-asg","aws_rds_cluster.aurora-cluster","aws_security_group.rancher_fw_rules"]
  #cambiar el nombre el autoscaling group para desplegar clusters diferentes


  #  depends_on = ["aws_autoscaling_group.master-us-east-2b-masters-chatbots-devisoft-tk","aws_security_group.rancher_fw_rules-2"]
    depends_on = ["aws_security_group.instance_rules"]

  #  depends_on = ["aws_rds_cluster.aurora-db","module.vpc"]
  #  depends_on = ["aws_rds_cluster.aurora-cluster"]
  #  subnet_id  = "${aws_subnet.rancher_subnet.id}"
  #  depends_on = ["aws_autoscaling_group.k8s-asg","aws_rds_cluster.aurora-db"]

  #  security_groups = ["${aws_security_group.rancher_fw_rules.name}"]
    vpc_security_group_ids = ["${aws_security_group.instance_rules.id}"]

  }

  #resource "aws_internet_gateway" "gw" {
  #  vpc_id = "${module.vpc.vpc_id}"
  #}

  #resource "aws_subnet" "rancher_subnet" {
  #  vpc_id                  = "${module.vpc.vpc_id}"
  #  cidr_block              = "10.0.0.0/24"
  #  map_public_ip_on_launch = true
  #  depends_on = ["aws_internet_gateway.gw"]
  #}


  #resource "aws_eip" "ip2" {
  #  instance = "${aws_instance.rancher-2.id}"
  #  depends_on = ["aws_instance.rancher-2"]
  #  provisioner "local-exec" {
  ##    command = "echo '${aws_eip.ip.public_ip}|${aws_rds_cluster.aurora-cluster.endpoint}' > rancher_ip.txt"
  ##    command = "echo ${aws_eip.ip.public_ip} > rancher_ip.txt"
  ##    command = "sudo /bin/bash rancher_conf.sh ${aws_eip.ip.public_ip} ${var.access_key} ${var.secret_key} ${aws_rds_cluster.rds_serverless_aurora.endpoint} ${aws_elasticache_replication_group.redis_rpg.primary_endpoint_address}"
  ##    command = "sudo /bin/bash rancher_conf.sh ${aws_eip.ip2.public_ip} ${aws_elasticache_replication_group.redis_rpg.primary_endpoint_address}"
  ##    command = "sudo /bin/bash rancher_conf.sh ${aws_eip.ip2.public_ip} ${aws_elasticache_replication_group.redis_rpg.primary_endpoint_address}"
  ##    command = "/bin/bash rancher_conf.sh ${aws_eip.ip2.public_ip} redis_address"
  #    command = "/bin/bash rancher_conf.sh ${aws_instance.rancher-2.public_ip} redis_address"
  #
  #  }
  #}


  output "ip_out" {
  #  value = "${aws_eip.ip2.public_ip}"
    value = "${aws_instance.ubuntu.public_ip}"
  }

