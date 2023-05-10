/**
 * # Demo project for terraform tools
 *
 * This project creates AWS keypair and a bastion machine in a given network.
 *
 * This documentation is auto-generated!
 * 
 */

locals {
  name = "${var.project}-${var.environment}"

  tags = {
    Author  = var.author
    Project = var.project
  }
}

## Keypair for bastion
resource "aws_key_pair" "bastion_key" {
  key_name   = "bastion-key"
  public_key = file(var.bastion_key_filename)

  tags = local.tags
}

## Elastic IP for bastion
resource "aws_eip" "bastion_reserved_ip" {
  vpc = true

  tags = local.tags
}

# ## suppress with comment: #checkov:skip=CKV2_AWS_19:We want to pay for this and have it reserved

resource "aws_vpc" "main" {

  #checkov:skip=CKV2_AWS_11:We don't need flow logging

  cidr_block                           = "172.24.0.0/16"
  enable_dns_support                   = true
  enable_dns_hostnames                 = true
  enable_network_address_usage_metrics = true

  tags = merge(
    local.tags,
    { "Name" = "${var.project}-${var.environment}-vpc" },
  )
}

resource "aws_internet_gateway" "main" {

  tags = merge(
    local.tags,
    { "Name" = "${var.project}-${var.environment}-igw" },
  )
}

resource "aws_internet_gateway_attachment" "main" {
  internet_gateway_id = aws_internet_gateway.main.id
  vpc_id              = aws_vpc.main.id
}

resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    local.tags,
    { "Name" = "${var.project}-${var.environment}-rt" },
  )
}

resource "aws_route" "main" {
  route_table_id         = aws_route_table.main.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

resource "aws_subnet" "main" {
  vpc_id            = aws_vpc.main.id
  availability_zone = element(data.aws_availability_zones.available.names, 0)
  cidr_block        = "172.24.0.0/24"

  tags = merge(
    local.tags,
    { "Name" = "${var.project}-${var.environment}-public" },
  )
}

resource "aws_route_table_association" "main" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.main.id
}

resource "aws_security_group" "allow_ssh" {
  name        = "${var.project}-${var.environment}-ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.main.id

  tags = merge(
    local.tags,
    { "Name" = "${var.project}-${var.environment}-ssh" },
  )
}

resource "aws_security_group_rule" "ssh_in" {

  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.allow_ssh.id
  description       = "Allow SSH from the Internet"
}

resource "aws_security_group_rule" "all_out" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = -1
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.allow_ssh.id
  description       = "Allow all traffic out"
}

resource "aws_instance" "bastion" {

  #checkov:skip=CKV_AWS_126:We do not need detailed monitoring

  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  key_name      = aws_key_pair.bastion_key.key_name
  subnet_id     = aws_subnet.main.id
  ebs_optimized = true

  vpc_security_group_ids = [
    aws_security_group.allow_ssh.id,
  ]

  # root_block_device {
  #   encrypted = true
  # }

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  tags = merge(
    local.tags,
    { "Name" = "${var.project}-${var.environment}-bastion" },
  )
}

# remove that and check infracost breakdown again
resource "aws_eip_association" "bastion" {
  instance_id   = aws_instance.bastion.id
  allocation_id = aws_eip.bastion_reserved_ip.id
}

resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.main.id
}