data "aws_caller_identity" "current" {}

module "ecr" {
  source      = "../modules/ecr"
  name_prefix = local.prefix
  tags        = local.common_tags
}

module "vpc" {
  source              = "../modules/vpc"
  availability_zone_a = var.availability_zone_a
  availability_zone_b = var.availability_zone_b
  name_prefix         = local.prefix
  tags                = local.common_tags
}

module "s3" {
  source      = "../modules/s3"
  tags        = local.common_tags
  name_prefix = local.prefix
}

module "parameter" {
  source      = "../modules/parameter"
  s3_key      = "s3://${module.s3.bucket_name}/v1/index.html"
  tags        = local.common_tags
  app_name    = local.app
  environment = local.env
}

module "security" {
  source      = "../modules/security"
  vpc_id      = module.vpc.vpc_id
  name_prefix = local.prefix
  tags        = local.common_tags
}

module "loadbalancer" {
  source             = "../modules/loadbalancer"
  vpc_id             = module.vpc.vpc_id
  name_prefix        = local.prefix
  lb_sg_id           = module.security.lb_sg_id
  public_subnet_a_id = module.vpc.subnet_public_a_id
  public_subnet_b_id = module.vpc.subnet_public_b_id
  tags               = local.common_tags
}

module "ecs_task" {
  source                  = "../modules/ecs-task"
  aws_account_id          = data.aws_caller_identity.current.account_id
  aws_region              = var.aws_region
  app_name                = local.app
  environment             = local.env
  tags                    = local.common_tags
  task_execution_role_arn = module.security.task_execution_role_arn
  task_role_arn           = module.security.task_role_arn
  cpu                     = var.ecs_task_cpu
  memory                  = var.ecs_task_memory
  app_container_name      = var.app_container_name
  app_container_image     = module.ecr.app_repository_url
  app_port                = var.app_port
  app_secrets_map = {
    "S3_URL" = module.parameter.s3_key_name
  }
  sidecar_container_name       = "init-container"
  sidecar_container_image      = module.ecr.sidecar_repository_url
  sidecar_container_command    = ["aws s3 cp $S3_URL /data/index.html"]
  sidecar_container_entrypoint = ["/bin/sh", "-c"]
  volume_name                  = "shared-storage"
  s3_key_version               = "" # Empty for now, or use module.parameter.s3_key_version if needed
}

module "ecs" {
  source              = "../modules/ecs"
  tags                = local.common_tags
  name_prefix         = local.prefix
  task_definition_arn = module.ecs_task.ecs_task_definition_arn
  desired_count       = var.ecs_desired_count
  subnets             = [module.vpc.subnet_private_app_a_id, module.vpc.subnet_private_app_b_id]
  security_groups     = [module.security.ecs_sg_id]
  load_balancer = {
    target_group_arn = module.loadbalancer.alb_tg_a_arn
    container_name   = var.app_container_name
    container_port   = var.app_port
  }
}

module "codedeploy" {
  source               = "../modules/codedeploy"
  tags                 = local.common_tags
  name_prefix          = local.prefix
  code_deploy_role_arn = module.security.code_deploy_role_arn
  ecs_cluster_name     = module.ecs.cluster_name
  ecs_service_name     = module.ecs.service_name
  load_balancer = {
    listener_arn            = module.loadbalancer.alb_listener_arn
    target_group_name_blue  = module.loadbalancer.alb_tg_a_name
    target_group_name_green = module.loadbalancer.alb_tg_b_name
  }
}

