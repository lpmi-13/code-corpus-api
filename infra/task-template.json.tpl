[
  {
    "name": "code-corpus-api",
    "image": "${aws_ecr_repository}:${tag}",
    "essential": true,
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-region": "${region}",
        "awslogs-stream-prefix": "code-corpus-api-service",
        "awslogs-group": "${log_group}"
      }
    },
    "portMappings": [
      {
        "containerPort": 8080,
        "hostPort": 8080,
        "protocol": "tcp"
      }
    ],
    "cpu": ".5",
    "environment": [
      {
        "name": "MODE",
        "value": "production"
      },
      {
        "name": "DB_CONNECTION_STRING_SECRET",
        "value": "DatabaseConnectionString"
      },
      {
        "name": "PORT",
        "value": "8080"
      }
    ],
    "ulimits": [
      {
        "name": "nofile",
        "softLimit": 65536,
        "hardLimit": 65536
      }
    ],
    "mountPoints": [],
    "memory": 1024,
    "volumesFrom": []
  }
]
