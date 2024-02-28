#create eip for Bastion host
resource "aws_eip" "bastion" {
  vpc = true
  tags = {
    Name = "bastion"
  }
}


