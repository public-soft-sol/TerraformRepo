provider "aws" {
  region     = "ap-south-1"
  access_key = "xxxxxxxxxxxx"
  secret_key = "xxxxxxxxxxxxxxxx"
}

terraform {
  backend "s3" {
    bucket = "terraform2023"
    key = "suman/myproject"
    region = "ap-south-1"
    access_key ="xxxxxxxxxxx"
    secret_key = "xxxxxxxxxxxxxxxxxxxxxxx"
    dynamodb_table = "sumandbtable"
  }
}

resource "aws_instance" "AWSEC2Instance" {
  
  ami             = "ami-062df10d14676e201"
  instance_type   = "t2.micro"
  security_groups = ["launch-wizard-1"]
  key_name        = "kamlesh"
  tags = {
    Name = "EC2_Instance by terraform"
  }
}




#if not create in defult VPC then use Lower resource template for create vpc subnet etc

resource "aws_vpc" "my_vpc" {
  cidr_block = "172.16.0.0/16"

  tags = {
    Name = "tf-example"
  }
}

resource "aws_subnet" "my_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "172.16.10.0/24"
  availability_zone = "ap-south-1a"

  tags = {
    Name = "tf-example"
  }
}

resource "aws_network_interface" "foo" {
  subnet_id   = aws_subnet.my_subnet.id
  private_ips = ["172.16.10.100"]

  tags = {
    Name = "primary_network_interface"
  }
}

resource "aws_instance" "foo" {
  ami           = "ami-062df10d14676e201" # ap-south-1
  instance_type = "t2.micro"

  network_interface {
    network_interface_id = aws_network_interface.foo.id
    device_index         = 0
  }

}

