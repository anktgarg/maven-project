provider "aws" {
  region  = var.aws_region
}

resource "aws_default_vpc" "default_vpc" {
  tags = {
    Name = "Default VPC"
  }
}

resource "aws_security_group" "ec2_sg" {
  name        = "ec2_sg"
  description = "tomcat deployment"
  vpc_id      = aws_default_vpc.default_vpc.id

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
   
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  #Outbound internet access

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "my_ec2" {
  ami = "ami-0ce21b51cb31a48b8"
  instance_type = "t2.micro"
  key_name = "terra2"
  vpc_security_group_ids = ["${aws_security_group.ec2_sg.id}"]
  tags = {
    Name = "myectwo"
  }
  
  connection {
    type = "ssh"
    user = "ec2-user"
    host = aws_instance.my_ec2.public_ip
    private_key = file("/home/ec2-user/.ssh/terra2.pem")
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum install -y java*",
      "sudo yum install -y tomcat*",
      "sudo systemctl enable tomcat",
    ]
  }

  provisioner "file" {
    source      = "/var/lib/jenkins/workspace/maven_pipeline/webapp/target/webapp_${BUILD_NUMBER}.war"
    destination = "/home/ec2-user/webapp.war"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo cp /home/ec2-user/webapp.war /usr/share/tomcat/webapps/webapp.war",
      "sudo systemctl start tomcat",
    ]
  }
  
}
