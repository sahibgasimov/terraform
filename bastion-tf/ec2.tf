resource "aws_instance" "private_ec2" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro"
  count                       = 1
  availability_zone           = "us-east-1c"
  associate_public_ip_address = false
  monitoring                  = true
  key_name                    = aws_key_pair.key.key_name
  security_groups             = [aws_security_group.ssh_access_for_bastion.id]
  subnet_id                   = aws_subnet.private_1.id
  tags = {
    Name      = "Private_EC2 ${count.index + 1}"
    CreatedBy = "Engineer"
    Team      = "DevOps"
  }
}

resource "aws_instance" "db" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro"
  count                       = 1
  availability_zone           = "us-east-1a"
  associate_public_ip_address = false
  key_name                    = aws_key_pair.key.key_name
  security_groups             = [aws_security_group.ssh_access_for_bastion.id]
  subnet_id                   = aws_subnet.db_1.id
  tags = {
    Name      = "DB_${count.index + 1}"
    CreatedBy = "Engineer"
    Team      = "DevOps"
  }
}
