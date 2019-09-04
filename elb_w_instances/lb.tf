resource "aws_elb" "scalr" {
  name            = "scalrexampletf"
  subnets         = ["subnet-0ebb1058ad727cfdb"]
  security_groups = ["sg-0434611e67ac24e27"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }

instances = "${aws_instance.scalr.*.id}"

}

output "load_balancer_dns" {
  value = "${aws_elb.scalr.dns_name}"
}
