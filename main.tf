resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_lambda_function" "ami_cleaner" {
  filename         = "ami_cleaner.zip"
  function_name    = "foghorn_ami_cleaner"
  role             = "${aws_iam_role.iam_for_lambda.arn}"
  handler          = "exports.test"
  source_code_hash = "${filebase64sha256("ami_cleaner.zip")}"
  runtime          = "python3.6"

  environment {
    variables = {
      exp_days = "60"
      filter_key = "name"
      filter_val = "*"
    }
  }
}

