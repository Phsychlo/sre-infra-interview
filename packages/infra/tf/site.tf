# Create security groups to allow specific traffic
resource "aws_security_group" "web_sg" {
  name        = "HTTP(S) and SSH"
  description = "Allow connections into EC2 instances"
  vpc_id      = aws_vpc.some_custom_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.1.0.0/16"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.1.0.0/16"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.1.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create EC2 instances on the subnet
resource "aws_instance" "web_instance" {
  ami           = "ami-084e8c05825742534"
  instance_type = "t2.micro"
  key_name      = "jnr_int_ec2s"

  subnet_id                   = aws_subnet.some_private_subnet.id
  vpc_security_group_ids      = [aws_security_group.web_sg.id]
  associate_public_ip_address = false
  iam_instance_profile        = "SSMInstanceProfile"

  user_data = <<-EOF
    #!/bin/bash 
    amazon-linux-extras install nginx1 -y
    echo "<h1>$(curl https://api.kanye.rest/?format=text)</h1>" >  /usr/share/nginx/html/index.html
    systemctl enable nginx
    systemctl start nginx
    EOF

  tags = merge(
    tomap({ "Name" : "Kanye1" }),
    var.default_tags
  )
}

resource "aws_instance" "web_instance2" {
  ami           = "ami-084e8c05825742534"
  instance_type = "t2.micro"
  key_name      = "jnr_int_ec2s"

  subnet_id                   = aws_subnet.some_private_subnet2.id
  vpc_security_group_ids      = [aws_security_group.web_sg.id]
  associate_public_ip_address = false
  iam_instance_profile        = "SSMInstanceProfile"

  user_data = <<-EOF
    #!/bin/bash 
    amazon-linux-extras install nginx1 -y
    echo "<h1>$(curl https://api.kanye.rest/?format=text)</h1>" >  /usr/share/nginx/html/index.html
    systemctl enable nginx
    systemctl start nginx
    EOF

  tags = merge(
    tomap({ "Name" : "Kanye2" }),
    var.default_tags
  )
}

# Create application load balancer
resource "aws_lb" "app_loadbalancer" {
  name                             = "basic-app-load-balancer"
  load_balancer_type               = "application"
  subnets                          = [aws_subnet.some_public_subnet.id, aws_subnet.some_public_subnet2.id]
  security_groups                  = [aws_security_group.alb-sg.id]
  enable_cross_zone_load_balancing = true
  tags = merge(
    tomap({ "Name" : "Kanye-alb" }),
    var.default_tags
  )
}

# Create load balancer listener
resource "aws_lb_listener" "app_lb_listner" {
  load_balancer_arn = aws_lb.app_loadbalancer.arn

  port     = 443
  protocol = "HTTPS"

  ssl_policy      = "ELBSecurityPolicy-2016-08"
  certificate_arn = aws_acm_certificate.alb_cert.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_lb_web_target_grp.arn
  }
  depends_on = [
    aws_acm_certificate_validation.alb_cert
  ]
}

# Create HTTP lb listener for redirect
resource "aws_lb_listener" "alb_listener-2" {
  load_balancer_arn = aws_lb.app_loadbalancer.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

# Create load balancing target group
resource "aws_lb_target_group" "app_lb_web_target_grp" {
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.some_custom_vpc.id

  load_balancing_algorithm_type = "round_robin"

  stickiness {
    enabled = false
    type    = "lb_cookie"
  }

  health_check {
    healthy_threshold   = 2
    interval            = 10
    protocol            = "HTTP"
    unhealthy_threshold = 2
  }

  depends_on = [
    aws_lb.app_loadbalancer
  ]

  lifecycle {
    create_before_destroy = true
  }
}

# Create lb securtiy group
resource "aws_security_group" "alb-sg" {
  name        = "HTTP(S)"
  description = "Allow connection into ALB"
  vpc_id      = aws_vpc.some_custom_vpc.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Attachting EC2's to load balancer
resource "aws_lb_target_group_attachment" "lb_ec2_attatchmemt" {
  target_group_arn = aws_lb_target_group.app_lb_web_target_grp.arn
  target_id        = aws_instance.web_instance.id
  port             = 80
}
# resource "aws_lb_target_group_attachment" "lb_ec2_attatchmemt2" {
#   target_group_arn = aws_lb_target_group.app_lb_web_target_grp.arn
#   target_id        = aws_instance.web_instance2.id
#   port             = 80
# }