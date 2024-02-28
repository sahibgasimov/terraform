data "aws_ami" "ubuntu" {
    most_recent = true
    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
    }
    filter {
        name = "virtualization-type"
        values = ["hvm"]
    }
    owners = ["099720109477"]
}

output "test" {
  value = data.aws_ami.ubuntu
}

resource "aws_launch_template" "as_template" {
  name_prefix = "sahib"
  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      volume_size = 20
    }
  }
  capacity_reservation_specification {
    capacity_reservation_preference = "open"
  }
  placement {
    availability_zone = "us-east-1a"
  }
vpc_security_group_ids =  [aws_security_group.ssh_access_for_bastion.id]
  image_id                             = data.aws_ami.ubuntu.id
  instance_initiated_shutdown_behavior = "terminate"
  instance_type                        = "t2.micro"
  key_name                             = aws_key_pair.key.key_name
  monitoring {
    enabled = true
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "Bastion"
    }
  }
  user_data                   = filebase64("./userdata.sh")
}


resource "aws_autoscaling_group" "asg" {
  name = "bastion_host"
  launch_template {
    id      = aws_launch_template.as_template.id
    version = "$Latest"
  }
  desired_capacity    = 1
  min_size            = 1
  max_size            = 1
  vpc_zone_identifier = [aws_subnet.public_1.id]

  # Required to redeploy without an outage.
  lifecycle {
    create_before_destroy = true
  }

  default_cooldown          = 30
  health_check_grace_period = 300

  tag {
    key                 = "Name"
    value               = "Bastion"
    propagate_at_launch = true
  }
}

resource "aws_key_pair" "key" {
  key_name   = "sahib"
  public_key = file(var.public_key)
}
