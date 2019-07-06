resource "aws_iam_role" "sans_iam_for_lambda" {
  name = "sans_iam_for_lambda"

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
/*
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "*"
        }
    ]
}
*/

resource "aws_iam_role_policy_attachment" "sans_iam_for_logs" {
  role       = "${aws_iam_role.sans_iam_for_lambda.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy" "sans_iam_for_folders" {
    name   = "sans_iam_for_folders"
    role   = "sans_iam_for_lambda"
    policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Action": [
        "dynamodb:PutItem",
        "dynamodb:DeleteItem",
        "dynamodb:GetItem",
        "dynamodb:Query",
        "dynamodb:UpdateItem"
      ],
      "Resource": "arn:aws:dynamodb:eu-west-2:739465383014:table/sans-folders"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy" "sans_iam_for_images" {
    name   = "sans_iam_for_images"
    role   = "sans_iam_for_lambda"
    policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Action": [
        "dynamodb:PutItem",
        "dynamodb:DeleteItem",
        "dynamodb:GetItem",
        "dynamodb:Query",
        "dynamodb:UpdateItem"
      ],
      "Resource": [ "arn:aws:dynamodb:eu-west-2:739465383014:table/sans-images",
                    "arn:aws:dynamodb:eu-west-2:739465383014:table/sans-images/index/userid-folderid-index" ]
    }
  ]
}
POLICY
}

data "archive_file" "sans-server" {
  type        = "zip"
  source_dir = "../sans-server"
  output_path = "./sans-server1.zip"
}

resource "aws_s3_bucket_object" "object" {
  bucket = "pipeline.sans-website.com"
  key    = "sans-server1.zip"
  source = "./sans-server1.zip"

  # The filemd5() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
  # etag = "${md5(file("path/to/file"))}"
//  etag = "${filemd5("./sans-server1.zip")}"
}

locals {
	s3_bucket      = "pipeline.sans-website.com"
	s3_key         = "sans-server.zips"
	lambda_payload = "s3://pipeline.sans-website.com/sans-server.zip" 
}

resource "aws_lambda_function" "sans_folders_create" {
  s3_bucket     = local.s3_bucket
	s3_key        = local.s3_key
  function_name = "sans_folders_create"
  role          = "${aws_iam_role.sans_iam_for_lambda.arn}"
  handler       = "src/folders.create"

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
//  source_code_hash = "${filebase64sha256("s3://pipeline.sans-website.com/sans-server.zip")}"
//	source_code_hash = "${data.aws_s3_bucket_object.lambda_zip_hash.body}"
  source_code_hash = "${data.archive_file.sans-server.output_base64sha256}"
  runtime = "nodejs10.x"

  environment {
    variables = {
      foo = "bar"
    }
  }
}

resource "aws_lambda_function" "sans_folders_get" {
  s3_bucket     = local.s3_bucket
	s3_key        = local.s3_key
  function_name = "sans_folders_get"
  role          = "${aws_iam_role.sans_iam_for_lambda.arn}"
  handler       = "src/folders.get"

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  source_code_hash = "${data.archive_file.sans-server.output_base64sha256}"

  runtime = "nodejs10.x"
}

resource "aws_lambda_function" "sans_folders_getall" {
  s3_bucket     = local.s3_bucket
	s3_key        = local.s3_key
  function_name = "sans_folders_getall"
  role          = "${aws_iam_role.sans_iam_for_lambda.arn}"
  handler       = "src/folders.getAll"

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  source_code_hash = "${data.archive_file.sans-server.output_base64sha256}"

  runtime = "nodejs10.x"
}

resource "aws_lambda_function" "sans_folders_rename" {
  s3_bucket     = local.s3_bucket
	s3_key        = local.s3_key
  function_name = "sans_folders_rename"
  role          = "${aws_iam_role.sans_iam_for_lambda.arn}"
  handler       = "src/folders.rename"

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  source_code_hash = "${data.archive_file.sans-server.output_base64sha256}"

  runtime = "nodejs10.x"
}

resource "aws_lambda_function" "sans_folders_delete" {
  s3_bucket     = local.s3_bucket
	s3_key        = local.s3_key
  function_name = "sans_folders_delete"
  role          = "${aws_iam_role.sans_iam_for_lambda.arn}"
  handler       = "src/folders.delete"

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  source_code_hash = "${data.archive_file.sans-server.output_base64sha256}"

  runtime = "nodejs10.x"
}

resource "aws_lambda_function" "sans_images_getall" {
  s3_bucket     = local.s3_bucket
	s3_key        = local.s3_key
  function_name = "sans_images_getall"
  role          = "${aws_iam_role.sans_iam_for_lambda.arn}"
  handler       = "src/images.getAll"

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  source_code_hash = "${data.archive_file.sans-server.output_base64sha256}"

  runtime = "nodejs10.x"
}

resource "aws_lambda_function" "sans_images_create" {
  s3_bucket     = local.s3_bucket
	s3_key        = local.s3_key
  function_name = "sans_images_create"
  role          = "${aws_iam_role.sans_iam_for_lambda.arn}"
  handler       = "src/images.create"

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  source_code_hash = "${data.archive_file.sans-server.output_base64sha256}"

  runtime = "nodejs10.x"
}

resource "aws_lambda_function" "sans_images_get" {
  s3_bucket     = local.s3_bucket
	s3_key        = local.s3_key
  function_name = "sans_images_get"
  role          = "${aws_iam_role.sans_iam_for_lambda.arn}"
  handler       = "src/images.get"

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  source_code_hash = "${data.archive_file.sans-server.output_base64sha256}"

  runtime = "nodejs10.x"
}

resource "aws_lambda_function" "sans_images_update" {
  s3_bucket     = local.s3_bucket
	s3_key        = local.s3_key
  function_name = "sans_images_update"
  role          = "${aws_iam_role.sans_iam_for_lambda.arn}"
  handler       = "src/images.update"

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  source_code_hash = "${data.archive_file.sans-server.output_base64sha256}"

  runtime = "nodejs10.x"
}

resource "aws_lambda_function" "sans_images_delete" {
  s3_bucket     = local.s3_bucket
	s3_key        = local.s3_key
  function_name = "sans_images_delete"
  role          = "${aws_iam_role.sans_iam_for_lambda.arn}"
  handler       = "src/images.delete"

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  source_code_hash = "${data.archive_file.sans-server.output_base64sha256}"

  runtime = "nodejs10.x"
}

resource "aws_lambda_function" "sans_cookies_get" {
  s3_bucket     = local.s3_bucket
	s3_key        = local.s3_key
  function_name = "sans_cookies_get"
  role          = "${aws_iam_role.sans_iam_for_lambda.arn}"
  handler       = "src/cookies.get"

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  source_code_hash = "${data.archive_file.sans-server.output_base64sha256}"

  runtime = "nodejs10.x"
}