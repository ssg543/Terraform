provider "aws" {
    region= "us-west-2"
}

resource "aws_vpc" "demo-vpc" {
    cidr_block= "10.0.0.0/26"
    tags = {
        Name= "Demo-VPC"
    }
}

resource "aws_subnet" "demo-subnet" {
    cidr_block= "10.0.0.0/27"
    vpc_id= aws_vpc.demo-vpc.id
    tags = {
        Name= "Demo-Subnet"
    }
}

resource "aws_internet_gateway" "demo-ITW" {
    vpc_id= aws_vpc.demo-vpc.id
    tags = {
        Name= "Demo-TGW"
    }
}

resource "aws_route_table" "demo-RT" {
    vpc_id= aws_vpc.demo-vpc.id
    route {
        cidr_block= "0.0.0.0/0"
        gateway_id= aws_internet_gateway.demo-ITW.id 
    }
    tags = {
        Name= "Demo-RT"
    }
}

resource "aws_route_table_association" "demo-Association" {
    subnet_id= aws_subnet.demo-subnet.id
    route_table_id= aws_route_table.demo-RT.id
}

resource "aws_instance" "demo-EC2" {
    ami           = "ami-04e35eeae7a7c5883"
    instance_type = "t2.micro"
    subnet_id     = aws_subnet.demo-subnet.id
    tags = {
        Name= "Demo-EC2"
    }
}