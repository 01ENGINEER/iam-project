provider "aws" {
  region = "us-west-2" # Change this to your desired region
}

# Create IAM Users
resource "aws_iam_user" "user1" {
  name = "user1"
}

resource "aws_iam_user" "user2" {
  name = "user2"
}

# Create IAM Policy
resource "aws_iam_policy" "s3_access" {
  name        = "S3AccessPolicy"
  description = "A policy that allows access to S3 buckets"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "s3:*"
        Resource = "*"
      },
    ]
  })
}

# Create IAM Role
resource "aws_iam_role" "ec2_role" {
  name = "ec2_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Effect = "Allow"
        Sid    = ""
      },
    ]
  })
}

# Attach Policy to Users
resource "aws_iam_policy_attachment" "user1_policy" {
  name       = "user1_policy_attachment"
  users      = [aws_iam_user.user1.name]
  policy_arn = aws_iam_policy.s3_access.arn
}

resource "aws_iam_policy_attachment" "user2_policy" {
  name       = "user2_policy_attachment"
  users      = [aws_iam_user.user2.name]
  policy_arn = aws_iam_policy.s3_access.arn
}

# Attach Policy to Role
resource "aws_iam_role_policy_attachment" "ec2_policy_attachment" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.s3_access.arn
}