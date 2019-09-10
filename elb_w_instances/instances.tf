provider "aws" {
  access_key = "${var.scalr_aws_access_key}"
  secret_key = "${var.scalr_aws_secret_key}" 
  region     = var.region
}

resource "aws_instance" "scalr" {
  ami                    = "ami-2757f631"
  instance_type          = "t2.nano"
  subnet_id              = "subnet-0ebb1058ad727cfdb"
  vpc_security_group_ids = ["sg-02228c3d8e04c8951"]
  key_name               = "ryan"

    provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install apache2 -y"
    ]
  }

  connection {
    type     = "ssh"
    user     = "ubuntu"
    password = ""
    private_key = var.key
    host     = "${aws_instance.scalr.public_ip}"
  }

}

output "instance_public_ips" {
  value = "${aws_instance.scalr.*.id}"
}
