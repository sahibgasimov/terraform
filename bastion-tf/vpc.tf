resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"

  tags = {
    Name = "main"
  }
}


resource "aws_subnet" "public_1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.11.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "public_subnet_1"
  }
}

resource "aws_subnet" "public_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.21.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "public_subnet_2"
  }
}

resource "aws_subnet" "private_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.12.0/24"
  availability_zone = "us-east-1c"

  tags = {
    Name = "private_subnet_1"
  }
}

resource "aws_subnet" "private_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.22.0/24"
  availability_zone = "us-east-1d"

  tags = {
    Name = "private_subnet_2"
  }
}

resource "aws_subnet" "db_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.13.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "db_subnet_1"
  }
}

resource "aws_subnet" "db_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.23.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "db_subnet_2"
  }
}


