resource "aws_key_pair" "my-key" {
  key_name   = "devops14_2021"
  public_key = file("${path.module}/my_public_key.txt")

}

resource "aws_eip" "devops14_2021" {
  vpc = true
  tags = {
    Name  = "devops14_2021"
    Owner = "Ahmet"
  }

}

output "eip" {
  value = aws_eip.devops14_2021.public_ip

}

resource "aws_security_group" "devops14_2021" {
  name = "devops14_2021"
  dynamic "ingress" {
    for_each = var.ingress_ports

    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = var.protocol
      cidr_blocks = var.cidr
    }
  }
  dynamic "egress" {
    for_each = var.egress_ports

    content {
      from_port   = egress.value
      to_port     = egress.value
      protocol    = var.protocol
      cidr_blocks = var.cidr
    }
  }
}

resource "aws_instance" "devops14_2021" {
  ami           = lookup(var.ami, var.region)
  instance_type = lookup(var.instance_type, var.region)
  key_name      = aws_key_pair.my-key.key_name
  tags = {
    Name  = "devops14-2021"
    Owner = "Ahmet"
  }
}

resource "aws_network_interface_sg_attachment" "sg_attachment" {
  security_group_id    = aws_security_group.devops14_2021.id
  network_interface_id = aws_instance.devops14_2021.primary_network_interface_id
}

resource "aws_eip_association" "devops14_2021-to-ec2" {
  instance_id   = aws_instance.devops14_2021.id
  allocation_id = aws_eip.devops14_2021.id
}
