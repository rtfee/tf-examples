resource "aws_elb" "scalr" {
  name            = "scalrexampletf"
  subnets         = ["subnet-0ebb1058ad727cfdb"]
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

instances = "${aws_instance.scalr.*.id}"

}

output "load_balancer_dns" {
  description= "Load Balancer FQDN"
  value = "${aws_elb.scalr.dns_name}"
}
