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

resource "aws_iam_role_policy" "sans_iam_for_albums" {
    name   = "sans_iam_for_albums"
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
      "Resource": "arn:aws:dynamodb:eu-west-2:739465383014:table/sans-albums"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy" "sans_iam_for_pagess" {
    name   = "sans_iam_for_pagess"
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
      "Resource": "arn:aws:dynamodb:eu-west-2:739465383014:table/sans-pages"
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

resource "aws_iam_role_policy" "sans_iam_for_events" {
    name   = "sans_iam_for_events"
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
      "Resource": "arn:aws:dynamodb:eu-west-2:739465383014:table/sans-events"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy" "sans_iam_for_messages" {
    name   = "sans_iam_for_messages"
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
      "Resource": "arn:aws:dynamodb:eu-west-2:739465383014:table/sans-messages"
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

//Folder lambda
resource "aws_lambda_function" "sans_folders_create" {
	filename      = "${data.archive_file.sans-server.output_path}"
  function_name = "sans_folders_create"
  role          = "${aws_iam_role.sans_iam_for_lambda.arn}"
  handler       = "src/folders.create"

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

  source_code_hash = "${data.archive_file.sans-server.output_base64sha256}"

  runtime = "nodejs10.x"
}

resource "aws_lambda_function" "sans_folders_getall" {
	filename      = "${data.archive_file.sans-server.output_path}"
  function_name = "sans_folders_getall"
  role          = "${aws_iam_role.sans_iam_for_lambda.arn}"
  handler       = "src/folders.getAll"

  source_code_hash = "${data.archive_file.sans-server.output_base64sha256}"

  runtime = "nodejs10.x"
}

resource "aws_lambda_function" "sans_folders_rename" {
	filename      = "${data.archive_file.sans-server.output_path}"
  function_name = "sans_folders_rename"
  role          = "${aws_iam_role.sans_iam_for_lambda.arn}"
  handler       = "src/folders.rename"

  source_code_hash = "${data.archive_file.sans-server.output_base64sha256}"

  runtime = "nodejs10.x"
}

resource "aws_lambda_function" "sans_folders_delete" {
	filename      = "${data.archive_file.sans-server.output_path}"
  function_name = "sans_folders_delete"
  role          = "${aws_iam_role.sans_iam_for_lambda.arn}"
  handler       = "src/folders.delete"

  source_code_hash = "${data.archive_file.sans-server.output_base64sha256}"

  runtime = "nodejs10.x"
}

//Album Lambda
resource "aws_lambda_function" "sans_albums_getall" {
	filename      = "${data.archive_file.sans-server.output_path}"
  function_name = "sans_albums_getall"
  role          = "${aws_iam_role.sans_iam_for_lambda.arn}"
  handler       = "src/albums.getAll"

  source_code_hash = "${data.archive_file.sans-server.output_base64sha256}"

  runtime = "nodejs10.x"
}

resource "aws_lambda_function" "sans_albums_create" {
	filename      = "${data.archive_file.sans-server.output_path}"
  function_name = "sans_albums_create"
  role          = "${aws_iam_role.sans_iam_for_lambda.arn}"
  handler       = "src/albums.create"

  source_code_hash = "${data.archive_file.sans-server.output_base64sha256}"

  runtime = "nodejs10.x"
}

resource "aws_lambda_function" "sans_albums_get" {
	filename      = "${data.archive_file.sans-server.output_path}"
  function_name = "sans_albums_get"
  role          = "${aws_iam_role.sans_iam_for_lambda.arn}"
  handler       = "src/albums.get"

  source_code_hash = "${data.archive_file.sans-server.output_base64sha256}"

  runtime = "nodejs10.x"
}

resource "aws_lambda_function" "sans_albums_update" {
	filename      = "${data.archive_file.sans-server.output_path}"
  function_name = "sans_albums_update"
  role          = "${aws_iam_role.sans_iam_for_lambda.arn}"
  handler       = "src/albums.update"

  source_code_hash = "${data.archive_file.sans-server.output_base64sha256}"

  runtime = "nodejs8.10"
}

resource "aws_lambda_function" "sans_albums_delete" {
	filename      = "${data.archive_file.sans-server.output_path}"
  function_name = "sans_albums_delete"
  role          = "${aws_iam_role.sans_iam_for_lambda.arn}"
  handler       = "src/albums.delete"

  source_code_hash = "${data.archive_file.sans-server.output_base64sha256}"

  runtime = "nodejs10.x"
}

resource "aws_lambda_function" "sans_albums_images_get" {
	filename      = "${data.archive_file.sans-server.output_path}"
  function_name = "sans_albums_images_get"
  role          = "${aws_iam_role.sans_iam_for_lambda.arn}"
  handler       = "src/albums.getImagesHandler"

  source_code_hash = "${data.archive_file.sans-server.output_base64sha256}"

  runtime = "nodejs10.x"
}

//Image Lambda
resource "aws_lambda_function" "sans_images_getall" {
	filename      = "${data.archive_file.sans-server.output_path}"
  function_name = "sans_images_getall"
  role          = "${aws_iam_role.sans_iam_for_lambda.arn}"
  handler       = "src/images.getAll"

  source_code_hash = "${data.archive_file.sans-server.output_base64sha256}"

  runtime = "nodejs10.x"
}

resource "aws_lambda_function" "sans_images_create" {
	filename      = "${data.archive_file.sans-server.output_path}"
  function_name = "sans_images_create"
  role          = "${aws_iam_role.sans_iam_for_lambda.arn}"
  handler       = "src/images.create"

  source_code_hash = "${data.archive_file.sans-server.output_base64sha256}"

  runtime = "nodejs10.x"
}

resource "aws_lambda_function" "sans_images_get" {
	filename      = "${data.archive_file.sans-server.output_path}"
  function_name = "sans_images_get"
  role          = "${aws_iam_role.sans_iam_for_lambda.arn}"
  handler       = "src/images.get"

  source_code_hash = "${data.archive_file.sans-server.output_base64sha256}"

  runtime = "nodejs10.x"
}

resource "aws_lambda_function" "sans_images_getpublic" {
	filename      = "${data.archive_file.sans-server.output_path}"
  function_name = "sans_images_getpublic"
  role          = "${aws_iam_role.sans_iam_for_lambda.arn}"
  handler       = "src/images.getpublic"

  source_code_hash = "${data.archive_file.sans-server.output_base64sha256}"

  runtime = "nodejs10.x"
}

resource "aws_lambda_function" "sans_images_update" {
	filename      = "${data.archive_file.sans-server.output_path}"
  function_name = "sans_images_update"
  role          = "${aws_iam_role.sans_iam_for_lambda.arn}"
  handler       = "src/images.update"

  source_code_hash = "${data.archive_file.sans-server.output_base64sha256}"

  runtime = "nodejs8.10"
}

resource "aws_lambda_function" "sans_images_delete" {
	filename      = "${data.archive_file.sans-server.output_path}"
  function_name = "sans_images_delete"
  role          = "${aws_iam_role.sans_iam_for_lambda.arn}"
  handler       = "src/images.delete"

  source_code_hash = "${data.archive_file.sans-server.output_base64sha256}"

  runtime = "nodejs10.x"
}

//Pages Lambda
resource "aws_lambda_function" "sans_pages_getall" {
	filename      = "${data.archive_file.sans-server.output_path}"
  function_name = "sans_pages_getall"
  role          = "${aws_iam_role.sans_iam_for_lambda.arn}"
  handler       = "src/pages.getAll"

  source_code_hash = "${data.archive_file.sans-server.output_base64sha256}"

  runtime = "nodejs10.x"
}

resource "aws_lambda_function" "sans_pages_create" {
	filename      = "${data.archive_file.sans-server.output_path}"
  function_name = "sans_pages_create"
  role          = "${aws_iam_role.sans_iam_for_lambda.arn}"
  handler       = "src/pages.create"

  source_code_hash = "${data.archive_file.sans-server.output_base64sha256}"

  runtime = "nodejs10.x"
}

resource "aws_lambda_function" "sans_pages_get" {
	filename      = "${data.archive_file.sans-server.output_path}"
  function_name = "sans_pages_get"
  role          = "${aws_iam_role.sans_iam_for_lambda.arn}"
  handler       = "src/pages.get"

  source_code_hash = "${data.archive_file.sans-server.output_base64sha256}"

  runtime = "nodejs10.x"
}

resource "aws_lambda_function" "sans_pages_update" {
	filename      = "${data.archive_file.sans-server.output_path}"
  function_name = "sans_pages_update"
  role          = "${aws_iam_role.sans_iam_for_lambda.arn}"
  handler       = "src/pages.update"

  source_code_hash = "${data.archive_file.sans-server.output_base64sha256}"

  runtime = "nodejs10.x"
}

resource "aws_lambda_function" "sans_pages_delete" {
	filename      = "${data.archive_file.sans-server.output_path}"
  function_name = "sans_pages_delete"
  role          = "${aws_iam_role.sans_iam_for_lambda.arn}"
  handler       = "src/pages.delete"

  source_code_hash = "${data.archive_file.sans-server.output_base64sha256}"

  runtime = "nodejs10.x"
}

resource "aws_lambda_function" "sans_events_getall" {
	filename      = "${data.archive_file.sans-server.output_path}"
  function_name = "sans_events_getall"
  role          = "${aws_iam_role.sans_iam_for_lambda.arn}"
  handler       = "src/events.getAll"

  source_code_hash = "${data.archive_file.sans-server.output_base64sha256}"

  runtime = "nodejs10.x"
}

resource "aws_lambda_function" "sans_events_create" {
	filename      = "${data.archive_file.sans-server.output_path}"
  function_name = "sans_events_create"
  role          = "${aws_iam_role.sans_iam_for_lambda.arn}"
  handler       = "src/events.create"

  source_code_hash = "${data.archive_file.sans-server.output_base64sha256}"

  runtime = "nodejs10.x"
}

resource "aws_lambda_function" "sans_events_get" {
	filename      = "${data.archive_file.sans-server.output_path}"
  function_name = "sans_events_get"
  role          = "${aws_iam_role.sans_iam_for_lambda.arn}"
  handler       = "src/events.get"

  source_code_hash = "${data.archive_file.sans-server.output_base64sha256}"

  runtime = "nodejs10.x"
}

resource "aws_lambda_function" "sans_events_update" {
	filename      = "${data.archive_file.sans-server.output_path}"
  function_name = "sans_events_update"
  role          = "${aws_iam_role.sans_iam_for_lambda.arn}"
  handler       = "src/events.update"

  source_code_hash = "${data.archive_file.sans-server.output_base64sha256}"

  runtime = "nodejs10.x"
}

resource "aws_lambda_function" "sans_events_delete" {
	filename      = "${data.archive_file.sans-server.output_path}"
  function_name = "sans_events_delete"
  role          = "${aws_iam_role.sans_iam_for_lambda.arn}"
  handler       = "src/events.delete"

  source_code_hash = "${data.archive_file.sans-server.output_base64sha256}"

  runtime = "nodejs10.x"
}

resource "aws_lambda_function" "sans_messages_getall" {
	filename      = "${data.archive_file.sans-server.output_path}"
  function_name = "sans_messages_getall"
  role          = "${aws_iam_role.sans_iam_for_lambda.arn}"
  handler       = "src/messages.getAll"

  source_code_hash = "${data.archive_file.sans-server.output_base64sha256}"

  runtime = "nodejs10.x"
}

resource "aws_lambda_function" "sans_messages_create" {
	filename      = "${data.archive_file.sans-server.output_path}"
  function_name = "sans_messages_create"
  role          = "${aws_iam_role.sans_iam_for_lambda.arn}"
  handler       = "src/messages.create"

  source_code_hash = "${data.archive_file.sans-server.output_base64sha256}"

  runtime = "nodejs10.x"
}

resource "aws_lambda_function" "sans_messages_get" {
	filename      = "${data.archive_file.sans-server.output_path}"
  function_name = "sans_messages_get"
  role          = "${aws_iam_role.sans_iam_for_lambda.arn}"
  handler       = "src/messages.get"

  source_code_hash = "${data.archive_file.sans-server.output_base64sha256}"

  runtime = "nodejs10.x"
}

resource "aws_lambda_function" "sans_messages_update" {
	filename      = "${data.archive_file.sans-server.output_path}"
  function_name = "sans_messages_update"
  role          = "${aws_iam_role.sans_iam_for_lambda.arn}"
  handler       = "src/messages.update"

  source_code_hash = "${data.archive_file.sans-server.output_base64sha256}"

  runtime = "nodejs10.x"
}

resource "aws_lambda_function" "sans_messages_delete" {
	filename      = "${data.archive_file.sans-server.output_path}"
  function_name = "sans_messages_delete"
  role          = "${aws_iam_role.sans_iam_for_lambda.arn}"
  handler       = "src/messages.delete"

  source_code_hash = "${data.archive_file.sans-server.output_base64sha256}"

  runtime = "nodejs10.x"
}

//Get signed cookie lambda 
resource "aws_lambda_function" "sans_cookies_get" {
	filename      = "${data.archive_file.sans-server.output_path}"
  function_name = "sans_cookies_get"
  role          = "${aws_iam_role.sans_iam_for_lambda.arn}"
  handler       = "src/cookies.get"

  source_code_hash = "${data.archive_file.sans-server.output_base64sha256}"

  runtime = "nodejs10.x"
}

///Lambda to generate image thumbnails for a folder (if required)
resource "aws_lambda_function" "sans_folders_resize_post" {
	filename      = "./sans-resizer.zip"
  function_name = "sans_folders_resize_post"
  role          = "${aws_iam_role.sans_iam_for_lambda.arn}"
  handler       = "index.resizeFolder"

	source_code_hash = "${filebase64sha256("./sans-resizer.zip")}"

  runtime = "nodejs8.10"
	memory_size = 1216
	timeout = 300

	depends_on = [ "data.external.worker_zip" ]
}

//Thumbnail generator triggered from file creation in private/ folder on private S3 bucket
resource "aws_lambda_function" "sans_images_resize" {
	filename      = "./sans-resizer.zip"
  function_name = "sans_images_resize"
  role          = "${aws_iam_role.sans_iam_for_lambda.arn}"
  handler       = "index.resizeImage"

	source_code_hash = "${filebase64sha256("./sans-resizer.zip")}"

  runtime = "nodejs8.10"
	memory_size = 1216
	timeout = 300

	depends_on = [ "data.external.worker_zip" ]
}

resource "aws_lambda_function" "sans_images_resize_all" {
	filename      = "./sans-resizer.zip"
  function_name = "sans_images_resize_all"
  role          = "${aws_iam_role.sans_iam_for_lambda.arn}"
  handler       = "index.createFolderThumbnailsTrigger"

	source_code_hash = "${filebase64sha256("./sans-resizer.zip")}"

  runtime = "nodejs8.10"
	memory_size = 1216
	timeout = 300

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