output "vpc_id" {
  value = aws_vpc.main.id
}

output "subnet_id" {
  description = "ID of the first public subnet"
  value       = aws_subnet.public1.id
}

output "cidr_block" {
  value = var.cidr_block
}

output "public_route_table_id" {
  value = aws_route_table.rt.id
}