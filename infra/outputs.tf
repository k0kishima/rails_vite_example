output "alb_dns_name" {
  description = "The DNS name of the ALB"
  value       = aws_lb.this.dns_name
}

output "vite_assets_bucket_name" {
  description = "The name of the S3 bucket for Vite assets"
  value       = aws_s3_bucket.app_assets.id
}
