output "SomeOutput" {
  value = <<EOF
        
      eval `ssh-agent -s`
      ssh-add ~/.ssh/ec2_id_rsa.pem
      ssh from Public to Private EC2 ssh -A ubuntu@${aws_instance.private_ec2[0].private_ip}
      SSH from Private to DB EC2 instance ssh -A ubuntu@${aws_instance.db[0].private_ip}
    EOF
}

output "vpc" {
  value = aws_vpc.main.id
}
output "public_subnets" {
  value = [
    aws_subnet.public_1.id,
    aws_subnet.public_2.id,
  ]
}
output "private_subnets" {
  value = [
    aws_subnet.private_1.id,
    aws_subnet.private_2.id,
  ]
}
output "db_subnets" {
  value = [
    aws_subnet.db_1.id,
    aws_subnet.db_2.id,
  ]
}
