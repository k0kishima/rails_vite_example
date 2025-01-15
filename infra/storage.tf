resource "aws_s3_bucket" "app_assets" {
  bucket = "${var.project}-app-assets"

  tags = {
    Name = "${var.project}-s3-bucket-app-assets"
  }
}
