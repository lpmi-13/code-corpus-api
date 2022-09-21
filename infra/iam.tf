data "aws_iam_policy_document" "ecs_task_execution_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "ecs-execution-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_execution_role.json
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

// this attaches the policy for the task role, which needs to be able to access the secrets
resource "aws_iam_role_policy_attachment" "task_running_actions" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = aws_iam_policy.code-corpus-api.arn
}

resource "aws_iam_role" "ecs_task_role" {
  name = "ecs-task-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_execution_role.json
}

// this is for the extra stuff
resource "aws_iam_policy" "code-corpus-api" {
  name        = "allow_provisioning"
  path        = "/"
  description = "allow service to start"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
           "secretsmanager:DescribeSecret",
           "secretsmanager:GetSecretValue",
           "sts:AssumeRole"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

# resource "aws_iam_role_policy_attachment" "extra_ecs_actions" {
  # role       = aws_iam_role.ecs_task_execution_role.name
  # policy_arn = aws_iam_policy.code-corpus-api.arn
# }