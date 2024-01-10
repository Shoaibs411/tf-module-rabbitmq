# creates ec2 instance
resource "aws_instance" "rabbitmq" {
  ami                    = data.aws_ami.ami.id                                # argument
  subnet_id              = data.terraform_remote_state.vpc.outputs.PRIVATE_SUBNET_IDS[0] 
  instance_type          = var.RABBITMQ_INSTANCE_TYPE
  vpc_security_group_ids = [aws_security_group.rabbitmq.id]

    tags = {
             Name        = "roboshop-${var.ENV}-rabbitmq"
    }
}

resource "null_resource" "app_install" {
  provisioner "remote-exec" {

    # connection block establishes connection to this
    connection {
      type     = "ssh"
      user     = "centos"
      password = "DevOps321"
      host     = aws_instance.rabbitmq.private_ip             # aws_instance.sample.private_ip : Use this only if your provisioner is outside the resource.
    }

    inline = [
        "curl https://gitlab.com/thecloudcareers/opensource/-/raw/master/lab-tools/ansible/install.sh | sudo bash",
        "ansible-pull -U https://github.com/Shoaibs411/ansible.git  -e ENV=dev -e COMPONENT=rabbitmq  roboshop-pull.yml"
        ]
    }
}