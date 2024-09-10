data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

module "bastion_ec2_instance" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name                        = "${var.env_name}-bastion"
  instance_type               = var.bastion_instance_type
  ami                         = data.aws_ami.amazon_linux.id
  associate_public_ip_address = true
  key_name                    = "${var.env_name}-bastion-key"
  monitoring                  = false
  vpc_security_group_ids      = var.bastion_sgs
  subnet_id                   = var.bastion_subnet_id
  tags                        = var.common_tags
}


resource "aws_eip" "bastion_eip" {
  instance = module.bastion_ec2_instance.id
  domain   = "vpc"
  tags = merge(var.common_tags, {
    Name = "${var.env_name}-bastion-eip"
  })
}

resource "aws_instance" "jenkins" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = var.jenkins_instance_type
  vpc_security_group_ids      = var.jekins_sgs
  associate_public_ip_address = true
  monitoring                  = true
  key_name                    = "${var.env_name}-jenkins-key"
  subnet_id                   = var.jenkins_subnet_id
  iam_instance_profile        = var.jenkins_ecr_instance_profile_name
  user_data                   = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install java-17-amazon-corretto -y
              sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
              sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
              sudo yum upgrade -y
              sudo yum install jenkins -y
              sudo systemctl enable jenkins
              sudo systemctl start jenkins
              sudo yum install git -y
              sudo amazon-linux-extras install docker
              sudo service docker start
              sudo usermod -a -G docker ec2-user
              sudo groupadd docker
              sudo usermod -aG docker jenkins
              sudo chmod 666 /var/run/docker.sock
              sudo service jenkins restart
              sudo service docker restart
              EOF

  tags = merge(var.common_tags, {
    Name = "${var.env_name}-jenkins"
  })
}

