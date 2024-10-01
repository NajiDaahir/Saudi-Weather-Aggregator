resource "aws_instance" "weather_instance" {
  ami                         = "ami-0fed63ea358539e44" 
  instance_type               = "t2.micro" 
  subnet_id                   = aws_subnet.public_subnet.id
  vpc_security_group_ids      = [aws_security_group.weather_sg.id]
  associate_public_ip_address = true  # Ensures the instance has a public IP.

  tags = {
    Name = "weather-instance"
  }

  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get install -y nginx
              EOF


  depends_on = [aws_security_group.weather_sg]  # Ensure security group is created first
}
// Installing Nginx (a basic web server) above on the instance to test everything.

resource "aws_security_group" "weather_sg" {
  vpc_id = aws_vpc.weather_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Open SSH for all IPs (this should be restricted to your IP).
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow HTTP traffic.
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # Allow all outbound traffic.
  }

  tags = {
    Name = "weather-sg"
  }
}
