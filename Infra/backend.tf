terraform {
/* Comment for remote deployment

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.18.0"
    }
  }
*/
  backend "s3" {
    bucket = "group1-terrastate-bucket"
    key    = "group1-terrastate-s3.tfstate"
    region = "ap-southeast-1"
  }
}
