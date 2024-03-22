resource "aws_subnet" "public-subnet1" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = var.az1
  map_public_ip_on_launch = true
  tags = {
    Name = "public001"
  }
}
resource "aws_subnet" "public-subnet2" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = var.az2
  map_public_ip_on_launch = true
  tags = {
    Name = "public002"
  }
}

resource "aws_subnet" "web-subnet1" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.11.0/24"
  availability_zone = var.az1
  map_public_ip_on_launch = false
  tags = {
    Name = "websub001"
    "kubernetes.io/role/internal-elb"             = 1
    "kubernetes.io/cluster/web"                   = "shared"
  }
}
resource "aws_subnet" "web-subnet2" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.12.0/24"
  availability_zone = var.az2
  map_public_ip_on_launch = false
  tags = {
    Name = "websub002"
    "kubernetes.io/cluster/web"                   = "shared"
    "kubernetes.io/role/internal-elb"             = 1
  }
}


resource "aws_subnet" "was-subnet1" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.21.0/24"
  availability_zone = var.az1
  map_public_ip_on_launch = false
  tags = {
    Name = "wassub001"
    "kubernetes.io/cluster/web"                   = "shared"
    "kubernetes.io/role/internal-elb"             = 1
  }
}

resource "aws_subnet" "was-subnet2" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.22.0/24"
  availability_zone = var.az2
  map_public_ip_on_launch = false
  tags = {
    Name = "wassub002"
    "kubernetes.io/cluster/web"                   = "shared"
    "kubernetes.io/role/internal-elb"             = 1
  }
}

resource "aws_subnet" "rds-subnet1" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.31.0/24"
  availability_zone = var.az1
  map_public_ip_on_launch = false
  tags = {
    Name = "rdssub001"
  }
}

resource "aws_subnet" "rds-subnet2" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.32.0/24"
  availability_zone = var.az2
  map_public_ip_on_launch = false
  tags = {
    Name = "rdssub002"
  }
}


resource "aws_db_subnet_group" "rds-subnet" {
  name = "my-db-subnet-group"
  subnet_ids = [aws_subnet.rds-subnet1.id, aws_subnet.rds-subnet2.id]
  tags = {
    Name = "DB Subnet Group"
  }
}