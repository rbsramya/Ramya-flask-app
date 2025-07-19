provider "aws" {
  region = "ap-southeast-1"
}

resource "aws_ecr_repository" "ecr" {
  name         = "${local.prefix}-ecr"
  force_delete = true
}

#Creating own VPC ramya-vpc1

resource "aws_vpc" "main" {
  cidr_block = var.cidr_block
  enable_dns_support =  true
  enable_dns_hostnames = true

  tags = {
    Name = "Ramya-VPC1"
  }
}

resource "aws_subnet" "public1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.subnet1_cidr
  map_public_ip_on_launch = true

  tags = {
    Name = "Ramya-public-subnet1"
  }
}

resource "aws_subnet" "public2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.subnet2_cidr
  map_public_ip_on_launch = true

  tags = {
    Name = "Ramya-public-subnet2"
  }
}


resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Ramya-igw"
  }
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
    Name = "Ramya-public-rt1"
  }
}

resource "aws_route_table_association" "public1" {
  subnet_id      = aws_subnet.public1.id 
  route_table_id = aws_route_table.rt.id
}

resource "aws_route_table_association" "public2" {
  subnet_id      = aws_subnet.public2.id 
  route_table_id = aws_route_table.rt.id
}



module "ecs" {
  #checkov:skip=CKV_TF_2:Some description
  source  = "terraform-aws-modules/ecs/aws"
  version = "~> 5.9.0"

  cluster_name = "${local.prefix}-ecs"
  fargate_capacity_providers = {
    FARGATE = {
      default_capacity_provider_strategy = {
        weight = 100
      }
    }
  }

  services = {
    ramya-tdef-ecs = { #task definition and service name -> #Change
      cpu    = 512
      memory = 1024
      container_definitions = {
        ramya-container = { #container name -> Change
          essential = true
          image     = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${data.aws_region.current.name}.amazonaws.com/${local.prefix}-ecr:latest"
          port_mappings = [
            {
              containerPort = 8080
              protocol      = "tcp"
            }
          ]
        }
      }
      assign_public_ip                   = true
      deployment_minimum_healthy_percent = 100
      subnet_ids                   = [
                aws_subnet.public1.id,
                aws_subnet.public2.id,
                      ] #List of subnet IDs to use for your tasks
      security_group_ids           = [
          aws_security_group.ecs.id       

      ] #Create a SG resource and pass it here
    }
  }
}


