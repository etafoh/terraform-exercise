module "dublin-deploy" {
  source = "modules/multiregion"

  region   = "eu-west-1"
  vpc-cidr = "10.10.10.0/24"
}

module "virginia-deploy" {
  source = "modules/multiregion"

  region   = "us-east-1"
  vpc-cidr = "192.168.0.0/24"
}
