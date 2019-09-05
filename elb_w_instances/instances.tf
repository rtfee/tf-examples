provider "aws" {
  access_key = "${var.scalr_aws_access_key}"
  secret_key = "${var.scalr_aws_secret_key}" 
  region     = var.region
}

resource "aws_instance" "scalr" {
  count = 2
  ami                    = "ami-2757f631"
  instance_type          = "t2.micro"
  subnet_id              = "subnet-0ebb1058ad727cfdb"
  vpc_security_group_ids = ["sg-02228c3d8e04c8951"]
  key_name               = "ryan"
  provisioner "local-exec" {
  command = <<EOH
     sudo apt-get install -y apache2
 EOH
}
}

output "instance_public_ips" {
  value = "${aws_instance.scalr.*.id}"
}
