variable "aws_region" {
  default = "us-east-1"
}

variable "cluster_name" {
  default = "tech-challenge2-eks"
}

variable "desired_size" {
  default = 1
}

variable "min_size" {
  default = 1
}

variable "max_size" {
  default = 4
}

variable "instance_type" {
  default = "t3.small"
}
