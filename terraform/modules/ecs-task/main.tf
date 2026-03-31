resource "aws_ecs_task_definition" "main-task" {
  family                   = "${var.app_name}-${var.environment}-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.cpu
  memory                   = var.memory
  tags                     = merge(var.tags, { Name = "${var.app_name}-${var.environment}-task" })

  execution_role_arn = var.task_execution_role_arn
  task_role_arn      = var.task_role_arn

  volume {
    name = var.volume_name
  }
  ephemeral_storage {
    size_in_gib = 21
  }

  container_definitions = jsonencode([{
    name       = var.sidecar_container_name
    image      = var.sidecar_container_image
    essential  = false

    mountPoints = [
      {
        sourceVolume  = var.volume_name
        containerPath = "/data"
        readOnly      = false
      }
    ]

    secrets = [
      for key, path in var.app_secrets_map : {
        name      = key
        valueFrom = "arn:aws:ssm:${var.aws_region}:${var.aws_account_id}:parameter${path}"
      }
    ]

    logConfiguration = {
      logDriver = "awslogs"
      options = {
        "awslogs-group"         = "/ecs/${var.app_name}-${var.environment}"
        "awslogs-region"        = var.aws_region
        "awslogs-stream-prefix" = "ecs"
        "awslogs-create-group"  = "true"
      }
    }
    },
    {
      name      = var.app_container_name
      image     = var.app_container_image
      essential = true


      portMappings = [
        {

          containerPort = tonumber(var.app_port)
          hostPort      = tonumber(var.app_port)
        }
      ]
      mountPoints = [
        {
          sourceVolume  = var.volume_name
          containerPath = "/usr/share/nginx/html"
          readOnly      = true
        }
      ],
      dependsOn = [
        {
          containerName = var.sidecar_container_name
          condition     = "SUCCESS"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/${var.app_name}-${var.environment}"
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "ecs"
          "awslogs-create-group"  = "true"
        }
      }
    }
  ])
}
