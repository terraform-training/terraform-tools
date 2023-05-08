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

resource "aws_key_pair" "bastion_key" {
  key_name   = "bastion-key"
  public_key = var.bastion_key

  tags = local.tags
}