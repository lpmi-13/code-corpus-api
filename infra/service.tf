resource "aws_ecs_cluster" "code-corpus" {
  name = "code-corpus"
}

resource "aws_ecs_service" "code-corpus-api" {
  name            = "code-corpus-api"
  cluster         = aws_ecs_cluster.code-corpus.id
  task_definition = aws_ecs_task_definition.service.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  platform_version = "1.4.0"
  health_check_grace_period_seconds = 30
  wait_for_steady_state = true

  network_configuration {
    security_groups  = [aws_security_group.ecs_tasks.id]
    subnets          = [
      aws_subnet.public_subnet_a.id,
      aws_subnet.public_subnet_b.id,
      aws_subnet.public_subnet_c.id
    ]
    assign_public_ip = true
  }

 load_balancer {
   target_group_arn = aws_lb_target_group.code-corpus-api.arn
   container_name   = "code-corpus-api"
   container_port   = 8080
 }

  depends_on = [
    aws_lb_listener.https,
    aws_iam_role_policy_attachment.ecs_task_execution_role,
    null_resource.bastion_setup
  ]

  tags = {
    Environment = "production"
    Application = "code-corpus-api"
  }
}

data "template_file" "code-corpus-api" {
  template = file("./task-template.json.tpl")
  vars = {
    aws_ecr_repository = var.ecr_repo_url
    region             = var.region
    tag                = "latest"
    log_group          = var.log_group_name
  }
}

resource "aws_ecs_task_definition" "service" {
  family                   = "code-corpus-api"
  network_mode             = "awsvpc"
  // this is the role that needs to be able to fetch secrets and run the task
  task_role_arn = aws_iam_role.ecs_task_role.arn
  // this is the role to pull the container image and start the task
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  cpu                      = 256
  memory                   = 2048
  requires_compatibilities = ["FARGATE"]
  container_definitions    = data.template_file.code-corpus-api.rendered
  tags = {
    Environment = "production"
    Application = "code-corpus-api"
  }
}

// just so our ECR stays not super cluttered
resource "aws_ecr_lifecycle_policy" "code-corpus-api" {
  repository = "code-corpus-api"

  policy = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Expire images older than 5 days",
            "selection": {
                "tagStatus": "untagged",
                "countType": "sinceImagePushed",
                "countUnit": "days",
                "countNumber": 5
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}

resource "aws_cloudwatch_log_group" "code-corpus-api" {
  name = var.log_group_name
  retention_in_days = 3

  tags = {
    Environment = "production"
    Application = "code-corpus-api"
  }
}