data "aws_caller_identity" "current" {
  provider = aws
}

data "aws_region" "current" {
  provider = aws
}

data "aws_region" "eufr" {
  provider = aws.eufr
}

data "aws_region" "usnv" {
  provider = aws.usnv
}

data "aws_region" "apsi" {
  provider = aws.apsi
}