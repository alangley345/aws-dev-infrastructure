#creates dev-tools VPC used for hosting various tools used to bootstrap other AWS projects
resource "aws_vpc" "devtools" {
  cidr_block                       = "10.50.0.0/16"
  assign_generated_ipv6_cidr_block = "true"
  instance_tenancy                 = "default"
  tags = {
    Name = vpc-devtools
  }
}

resource "aws_default_network_acl" "devtools" {
  default_network_acl_id = aws_vpc.devtools.default_network_acl_id
  depends_on             = [aws_vpc.devtools]

  #egress rules
  egress {
    rule_no    = 100
    protocol   = "icmp"
    from_port  = -1
    to_port    = -1
    icmp_type  = -1
    icmp_code  = -1
    cidr_block = "0.0.0.0/0"
    action     = "allow"
  }

  egress {
    protocol   = "-1"
    rule_no    = 150
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  #ingress rule
  ingress {
    rule_no    = 100
    protocol   = "icmp"
    from_port  = -1
    to_port    = -1
    icmp_type  = -1
    icmp_code  = -1
    cidr_block = "0.0.0.0/0"
    action     = "allow"
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 150
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }

}


#Create sn0-devtools
resource "aws_subnet" "sn0-devtools" {
  vpc_id            = aws_vpc.devtools.id
  cidr_block        = "10.50.0.0/24"
  depends_on        = [aws_vpc.devtools]
  availability_zone = "us-east-1a"
  tags = {
    Name = sn0-devtools
  }
}

#Create sn1-devtools
resource "aws_subnet" "sn1-devtools" {
  vpc_id            = aws_vpc.devtools.id
  cidr_block        = "10.50.1.0/24"
  depends_on        = [aws_vpc.devtools]
  availability_zone = "us-east-1b"
  tags = {
    Name = sn1-devtools
  }
}

#Create sn2-devtools
resource "aws_subnet" "sn2-devtools" {
  vpc_id            = aws_vpc.devtools.id
  cidr_block        = "10.50.2.0/24"
  depends_on        = [aws_vpc.devtools]
  availability_zone = "us-east-1c"
  tags = {
    Name = sn2-devtools
  }
}

#Create sn3-devtools
resource "aws_subnet" "sn3-devtools" {
  vpc_id            = aws_vpc.devtools.id
  cidr_block        = "10.50.3.0/24"
  depends_on        = [aws_vpc.devtools]
  availability_zone = "us-east-1d"
  tags = {
    Name = sn3-devtools
  }
}

#Create sn4-devtools
resource "aws_subnet" "sn4-devtools" {
  vpc_id            = aws_vpc.devtools.id
  cidr_block        = "10.50.4.0/24"
  depends_on        = [aws_vpc.devtools]
  availability_zone = "us-east-1d"
  tags = {
    Name = sn4-devtools
  }
}

#Create sn5-devtools
resource "aws_subnet" "sn5-devtools" {
  vpc_id            = aws_vpc.devtools.id
  cidr_block        = "10.50.5.0/24"
  depends_on        = [aws_vpc.devtools]
  availability_zone = "us-east-1d"
  tags = {
    Name = sn5-devtools
  }
}

#Internet gateway for devtools VPC
resource "aws_internet_gateway" "devtools" {
  vpc_id     = aws_vpc.devtools.id
  depends_on = [aws_vpc.devtools]
  tags = {
    Name = ig-devtools
  }
}

#create route table for VPC
resource "aws_route_table" "devtools" {
  vpc_id     = aws_vpc.devtools.id
  depends_on = [aws_internet_gateway.devtools, aws_vpc.devtools]
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc.id
  }

  tags = {
    Name = rt-devtools
  }
}

#associate devtools route table with devtools vpc
resource "aws_main_route_table_association" "devtools" {
  vpc_id         = aws_vpc.devtools.id
  route_table_id = aws_route_table.devtools.id
}
