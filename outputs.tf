output "s3-bucket" {
  value = aws_s3_bucket.my_s3_bucket.bucket
}
output "aws_s3_bucket_version" {
  value = aws_s3_bucket.my_s3_bucket.id
}
