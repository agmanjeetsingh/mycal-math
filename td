ts # ... (previous code remains unchanged)

# Elastic Load Balancer
resource "aws_lb" "app" {
  name               = format("%s-nlb", var.vpc_name)
  internal           = true
  load_balancer_type = "network"
  security_groups    = [aws_security_group.private.id]
  subnets            = aws_subnet.private_subnet[*].id

  enable_deletion_protection = false

  tags = {
    Name = format("%s-nlb", var.vpc_name)
  }
}

# Create target groups and listeners dynamically
resource "aws_lb_target_group" "app" {
  for_each = var.subnet_ports

  name     = format("%s-target-group-%s", var.vpc_name, each.key)
  port     = each.value[0] # Use the first port for the main target group
  protocol = "TCP"
  vpc_id   = aws_vpc.main.id

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    protocol            = "TCP"
  }
}

resource "aws_lb_listener" "app" {
  for_each = var.subnet_ports

  load_balancer_arn = aws_lb.app.arn
  port              = each.value[0] # Use the first port for the listener
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app[each.key].arn
  }
}

# Create additional listeners for other ports
resource "aws_lb_listener" "additional" {
  for_each = { for subnet, ports in var.subnet_ports : subnet => ports[1:] }

  load_balancer_arn = aws_lb.app.arn
  port              = each.value[0] # Use the next port in the list
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app[each.key].arn
  }
}
