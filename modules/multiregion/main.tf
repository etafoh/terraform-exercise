provider "aws" {
  region = "${var.region}"
}

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_ami" "default" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn-ami-hvm-2017.03.1.20170623*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  owners = ["amazon"]
}

resource "aws_vpc" "vpc" {
  cidr_block           = "${var.vpc-cidr}"
  enable_dns_hostnames = true
}

# Public Subnets
resource "aws_subnet" "public_subnet" {
  count                   = "${length(data.aws_availability_zones.available.names)}"
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${cidrsubnet(aws_vpc.vpc.cidr_block, 3 , count.index)}"
  availability_zone       = "${element(data.aws_availability_zones.available.names , count.index)}"
  map_public_ip_on_launch = true

  tags {
    Name = "public-subnet-${count.index}"
  }
}

#resource "aws_subnet" "subnet-b" {
#  vpc_id            = "${aws_vpc.vpc.id}"
#  cidr_block        = "${var.subnet-cidr-b}"
#  availability_zone = "${var.region}b"
#}

resource "aws_route_table" "subnet-route-table" {
  vpc_id = "${aws_vpc.vpc.id}"
}

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc.id}"
}

resource "aws_route" "subnet-route" {
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.igw.id}"
  route_table_id         = "${aws_route_table.subnet-route-table.id}"
}

resource "aws_route_table_association" "subnet-route-table-association" {
  count          = "${length(data.aws_availability_zones.available.names)}"
  subnet_id      = "${element(aws_subnet.public_subnet.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.subnet-route-table.*.id, count.index)}"
}

#resource "aws_route_table_association" "subnet-b-route-table-association" {
#  subnet_id      = "${aws_subnet.subnet-b.id}"
# route_table_id = "${aws_route_table.subnet-route-table.id}"
#}

# Nginx
resource "aws_instance" "instance" {
  ami                    = "${data.aws_ami.default.id}"
  instance_type          = "t2.small"
  vpc_security_group_ids = ["${aws_security_group.security-group.id}"]

  #subnet_id                   = "${aws_subnet.subnet-a.id}"
  subnet_id                   = "${element(aws_subnet.public_subnet.*.id, 0)}"
  associate_public_ip_address = true

  user_data = <<EOF
#!/bin/sh
yum install -y nginx
service nginx start
EOF
}

resource "aws_security_group" "security-group" {
  vpc_id = "${aws_vpc.vpc.id}"

  ingress = [
    {
      from_port   = "80"
      to_port     = "80"
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = "443"
      to_port     = "443"
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = "22"
      to_port     = "22"
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
  ]

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "nginx_domain" {
  value = "${aws_instance.instance.public_dns}"
}
