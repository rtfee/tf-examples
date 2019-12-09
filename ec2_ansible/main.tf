locals {
  ssh_private_key_file = "./ssh/id_rsa"
}

provider "aws" {
  access_key = "${var.scalr_aws_access_key}"
  secret_key = "${var.scalr_aws_secret_key}"
  region     = var.region
}

data "null_data_source" "values" {
  inputs = {
    vpc_id = var.vpc_id
    }
}

resource "aws_instance" "scalr" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = var.subnet
  vpc_security_group_ids = var.sg
  key_name               = var.key

  connection {
        host	= var.remote_host
        type     = "ssh"
        user     = "root"
        private_key = "${file(local.ssh_private_key_file)}"
        timeout  = "20m"
  }

  provisioner "file" {
  source      = "./scripts/script.sh"
  destination = "/tmp/script.sh"
}

provisioner "remote-exec" {
  inline = [
    "chmod +x /tmp/script.sh",
    "/tmp/script.sh "
  ]
}

  provisioner "remote-exec" {
      inline = [
        "echo ${self.public_ip}  >> '/etc/ansible/hosts'",
        "sudo ansible-playbook /etc/ansible/playbooks/helloworld.yml --limit ${self.public_ip} --verbose"
      ]
  }

}
