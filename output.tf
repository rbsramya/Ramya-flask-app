output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}

output "public_route_table_id" {
  value = aws_route_table.public.id
}

output "ecs_cluster_name" {
  value = module.ecs_cluster.cluster_name
}
output "ecs_cluster_id" {
  value = module.ecs_cluster.cluster_id
}

output "ecr_repository_url" {
  value = aws_ecr_repository.ecr.repository_url
}

# Add these to output.tf (keep existing outputs)
output "ecr_repository_name" {
  value       = aws_ecr_repository.ecr.name
  description = "The name of the ECR repository"
}

output "ecs_service_name" {
  value       = aws_ecs_service.app.name
  description = "The name of the ECS service"
}

output "task_definition_family" {
  value       = aws_ecs_task_definition.app.family
  description = "The family of the task definition"
}

output "container_name" {
  value       = "${local.prefix}-container"
  description = "The name of the container"
}
