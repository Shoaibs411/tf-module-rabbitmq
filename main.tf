# creates ec2 instance
resource "aws_instance" "allows_rabbitmq" {
  ami                    = data.aws_ami.ami.id                                # argument
  subnet_id              = data.terraform_remote_state.vpc.outputs.PRIVATE_SUBNET_IDS[0] 
  instance_type          = var.RABBITMQ_INSTANCE_TYPE
  vpc_security_group_ids = [aws_security_group.allows_rabbitmq.id]

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
      host     = aws_spot_instance_request.allows_rabbitmq.private_ip             # aws_instance.sample.private_ip : Use this only if your provisioner is outside the resource.
    }

    inline = [
      "ansible-pull -U https://github.com/Shoaibs411/ansible.git  -e ENV=dev -e COMPONENT=rabbitmq  roboshop-pull.yml"
        ]
    }
}