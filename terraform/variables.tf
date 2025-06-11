variable "ec2_ami" {
  default = "ami-0c94855ba95c71c99"
}

variable "ec2_instance_type" {
  default = "t2.micro"
}

variable "db_name" {
  default = "clouddb"
}

variable "db_username" {
  default = "admin"
}

variable "db_password" {
  description = "Database password"
  sensitive   = true
}

variable "db_instance_class" {
  default = "db.t3.micro"
}

variable "db_allocated_storage" {
  default = 20
}
