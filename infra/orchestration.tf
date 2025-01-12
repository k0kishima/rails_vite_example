resource "aws_ecs_cluster" "this" {
  name = "${var.project}-ecs-cluster"

  tags = {
    Project = var.project
    Name    = "${var.project}-ecs-cluster"
  }
}

resource "aws_ecs_task_definition" "nginx" {
  family                   = "${var.project}-nginx-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  cpu                      = "256"
  memory                   = "512"

  container_definitions = jsonencode([
    {
      name      = "nginx"
      image     = "nginx:1.27.3"
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
          protocol      = "tcp"
        }
      ]
    }
  ])

  tags = {
    Project = var.project
    Name    = "${var.project}-nginx-task"
  }
}

resource "aws_ecs_service" "nginx" {
  name            = "${var.project}-nginx-service"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.nginx.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [aws_subnet.private.id]
    security_groups  = [aws_security_group.nginx_sg.id]
    assign_public_ip = false
  }

  tags = {
    Project = var.project
    Name    = "${var.project}-nginx-service"
  }
}

resource "aws_security_group" "nginx_sg" {
  name        = "${var.project}-nginx-sg"
  description = "Security group for Nginx ECS tasks"
  vpc_id      = aws_vpc.this.id

  ingress {
    from_port       = 80
    to_port         = 80
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
    Project = var.project
    Name    = "${var.project}-nginx-sg"
  }
}
