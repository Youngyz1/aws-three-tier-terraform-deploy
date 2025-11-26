resource "aws_internet_gateway" "youngyz-gw" {
  vpc_id = aws_vpc.youngyz-vpc.id

  tags = {
    Name        = "${var.environment}-internet-gateway"
    Environment = var.environment
  }
}