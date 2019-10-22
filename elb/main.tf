provider "aws" {
  version = "~> 2.0"
  region = "${var.region}"
  access_key = "${var.scalr_aws_access_key}"
  secret_key = "${var.scalr_aws_secret_key}"
}

data "aws_subnet_ids" "example" {
  vpc_id = customer-success
}

data "aws_subnet_ids" "subnet" {
  tags = {
    Name = "cs-public"
  }
}

resource "aws_elb" "scalr" {
  name            = var.elb_name
  subnets         = element(tolist(data.aws_subnet_ids.subnet.ids),0)
  security_groups = ["sg-02228c3d8e04c8951"]

  listener {
    instance_port     = 80
    instance_protocol = "tcp"
    lb_port           = 80
    lb_protocol       = "tcp"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "TCP:80"
    interval            = 30
  }

}

output "load_balancer_dns" {
  description= "ELB FQDN"
  value = "${aws_elb.scalr.dns_name}"
}
