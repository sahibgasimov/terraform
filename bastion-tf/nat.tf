resource "aws_nat_gateway" "first" {
  allocation_id = aws_eip.main.id
  subnet_id     = aws_subnet.public_1.id
  depends_on    = [aws_internet_gateway.gw]
  tags = {
    Name = "nat_gateway_1"
  }
}

resource "aws_nat_gateway" "second" {
  allocation_id = aws_eip.main2.id
  subnet_id     = aws_subnet.public_2.id
  depends_on    = [aws_internet_gateway.gw]
  tags = {
    Name = "nat_gateway_2"
  }
}
resource "aws_eip" "main" {
  //   instance = aws_instance.web.id
  vpc = true
  tags = {
    Name = "eip_for_nat_gateway_1"
  }
}

resource "aws_eip" "main2" {
  //   instance = aws_instance.web.id
  vpc = true
  tags = {
    Name = "eip_for_nat_gateway_2"
  }
}
