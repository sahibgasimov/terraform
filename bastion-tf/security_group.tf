# Allows port 22 SSH, you can add more port inside "allow_ports" variable.tf file
resource "aws_security_group" "ssh_access_for_bastion" {
  name   = "Sahib security group"
  vpc_id = aws_vpc.main.id
  dynamic "ingress" {
    for_each = var.allow_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  ingress {
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow ping inside vpc network 0.0.0.0/0"
  }
  # Allow incoming ICMP echo ("ping") from any source via a security group
  ingress {
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow ping inside vpc network 0.0.0.0/0"
  }

  # Allow outcoming ICMP echo ("ping") from any source via a security group
  egress {
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow ping out from network"
  }

  # allow bastion download anything from internet 
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(var.common_tags, { Name = "${var.common_tags["Environment"]} Server SecurityGroup" })
}
