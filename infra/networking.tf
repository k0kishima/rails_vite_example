resource "aws_vpc" "this" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Project = var.project
    Name    = "${var.project}-vpc"
  }
}

/*
NOTE: Availability Zone (AZ) is explicitly defined here.
- If `availability_zone` attribute is not specified, an availability zone (AZ) is assigned automatically
  - But it is explicitly defined here.
- The public and private subnets are assigned to the same AZ for simplicity.
- Even if AWS automatically assigns different AZs, the network is optimized to minimize latency.
  - However, explicitly specifying the AZ makes the configuration clearer.
- This is a sample application, so a multi-AZ setup is not implemented.
*/
resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-northeast-1a"

  tags = {
    Project = var.project
    Name    = "${var.project}-public-subnet"
  }
}

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "ap-northeast-1a"

  tags = {
    Project = var.project
    Name    = "${var.project}-private-subnet"
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Project = var.project
    Name    = "${var.project}-igw"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Project = var.project
    Name    = "${var.project}-public-rt"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}
