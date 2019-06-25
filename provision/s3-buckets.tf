resource "aws_s3_bucket" "lambda_code_bucket" {
  bucket = "move-ftp-files-to-s3-code-${var.uniqueid}"
}

resource "aws_s3_bucket" "destination_one_bucket" {
  bucket = "destination-one-${var.uniqueid}"
}

# resource "aws_s3_bucket" "destination_two_bucket" {
#   bucket = "destination-two-${var.uniqueid}"
# }


