resource "aws_launch_configuration" "web" {
  name_prefix = "web-"
  image_id = "ami-0e0bf53f6def86294"        #Amazon Linux 2 AMI (HVM), SSD Volume Type
  instance_type = "t2.small"
  key_name = aws_key_pair.terraform_key.key_name
  security_groups = [aws_security_group.web_sg.id]
  associate_public_ip_address = false
  lifecycle {
    create_before_destroy = true
  }
}