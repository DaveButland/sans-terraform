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
  output_path = "./sans-server.zip"
}

data "external" "worker_zip" {
  program = ["./zip.sh"]
}

/* This doesn't work because of symbolic links 
data "archive_file" "sans-resizer" {
  type        = "zip"
  source_dir = "../sans-resizer"
  output_path = "./sans-resizer.zip"
}
*/

/* replace with external zip
data "external" "main" {
  program = ["sh", "${path.module}/archive.sh"]
  query = {
    input_path = "${path.module}/my_function_code/"
    output_path = "${path.module}/my_function_code.zip"
  }
}

resource "aws_lambda_function" "main" {
  filename = "${data.external.main.result.output_path}"
  source_code_hash = "${data.external.main.result.output_hash}"
  # ...
}
*/

/* this doesn't work for me, must be doing something wrong with the md5 hash
resource "aws_s3_bucket_object" "object" {
  bucket = "pipeline.sans-website.com"
  key    = "sans-server.zip"
  source = "./sans-server.zip"

  # The filemd5() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
  # etag = "${md5(file("path/to/file"))}"
//  etag = "${filemd5("./sans-server1.zip")}"
}
*/

resource "aws_lambda_function" "sans_folders_create" {
	filename      = "${data.archive_file.sans-server.output_path}"
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
	filename      = "${data.archive_file.sans-server.output_path}"
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
	filename      = "${data.archive_file.sans-server.output_path}"
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
	filename      = "${data.archive_file.sans-server.output_path}"
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
	filename      = "${data.archive_file.sans-server.output_path}"
  function_name = "sans_folders_delete"
  role          = "${aws_iam_role.sans_iam_for_lambda.arn}"
  handler       = "src/folders.delete"

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  source_code_hash = "${data.archive_file.sans-server.output_base64sha256}"

  runtime = "nodejs10.x"
}

resource "aws_lambda_function" "sans_folders_resize_post" {
	filename      = "./sans-resizer.zip"
  function_name = "sans_folders_resize_post"
  role          = "${aws_iam_role.sans_iam_for_lambda.arn}"
  handler       = "index.resizeFolder"

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
	source_code_hash = "${filebase64sha256("./sans-resizer.zip")}"

  runtime = "nodejs8.10"
	memory_size = 1216
	timeout = 300

	depends_on = [ "data.external.worker_zip" ]
}

resource "aws_lambda_function" "sans_folders_resize_delete" {
	filename      = "./sans-resizer.zip"
  function_name = "sans_folders_resize_delete"
  role          = "${aws_iam_role.sans_iam_for_lambda.arn}"
  handler       = "index.resizeFolder"

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
	source_code_hash = "${filebase64sha256("./sans-resizer.zip")}"

  runtime = "nodejs8.10"
	memory_size = 1216
	timeout = 10

	depends_on = [ "data.external.worker_zip" ]
}

resource "aws_lambda_function" "sans_images_getall" {
	filename      = "${data.archive_file.sans-server.output_path}"
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
	filename      = "${data.archive_file.sans-server.output_path}"
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
	filename      = "${data.archive_file.sans-server.output_path}"
  function_name = "sans_images_get"
  role          = "${aws_iam_role.sans_iam_for_lambda.arn}"
  handler       = "src/images.get"

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  source_code_hash = "${data.archive_file.sans-server.output_base64sha256}"

  runtime = "nodejs10.x"
}

// Hard coded zip file because of problems with terraform zip and symbolic links
resource "aws_lambda_function" "sans_images_update" {
	filename      = "./sans-resizer.zip"
  function_name = "sans_images_update"
  role          = "${aws_iam_role.sans_iam_for_lambda.arn}"
  handler       = "index.resize"

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
	source_code_hash = "${filebase64sha256("./sans-resizer.zip")}"

  runtime = "nodejs8.10"
	memory_size = 1216
	timeout = 10

	depends_on = [ "data.external.worker_zip" ]
}

resource "aws_lambda_function" "sans_images_delete" {
	filename      = "${data.archive_file.sans-server.output_path}"
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
	filename      = "${data.archive_file.sans-server.output_path}"
  function_name = "sans_cookies_get"
  role          = "${aws_iam_role.sans_iam_for_lambda.arn}"
  handler       = "src/cookies.get"

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  source_code_hash = "${data.archive_file.sans-server.output_base64sha256}"

  runtime = "nodejs10.x"
}

resource "aws_lambda_function" "sans_images_resize" {
	filename      = "./sans-resizer.zip"
  function_name = "sans_images_resize"
  role          = "${aws_iam_role.sans_iam_for_lambda.arn}"
  handler       = "index.resizeImage"

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
	source_code_hash = "${filebase64sha256("./sans-resizer.zip")}"

  runtime = "nodejs8.10"
	memory_size = 1216
	timeout = 10

	depends_on = [ "data.external.worker_zip" ]
}

resource "aws_lambda_permission" "sans_iamges_resize" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.sans_images_resize.arn}"
  principal     = "s3.amazonaws.com"
  source_arn    = "${aws_s3_bucket.private.arn}"
}

resource "aws_s3_bucket_notification" "sans_images_resize" {
  bucket = "${aws_s3_bucket.private.id}"

  lambda_function {
    lambda_function_arn = "${aws_lambda_function.sans_images_resize.arn}"
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "private/"
  }
}