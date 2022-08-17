resource "aws_ecs_cluster" "code-corpus" {
  name = "code-corpus"
}

// still ironing this out...
//resource "aws_ecs_service" "code-corpus-api" {
//  name            = "code-corpus-api"
//  cluster         = aws_ecs_cluster.code-corpus.id
//  task_definition = aws_ecs_task_definition.service.arn
//  desired_count   = 1
//  launch_type     = "FARGATE"
//
//  network_configuration {
//    # security_groups  = [aws_security_group.ecs_tasks.id]
//    subnets          = aws_subnet.private_subnet.*.id
//    assign_public_ip = false
//  }
//
//  load_balancer {
//    target_group_arn = aws_lb.code-corpus-alb.id
//    container_name   = "code-corpus-api"
//    container_port   = 8080
//  }
//
//  depends_on = [aws_lb_listener.https_forward, aws_iam_role_policy_attachment.ecs_task_execution_role]
//
//  tags = {
//    Environment = "production"
//    Application = "code-corpus-api"
//  }
//}

data "template_file" "code-corpus-api" {
  template = file("./task-template.json.tpl")
  vars = {
    aws_ecr_repository = var.ecr_repo_url
    region             = var.region
    tag                = "latest"
  }
}

resource "aws_ecs_task_definition" "service" {
  family                   = "Linux"
  network_mode             = "awsvpc"
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
