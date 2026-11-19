resource "aws_s3_bucket" "my_s3_bucket" {
  bucket = "multienv-s3-bucket"
  tags = {
    Name = "S3-Bucket-TagName"
  }
}


# EC2 AMI 
data "aws_ami" "ubuntu_ami" {
  most_recent = true
  filter {
    name   = "image-id"
    values = ["ami-0547ecbf0e9b4aeb5"]
  }
}
# EC2 instance vpc
resource "aws_default_vpc" "aws_default_vpc" {}

# EC2 subnets
resource "aws_subnet" "default_subnet" {
 vpc_id                  = aws_default_vpc.aws_default_vpc.id
  cidr_block              = "172.31.10.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name        = "my-default-subnet"
    Environment = var.environment
  }
}

# EC2 instance security groups
resource "aws_security_group" "ec2_security_groups" {
  description = "This section is for the security groups"
  name        = "${var.environment}-security-group"
  vpc_id      = aws_default_vpc.aws_default_vpc.id

  ingress {
    description = "inbound rule for SSH traffic"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "inbound rule for HTTP traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "inbound rule for HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "Outbound rule for EC2 instance"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "EC2 Security Groups"
  }
}

# EC2 Instance

#single map example

# resource "aws_instance" "ec2_instance" {
#   for_each               = var.instances
#   instance_type          = each.value
  
#   ami                    = data.aws_ami.ubuntu_ami.id
#   vpc_security_group_ids = [aws_security_group.ec2_security_groups.id]
#   key_name               = var.ec2_key
#   subnet_id = aws_subnet.default_subnet.id
#   root_block_device {
#     volume_size = 20
#     volume_type = "gp3"
#   }
#   tags = {
#     Name        = each.key
#     Environment = var.environment
#   }
# }


# EC2 instance for map objects

resource "aws_instance" "ec2_instance" {
  for_each               = var.instances
  instance_type          = each.value.instance_type
  
  ami                    = data.aws_ami.ubuntu_ami.id
  vpc_security_group_ids = [aws_security_group.ec2_security_groups.id]
  key_name               = var.ec2_key
  subnet_id = aws_subnet.default_subnet.id
  monitoring = each.value.monitoring.enable
  
  root_block_device {
    volume_size = each.value.volume_size
    volume_type = each.value.volume_type
  }
  tags = {
    Name        = each.key
    Environment = var.environment
    monitoring_level = each.value.monitoring.level
  }
}
