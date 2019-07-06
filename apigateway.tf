
//API GATEWAY
resource "aws_api_gateway_rest_api" "sans_api" {
  name        = "sans_api"
  description = "Sans-website apis"
}

//Need to know what to put here
data "aws_cognito_user_pools" "sans_website" {
  name = "${aws_cognito_user_pool.sans_website.name}"

	depends_on = ["aws_cognito_user_pool.sans_website"]
}

resource "aws_api_gateway_authorizer" "sans_api" {
  name                   = "sans_api"
	type                   = "COGNITO_USER_POOLS"
  rest_api_id            = "${aws_api_gateway_rest_api.sans_api.id}"
	provider_arns          = "${data.aws_cognito_user_pools.sans_website.arns}"
	identity_source        = "method.request.header.Authorization"

	depends_on = ["aws_cognito_user_pool.sans_website"]
}

//API RESOURCES
resource "aws_api_gateway_resource" "sans_api_folders" {
  rest_api_id = "${aws_api_gateway_rest_api.sans_api.id}"
  parent_id   = "${aws_api_gateway_rest_api.sans_api.root_resource_id}"
  path_part   = "folders"

  depends_on = ["aws_api_gateway_rest_api.sans_api"]
}

resource "aws_api_gateway_resource" "sans_api_folders_folderid" {
  rest_api_id = "${aws_api_gateway_rest_api.sans_api.id}"
  parent_id   = "${aws_api_gateway_resource.sans_api_folders.id}"
  path_part   = "{folderid}"

  depends_on = ["aws_api_gateway_resource.sans_api_folders"]
}

resource "aws_api_gateway_resource" "sans_api_folders_folderid_images" {
  rest_api_id = "${aws_api_gateway_rest_api.sans_api.id}"
  parent_id   = "${aws_api_gateway_resource.sans_api_folders_folderid.id}"
  path_part   = "images"

  depends_on = ["aws_api_gateway_resource.sans_api_folders_folderid"]
}

resource "aws_api_gateway_resource" "sans_api_folders_folderid_images_imageid" {
  rest_api_id = "${aws_api_gateway_rest_api.sans_api.id}"
  parent_id   = "${aws_api_gateway_resource.sans_api_folders_folderid_images.id}"
  path_part   = "{imagesid}"

  depends_on = ["aws_api_gateway_resource.sans_api_folders_folderid_images"]
}

resource "aws_api_gateway_resource" "sans_api_images" {
  rest_api_id = "${aws_api_gateway_rest_api.sans_api.id}"
  parent_id   = "${aws_api_gateway_rest_api.sans_api.root_resource_id}"
  path_part   = "images"

  depends_on = ["aws_api_gateway_rest_api.sans_api"]
}

resource "aws_api_gateway_resource" "sans_api_images_imageid" {
  rest_api_id = "${aws_api_gateway_rest_api.sans_api.id}"
  parent_id   = "${aws_api_gateway_resource.sans_api_images.id}"
  path_part   = "{imageid}"

  depends_on = ["aws_api_gateway_resource.sans_api_images"]
}

resource "aws_api_gateway_resource" "sans_api_cookies" {
  rest_api_id = "${aws_api_gateway_rest_api.sans_api.id}"
  parent_id   = "${aws_api_gateway_rest_api.sans_api.root_resource_id}"
  path_part   = "cookies"

  depends_on = ["aws_api_gateway_rest_api.sans_api"]
}

//API METHODS
resource "aws_api_gateway_method" "sans_api_folders_options" {
  rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
  resource_id   = "${aws_api_gateway_resource.sans_api_folders.id}"
  http_method   = "OPTIONS"
  authorization = "NONE"

  depends_on = ["aws_api_gateway_resource.sans_api_folders"]
}

resource "aws_api_gateway_method" "sans_api_folders_get" {
  rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
  resource_id   = "${aws_api_gateway_resource.sans_api_folders.id}"
  http_method   = "GET"
	
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = "${aws_api_gateway_authorizer.sans_api.id}"
	authorization_scopes = ["aws.cognito.signin.user.admin"]

  depends_on = ["aws_api_gateway_resource.sans_api_folders"]
}

resource "aws_api_gateway_method" "sans_api_folders_post" {
  rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
  resource_id   = "${aws_api_gateway_resource.sans_api_folders.id}"
  http_method   = "POST"

  authorization = "COGNITO_USER_POOLS"
  authorizer_id = "${aws_api_gateway_authorizer.sans_api.id}"
	authorization_scopes = ["aws.cognito.signin.user.admin"]

  depends_on = ["aws_api_gateway_resource.sans_api_folders"]
}

resource "aws_api_gateway_method" "sans_api_folders_folderid_options" {
  rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
  resource_id   = "${aws_api_gateway_resource.sans_api_folders_folderid.id}"
  http_method   = "OPTIONS"

  authorization = "NONE"

  depends_on = ["aws_api_gateway_resource.sans_api_folders_folderid"]
}

resource "aws_api_gateway_method" "sans_api_folders_folderid_get" {
  rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
  resource_id   = "${aws_api_gateway_resource.sans_api_folders_folderid.id}"
  http_method   = "GET"

  authorization = "COGNITO_USER_POOLS"
  authorizer_id = "${aws_api_gateway_authorizer.sans_api.id}"
	authorization_scopes = ["aws.cognito.signin.user.admin"]

  depends_on = ["aws_api_gateway_resource.sans_api_folders_folderid"]
}

resource "aws_api_gateway_method" "sans_api_folders_folderid_put" {
  rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
  resource_id   = "${aws_api_gateway_resource.sans_api_folders_folderid.id}"
  http_method   = "PUT"

  authorization = "COGNITO_USER_POOLS"
  authorizer_id = "${aws_api_gateway_authorizer.sans_api.id}"
	authorization_scopes = ["aws.cognito.signin.user.admin"]

  depends_on = ["aws_api_gateway_resource.sans_api_folders_folderid"]
}

resource "aws_api_gateway_method" "sans_api_folders_folderid_delete" {
  rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
  resource_id   = "${aws_api_gateway_resource.sans_api_folders_folderid.id}"
  http_method   = "DELETE"

  authorization = "COGNITO_USER_POOLS"
  authorizer_id = "${aws_api_gateway_authorizer.sans_api.id}"
	authorization_scopes = ["aws.cognito.signin.user.admin"]

  depends_on = ["aws_api_gateway_resource.sans_api_folders_folderid"]
}

resource "aws_api_gateway_method" "sans_api_folders_folderid_images_options" {
  rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
  resource_id   = "${aws_api_gateway_resource.sans_api_folders_folderid_images.id}"
  http_method   = "OPTIONS"
  authorization = "NONE"

  depends_on = ["aws_api_gateway_resource.sans_api_folders_folderid_images"]
}

resource "aws_api_gateway_method" "sans_api_folders_folderid_images_get" {
  rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
  resource_id   = "${aws_api_gateway_resource.sans_api_folders_folderid_images.id}"
  http_method   = "GET"

  authorization = "COGNITO_USER_POOLS"
  authorizer_id = "${aws_api_gateway_authorizer.sans_api.id}"
	authorization_scopes = ["aws.cognito.signin.user.admin"]

  depends_on = ["aws_api_gateway_resource.sans_api_folders_folderid_images"]
}

resource "aws_api_gateway_method" "sans_api_folders_folderid_images_imageid_options" {
  rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
  resource_id   = "${aws_api_gateway_resource.sans_api_folders_folderid_images_imageid.id}"
  http_method   = "OPTIONS"
  authorization = "NONE"

  depends_on = ["aws_api_gateway_resource.sans_api_folders_folderid_images_imageid"]
}

resource "aws_api_gateway_method" "sans_api_folders_folderid_images_imageid_delete" {
  rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
  resource_id   = "${aws_api_gateway_resource.sans_api_folders_folderid_images_imageid.id}"
  http_method   = "DELETE"

  authorization = "COGNITO_USER_POOLS"
  authorizer_id = "${aws_api_gateway_authorizer.sans_api.id}"
	authorization_scopes = ["aws.cognito.signin.user.admin"]

  depends_on = ["aws_api_gateway_resource.sans_api_folders_folderid_images_imageid"]
}

resource "aws_api_gateway_method" "sans_api_images_options" {
  rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
  resource_id   = "${aws_api_gateway_resource.sans_api_images.id}"
  http_method   = "OPTIONS"
  authorization = "NONE"

  depends_on = ["aws_api_gateway_resource.sans_api_images"]
}

resource "aws_api_gateway_method" "sans_api_images_get" {
  rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
  resource_id   = "${aws_api_gateway_resource.sans_api_images.id}"
  http_method   = "GET"

  authorization = "COGNITO_USER_POOLS"
  authorizer_id = "${aws_api_gateway_authorizer.sans_api.id}"
	authorization_scopes = ["aws.cognito.signin.user.admin"]

  depends_on = ["aws_api_gateway_resource.sans_api_images"]
}

resource "aws_api_gateway_method" "sans_api_images_post" {
  rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
  resource_id   = "${aws_api_gateway_resource.sans_api_images.id}"
  http_method   = "POST"

  authorization = "COGNITO_USER_POOLS"
  authorizer_id = "${aws_api_gateway_authorizer.sans_api.id}"
	authorization_scopes = ["aws.cognito.signin.user.admin"]

  depends_on = ["aws_api_gateway_resource.sans_api_images"]
}

resource "aws_api_gateway_method" "sans_api_images_imageid_options" {
  rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
  resource_id   = "${aws_api_gateway_resource.sans_api_images_imageid.id}"
  http_method   = "OPTIONS"

  authorization = "NONE"

  depends_on = ["aws_api_gateway_resource.sans_api_images_imageid"]
}

resource "aws_api_gateway_method" "sans_api_images_imageid_get" {
  rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
  resource_id   = "${aws_api_gateway_resource.sans_api_images_imageid.id}"
  http_method   = "GET"

  authorization = "COGNITO_USER_POOLS"
  authorizer_id = "${aws_api_gateway_authorizer.sans_api.id}"
	authorization_scopes = ["aws.cognito.signin.user.admin"]

  depends_on = ["aws_api_gateway_resource.sans_api_images_imageid"]
}

resource "aws_api_gateway_method" "sans_api_images_imageid_put" {
  rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
  resource_id   = "${aws_api_gateway_resource.sans_api_images_imageid.id}"
  http_method   = "PUT"

  authorization = "COGNITO_USER_POOLS"
  authorizer_id = "${aws_api_gateway_authorizer.sans_api.id}"
	authorization_scopes = ["aws.cognito.signin.user.admin"]

  depends_on = ["aws_api_gateway_resource.sans_api_images_imageid"]
}

resource "aws_api_gateway_method" "sans_api_images_imageid_delete" {
  rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
  resource_id   = "${aws_api_gateway_resource.sans_api_images_imageid.id}"
  http_method   = "DELETE"

  authorization = "COGNITO_USER_POOLS"
  authorizer_id = "${aws_api_gateway_authorizer.sans_api.id}"
	authorization_scopes = ["aws.cognito.signin.user.admin"]

  depends_on = ["aws_api_gateway_resource.sans_api_images_imageid"]
}

resource "aws_api_gateway_method" "sans_api_cookies_options" {
  rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
  resource_id   = "${aws_api_gateway_resource.sans_api_cookies.id}"
  http_method   = "OPTIONS"
  authorization = "NONE"

  depends_on = ["aws_api_gateway_resource.sans_api_cookies"]
}

resource "aws_api_gateway_method" "sans_api_cookies_get" {
  rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
  resource_id   = "${aws_api_gateway_resource.sans_api_cookies.id}"
  http_method   = "GET"

  authorization = "COGNITO_USER_POOLS"
  authorizer_id = "${aws_api_gateway_authorizer.sans_api.id}"
	authorization_scopes = ["aws.cognito.signin.user.admin"]

  depends_on = ["aws_api_gateway_resource.sans_api_cookies"]
}

//METHOD RESPONSE
resource "aws_api_gateway_method_response" "sans_api_folders_options" {
    rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
    resource_id   = "${aws_api_gateway_resource.sans_api_folders.id}"
    http_method   = "${aws_api_gateway_method.sans_api_folders_options.http_method}"
    status_code   = 200
		response_models = {
			"application/json" = "Empty"
    }		
		response_parameters = { 
			"method.response.header.Access-Control-Allow-Headers" = true 
			"method.response.header.Access-Control-Allow-Methods" = true 
			"method.response.header.Access-Control-Allow-Origin" = true 
		}

    depends_on = ["aws_api_gateway_method.sans_api_folders_options"]
}

resource "aws_api_gateway_method_response" "sans_api_folders_get" {
    rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
    resource_id   = "${aws_api_gateway_resource.sans_api_folders.id}"
    http_method   = "${aws_api_gateway_method.sans_api_folders_get.http_method}"
    status_code   = 200
		response_models = {
			"application/json" = "Empty"
    }

    depends_on = ["aws_api_gateway_method.sans_api_folders_get"]
}

resource "aws_api_gateway_method_response" "sans_api_folders_post" {
    rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
    resource_id   = "${aws_api_gateway_resource.sans_api_folders.id}"
    http_method   = "${aws_api_gateway_method.sans_api_folders_post.http_method}"
    status_code   = 200
		response_models = {
			"application/json" = "Empty"
    }

    depends_on = ["aws_api_gateway_method.sans_api_folders_post"]
}

resource "aws_api_gateway_method_response" "sans_api_folders_folderid_options" {
    rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
    resource_id   = "${aws_api_gateway_resource.sans_api_folders_folderid.id}"
    http_method   = "${aws_api_gateway_method.sans_api_folders_folderid_options.http_method}"
    status_code   = 200
		response_models = {
			"application/json" = "Empty"
    }		
		response_parameters = { 
			"method.response.header.Access-Control-Allow-Headers" = true 
			"method.response.header.Access-Control-Allow-Methods" = true 
			"method.response.header.Access-Control-Allow-Origin" = true 
		}

    depends_on = ["aws_api_gateway_method.sans_api_folders_folderid_options"]
}

resource "aws_api_gateway_method_response" "sans_api_folders_folderid_get" {
    rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
    resource_id   = "${aws_api_gateway_resource.sans_api_folders_folderid.id}"
    http_method   = "${aws_api_gateway_method.sans_api_folders_folderid_get.http_method}"
    status_code   = 200
		response_models = {
			"application/json" = "Empty"
    }

    depends_on = ["aws_api_gateway_method.sans_api_folders_folderid_get"]
}

resource "aws_api_gateway_method_response" "sans_api_folders_folderid_put" {
    rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
    resource_id   = "${aws_api_gateway_resource.sans_api_folders_folderid.id}"
    http_method   = "${aws_api_gateway_method.sans_api_folders_folderid_put.http_method}"
    status_code   = 200
		response_models = {
			"application/json" = "Empty"
    }

    depends_on = ["aws_api_gateway_method.sans_api_folders_folderid_put"]
}

resource "aws_api_gateway_method_response" "sans_api_folders_folderid_delete" {
    rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
    resource_id   = "${aws_api_gateway_resource.sans_api_folders_folderid.id}"
    http_method   = "${aws_api_gateway_method.sans_api_folders_folderid_delete.http_method}"
    status_code   = 200
		response_models = {
			"application/json" = "Empty"
    }

    depends_on = ["aws_api_gateway_method.sans_api_folders_folderid_delete"]
}

resource "aws_api_gateway_method_response" "sans_api_folders_folderid_images_options" {
    rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
    resource_id   = "${aws_api_gateway_resource.sans_api_folders_folderid_images.id}"
    http_method   = "${aws_api_gateway_method.sans_api_folders_folderid_images_options.http_method}"
    status_code   = 200
		response_models = {
			"application/json" = "Empty"
    }		
		response_parameters = { 
			"method.response.header.Access-Control-Allow-Headers" = true 
			"method.response.header.Access-Control-Allow-Methods" = true 
			"method.response.header.Access-Control-Allow-Origin" = true 
		}

    depends_on = ["aws_api_gateway_method.sans_api_folders_folderid_images_options"]
}
resource "aws_api_gateway_method_response" "sans_api_folders_folderid_images_get" {
    rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
    resource_id   = "${aws_api_gateway_resource.sans_api_folders_folderid_images.id}"
    http_method   = "${aws_api_gateway_method.sans_api_folders_folderid_images_get.http_method}"
    status_code   = 200
		response_models = {
			"application/json" = "Empty"
    }

    depends_on = ["aws_api_gateway_method.sans_api_folders_folderid_images_get"]
}

resource "aws_api_gateway_method_response" "sans_api_folders_folderid_images_imageid_options" {
    rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
    resource_id   = "${aws_api_gateway_resource.sans_api_folders_folderid_images_imageid.id}"
    http_method   = "${aws_api_gateway_method.sans_api_folders_folderid_images_imageid_options.http_method}"
    status_code   = 200
		response_models = {
			"application/json" = "Empty"
    }		
		response_parameters = { 
			"method.response.header.Access-Control-Allow-Headers" = true 
			"method.response.header.Access-Control-Allow-Methods" = true 
			"method.response.header.Access-Control-Allow-Origin" = true 
		}

    depends_on = ["aws_api_gateway_method.sans_api_folders_folderid_images_imageid_options"]
}
resource "aws_api_gateway_method_response" "sans_api_folders_folderid_images_imageid_delete" {
    rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
    resource_id   = "${aws_api_gateway_resource.sans_api_folders_folderid_images_imageid.id}"
    http_method   = "${aws_api_gateway_method.sans_api_folders_folderid_images_imageid_delete.http_method}"
    status_code   = 200
		response_models = {
			"application/json" = "Empty"
    }

    depends_on = ["aws_api_gateway_method.sans_api_folders_folderid_images_imageid_delete"]
}

resource "aws_api_gateway_method_response" "sans_api_images_options" {
    rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
    resource_id   = "${aws_api_gateway_resource.sans_api_images.id}"
    http_method   = "${aws_api_gateway_method.sans_api_images_options.http_method}"
    status_code   = 200
		response_models = {
			"application/json" = "Empty"
    }		
		response_parameters = { 
			"method.response.header.Access-Control-Allow-Headers" = true 
			"method.response.header.Access-Control-Allow-Methods" = true 
			"method.response.header.Access-Control-Allow-Origin" = true 
		}
    depends_on = ["aws_api_gateway_method.sans_api_images_options"]
}

resource "aws_api_gateway_method_response" "sans_api_images_get" {
    rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
    resource_id   = "${aws_api_gateway_resource.sans_api_images.id}"
    http_method   = "${aws_api_gateway_method.sans_api_images_get.http_method}"
    status_code   = 200
		response_models = {
			"application/json" = "Empty"
    }

    depends_on = ["aws_api_gateway_method.sans_api_images_get"]
}

resource "aws_api_gateway_method_response" "sans_api_images_post" {
    rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
    resource_id   = "${aws_api_gateway_resource.sans_api_images.id}"
    http_method   = "${aws_api_gateway_method.sans_api_images_post.http_method}"
    status_code   = 200
		response_models = {
			"application/json" = "Empty"
    }

    depends_on = ["aws_api_gateway_method.sans_api_images_post"]
}

resource "aws_api_gateway_method_response" "sans_api_images_imageid_options" {
    rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
    resource_id   = "${aws_api_gateway_resource.sans_api_images_imageid.id}"
    http_method   = "${aws_api_gateway_method.sans_api_images_imageid_options.http_method}"
    status_code   = 200
		response_models = {
			"application/json" = "Empty"
    }		
		response_parameters = { 
			"method.response.header.Access-Control-Allow-Headers" = true 
			"method.response.header.Access-Control-Allow-Methods" = true 
			"method.response.header.Access-Control-Allow-Origin" = true 
		}

    depends_on = ["aws_api_gateway_method.sans_api_images_imageid_options"]
}

resource "aws_api_gateway_method_response" "sans_api_images_imageid_get" {
    rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
    resource_id   = "${aws_api_gateway_resource.sans_api_images_imageid.id}"
    http_method   = "${aws_api_gateway_method.sans_api_images_imageid_get.http_method}"
    status_code   = 200
		response_models = {
			"application/json" = "Empty"
    }

    depends_on = ["aws_api_gateway_method.sans_api_images_imageid_get"]
}

resource "aws_api_gateway_method_response" "sans_api_images_imageid_put" {
    rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
    resource_id   = "${aws_api_gateway_resource.sans_api_images_imageid.id}"
    http_method   = "${aws_api_gateway_method.sans_api_images_imageid_put.http_method}"
    status_code   = 200
		response_models = {
			"application/json" = "Empty"
    }

    depends_on = ["aws_api_gateway_method.sans_api_images_imageid_put"]
}

resource "aws_api_gateway_method_response" "sans_api_images_imageid_delete" {
    rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
    resource_id   = "${aws_api_gateway_resource.sans_api_images_imageid.id}"
    http_method   = "${aws_api_gateway_method.sans_api_images_imageid_delete.http_method}"
    status_code   = 200
		response_models = {
			"application/json" = "Empty"
    }

    depends_on = ["aws_api_gateway_method.sans_api_images_imageid_delete"]
}

resource "aws_api_gateway_method_response" "sans_api_cookies_options" {
    rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
    resource_id   = "${aws_api_gateway_resource.sans_api_cookies.id}"
    http_method   = "${aws_api_gateway_method.sans_api_cookies_options.http_method}"
    status_code   = 200
		response_models = {
			"application/json" = "Empty"
    }		
		response_parameters = { 
			"method.response.header.Access-Control-Allow-Headers" = true 
			"method.response.header.Access-Control-Allow-Methods" = true 
			"method.response.header.Access-Control-Allow-Origin" = true 
		}
    depends_on = ["aws_api_gateway_method.sans_api_cookies_options"]
}

resource "aws_api_gateway_method_response" "sans_api_cookies_get" {
    rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
    resource_id   = "${aws_api_gateway_resource.sans_api_cookies.id}"
    http_method   = "${aws_api_gateway_method.sans_api_cookies_get.http_method}"
    status_code   = 200
		response_models = {
			"application/json" = "Empty"
    }

    depends_on = ["aws_api_gateway_method.sans_api_cookies_get"]
}

//API INTEGRATIONS
resource "aws_api_gateway_integration" "sans_api_folders_options" {
  rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
  resource_id   = "${aws_api_gateway_resource.sans_api_folders.id}"
  http_method   = "${aws_api_gateway_method.sans_api_folders_options.http_method}"
  type          = "MOCK"
	request_templates = {
    "application/json" = <<EOF
{"statusCode": 200}
EOF
}

  depends_on = ["aws_api_gateway_method.sans_api_folders_options"]
}

resource "aws_api_gateway_integration" "sans_api_folders_get" {
  rest_api_id = "${aws_api_gateway_rest_api.sans_api.id}"
  resource_id = "${aws_api_gateway_method.sans_api_folders_get.resource_id}"
  http_method = "${aws_api_gateway_method.sans_api_folders_get.http_method}"

	content_handling        = "CONVERT_TO_TEXT"
	integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.sans_folders_getall.invoke_arn}"

  depends_on = ["aws_api_gateway_method.sans_api_folders_get"]
}

resource "aws_api_gateway_integration" "sans_api_folders_post" {
  rest_api_id = "${aws_api_gateway_rest_api.sans_api.id}"
  resource_id = "${aws_api_gateway_method.sans_api_folders_post.resource_id}"
  http_method = "${aws_api_gateway_method.sans_api_folders_post.http_method}"

	content_handling        = "CONVERT_TO_TEXT"
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.sans_folders_create.invoke_arn}"

  depends_on = ["aws_api_gateway_method.sans_api_folders_post"]
}

resource "aws_api_gateway_integration" "sans_api_folders_folderid_options" {
  rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
  resource_id   = "${aws_api_gateway_resource.sans_api_folders_folderid.id}"
  http_method   = "${aws_api_gateway_method.sans_api_folders_folderid_options.http_method}"
  type          = "MOCK"
	request_templates = {
    "application/json" = <<EOF
{"statusCode": 200}
EOF
}

  depends_on = ["aws_api_gateway_method.sans_api_folders_folderid_options"]
}

resource "aws_api_gateway_integration" "sans_api_folders_folderid_get" {
  rest_api_id = "${aws_api_gateway_rest_api.sans_api.id}"
  resource_id = "${aws_api_gateway_method.sans_api_folders_folderid_get.resource_id}"
  http_method = "${aws_api_gateway_method.sans_api_folders_folderid_get.http_method}"

	content_handling        = "CONVERT_TO_TEXT"
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.sans_folders_get.invoke_arn}"

  depends_on = ["aws_api_gateway_method.sans_api_folders_folderid_get"]
}

resource "aws_api_gateway_integration" "sans_api_folders_folderid_put" {
  rest_api_id = "${aws_api_gateway_rest_api.sans_api.id}"
  resource_id = "${aws_api_gateway_method.sans_api_folders_folderid_put.resource_id}"
  http_method = "${aws_api_gateway_method.sans_api_folders_folderid_put.http_method}"

	content_handling        = "CONVERT_TO_TEXT"
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.sans_folders_rename.invoke_arn}"

  depends_on = ["aws_api_gateway_method.sans_api_folders_folderid_put"]
}

resource "aws_api_gateway_integration" "sans_api_folders_folderid_delete" {
  rest_api_id = "${aws_api_gateway_rest_api.sans_api.id}"
  resource_id = "${aws_api_gateway_method.sans_api_folders_folderid_delete.resource_id}"
  http_method = "${aws_api_gateway_method.sans_api_folders_folderid_delete.http_method}"

	content_handling        = "CONVERT_TO_TEXT"
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.sans_folders_delete.invoke_arn}"

  depends_on = ["aws_api_gateway_method.sans_api_folders_folderid_delete"]
}

resource "aws_api_gateway_integration" "sans_api_folders_folderid_images_options" {
  rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
  resource_id   = "${aws_api_gateway_resource.sans_api_folders_folderid_images.id}"
  http_method   = "${aws_api_gateway_method.sans_api_folders_folderid_images_options.http_method}"
  type          = "MOCK"
	request_templates = {
    "application/json" = <<EOF
{"statusCode": 200}
EOF
}

  depends_on = ["aws_api_gateway_method.sans_api_folders_folderid_images_options"]
}

resource "aws_api_gateway_integration" "sans_api_folders_folderid_images_get" {
  rest_api_id = "${aws_api_gateway_rest_api.sans_api.id}"
  resource_id = "${aws_api_gateway_method.sans_api_folders_folderid_images_get.resource_id}"
  http_method = "${aws_api_gateway_method.sans_api_folders_folderid_images_get.http_method}"

	content_handling        = "CONVERT_TO_TEXT"
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.sans_images_getall.invoke_arn}"

  depends_on = ["aws_api_gateway_method.sans_api_folders_folderid_images_get"]
}

resource "aws_api_gateway_integration" "sans_api_folders_folderid_images_imageid_options" {
  rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
  resource_id   = "${aws_api_gateway_resource.sans_api_folders_folderid_images_imageid.id}"
  http_method   = "${aws_api_gateway_method.sans_api_folders_folderid_images_imageid_options.http_method}"
  type          = "MOCK"
	request_templates = {
    "application/json" = <<EOF
{"statusCode": 200}
EOF
}

  depends_on = ["aws_api_gateway_method.sans_api_folders_folderid_images_imageid_options"]
}

resource "aws_api_gateway_integration" "sans_api_folders_folderid_images_imageid_delete" {
  rest_api_id = "${aws_api_gateway_rest_api.sans_api.id}"
  resource_id = "${aws_api_gateway_method.sans_api_folders_folderid_images_imageid_delete.resource_id}"
  http_method = "${aws_api_gateway_method.sans_api_folders_folderid_images_imageid_delete.http_method}"

	content_handling        = "CONVERT_TO_TEXT"
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.sans_images_delete.invoke_arn}"

  depends_on = ["aws_api_gateway_method.sans_api_folders_folderid_images_imageid_delete"]
}

resource "aws_api_gateway_integration" "sans_api_images_options" {
  rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
  resource_id   = "${aws_api_gateway_resource.sans_api_images.id}"
  http_method   = "${aws_api_gateway_method.sans_api_images_options.http_method}"
  type          = "MOCK"
	request_templates = {
    "application/json" = <<EOF
{"statusCode": 200}
EOF
}

  depends_on = ["aws_api_gateway_method.sans_api_images_options"]
}

resource "aws_api_gateway_integration" "sans_api_images_get" {
  rest_api_id = "${aws_api_gateway_rest_api.sans_api.id}"
  resource_id = "${aws_api_gateway_method.sans_api_images_get.resource_id}"
  http_method = "${aws_api_gateway_method.sans_api_images_get.http_method}"

	content_handling        = "CONVERT_TO_TEXT"
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.sans_images_getall.invoke_arn}"

  depends_on = ["aws_api_gateway_method.sans_api_images_get"]
}

resource "aws_api_gateway_integration" "sans_api_images_post" {
  rest_api_id = "${aws_api_gateway_rest_api.sans_api.id}"
  resource_id = "${aws_api_gateway_method.sans_api_images_post.resource_id}"
  http_method = "${aws_api_gateway_method.sans_api_images_post.http_method}"

	content_handling        = "CONVERT_TO_TEXT"
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.sans_images_create.invoke_arn}"

  depends_on = ["aws_api_gateway_method.sans_api_images_post"]
}

resource "aws_api_gateway_integration" "sans_api_images_imageid_options" {
  rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
  resource_id   = "${aws_api_gateway_resource.sans_api_images_imageid.id}"
  http_method   = "${aws_api_gateway_method.sans_api_images_imageid_options.http_method}"
  type          = "MOCK"
	request_templates = {
    "application/json" = <<EOF
{"statusCode": 200}
EOF
}

  depends_on = ["aws_api_gateway_method.sans_api_images_imageid_options"]
}

resource "aws_api_gateway_integration" "sans_api_images_imageid_get" {
  rest_api_id = "${aws_api_gateway_rest_api.sans_api.id}"
  resource_id = "${aws_api_gateway_method.sans_api_images_imageid_get.resource_id}"
  http_method = "${aws_api_gateway_method.sans_api_images_imageid_get.http_method}"

	content_handling        = "CONVERT_TO_TEXT"
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.sans_images_get.invoke_arn}"

  depends_on = ["aws_api_gateway_method.sans_api_images_imageid_get"]
}

resource "aws_api_gateway_integration" "sans_api_images_imageid_put" {
  rest_api_id = "${aws_api_gateway_rest_api.sans_api.id}"
  resource_id = "${aws_api_gateway_method.sans_api_images_imageid_put.resource_id}"
  http_method = "${aws_api_gateway_method.sans_api_images_imageid_put.http_method}"

	content_handling        = "CONVERT_TO_TEXT"
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.sans_images_update.invoke_arn}"

  depends_on = ["aws_api_gateway_method.sans_api_images_imageid_put"]
}

resource "aws_api_gateway_integration" "sans_api_images_imageid_delete" {
  rest_api_id = "${aws_api_gateway_rest_api.sans_api.id}"
  resource_id = "${aws_api_gateway_method.sans_api_images_imageid_delete.resource_id}"
  http_method = "${aws_api_gateway_method.sans_api_images_imageid_delete.http_method}"

	content_handling        = "CONVERT_TO_TEXT"
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.sans_images_delete.invoke_arn}"

  depends_on = ["aws_api_gateway_method.sans_api_images_imageid_delete"]
}

resource "aws_api_gateway_integration" "sans_api_cookies_options" {
  rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
  resource_id   = "${aws_api_gateway_resource.sans_api_cookies.id}"
  http_method   = "${aws_api_gateway_method.sans_api_cookies_options.http_method}"
  type          = "MOCK"
	request_templates = {
    "application/json" = <<EOF
{"statusCode": 200}
EOF
}

  depends_on = ["aws_api_gateway_method.sans_api_cookies_options"]
}

resource "aws_api_gateway_integration" "sans_api_cookies_get" {
  rest_api_id = "${aws_api_gateway_rest_api.sans_api.id}"
  resource_id = "${aws_api_gateway_method.sans_api_cookies_get.resource_id}"
  http_method = "${aws_api_gateway_method.sans_api_cookies_get.http_method}"

	content_handling        = "CONVERT_TO_TEXT"
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.sans_cookies_get.invoke_arn}"

  depends_on = ["aws_api_gateway_method.sans_api_cookies_get"]
}

//Integration Responses
resource "aws_api_gateway_integration_response" "sans_api_folders_options" {
    rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
    resource_id   = "${aws_api_gateway_resource.sans_api_folders.id}"
    http_method   = "${aws_api_gateway_method.sans_api_folders_options.http_method}"
    status_code   = "${aws_api_gateway_method_response.sans_api_folders_options.status_code}"
    response_parameters = {
			"method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
			"method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT,DELETE'",
			"method.response.header.Access-Control-Allow-Origin" = "'*'"
    }
    depends_on = ["aws_api_gateway_integration.sans_api_folders_options"]
}

resource "aws_api_gateway_integration_response" "sans_api_folders_get" {
    rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
    resource_id   = "${aws_api_gateway_resource.sans_api_folders.id}"
    http_method   = "${aws_api_gateway_method.sans_api_folders_get.http_method}"
    status_code   = "${aws_api_gateway_method_response.sans_api_folders_get.status_code}"
		response_templates = { 
			"application/json" = "null"
    }		

    depends_on = ["aws_api_gateway_integration.sans_api_folders_get"]
}

resource "aws_api_gateway_integration_response" "sans_api_folders_post" {
    rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
    resource_id   = "${aws_api_gateway_resource.sans_api_folders.id}"
    http_method   = "${aws_api_gateway_method.sans_api_folders_post.http_method}"
    status_code   = "${aws_api_gateway_method_response.sans_api_folders_get.status_code}"
		response_templates = { 
			"application/json" = "null"
    }		

    depends_on = ["aws_api_gateway_integration.sans_api_folders_post"]
}

resource "aws_api_gateway_integration_response" "sans_api_folders_folderid_options" {
    rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
    resource_id   = "${aws_api_gateway_resource.sans_api_folders_folderid.id}"
    http_method   = "${aws_api_gateway_method.sans_api_folders_folderid_options.http_method}"
    status_code   = "${aws_api_gateway_method_response.sans_api_folders_folderid_options.status_code}"
    response_parameters = {
			"method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
			"method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT,DELETE'",
			"method.response.header.Access-Control-Allow-Origin" = "'*'"
    }
    depends_on = ["aws_api_gateway_integration.sans_api_folders_folderid_options"]
}

resource "aws_api_gateway_integration_response" "sans_api_folders_folderid_get" {
    rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
    resource_id   = "${aws_api_gateway_resource.sans_api_folders_folderid.id}"
    http_method   = "${aws_api_gateway_method.sans_api_folders_folderid_get.http_method}"
    status_code   = "${aws_api_gateway_method_response.sans_api_folders_folderid_get.status_code}"
		response_templates = { 
			"application/json" = "null"
    }		

    depends_on = ["aws_api_gateway_integration.sans_api_folders_folderid_get"]
}

resource "aws_api_gateway_integration_response" "sans_api_folders_folderid_put" {
    rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
    resource_id   = "${aws_api_gateway_resource.sans_api_folders_folderid.id}"
    http_method   = "${aws_api_gateway_method.sans_api_folders_folderid_put.http_method}"
    status_code   = "${aws_api_gateway_method_response.sans_api_folders_folderid_put.status_code}"
		response_templates = { 
			"application/json" = "null"
    }		

    depends_on = ["aws_api_gateway_integration.sans_api_folders_folderid_put"]
}

resource "aws_api_gateway_integration_response" "sans_api_folders_folderid_delete" {
    rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
    resource_id   = "${aws_api_gateway_resource.sans_api_folders_folderid.id}"
    http_method   = "${aws_api_gateway_method.sans_api_folders_folderid_delete.http_method}"
    status_code   = "${aws_api_gateway_method_response.sans_api_folders_folderid_delete.status_code}"
		response_templates = { 
			"application/json" = "null"
    }		

    depends_on = ["aws_api_gateway_integration.sans_api_folders_folderid_delete"]
}

resource "aws_api_gateway_integration_response" "sans_api_folders_folderid_images_options" {
    rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
    resource_id   = "${aws_api_gateway_resource.sans_api_folders_folderid_images.id}"
    http_method   = "${aws_api_gateway_method.sans_api_folders_folderid_images_options.http_method}"
    status_code   = "${aws_api_gateway_method_response.sans_api_folders_folderid_images_options.status_code}"
    response_parameters = {
			"method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
			"method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT,DELETE'",
			"method.response.header.Access-Control-Allow-Origin" = "'*'"
    }
    depends_on = ["aws_api_gateway_integration.sans_api_folders_folderid_images_options"]
}

resource "aws_api_gateway_integration_response" "sans_api_folders_folderid_images_get" {
    rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
    resource_id   = "${aws_api_gateway_resource.sans_api_folders_folderid_images.id}"
    http_method   = "${aws_api_gateway_method.sans_api_folders_folderid_images_get.http_method}"
    status_code   = "${aws_api_gateway_method_response.sans_api_folders_folderid_images_get.status_code}"
		response_templates = { 
			"application/json" = "null"
    }		

    depends_on = ["aws_api_gateway_integration.sans_api_folders_folderid_images_get"]
}

resource "aws_api_gateway_integration_response" "sans_api_folders_folderid_images_imageid_options" {
    rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
    resource_id   = "${aws_api_gateway_resource.sans_api_folders_folderid_images_imageid.id}"
    http_method   = "${aws_api_gateway_method.sans_api_folders_folderid_images_imageid_options.http_method}"
    status_code   = "${aws_api_gateway_method_response.sans_api_folders_folderid_images_imageid_options.status_code}"
    response_parameters = {
			"method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
			"method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT,DELETE'",
			"method.response.header.Access-Control-Allow-Origin" = "'*'"
    }
    depends_on = ["aws_api_gateway_integration.sans_api_folders_folderid_images_imageid_options"]
}

resource "aws_api_gateway_integration_response" "sans_api_folders_folderid_images_imageid_delete" {
    rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
    resource_id   = "${aws_api_gateway_resource.sans_api_folders_folderid_images_imageid.id}"
    http_method   = "${aws_api_gateway_method.sans_api_folders_folderid_images_imageid_delete.http_method}"
    status_code   = "${aws_api_gateway_method_response.sans_api_folders_folderid_images_imageid_delete.status_code}"
		response_templates = { 
			"application/json" = "null"
    }		

    depends_on = ["aws_api_gateway_integration.sans_api_folders_folderid_images_imageid_delete"]
}

resource "aws_api_gateway_integration_response" "sans_api_images_options" {
    rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
    resource_id   = "${aws_api_gateway_resource.sans_api_images.id}"
    http_method   = "${aws_api_gateway_method.sans_api_images_options.http_method}"
    status_code   = "${aws_api_gateway_method_response.sans_api_images_options.status_code}"
    response_parameters = {
			"method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
			"method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT,DELETE'",
			"method.response.header.Access-Control-Allow-Origin" = "'*'"
    }
    depends_on = ["aws_api_gateway_integration.sans_api_images_options"]
}

resource "aws_api_gateway_integration_response" "sans_api_images_get" {
    rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
    resource_id   = "${aws_api_gateway_resource.sans_api_images.id}"
    http_method   = "${aws_api_gateway_method.sans_api_images_get.http_method}"
    status_code   = "${aws_api_gateway_method_response.sans_api_images_get.status_code}"
		response_templates = { 
			"application/json" = "null"
    }		

    depends_on = ["aws_api_gateway_integration.sans_api_images_get"]
}

resource "aws_api_gateway_integration_response" "sans_api_images_post" {
    rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
    resource_id   = "${aws_api_gateway_resource.sans_api_images.id}"
    http_method   = "${aws_api_gateway_method.sans_api_images_post.http_method}"
    status_code   = "${aws_api_gateway_method_response.sans_api_images_post.status_code}"
		response_templates = { 
			"application/json" = "null"
    }		

    depends_on = ["aws_api_gateway_integration.sans_api_images_post"]
}

resource "aws_api_gateway_integration_response" "sans_api_images_imageid_options" {
    rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
    resource_id   = "${aws_api_gateway_resource.sans_api_images_imageid.id}"
    http_method   = "${aws_api_gateway_method.sans_api_images_imageid_options.http_method}"
    status_code   = "${aws_api_gateway_method_response.sans_api_images_imageid_options.status_code}"
    response_parameters = {
			"method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
			"method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT,DELETE'",
			"method.response.header.Access-Control-Allow-Origin" = "'*'"
    }
    depends_on = ["aws_api_gateway_integration.sans_api_images_imageid_options"]
}

resource "aws_api_gateway_integration_response" "sans_api_images_imageid_get" {
    rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
    resource_id   = "${aws_api_gateway_resource.sans_api_images_imageid.id}"
    http_method   = "${aws_api_gateway_method.sans_api_images_imageid_get.http_method}"
    status_code   = "${aws_api_gateway_method_response.sans_api_images_imageid_get.status_code}"
		response_templates = { 
			"application/json" = "null"
    }		

    depends_on = ["aws_api_gateway_integration.sans_api_images_imageid_get"]
}

resource "aws_api_gateway_integration_response" "sans_api_images_imageid_put" {
    rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
    resource_id   = "${aws_api_gateway_resource.sans_api_images_imageid.id}"
    http_method   = "${aws_api_gateway_method.sans_api_images_imageid_put.http_method}"
    status_code   = "${aws_api_gateway_method_response.sans_api_images_imageid_put.status_code}"
		response_templates = { 
			"application/json" = "null"
    }		

    depends_on = ["aws_api_gateway_integration.sans_api_images_imageid_put"]
}

resource "aws_api_gateway_integration_response" "sans_api_images_imageid_delete" {
    rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
    resource_id   = "${aws_api_gateway_resource.sans_api_images_imageid.id}"
    http_method   = "${aws_api_gateway_method.sans_api_images_imageid_delete.http_method}"
    status_code   = "${aws_api_gateway_method_response.sans_api_images_imageid_delete.status_code}"
		response_templates = { 
			"application/json" = "null"
    }		

    depends_on = ["aws_api_gateway_integration.sans_api_images_imageid_delete"]
}

resource "aws_api_gateway_integration_response" "sans_api_cookies_options" {
    rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
    resource_id   = "${aws_api_gateway_resource.sans_api_cookies.id}"
    http_method   = "${aws_api_gateway_method.sans_api_cookies_options.http_method}"
    status_code   = "${aws_api_gateway_method_response.sans_api_cookies_options.status_code}"
    response_parameters = {
			"method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
			"method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT,DELETE'",
			"method.response.header.Access-Control-Allow-Origin" = "'*'"
    }
    depends_on = ["aws_api_gateway_integration.sans_api_cookies_options"]
}

resource "aws_api_gateway_integration_response" "sans_api_cookies_get" {
    rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
    resource_id   = "${aws_api_gateway_resource.sans_api_cookies.id}"
    http_method   = "${aws_api_gateway_method.sans_api_cookies_get.http_method}"
    status_code   = "${aws_api_gateway_method_response.sans_api_cookies_get.status_code}"
		response_templates = { 
			"application/json" = "null"
    }		

    depends_on = ["aws_api_gateway_integration.sans_api_cookies_get"]
}

resource "aws_api_gateway_deployment" "sans_api" {
  rest_api_id = "${aws_api_gateway_rest_api.sans_api.id}"
  stage_name  = "live"

	depends_on = [ "aws_api_gateway_integration.sans_api_folders_options"
	             , "aws_api_gateway_integration.sans_api_folders_get"
	             , "aws_api_gateway_integration.sans_api_folders_post"
	             , "aws_api_gateway_integration.sans_api_folders_folderid_options"
	             , "aws_api_gateway_integration.sans_api_folders_folderid_get"
	             , "aws_api_gateway_integration.sans_api_folders_folderid_put"
	             , "aws_api_gateway_integration.sans_api_folders_folderid_delete"
	             , "aws_api_gateway_integration.sans_api_folders_folderid_images_options"
	             , "aws_api_gateway_integration.sans_api_folders_folderid_images_get"
	             , "aws_api_gateway_integration.sans_api_folders_folderid_images_imageid_options"
	             , "aws_api_gateway_integration.sans_api_folders_folderid_images_imageid_delete"
	             , "aws_api_gateway_integration.sans_api_images_options"
	             , "aws_api_gateway_integration.sans_api_images_get"
	             , "aws_api_gateway_integration.sans_api_images_post"
	             , "aws_api_gateway_integration.sans_api_images_imageid_options"
	             , "aws_api_gateway_integration.sans_api_images_imageid_get"
	             , "aws_api_gateway_integration.sans_api_images_imageid_put"
	             , "aws_api_gateway_integration.sans_api_images_imageid_delete"
	             , "aws_api_gateway_integration.sans_api_cookies_options"
	             , "aws_api_gateway_integration.sans_api_cookies_get"
							 ]
}

/*
resource "aws_api_gateway_stage" "sans_api" {
  stage_name    = "live"
  rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
  deployment_id = "${aws_api_gateway_deployment.sans_api.id}"
}
*/

output "sans_api_url" {
  value = "${aws_api_gateway_deployment.sans_api.invoke_url}"
}

resource "aws_lambda_permission" "sans_api_sans_folders_getall" {
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.sans_folders_getall.arn}"
  principal     = "apigateway.amazonaws.com"
  source_arn = "${aws_api_gateway_rest_api.sans_api.execution_arn}/*/GET/folders"
}

resource "aws_lambda_permission" "sans_api_sans_folders_create" {
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.sans_folders_create.arn}"
  principal     = "apigateway.amazonaws.com"
  source_arn = "${aws_api_gateway_rest_api.sans_api.execution_arn}/*/POST/folders"
}

resource "aws_lambda_permission" "sans_api_sans_folders_get" {
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.sans_folders_get.arn}"
  principal     = "apigateway.amazonaws.com"
  source_arn = "${aws_api_gateway_rest_api.sans_api.execution_arn}/*/GET/folders/{folderid}"
}

resource "aws_lambda_permission" "sans_api_sans_folders_rename" {
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.sans_folders_rename.arn}"
  principal     = "apigateway.amazonaws.com"
  source_arn = "${aws_api_gateway_rest_api.sans_api.execution_arn}/*/PUT/folders/{folderid}"
}

resource "aws_lambda_permission" "sans_api_sans_folders_delete" {
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.sans_folders_delete.arn}"
  principal     = "apigateway.amazonaws.com"
  source_arn = "${aws_api_gateway_rest_api.sans_api.execution_arn}/*/DELETE/folders/{folderid}"
}

resource "aws_lambda_permission" "sans_api_sans_images_getall" {
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.sans_images_getall.arn}"
  principal     = "apigateway.amazonaws.com"
  source_arn = "${aws_api_gateway_rest_api.sans_api.execution_arn}/*/GET/folders/{folderid}/images"
}

resource "aws_lambda_permission" "sans_api_sans_images_create" {
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.sans_images_create.arn}"
  principal     = "apigateway.amazonaws.com"
  source_arn = "${aws_api_gateway_rest_api.sans_api.execution_arn}/*/POST/images"
}

resource "aws_lambda_permission" "sans_api_sans_images_get" {
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.sans_images_get.arn}"
  principal     = "apigateway.amazonaws.com"
  source_arn = "${aws_api_gateway_rest_api.sans_api.execution_arn}/*/GET/images/{imageid}"
}

resource "aws_lambda_permission" "sans_api_sans_images_update" {
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.sans_images_update.arn}"
  principal     = "apigateway.amazonaws.com"
  source_arn = "${aws_api_gateway_rest_api.sans_api.execution_arn}/*/PUT/images/{imageid}"
}

//Need to move this to image but first need to handle folder differently.
resource "aws_lambda_permission" "sans_api_sans_images_delete" {
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.sans_images_delete.arn}"
  principal     = "apigateway.amazonaws.com"
  source_arn = "${aws_api_gateway_rest_api.sans_api.execution_arn}/*/DELETE/folders/{folderid}/images/{imageid}"
}

resource "aws_lambda_permission" "sans_api_sans_cookies_get" {
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.sans_cookies_get.arn}"
  principal     = "apigateway.amazonaws.com"
  source_arn = "${aws_api_gateway_rest_api.sans_api.execution_arn}/*/GET/cookies"
}

