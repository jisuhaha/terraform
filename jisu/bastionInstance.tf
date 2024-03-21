
data "aws_ami" "amzn-linux-2023-ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

resource "aws_instance" "example" {

  ami           = data.aws_ami.amzn-linux-2023-ami.id
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public-subnet1.id
  key_name = aws_key_pair.terraform_key.key_name
  security_groups = [aws_security_group.bastion_sg.id]

  tags = {
    Name = "bastion-instance"
  }
}