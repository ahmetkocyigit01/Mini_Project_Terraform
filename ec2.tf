resource “aws_instance” “sensitive” {
    ami = “ami-00dfe2c7ce89a450b”
    instance_type = “t2.micro”

    tags = {
        Name = “terraform cloud”
    }
}
