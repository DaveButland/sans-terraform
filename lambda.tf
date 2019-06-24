provider "aws" {
  access_key = var.access_key
  secret_key = var.secret_key
  region     = var.region
}

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

resource "aws_iam_role_policy" "iam_for_lambda_WriteArticles" {
    name   = "WriteArticles"
    role   = "iam_for_lambda"
    policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Action": "dynamodb:PutItem",
      "Resource": "arn:aws:dynamodb:eu-west-2:739465383014:table/articles"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy" "iam_for_lambda_WriteFolders" {
    name   = "WriteFolders"
    role   = "iam_for_lambda"
    policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Action": "dynamodb:PutItem",
      "Resource": "arn:aws:dynamodb:eu-west-2:739465383014:table/folders"
    }
  ]
}
POLICY
}

resource "aws_lambda_function" "test_lambda" {
  filename      = "lambda_function_payload.zip"
  function_name = "createArticleTest"
  role          = "${aws_iam_role.iam_for_lambda.arn}"
  handler       = "server/createArticle.handler"

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  source_code_hash = "${filebase64sha256("lambda_function_payload.zip")}"

  runtime = "nodejs10.x"

  environment {
    variables = {
      foo = "bar"
    }
  }
}

resource "aws_lambda_function" "createFolder" {
  filename      = "lambda_function_payload.zip"
  function_name = "createFolder"
  role          = "${aws_iam_role.iam_for_lambda.arn}"
  handler       = "server/folders.create"

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  source_code_hash = "${filebase64sha256("lambda_function_payload.zip")}"

  runtime = "nodejs10.x"

  environment {
    variables = {
      foo = "bar"
    }
  }
}

resource "aws_lambda_function" "getFolders" {
  filename      = "lambda_function_payload.zip"
  function_name = "getFolders"
  role          = "${aws_iam_role.iam_for_lambda.arn}"
  handler       = "server/folders.getAll"

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  source_code_hash = "${filebase64sha256("lambda_function_payload.zip")}"

  runtime = "nodejs10.x"

  environment {
    variables = {
      foo = "bar"
    }
  }
}

resource "aws_lambda_function" "getFolder" {
  filename      = "lambda_function_payload.zip"
  function_name = "getFolder"
  role          = "${aws_iam_role.iam_for_lambda.arn}"
  handler       = "server/folders.get"

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  source_code_hash = "${filebase64sha256("lambda_function_payload.zip")}"

  runtime = "nodejs10.x"

  environment {
    variables = {
      foo = "bar"
    }
  }
}

resource "aws_lambda_function" "renameFolder" {
  filename      = "lambda_function_payload.zip"
  function_name = "renameFolder"
  role          = "${aws_iam_role.iam_for_lambda.arn}"
  handler       = "server/folders.rename"

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  source_code_hash = "${filebase64sha256("lambda_function_payload.zip")}"

  runtime = "nodejs10.x"

  environment {
    variables = {
      foo = "bar"
    }
  }
}

resource "aws_lambda_function" "deleteFolder" {
  filename      = "lambda_function_payload.zip"
  function_name = "deleteFolder"
  role          = "${aws_iam_role.iam_for_lambda.arn}"
  handler       = "server/folders.delete"

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  source_code_hash = "${filebase64sha256("lambda_function_payload.zip")}"

  runtime = "nodejs10.x"

  environment {
    variables = {
      foo = "bar"
    }
  }
}

/*
{
    "Functions": [
        {
            "TracingConfig": {
                "Mode": "PassThrough"
            }, 
            "Version": "$LATEST", 
            "CodeSha256": "Vh7oOgJ09mD+F64JcLUzKykuxngsfXUIMbBaBdx1Ejo=", 
            "FunctionName": "createArticle", 
            "VpcConfig": {
                "SubnetIds": [], 
                "VpcId": "", 
                "SecurityGroupIds": []
            }, 
            "MemorySize": 128, 
            "RevisionId": "b029cde1-911e-402f-95e2-760dc76918cf", 
            "CodeSize": 873, 
            "FunctionArn": "arn:aws:lambda:eu-west-2:739465383014:function:createArticle", 
            "Handler": "index.handler", 
            "Role": "arn:aws:iam::739465383014:role/AWSBlogLambda", 
            "Timeout": 3, 
            "LastModified": "2019-06-03T11:23:15.121+0000", 
            "Runtime": "nodejs10.x", 
            "Description": ""
        }
    ]
}

       {
            "Description": "Allows Lambda functions to call AWS services on your behalf.", 
            "AssumeRolePolicyDocument": {
                "Version": "2012-10-17", 
                "Statement": [
                    {
                        "Action": "sts:AssumeRole", 
                        "Effect": "Allow", 
                        "Principal": {
                            "Service": "lambda.amazonaws.com"
                        }
                    }
                ]
            }, 
            "MaxSessionDuration": 3600, 
            "RoleId": "AROA2YK4SJRTCGF7OUU7K", 
            "CreateDate": "2019-06-03T10:50:08Z", 
            "RoleName": "AWSBlogLambda", 
            "Path": "/", 
            "Arn": "arn:aws:iam::739465383014:role/AWSBlogLambda"
        }, 
        {
            "AssumeRolePolicyDocument": {
                "Version": "2012-10-17", 
                "Statement": [
                    {
                        "Action": "sts:AssumeRole", 
                        "Effect": "Allow", 
                        "Principal": {
                            "Service": "dynamodb.application-autoscaling.amazonaws.com"
                        }
                    }
                ]
            }, 
            "MaxSessionDuration": 3600, 
            "RoleId": "AROA2YK4SJRTGEHGJBOAO", 
            "CreateDate": "2019-06-03T08:36:51Z", 
            "RoleName": "AWSServiceRoleForApplicationAutoScaling_DynamoDBTable", 
            "Path": "/aws-service-role/dynamodb.application-autoscaling.amazonaws.com/", 
            "Arn": "arn:aws:iam::739465383014:role/aws-service-role/dynamodb.application-autoscaling.amazonaws.com/AWSServiceRoleForApplicationAutoScaling_DynamoDBTable"
        }, 


resource "aws_iam_role_policy" "AWSBlogLambda_DynamoDBWriteAccess" {
    name   = "DynamoDBWriteAccess"
    role   = "AWSBlogLambda"
    policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "VisualEditor0",
      "Effect": "Allow",
      "Action": "dynamodb:PutItem",
      "Resource": "arn:aws:dynamodb:eu-west-2:739465383014:table/articles"
    }
  ]
}
POLICY
}
*/