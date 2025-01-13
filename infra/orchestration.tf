resource "aws_ecs_cluster" "this" {
  name = "${var.project}-ecs-cluster"

  tags = {
    Name = "${var.project}-ecs-cluster"
  }
}

resource "aws_ecs_task_definition" "this" {
  family                   = "${var.project}-ecs-task-rails"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  cpu                      = "512"
  memory                   = "1024"

  container_definitions = jsonencode([
    {
      name    = "rails_app"
      image   = "python:alpine"
      command = ["sh", "-c", "python3 -m http.server 3000"]
      portMappings = [
        {
          containerPort = 3000
          protocol      = "tcp"
        }
      ]
    }
  ])

  tags = {
    Name = "${var.project}-ecs-task-rails"
  }
}

resource "aws_ecs_service" "this" {
  name            = "${var.project}-ecs-service-rails"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.this.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [aws_subnet.private_a.id, aws_subnet.private_c.id]
    security_groups  = [aws_security_group.this.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.this.arn
    container_name   = "rails_app"
    container_port   = 3000
  }

  tags = {
    Name = "${var.project}-ecs-service-rails"
  }
}

resource "aws_security_group" "this" {
  name        = "${var.project}-sg"
  description = "Security group for ECS Rails app"
  vpc_id      = aws_vpc.this.id

  ingress {
    from_port       = 3000
    to_port         = 3000
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project}-sg-ecs-rails"
  }
}


resource "aws_cloudwatch_log_group" "ecs_rails_logs" {
  name              = "/aws/ecs/${var.project}"
  retention_in_days = 7

  tags = {
    Name = "${var.project}-logs"
  }
}
