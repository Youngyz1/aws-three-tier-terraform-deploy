resource "aws_nat_gateway" "youngyz-ngw" {
  count         = var.create_elastic_ip ? var.countsub : 0
  allocation_id = aws_eip.youngyz-elastic-ip[count.index].id
  subnet_id     = aws_subnet.public_subnet[count.index].id
  tags = {
    Name        = "${var.environment}-nat-gateway-${count.index + 1}"
    Environment = var.environment
  }
}