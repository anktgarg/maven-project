variable "aws_region" {
  description = "AWS region to launch servers."
  default     = "us-west-2"
}
variable "BUILD_NUMBER" { default = "${env.BUILD_NUMBER}" }
