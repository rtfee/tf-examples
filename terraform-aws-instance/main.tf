resource "aws_instance" "scalr" {
  ami                    = "ami-0c7217cdde317cfec"
  instance_type          = "t2.micro"
  subnet_id              = "subnet-0ebb1058ad727cfdb"
  vpc_security_group_ids = ["sg-00ca83d8673cddcef"]
  key_name               = "ryan"
}
