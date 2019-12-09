provider "aws" {
  access_key = var.scalr_aws_access_key
  secret_key = var.scalr_aws_secret_key
  region     = "us-east-1"
}

resource "aws_instance" "scalr" {
  ami                    = "ami-0b14d69d423a2539d"
  instance_type          = "t2.nano"
  subnet_id              = "subnet-0ebb1058ad727cfdb"
  vpc_security_group_ids = ["sg-0880cfdc546b123ba"]
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
