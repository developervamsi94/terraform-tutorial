resource "aws_security_group" "terraform_asg_sg" {
  name = "terraform_asg_sg"

  ingress {
    from_port = var.server_port
    to_port = var.server_port
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_launch_configuration" "terraform_asg_launch" {
  image_id = "ami-0c7217cdde317cfec"
  instance_type = "t2.micro"
  security_groups = [aws_security_group.terraform_asg_sg.id]


  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, world" > index.html
              nohup busybox httpd -f -p ${var.server_port} &
              EOF

  lifecycle {
    create_before_destroy = true
  }

}


resource "aws_autoscaling_group" "terraform_asg" {
  launch_configuration = aws_launch_configuration.terraform_asg_launch.name
  vpc_zone_identifier = data.aws_subnets.default_vpc_subnets.ids

  target_group_arns = [aws_lb_target_group.asg_lb_tg.arn]
  health_check_type = "ELB"

  min_size = 2
  max_size = 10

  tag {
    key                 = "Name"
    propagate_at_launch = false
    value               = "terraform-asg-example"
  }


}

data "aws_vpc" "default_vpc" {
  default = true
}

data "aws_subnets" "default_vpc_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default_vpc.id]
  }
}

resource "aws_lb" "terraform_lb" {
  name = var.alb_name
  load_balancer_type = "application"
  subnets = data.aws_subnets.default_vpc_subnets.ids
  security_groups = [aws_security_group.alb_sg.id]

}

resource "aws_lb_listener" "asg_lb_listener" {
  load_balancer_arn = aws_lb.terraform_lb.arn
  port = 80
  protocol = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "404: page not found"
      status_code = 404
    }
  }
}

resource "aws_lb_target_group" "asg_lb_tg" {
  name = "terraform-asg-lb-tg"
  port = var.server_port
  protocol = "HTTP"
  vpc_id = data.aws_vpc.default_vpc.id

  health_check {
    path = "/"
    protocol = "HTTP"
    matcher = "200"
    interval = 15
    timeout = 3
    healthy_threshold = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener_rule" "asg_lb_listener_rule" {
  listener_arn = aws_lb_listener.asg_lb_listener.arn
  priority = 100
  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.asg_lb_tg.arn
  }
  condition {
    path_pattern {
      values = ["*"]
    }
  }
}


resource "aws_security_group" "alb_sg" {
  name = "terraform_alb_sg"

  ingress {
    from_port = 80
    protocol  = "tcp"
    to_port   = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    protocol  = "-1"
    to_port   = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}




