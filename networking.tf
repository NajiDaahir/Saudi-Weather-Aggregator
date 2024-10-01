resource "aws_vpc" "weather_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "weather-aggregator-vpc"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.weather_vpc.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true  # Ensures EC2 instance gets a public IP.
  availability_zone = "eu-west-1a" 
  tags = {
    Name = "public-subnet"
  }
}

resource "aws_internet_gateway" "weather_gateway" {
  vpc_id = aws_vpc.weather_vpc.id
  tags = {
    Name = "weather-gateway"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.weather_vpc.id

  route {
    cidr_block = "0.0.0.0/0"  # Allows all traffic to the internet
    gateway_id = aws_internet_gateway.weather_gateway.id
  }
}

resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

