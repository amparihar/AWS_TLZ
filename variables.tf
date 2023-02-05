variable "aws_region"{
    type = string
}

variable "aws_regions" {
    type = map(string)
}

variable "multi_region" {
    type = bool
}