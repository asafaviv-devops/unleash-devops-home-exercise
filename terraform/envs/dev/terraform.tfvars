role_arn = "arn:aws:iam::532150070616:role/TerraformExecutionRole"

app_name = "filechker"
env      = "dev"

cluster_name = "filechecker-dev"

vpc_cidr = "10.0.0.0/16"

public_subnets = [
  "10.0.1.0/24",
  "10.0.2.0/24"
]

private_subnets = [
  "10.0.11.0/24",
  "10.0.12.0/24"
]

