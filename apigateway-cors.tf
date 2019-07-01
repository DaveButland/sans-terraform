/*
resource "aws_lambda_function" "hello_world" {
  filename      = "lambda_hello_world.zip"
  function_name = "hello_world"
  role          = "${aws_iam_role.sans_iam_for_lambda.arn}"
  handler       = "lambda_hello_world.handler"

  source_code_hash = "${filebase64sha256("lambda_hello_world.zip")}"

  runtime = "nodejs10.x"
}

resource "aws_api_gateway_rest_api" "cors_api" {
    name          = "sans-demo"
    description   = "An API for demonstrating CORS-enabled methods."
}

resource "aws_api_gateway_resource" "cors_resource" {
    path_part     = "Employee"
    parent_id     = "${aws_api_gateway_rest_api.cors_api.root_resource_id}"
    rest_api_id   = "${aws_api_gateway_rest_api.cors_api.id}"
}

resource "aws_api_gateway_method" "options_method" {
    rest_api_id   = "${aws_api_gateway_rest_api.cors_api.id}"
    resource_id   = "${aws_api_gateway_resource.cors_resource.id}"
    http_method   = "OPTIONS"
    authorization = "NONE"
}

resource "aws_api_gateway_method" "get_method" {
    rest_api_id   = "${aws_api_gateway_rest_api.cors_api.id}"
    resource_id   = "${aws_api_gateway_resource.cors_resource.id}"
    http_method   = "GET"
    authorization = "NONE"
}

resource "aws_api_gateway_method_response" "options_200" {
    rest_api_id   = "${aws_api_gateway_rest_api.cors_api.id}"
    resource_id   = "${aws_api_gateway_resource.cors_resource.id}"
    http_method   = "${aws_api_gateway_method.options_method.http_method}"
    status_code   = "200"
		response_models = {
			"application/json" = "Empty"
    }		
		response_parameters = { 
			"method.response.header.Access-Control-Allow-Headers" = true 
			"method.response.header.Access-Control-Allow-Methods" = true 
			"method.response.header.Access-Control-Allow-Origin" = true 
		}
    depends_on = ["aws_api_gateway_method.options_method"]
}

resource "aws_api_gateway_method_response" "get_200" {
    rest_api_id   = "${aws_api_gateway_rest_api.cors_api.id}"
    resource_id   = "${aws_api_gateway_resource.cors_resource.id}"
    http_method   = "${aws_api_gateway_method.get_method.http_method}"
    status_code   = "200"
		response_models = {
			"application/json" = "Empty"
    }		
		response_parameters = { 
			"method.response.header.Access-Control-Allow-Headers" = true 
			"method.response.header.Access-Control-Allow-Methods" = true 
			"method.response.header.Access-Control-Allow-Origin" = true 
		}
    depends_on = ["aws_api_gateway_method.get_method"]
}

resource "aws_api_gateway_integration" "options_integration" {
    rest_api_id   = "${aws_api_gateway_rest_api.cors_api.id}"
    resource_id   = "${aws_api_gateway_resource.cors_resource.id}"
    http_method   = "${aws_api_gateway_method.options_method.http_method}"
    type          = "MOCK"
    depends_on = ["aws_api_gateway_method.options_method"]
}

resource "aws_api_gateway_integration" "get_integration" {
    rest_api_id   = "${aws_api_gateway_rest_api.cors_api.id}"
    resource_id   = "${aws_api_gateway_resource.cors_resource.id}"
    http_method   = "${aws_api_gateway_method.get_method.http_method}"
		integration_http_method = "GET"
    type          					= "AWS_PROXY"	
		uri											= "${aws_lambda_function.hello_world.invoke_arn}"
    depends_on = ["aws_api_gateway_method.get_method"]
}
resource "aws_api_gateway_integration_response" "options_integration_response" {
    rest_api_id   = "${aws_api_gateway_rest_api.cors_api.id}"
    resource_id   = "${aws_api_gateway_resource.cors_resource.id}"
    http_method   = "${aws_api_gateway_method.options_method.http_method}"
    status_code   = "${aws_api_gateway_method_response.options_200.status_code}"
    response_parameters = {
			"method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
			"method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT'",
			"method.response.header.Access-Control-Allow-Origin" = "'*'"
    }
    depends_on = ["aws_api_gateway_method_response.options_200"]
}

resource "aws_api_gateway_integration_response" "get_integration_response" {
    rest_api_id   = "${aws_api_gateway_rest_api.cors_api.id}"
    resource_id   = "${aws_api_gateway_resource.cors_resource.id}"
    http_method   = "${aws_api_gateway_method.get_method.http_method}"
    status_code   = "${aws_api_gateway_method_response.get_200.status_code}"
    response_parameters = {
			"method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
			"method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT'",
			"method.response.header.Access-Control-Allow-Origin" = "'*'"
    }
    depends_on = ["aws_api_gateway_method_response.get_200"]
}

resource "aws_api_gateway_deployment" "cors_api" {
  depends_on = [
    "aws_api_gateway_integration.get_integration"
  ]

  rest_api_id = "${aws_api_gateway_rest_api.cors_api.id}"
  stage_name  = "test"
}

resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.hello_world.arn}"
  principal     = "apigateway.amazonaws.com"

  # within the API Gateway "REST API".
  source_arn = "${aws_api_gateway_deployment.cors_api.execution_arn}/* /*"
}

output "base_url" {
  value = "${aws_api_gateway_deployment.cors_api.invoke_url}"
}

*/

