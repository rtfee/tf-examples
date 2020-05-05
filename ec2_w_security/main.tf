  
provider "aws" {
  region     = "us-east-1"
}

resource "aws_instance" "ec2" {
  ami                    = "ami-2757f631"
  instance_type          = "t2.nano"
  subnet_id              = "subnet-0ebb1058ad727cfdb"
  vpc_security_group_ids = ["sg-0880cfdc546b123ba"]
  key_name               = "ryan"
}

resource "aws_security_group" "sg" {
  count = var.security_group ? 1 : 0
  name = "allow_ssh_${aws_instance.ec2.id}"
  description = "Allow ssh"
  vpc_id = element(tolist(data.aws_vpcs.vpcs.ids),0)
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "ssh" {
  depends_on = [ aws_security_group.sg ]
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.sg[0].id
}


resource "aws_network_interface_sg_attachment" "sg_attachment" {
  depends_on = [ aws_security_group.sg ]
  security_group_id = aws_security_group.sg[0].id
  network_interface_id = aws_instance.ec2.primary_network_interface_id
}
