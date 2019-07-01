/*
# IAM role which dictates what other AWS services the Lambda function
# may access.
resource "aws_iam_role" "sans_example_exec" {
  name = "sans_example_lambda1"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": [ "lambda.amazonaws.com",
        	"apigateway.amazonaws.com"
				]
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "sans_example_exec_logs" {
  role       = "${aws_iam_role.sans_example_exec.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "sans_example" {
  filename      = "lambda_hello_world.zip"
  function_name = "sans_example"
  role          = "${aws_iam_role.sans_example_exec.arn}"
  handler       = "lambda_hello_world.handler"

  source_code_hash = "${filebase64sha256("lambda_hello_world.zip")}"

  runtime = "nodejs10.x"
}

resource "aws_api_gateway_rest_api" "sans_example" {
  name        = "sans_example"
  description = "Terraform Serverless Application Example"
}

resource "aws_api_gateway_resource" "sans_proxy" {
  rest_api_id = "${aws_api_gateway_rest_api.sans_example.id}"
  parent_id   = "${aws_api_gateway_rest_api.sans_example.root_resource_id}"
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_resource" "sans_test" {
  rest_api_id = "${aws_api_gateway_rest_api.sans_example.id}"
  parent_id   = "${aws_api_gateway_rest_api.sans_example.root_resource_id}"
  path_part   = "test"
}

resource "aws_api_gateway_method" "sans_proxy" {
  rest_api_id   = "${aws_api_gateway_rest_api.sans_example.id}"
  resource_id   = "${aws_api_gateway_resource.sans_proxy.id}"
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "sans_test_get" {
  rest_api_id   = "${aws_api_gateway_rest_api.sans_example.id}"
  resource_id   = "${aws_api_gateway_resource.sans_test.id}"
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "sans_lambda" {
  rest_api_id = "${aws_api_gateway_rest_api.sans_example.id}"
  resource_id = "${aws_api_gateway_method.sans_proxy.resource_id}"
  http_method = "${aws_api_gateway_method.sans_proxy.http_method}"

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.sans_example.invoke_arn}"
}

resource "aws_api_gateway_integration" "sans_test_get" {
  rest_api_id = "${aws_api_gateway_rest_api.sans_example.id}"
  resource_id = "${aws_api_gateway_method.sans_test_get.resource_id}"
  http_method = "${aws_api_gateway_method.sans_test_get.http_method}"
	content_handling = "CONVERT_TO_TEXT"

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.sans_example.invoke_arn}"
}

resource "aws_api_gateway_method" "sans_proxy_root" {
  rest_api_id   = "${aws_api_gateway_rest_api.sans_example.id}"
  resource_id   = "${aws_api_gateway_rest_api.sans_example.root_resource_id}"
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "sans_lambda_root" {
  rest_api_id = "${aws_api_gateway_rest_api.sans_example.id}"
  resource_id = "${aws_api_gateway_method.sans_proxy_root.resource_id}"
  http_method = "${aws_api_gateway_method.sans_proxy_root.http_method}"

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.sans_example.invoke_arn}"
}

resource "aws_api_gateway_deployment" "sans_example" {
  depends_on = [
    "aws_api_gateway_integration.sans_lambda",
    "aws_api_gateway_integration.sans_lambda_root",
  ]

  rest_api_id = "${aws_api_gateway_rest_api.sans_example.id}"
  stage_name  = "test"
}

resource "aws_lambda_permission" "sans_example_apigw" {
//  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.sans_example.arn}"
  principal     = "apigateway.amazonaws.com"

  # within the API Gateway "REST API".
  source_arn = "${aws_api_gateway_rest_api.sans_example.execution_arn}/* /GET/test"
}
*/