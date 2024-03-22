
resource "aws_instance" "example" {
  depends_on = [aws_security_group.bastion_sg]
  ami           = var.amiAL2023
  instance_type = "t2.micro"
  key_name = aws_key_pair.terraform_key.key_name
  security_groups = [aws_security_group.bastion_sg.id]
  associate_public_ip_address = true
  subnet_id     = aws_subnet.public-subnet1.id

  tags = {
    Name = "bastion-instance"
  }
}