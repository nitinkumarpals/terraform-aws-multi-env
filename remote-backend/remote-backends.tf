#S3

resource "aws_s3_bucket" "terraform_state" {
  bucket = "terraform-state-nitin-2026-aug"
  tags = {
    Name        = "terraform-state-bucket"
    Environment = "Dev"
  }  
}

#DynamoDB

# resource "aws_dynamodb_table" "terraform_locks_dynamodb_table" {
#   name         = "terraform-locks"
#   billing_mode = "PAY_PER_REQUEST"
#   hash_key     = "LockID" # Defines the primary key for the table required by Terraform

#   attribute {
#     name = "LockID" # The specific attribute name Terraform looks for to store the state lock string
#     type = "S"      # String type, as Terraform state lock IDs are text strings
#   }

#   tags = {
#     Name        = "terraform-locks"
#     Environment = "Dev"
#   }
# }
