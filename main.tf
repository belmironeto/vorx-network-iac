# Criação da VPC
resource "aws_vpc" "vorx_vpc" {
    cidr_block = "10.0.0.0/16"
    enable_dns_hostnames = true

    tags = {
        Name = "vorx_vpc"
    }
}

#Criação das Subnets Públicas
resource "aws_subnet" "vorx_subnet_public1" {
    vpc_id = aws_vpc.vorx_vpc.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-east-1a"

    tags = {
        Name = "vorx_subnet_public_1"
    }
}

resource "aws_subnet" "vorx_subnet_public2" {
    vpc_id = aws_vpc.vorx_vpc.id
    cidr_block = "10.0.3.0/24"
    availability_zone = "us-east-1b"

    tags = {
        Name = "vorx_subnet_public_2"
    }
}

#Criação das Subnets Privadas
resource "aws_subnet" "vorx_subnet_private1" {
    vpc_id = aws_vpc.vorx_vpc.id
    cidr_block = "10.0.2.0/24"
    availability_zone = "us-east-1a"

    tags = {
        Name = "vorx_subnet_private_1"
    }
}

resource "aws_subnet" "vorx_subnet_private2" {
    vpc_id = aws_vpc.vorx_vpc.id
    cidr_block = "10.0.4.0/24"
    availability_zone = "us-east-1b"
    tags = {
        Name = "vorx_subnet_private_2"
    }
}

#Criação do Internet Gateway
resource "aws_internet_gateway" "vorx_igw" {
    vpc_id = aws_vpc.vorx_vpc.id
    
    tags = {
        Name = "vorx_igw"
    }
}

#Tabela de Roteamento da Rede Pública
resource "aws_route_table" "vorx_routeTable_pub" {
    vpc_id = aws_vpc.vorx_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.vorx_igw.id
    }
    
    tags = {
        Name = "vorx_routeTable_public"
    }
}

resource "aws_route" "vorx_routeToInternet" {
  route_table_id = aws_route_table.vorx_routeTable_pub.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.vorx_igw.id
}

#Associando Subnet pública com a Tabela de Roteamento
resource "aws_route_table_association" "vorx_rt_association_pub1" {
    subnet_id = aws_subnet.vorx_subnet_public1.id
    route_table_id = aws_route_table.vorx_routeTable_pub.id
}

resource "aws_route_table_association" "vorx_rt_association_pub2" {
    subnet_id = aws_subnet.vorx_subnet_public2.id
    route_table_id = aws_route_table.vorx_routeTable_pub.id
}

