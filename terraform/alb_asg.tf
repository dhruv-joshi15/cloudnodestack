# Security group for ALB to allow HTTP traffic
resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Allow HTTP"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ALB
resource "aws_lb" "app_alb" {
  name               = "cloudnode-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.public.id]

  enable_deletion_protection = false
}

# Target Group
resource "aws_lb_target_group" "app_tg" {
  name     = "cloudnode-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }
}

# Listener
resource "aws_lb_listener" "app_listener" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}

# Launch Template
resource "aws_launch_template" "app_lt" {
  name_prefix   = "cloudnode-lt"
  image_id      = var.ec2_ami
  instance_type = var.ec2_instance_type
  key_name      = "cloudnodestack-key"

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.allow_ssh.id]
    subnet_id                   = aws_subnet.public.id
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "cloudnode-asg-instance"
    }
  }
}

# Auto Scaling Group
resource "aws_autoscaling_group" "app_asg" {
  name                      = "cloudnode-asg"
  min_size                  = 1
  max_size                  = 2
  desired_capacity          = 1
  vpc_zone_identifier       = [aws_subnet.public.id]
  health_check_type         = "EC2"
  target_group_arns         = [aws_lb_target_group.app_tg.arn]

  launch_template {
    id      = aws_launch_template.app_lt.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "cloudnode-asg-instance"
    propagate_at_launch = true
  }
}
