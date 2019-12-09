provider "aws" {
  access_key = var.scalr_aws_access_key
  secret_key = var.scalr_aws_secret_key
  region     = "us-east-1"
}

resource "aws_instance" "scalr" {
  ami                    = var.ami
  instance_type          = var.instancetype
  subnet_id              = var.subnet
  vpc_security_group_ids = var.sg
  key_name               = "ryan"

  connection {
        host	= var.remote_host
        type     = "ssh"
        user     = "root"
        private_key = var.private_key
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
