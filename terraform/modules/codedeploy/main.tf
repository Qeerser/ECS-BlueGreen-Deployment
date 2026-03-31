resource "aws_codedeploy_app" "main" {
  name             = "${var.name_prefix}-app"
  compute_platform = "ECS"
  tags             = merge(var.tags, { Name = "${var.name_prefix}-app" })
}

resource "aws_codedeploy_deployment_group" "main" {
  app_name               = aws_codedeploy_app.main.name
  deployment_config_name = var.deployment_config_name
  deployment_group_name  = "${var.name_prefix}-deployment-group"
  service_role_arn       = var.code_deploy_role_arn

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout = "CONTINUE_DEPLOYMENT"
    }

    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = var.termination_wait_time_in_minutes
    }
  }

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }

  ecs_service {
    cluster_name = var.ecs_cluster_name
    service_name = var.ecs_service_name
  }

  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = [var.load_balancer.listener_arn]
      }

      target_group {
        name = var.load_balancer.target_group_name_blue
      }

      target_group {
        name = var.load_balancer.target_group_name_green
      }
    }
  }
}