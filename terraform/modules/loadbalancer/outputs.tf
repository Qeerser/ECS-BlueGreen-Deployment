output "alb_dns_name" {
  description = "The DNS name of the load balancer"
  value       = aws_lb.main.dns_name
}

output "alb_listener_arn" {
  description = "The ARN of the load balancer listener"
  value       = aws_lb_listener.http.arn
}

output "alb_tg_a_arn" {
  description = "The ARN of the Blue target group"
  value       = aws_lb_target_group.app_tg_a.arn
}

output "alb_tg_a_name" {
  description = "The Name of the Blue target group"
  value       = aws_lb_target_group.app_tg_a.name
}

output "alb_tg_b_arn" {
  description = "The ARN of the Green target group"
  value       = aws_lb_target_group.app_tg_b.arn
}

output "alb_tg_b_name" {
  description = "The Name of the Green target group"
  value       = aws_lb_target_group.app_tg_b.name
}
