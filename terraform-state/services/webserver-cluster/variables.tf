variable server_port {
  description = "server port used for HTTP request"
  type = number
  default = 8080
}

variable "alb_name" {
  description = "The name of the ALB"
  type = string
  default = "terraform-alb"
}




