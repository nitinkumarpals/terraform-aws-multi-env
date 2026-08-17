#key pair resource block
resource "aws_key_pair" "nitin_key" {
  key_name   = "terra-nitin-key"
  public_key = file(pathexpand("~/.ssh/nitin-key.pub"))
}

#vpc default

resource "aws_default_vpc" "default" {
  tags = {
    Name = "default-vpc"
  }

}

#security group resource block

resource "aws_security_group" "nitin_sg" {
  name        = "terra-sg"
  vpc_id      = aws_default_vpc.default.id #interpolation to get the vpc id
  description = "Allow SSH and HTTP inbound traffic"
}

#inbound and outbound rules for security group

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv6" {
  security_group_id = aws_security_group.nitin_sg.id
  cidr_ipv4         = aws_default_vpc.default.cidr_block
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
}

#allow http inbound rule for security group

resource "aws_vpc_security_group_ingress_rule" "allow_http_ipv4" {
  security_group_id = aws_security_group.nitin_sg.id
  cidr_ipv4         = aws_default_vpc.default.cidr_block
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
}

#allow ssh inbound rule for security group
resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ipv4" {
  security_group_id = aws_security_group.nitin_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
}

#outbound rule for security group

resource "aws_vpc_security_group_egress_rule" "allow_all_outbound_ipv4" {
  security_group_id = aws_security_group.nitin_sg.id

  cidr_ipv4   = "10.0.0.0/8"
  ip_protocol = "-1"
}

#ec2 instance
resource "aws_instance" "my-instance" {
  ami                    = "ami-0e5497a77ef21b5ac"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.nitin_sg.id]
  key_name               = aws_key_pair.nitin_key.key_name

  #root storage(ebs)
  root_block_device {
    volume_size = 8
    volume_type = "gp3"
  }
  tags = {
    Name = "terra-auto-instance"
  }
}

resource "aws_ec2_instance_state" "my-instance-state" {
  instance_id = aws_instance.my-instance.id
  state       = "running" # Set to "stopped" when you want to power it down
}