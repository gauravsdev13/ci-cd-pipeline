output "bucket_name" {
  value = aws_s3_bucket.app_bucket.bucket
}

output "security_group_id" {
  value = aws_security_group.gaurav_sg.id
  description = "The ID of the security group"
}

output "ec2_instance_id" {
  value = aws_instance.gaurav_instance.id
  description = "The ID of the EC2 instance"
}

output "ec2_instance_public_ip" {
  value = aws_instance.gaurav_instance.public_ip
  description = "The public IP of the EC2 instance"
}

output "ec2_instance_private_ip" {
  value = aws_instance.gaurav_instance.private_ip
  description = "The private IP of the EC2 instance"
}

output "ecr_repository_url" {
  description = "The URL of the ECR repository"
  value       = aws_ecr_repository.node_app.repository_url
}