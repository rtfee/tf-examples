provider "aws" {
  region     = "us-east-1"
}

resource "aws_instance" "scalr" {
  ami                    = "ami-2757f631"
  instance_type          = "t2.micro"
  subnet_id              = "subnet-0ebb1058ad727cfdb"
  vpc_security_group_ids = ["sg-0880cfdc546b123ba"]
  key_name               = "ryan"
}
