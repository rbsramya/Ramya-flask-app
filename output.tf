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
