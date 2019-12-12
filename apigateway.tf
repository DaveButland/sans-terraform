
//API GATEWAY
resource "aws_api_gateway_rest_api" "sans_api" {
  name        = "sans_api"
  description = "api.quyen-le-model.com"
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

//Need to make the certificate terraformed - how does that work?
resource "aws_api_gateway_domain_name" "sans_api" {
	certificate_arn = "arn:aws:acm:us-east-1:739465383014:certificate/cebad9e0-76d9-4610-b7f3-b8d77bcd945d"
//	certificate_arn = "${aws_acm_certificate_validation.example.certificate_arn}"
  domain_name     = "api.quyen-le-model.com"
}

//Manually configured for now - need to get route53 zone terraformed
/*
resource "aws_route53_record" "sans-api" {
  name    = "${aws_api_gateway_domain_name.example.domain_name}"
  type    = "A"
  zone_id = "${aws_route53_zone.example.id}"

  alias {
    evaluate_target_health = true
    name                   = "${aws_api_gateway_domain_name.example.cloudfront_domain_name}"
    zone_id                = "${aws_api_gateway_domain_name.example.cloudfront_zone_id}"
  }
}
*/

//API RESOURCES
//folders
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

resource "aws_api_gateway_resource" "sans_api_folders_folderid_resize" {
  rest_api_id = "${aws_api_gateway_rest_api.sans_api.id}"
  parent_id   = "${aws_api_gateway_resource.sans_api_folders_folderid.id}"
  path_part   = "resize"

  depends_on = ["aws_api_gateway_resource.sans_api_folders_folderid"]
}

resource "aws_api_gateway_resource" "sans_api_folders_folderid_images_imageid" {
  rest_api_id = "${aws_api_gateway_rest_api.sans_api.id}"
  parent_id   = "${aws_api_gateway_resource.sans_api_folders_folderid_images.id}"
  path_part   = "{imagesid}"

  depends_on = ["aws_api_gateway_resource.sans_api_folders_folderid_images"]
}

//albums
resource "aws_api_gateway_resource" "sans_api_albums" {
  rest_api_id = "${aws_api_gateway_rest_api.sans_api.id}"
  parent_id   = "${aws_api_gateway_rest_api.sans_api.root_resource_id}"
  path_part   = "albums"

  depends_on = ["aws_api_gateway_rest_api.sans_api"]
}

resource "aws_api_gateway_resource" "sans_api_albums_albumid" {
  rest_api_id = "${aws_api_gateway_rest_api.sans_api.id}"
  parent_id   = "${aws_api_gateway_resource.sans_api_albums.id}"
  path_part   = "{albumid}"

  depends_on = ["aws_api_gateway_resource.sans_api_albums"]
}

resource "aws_api_gateway_resource" "sans_api_albums_albumid_images" {
  rest_api_id = "${aws_api_gateway_rest_api.sans_api.id}"
  parent_id   = "${aws_api_gateway_resource.sans_api_albums_albumid.id}"
  path_part   = "images"

  depends_on = ["aws_api_gateway_resource.sans_api_albums_albumid"]
}

resource "aws_api_gateway_resource" "sans_api_messages" {
  rest_api_id = "${aws_api_gateway_rest_api.sans_api.id}"
  parent_id   = "${aws_api_gateway_rest_api.sans_api.root_resource_id}"
  path_part   = "messages"

  depends_on = ["aws_api_gateway_rest_api.sans_api"]
}

resource "aws_api_gateway_resource" "sans_api_messages_messageid" {
  rest_api_id = "${aws_api_gateway_rest_api.sans_api.id}"
  parent_id   = "${aws_api_gateway_resource.sans_api_messages.id}"
  path_part   = "{messageid}"

  depends_on = ["aws_api_gateway_resource.sans_api_messages"]
}

resource "aws_api_gateway_resource" "sans_api_events" {
  rest_api_id = "${aws_api_gateway_rest_api.sans_api.id}"
  parent_id   = "${aws_api_gateway_rest_api.sans_api.root_resource_id}"
  path_part   = "events"

  depends_on = ["aws_api_gateway_rest_api.sans_api"]
}

resource "aws_api_gateway_resource" "sans_api_events_eventid" {
  rest_api_id = "${aws_api_gateway_rest_api.sans_api.id}"
  parent_id   = "${aws_api_gateway_resource.sans_api_events.id}"
  path_part   = "{eventid}"

  depends_on = ["aws_api_gateway_resource.sans_api_events"]
}

//images
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

resource "aws_api_gateway_resource" "sans_api_images_public" {
  rest_api_id = "${aws_api_gateway_rest_api.sans_api.id}"
  parent_id   = "${aws_api_gateway_resource.sans_api_images.id}"
  path_part   = "public"

  depends_on = ["aws_api_gateway_resource.sans_api_images"]
}

resource "aws_api_gateway_resource" "sans_api_cookies" {
  rest_api_id = "${aws_api_gateway_rest_api.sans_api.id}"
  parent_id   = "${aws_api_gateway_rest_api.sans_api.root_resource_id}"
  path_part   = "cookies"

  depends_on = ["aws_api_gateway_rest_api.sans_api"]
}

//pages
resource "aws_api_gateway_resource" "sans_api_pages" {
  rest_api_id = "${aws_api_gateway_rest_api.sans_api.id}"
  parent_id   = "${aws_api_gateway_rest_api.sans_api.root_resource_id}"
  path_part   = "pages"

  depends_on = ["aws_api_gateway_rest_api.sans_api"]
}

resource "aws_api_gateway_resource" "sans_api_pages_pageid" {
  rest_api_id = "${aws_api_gateway_rest_api.sans_api.id}"
  parent_id   = "${aws_api_gateway_resource.sans_api_pages.id}"
  path_part   = "{pageid}"

  depends_on = ["aws_api_gateway_resource.sans_api_pages"]
}

//API METHODS
//folders
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

resource "aws_api_gateway_method" "sans_api_folders_folderid_resize_options" {
  rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
  resource_id   = "${aws_api_gateway_resource.sans_api_folders_folderid_resize.id}"
  http_method   = "OPTIONS"
  authorization = "NONE"

  depends_on = ["aws_api_gateway_resource.sans_api_folders_folderid_resize"]
}

resource "aws_api_gateway_method" "sans_api_folders_folderid_resize_post" {
  rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
  resource_id   = "${aws_api_gateway_resource.sans_api_folders_folderid_resize.id}"
  http_method   = "POST"

  authorization = "COGNITO_USER_POOLS"
  authorizer_id = "${aws_api_gateway_authorizer.sans_api.id}"
	authorization_scopes = ["aws.cognito.signin.user.admin"]

  depends_on = ["aws_api_gateway_resource.sans_api_folders_folderid_resize"]
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

//albums
resource "aws_api_gateway_method" "sans_api_albums_options" {
  rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
  resource_id   = "${aws_api_gateway_resource.sans_api_albums.id}"
  http_method   = "OPTIONS"
  authorization = "NONE"

  depends_on = ["aws_api_gateway_resource.sans_api_albums"]
}

resource "aws_api_gateway_method" "sans_api_albums_get" {
  rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
  resource_id   = "${aws_api_gateway_resource.sans_api_albums.id}"
  http_method   = "GET"
  authorization = "NONE"

  depends_on = ["aws_api_gateway_resource.sans_api_albums"]
}

resource "aws_api_gateway_method" "sans_api_albums_post" {
  rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
  resource_id   = "${aws_api_gateway_resource.sans_api_albums.id}"
  http_method   = "POST"

  authorization = "COGNITO_USER_POOLS"
  authorizer_id = "${aws_api_gateway_authorizer.sans_api.id}"
	authorization_scopes = ["aws.cognito.signin.user.admin"]

  depends_on = ["aws_api_gateway_resource.sans_api_albums"]
}

resource "aws_api_gateway_method" "sans_api_albums_albumid_options" {
  rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
  resource_id   = "${aws_api_gateway_resource.sans_api_albums_albumid.id}"
  http_method   = "OPTIONS"

  authorization = "NONE"

  depends_on = ["aws_api_gateway_resource.sans_api_albums_albumid"]
}

resource "aws_api_gateway_method" "sans_api_albums_albumid_get" {
  rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
  resource_id   = "${aws_api_gateway_resource.sans_api_albums_albumid.id}"
  http_method   = "GET"

  authorization = "COGNITO_USER_POOLS"
  authorizer_id = "${aws_api_gateway_authorizer.sans_api.id}"
	authorization_scopes = ["aws.cognito.signin.user.admin"]

  depends_on = ["aws_api_gateway_resource.sans_api_albums_albumid"]
}

resource "aws_api_gateway_method" "sans_api_albums_albumid_put" {
  rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
  resource_id   = "${aws_api_gateway_resource.sans_api_albums_albumid.id}"
  http_method   = "PUT"

  authorization = "COGNITO_USER_POOLS"
  authorizer_id = "${aws_api_gateway_authorizer.sans_api.id}"
	authorization_scopes = ["aws.cognito.signin.user.admin"]

  depends_on = ["aws_api_gateway_resource.sans_api_albums_albumid"]
}

resource "aws_api_gateway_method" "sans_api_albums_albumid_delete" {
  rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
  resource_id   = "${aws_api_gateway_resource.sans_api_albums_albumid.id}"
  http_method   = "DELETE"

  authorization = "COGNITO_USER_POOLS"
  authorizer_id = "${aws_api_gateway_authorizer.sans_api.id}"
	authorization_scopes = ["aws.cognito.signin.user.admin"]

  depends_on = ["aws_api_gateway_resource.sans_api_albums_albumid"]
}

resource "aws_api_gateway_method" "sans_api_albums_albumid_images_options" {
  rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
  resource_id   = "${aws_api_gateway_resource.sans_api_albums_albumid_images.id}"
  http_method   = "OPTIONS"
  authorization = "NONE"

  depends_on = ["aws_api_gateway_resource.sans_api_albums_albumid_images"]
}

resource "aws_api_gateway_method" "sans_api_albums_albumid_images_get" {
  rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
  resource_id   = "${aws_api_gateway_resource.sans_api_albums_albumid_images.id}"
  http_method   = "GET"
	authorization = "NONE"

// public for now
//  authorization = "COGNITO_USER_POOLS"
//  authorizer_id = "${aws_api_gateway_authorizer.sans_api.id}"
//	authorization_scopes = ["aws.cognito.signin.user.admin"]

  depends_on = ["aws_api_gateway_resource.sans_api_albums_albumid_images"]
}

//events
resource "aws_api_gateway_method" "sans_api_events_options" {
  rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
  resource_id   = "${aws_api_gateway_resource.sans_api_events.id}"
  http_method   = "OPTIONS"
  authorization = "NONE"

  depends_on = ["aws_api_gateway_resource.sans_api_events"]
}

resource "aws_api_gateway_method" "sans_api_events_get" {
  rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
  resource_id   = "${aws_api_gateway_resource.sans_api_events.id}"
  http_method   = "GET"
 	authorization = "NONE"	
//  authorization = "COGNITO_USER_POOLS"
//  authorizer_id = "${aws_api_gateway_authorizer.sans_api.id}"
//	authorization_scopes = ["aws.cognito.signin.user.admin"]

  depends_on = ["aws_api_gateway_resource.sans_api_events"]
}

resource "aws_api_gateway_method" "sans_api_events_post" {
  rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
  resource_id   = "${aws_api_gateway_resource.sans_api_events.id}"
  http_method   = "POST"

  authorization = "COGNITO_USER_POOLS"
  authorizer_id = "${aws_api_gateway_authorizer.sans_api.id}"
	authorization_scopes = ["aws.cognito.signin.user.admin"]

  depends_on = ["aws_api_gateway_resource.sans_api_events"]
}

resource "aws_api_gateway_method" "sans_api_events_eventid_options" {
  rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
  resource_id   = "${aws_api_gateway_resource.sans_api_events_eventid.id}"
  http_method   = "OPTIONS"

  authorization = "NONE"

  depends_on = ["aws_api_gateway_resource.sans_api_events_eventid"]
}

resource "aws_api_gateway_method" "sans_api_events_eventid_get" {
  rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
  resource_id   = "${aws_api_gateway_resource.sans_api_events_eventid.id}"
  http_method   = "GET"

  authorization = "COGNITO_USER_POOLS"
  authorizer_id = "${aws_api_gateway_authorizer.sans_api.id}"
	authorization_scopes = ["aws.cognito.signin.user.admin"]

  depends_on = ["aws_api_gateway_resource.sans_api_events_eventid"]
}

resource "aws_api_gateway_method" "sans_api_events_eventid_put" {
  rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
  resource_id   = "${aws_api_gateway_resource.sans_api_events_eventid.id}"
  http_method   = "PUT"

  authorization = "COGNITO_USER_POOLS"
  authorizer_id = "${aws_api_gateway_authorizer.sans_api.id}"
	authorization_scopes = ["aws.cognito.signin.user.admin"]

  depends_on = ["aws_api_gateway_resource.sans_api_events_eventid"]
}

resource "aws_api_gateway_method" "sans_api_events_eventid_delete" {
  rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
  resource_id   = "${aws_api_gateway_resource.sans_api_events_eventid.id}"
  http_method   = "DELETE"

  authorization = "COGNITO_USER_POOLS"
  authorizer_id = "${aws_api_gateway_authorizer.sans_api.id}"
	authorization_scopes = ["aws.cognito.signin.user.admin"]

  depends_on = ["aws_api_gateway_resource.sans_api_events_eventid"]
}

//messages
resource "aws_api_gateway_method" "sans_api_messages_options" {
  rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
  resource_id   = "${aws_api_gateway_resource.sans_api_messages.id}"
  http_method   = "OPTIONS"
  authorization = "NONE"

  depends_on = ["aws_api_gateway_resource.sans_api_messages"]
}

resource "aws_api_gateway_method" "sans_api_messages_get" {
  rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
  resource_id   = "${aws_api_gateway_resource.sans_api_messages.id}"
  http_method   = "GET"
	
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = "${aws_api_gateway_authorizer.sans_api.id}"
	authorization_scopes = ["aws.cognito.signin.user.admin"]

  depends_on = ["aws_api_gateway_resource.sans_api_messages"]
}

resource "aws_api_gateway_method" "sans_api_messages_post" {
  rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
  resource_id   = "${aws_api_gateway_resource.sans_api_messages.id}"
  http_method   = "POST"
 	authorization = "NONE"
//  authorization = "COGNITO_USER_POOLS"
//  authorizer_id = "${aws_api_gateway_authorizer.sans_api.id}"
//	authorization_scopes = ["aws.cognito.signin.user.admin"]

  depends_on = ["aws_api_gateway_resource.sans_api_messages"]
}

resource "aws_api_gateway_method" "sans_api_messages_messageid_options" {
  rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
  resource_id   = "${aws_api_gateway_resource.sans_api_messages_messageid.id}"
  http_method   = "OPTIONS"

  authorization = "NONE"

  depends_on = ["aws_api_gateway_resource.sans_api_messages_messageid"]
}

resource "aws_api_gateway_method" "sans_api_messages_messageid_get" {
  rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
  resource_id   = "${aws_api_gateway_resource.sans_api_messages_messageid.id}"
  http_method   = "GET"

  authorization = "COGNITO_USER_POOLS"
  authorizer_id = "${aws_api_gateway_authorizer.sans_api.id}"
	authorization_scopes = ["aws.cognito.signin.user.admin"]

  depends_on = ["aws_api_gateway_resource.sans_api_messages_messageid"]
}

resource "aws_api_gateway_method" "sans_api_messages_messageid_put" {
  rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
  resource_id   = "${aws_api_gateway_resource.sans_api_messages_messageid.id}"
  http_method   = "PUT"

  authorization = "COGNITO_USER_POOLS"
  authorizer_id = "${aws_api_gateway_authorizer.sans_api.id}"
	authorization_scopes = ["aws.cognito.signin.user.admin"]

  depends_on = ["aws_api_gateway_resource.sans_api_messages_messageid"]
}

resource "aws_api_gateway_method" "sans_api_messages_messageid_delete" {
  rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
  resource_id   = "${aws_api_gateway_resource.sans_api_messages_messageid.id}"
  http_method   = "DELETE"

  authorization = "COGNITO_USER_POOLS"
  authorizer_id = "${aws_api_gateway_authorizer.sans_api.id}"
	authorization_scopes = ["aws.cognito.signin.user.admin"]

  depends_on = ["aws_api_gateway_resource.sans_api_messages_messageid"]
}

//images
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
  authorization = "NONE"

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

resource "aws_api_gateway_method" "sans_api_images_public_options" {
  rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
  resource_id   = "${aws_api_gateway_resource.sans_api_images_public.id}"
  http_method   = "OPTIONS"

  authorization = "NONE"

  depends_on = ["aws_api_gateway_resource.sans_api_images_public"]
}

resource "aws_api_gateway_method" "sans_api_images_public_get" {
  rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
  resource_id   = "${aws_api_gateway_resource.sans_api_images_public.id}"
  http_method   = "GET"

	authorization = "NONE"

  depends_on = ["aws_api_gateway_resource.sans_api_images_public"]
}

//pages
resource "aws_api_gateway_method" "sans_api_pages_options" {
  rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
  resource_id   = "${aws_api_gateway_resource.sans_api_pages.id}"
  http_method   = "OPTIONS"
  authorization = "NONE"

  depends_on = ["aws_api_gateway_resource.sans_api_pages"]
}

resource "aws_api_gateway_method" "sans_api_pages_get" {
  rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
  resource_id   = "${aws_api_gateway_resource.sans_api_pages.id}"
  http_method   = "GET"
	
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = "${aws_api_gateway_authorizer.sans_api.id}"
	authorization_scopes = ["aws.cognito.signin.user.admin"]

  depends_on = ["aws_api_gateway_resource.sans_api_pages"]
}

resource "aws_api_gateway_method" "sans_api_pages_post" {
  rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
  resource_id   = "${aws_api_gateway_resource.sans_api_pages.id}"
  http_method   = "POST"

  authorization = "COGNITO_USER_POOLS"
  authorizer_id = "${aws_api_gateway_authorizer.sans_api.id}"
	authorization_scopes = ["aws.cognito.signin.user.admin"]

  depends_on = ["aws_api_gateway_resource.sans_api_pages"]
}

resource "aws_api_gateway_method" "sans_api_pages_pageid_options" {
  rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
  resource_id   = "${aws_api_gateway_resource.sans_api_pages_pageid.id}"
  http_method   = "OPTIONS"

  authorization = "NONE"

  depends_on = ["aws_api_gateway_resource.sans_api_pages_pageid"]
}

resource "aws_api_gateway_method" "sans_api_pages_pageid_get" {
  rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
  resource_id   = "${aws_api_gateway_resource.sans_api_pages_pageid.id}"
  http_method   = "GET"

  authorization = "COGNITO_USER_POOLS"
  authorizer_id = "${aws_api_gateway_authorizer.sans_api.id}"
	authorization_scopes = ["aws.cognito.signin.user.admin"]

  depends_on = ["aws_api_gateway_resource.sans_api_pages_pageid"]
}

resource "aws_api_gateway_method" "sans_api_pages_pageid_put" {
  rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
  resource_id   = "${aws_api_gateway_resource.sans_api_pages_pageid.id}"
  http_method   = "PUT"

  authorization = "COGNITO_USER_POOLS"
  authorizer_id = "${aws_api_gateway_authorizer.sans_api.id}"
	authorization_scopes = ["aws.cognito.signin.user.admin"]

  depends_on = ["aws_api_gateway_resource.sans_api_pages_pageid"]
}

resource "aws_api_gateway_method" "sans_api_pages_pageid_delete" {
  rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
  resource_id   = "${aws_api_gateway_resource.sans_api_pages_pageid.id}"
  http_method   = "DELETE"

  authorization = "COGNITO_USER_POOLS"
  authorizer_id = "${aws_api_gateway_authorizer.sans_api.id}"
	authorization_scopes = ["aws.cognito.signin.user.admin"]

  depends_on = ["aws_api_gateway_resource.sans_api_pages_pageid"]
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
//folders
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

resource "aws_api_gateway_method_response" "sans_api_folders_folderid_resize_options" {
    rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
    resource_id   = "${aws_api_gateway_resource.sans_api_folders_folderid_resize.id}"
    http_method   = "${aws_api_gateway_method.sans_api_folders_folderid_resize_options.http_method}"
    status_code   = 200
		response_models = {
			"application/json" = "Empty"
    }		
		response_parameters = { 
			"method.response.header.Access-Control-Allow-Headers" = true 
			"method.response.header.Access-Control-Allow-Methods" = true 
			"method.response.header.Access-Control-Allow-Origin" = true 
		}

    depends_on = ["aws_api_gateway_method.sans_api_folders_folderid_resize_options"]
}
resource "aws_api_gateway_method_response" "sans_api_folders_folderid_resize_post" {
    rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
    resource_id   = "${aws_api_gateway_resource.sans_api_folders_folderid_resize.id}"
    http_method   = "${aws_api_gateway_method.sans_api_folders_folderid_resize_post.http_method}"
    status_code   = 200
		response_models = {
			"application/json" = "Empty"
    }

    depends_on = ["aws_api_gateway_method.sans_api_folders_folderid_resize_post"]
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

//albums
resource "aws_api_gateway_method_response" "sans_api_albums_options" {
    rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
    resource_id   = "${aws_api_gateway_resource.sans_api_albums.id}"
    http_method   = "${aws_api_gateway_method.sans_api_albums_options.http_method}"
    status_code   = 200
		response_models = {
			"application/json" = "Empty"
    }		
		response_parameters = { 
			"method.response.header.Access-Control-Allow-Headers" = true 
			"method.response.header.Access-Control-Allow-Methods" = true 
			"method.response.header.Access-Control-Allow-Origin" = true 
		}

    depends_on = ["aws_api_gateway_method.sans_api_albums_options"]
}

resource "aws_api_gateway_method_response" "sans_api_albums_get" {
    rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
    resource_id   = "${aws_api_gateway_resource.sans_api_albums.id}"
    http_method   = "${aws_api_gateway_method.sans_api_albums_get.http_method}"
    status_code   = 200
		response_models = {
			"application/json" = "Empty"
    }

    depends_on = ["aws_api_gateway_method.sans_api_albums_get"]
}

resource "aws_api_gateway_method_response" "sans_api_albums_post" {
    rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
    resource_id   = "${aws_api_gateway_resource.sans_api_albums.id}"
    http_method   = "${aws_api_gateway_method.sans_api_albums_post.http_method}"
    status_code   = 200
		response_models = {
			"application/json" = "Empty"
    }

    depends_on = ["aws_api_gateway_method.sans_api_albums_post"]
}

resource "aws_api_gateway_method_response" "sans_api_albums_albumid_options" {
    rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
    resource_id   = "${aws_api_gateway_resource.sans_api_albums_albumid.id}"
    http_method   = "${aws_api_gateway_method.sans_api_albums_albumid_options.http_method}"
    status_code   = 200
		response_models = {
			"application/json" = "Empty"
    }		
		response_parameters = { 
			"method.response.header.Access-Control-Allow-Headers" = true 
			"method.response.header.Access-Control-Allow-Methods" = true 
			"method.response.header.Access-Control-Allow-Origin" = true 
		}

    depends_on = ["aws_api_gateway_method.sans_api_albums_albumid_options"]
}

resource "aws_api_gateway_method_response" "sans_api_albums_albumid_get" {
    rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
    resource_id   = "${aws_api_gateway_resource.sans_api_albums_albumid.id}"
    http_method   = "${aws_api_gateway_method.sans_api_albums_albumid_get.http_method}"
    status_code   = 200
		response_models = {
			"application/json" = "Empty"
    }

    depends_on = ["aws_api_gateway_method.sans_api_albums_albumid_get"]
}

resource "aws_api_gateway_method_response" "sans_api_albums_albumid_put" {
    rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
    resource_id   = "${aws_api_gateway_resource.sans_api_albums_albumid.id}"
    http_method   = "${aws_api_gateway_method.sans_api_albums_albumid_put.http_method}"
    status_code   = 200
		response_models = {
			"application/json" = "Empty"
    }

    depends_on = ["aws_api_gateway_method.sans_api_albums_albumid_put"]
}

resource "aws_api_gateway_method_response" "sans_api_albums_albumid_delete" {
    rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
    resource_id   = "${aws_api_gateway_resource.sans_api_albums_albumid.id}"
    http_method   = "${aws_api_gateway_method.sans_api_albums_albumid_delete.http_method}"
    status_code   = 200
		response_models = {
			"application/json" = "Empty"
    }

    depends_on = ["aws_api_gateway_method.sans_api_albums_albumid_delete"]
}

resource "aws_api_gateway_method_response" "sans_api_albums_albumid_images_options" {
    rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
    resource_id   = "${aws_api_gateway_resource.sans_api_albums_albumid_images.id}"
    http_method   = "${aws_api_gateway_method.sans_api_albums_albumid_images_options.http_method}"
    status_code   = 200
		response_models = {
			"application/json" = "Empty"
    }		
		response_parameters = { 
			"method.response.header.Access-Control-Allow-Headers" = true 
			"method.response.header.Access-Control-Allow-Methods" = true 
			"method.response.header.Access-Control-Allow-Origin" = true 
		}

    depends_on = ["aws_api_gateway_method.sans_api_albums_albumid_images_options"]
}


resource "aws_api_gateway_method_response" "sans_api_albums_albumid_images_get" {
    rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
    resource_id   = "${aws_api_gateway_resource.sans_api_albums_albumid_images.id}"
    http_method   = "${aws_api_gateway_method.sans_api_albums_albumid_images_get.http_method}"
    status_code   = 200
		response_models = {
			"application/json" = "Empty"
    }

    depends_on = ["aws_api_gateway_method.sans_api_albums_albumid_images_get"]
}

//events
resource "aws_api_gateway_method_response" "sans_api_events_options" {
    rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
    resource_id   = "${aws_api_gateway_resource.sans_api_events.id}"
    http_method   = "${aws_api_gateway_method.sans_api_events_options.http_method}"
    status_code   = 200
		response_models = {
			"application/json" = "Empty"
    }		
		response_parameters = { 
			"method.response.header.Access-Control-Allow-Headers" = true 
			"method.response.header.Access-Control-Allow-Methods" = true 
			"method.response.header.Access-Control-Allow-Origin" = true 
		}

    depends_on = ["aws_api_gateway_method.sans_api_events_options"]
}

resource "aws_api_gateway_method_response" "sans_api_events_get" {
    rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
    resource_id   = "${aws_api_gateway_resource.sans_api_events.id}"
    http_method   = "${aws_api_gateway_method.sans_api_events_get.http_method}"
    status_code   = 200
		response_models = {
			"application/json" = "Empty"
    }

    depends_on = ["aws_api_gateway_method.sans_api_events_get"]
}

resource "aws_api_gateway_method_response" "sans_api_events_post" {
    rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
    resource_id   = "${aws_api_gateway_resource.sans_api_events.id}"
    http_method   = "${aws_api_gateway_method.sans_api_events_post.http_method}"
    status_code   = 200
		response_models = {
			"application/json" = "Empty"
    }

    depends_on = ["aws_api_gateway_method.sans_api_events_post"]
}

resource "aws_api_gateway_method_response" "sans_api_events_eventid_options" {
    rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
    resource_id   = "${aws_api_gateway_resource.sans_api_events_eventid.id}"
    http_method   = "${aws_api_gateway_method.sans_api_events_eventid_options.http_method}"
    status_code   = 200
		response_models = {
			"application/json" = "Empty"
    }		
		response_parameters = { 
			"method.response.header.Access-Control-Allow-Headers" = true 
			"method.response.header.Access-Control-Allow-Methods" = true 
			"method.response.header.Access-Control-Allow-Origin" = true 
		}

    depends_on = ["aws_api_gateway_method.sans_api_events_eventid_options"]
}

resource "aws_api_gateway_method_response" "sans_api_events_eventid_get" {
    rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
    resource_id   = "${aws_api_gateway_resource.sans_api_events_eventid.id}"
    http_method   = "${aws_api_gateway_method.sans_api_events_eventid_get.http_method}"
    status_code   = 200
		response_models = {
			"application/json" = "Empty"
    }

    depends_on = ["aws_api_gateway_method.sans_api_events_eventid_get"]
}

resource "aws_api_gateway_method_response" "sans_api_events_eventid_put" {
    rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
    resource_id   = "${aws_api_gateway_resource.sans_api_events_eventid.id}"
    http_method   = "${aws_api_gateway_method.sans_api_events_eventid_put.http_method}"
    status_code   = 200
		response_models = {
			"application/json" = "Empty"
    }

    depends_on = ["aws_api_gateway_method.sans_api_events_eventid_put"]
}

resource "aws_api_gateway_method_response" "sans_api_events_eventid_delete" {
    rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
    resource_id   = "${aws_api_gateway_resource.sans_api_events_eventid.id}"
    http_method   = "${aws_api_gateway_method.sans_api_events_eventid_delete.http_method}"
    status_code   = 200
		response_models = {
			"application/json" = "Empty"
    }

    depends_on = ["aws_api_gateway_method.sans_api_events_eventid_delete"]
}

//messages
resource "aws_api_gateway_method_response" "sans_api_messages_options" {
    rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
    resource_id   = "${aws_api_gateway_resource.sans_api_messages.id}"
    http_method   = "${aws_api_gateway_method.sans_api_messages_options.http_method}"
    status_code   = 200
		response_models = {
			"application/json" = "Empty"
    }		
		response_parameters = { 
			"method.response.header.Access-Control-Allow-Headers" = true 
			"method.response.header.Access-Control-Allow-Methods" = true 
			"method.response.header.Access-Control-Allow-Origin" = true 
		}

    depends_on = ["aws_api_gateway_method.sans_api_messages_options"]
}

resource "aws_api_gateway_method_response" "sans_api_messages_get" {
    rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
    resource_id   = "${aws_api_gateway_resource.sans_api_messages.id}"
    http_method   = "${aws_api_gateway_method.sans_api_messages_get.http_method}"
    status_code   = 200
		response_models = {
			"application/json" = "Empty"
    }

    depends_on = ["aws_api_gateway_method.sans_api_messages_get"]
}

resource "aws_api_gateway_method_response" "sans_api_messages_post" {
    rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
    resource_id   = "${aws_api_gateway_resource.sans_api_messages.id}"
    http_method   = "${aws_api_gateway_method.sans_api_messages_post.http_method}"
    status_code   = 200
		response_models = {
			"application/json" = "Empty"
    }

    depends_on = ["aws_api_gateway_method.sans_api_messages_post"]
}

resource "aws_api_gateway_method_response" "sans_api_messages_messageid_options" {
    rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
    resource_id   = "${aws_api_gateway_resource.sans_api_messages_messageid.id}"
    http_method   = "${aws_api_gateway_method.sans_api_messages_messageid_options.http_method}"
    status_code   = 200
		response_models = {
			"application/json" = "Empty"
    }		
		response_parameters = { 
			"method.response.header.Access-Control-Allow-Headers" = true 
			"method.response.header.Access-Control-Allow-Methods" = true 
			"method.response.header.Access-Control-Allow-Origin" = true 
		}

    depends_on = ["aws_api_gateway_method.sans_api_messages_messageid_options"]
}

resource "aws_api_gateway_method_response" "sans_api_messages_messageid_get" {
    rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
    resource_id   = "${aws_api_gateway_resource.sans_api_messages_messageid.id}"
    http_method   = "${aws_api_gateway_method.sans_api_messages_messageid_get.http_method}"
    status_code   = 200
		response_models = {
			"application/json" = "Empty"
    }

    depends_on = ["aws_api_gateway_method.sans_api_messages_messageid_get"]
}

resource "aws_api_gateway_method_response" "sans_api_messages_messageid_put" {
    rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
    resource_id   = "${aws_api_gateway_resource.sans_api_messages_messageid.id}"
    http_method   = "${aws_api_gateway_method.sans_api_messages_messageid_put.http_method}"
    status_code   = 200
		response_models = {
			"application/json" = "Empty"
    }

    depends_on = ["aws_api_gateway_method.sans_api_messages_messageid_put"]
}

resource "aws_api_gateway_method_response" "sans_api_messages_messageid_delete" {
    rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
    resource_id   = "${aws_api_gateway_resource.sans_api_messages_messageid.id}"
    http_method   = "${aws_api_gateway_method.sans_api_messages_messageid_delete.http_method}"
    status_code   = 200
		response_models = {
			"application/json" = "Empty"
    }

    depends_on = ["aws_api_gateway_method.sans_api_messages_messageid_delete"]
}

//images
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

resource "aws_api_gateway_method_response" "sans_api_images_public_options" {
    rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
    resource_id   = "${aws_api_gateway_resource.sans_api_images_public.id}"
    http_method   = "${aws_api_gateway_method.sans_api_images_public_options.http_method}"
    status_code   = 200
		response_models = {
			"application/json" = "Empty"
    }		
		response_parameters = { 
			"method.response.header.Access-Control-Allow-Headers" = true 
			"method.response.header.Access-Control-Allow-Methods" = true 
			"method.response.header.Access-Control-Allow-Origin" = true 
		}

    depends_on = ["aws_api_gateway_method.sans_api_images_public_options"]
}

resource "aws_api_gateway_method_response" "sans_api_images_public_get" {
    rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
    resource_id   = "${aws_api_gateway_resource.sans_api_images_public.id}"
    http_method   = "${aws_api_gateway_method.sans_api_images_public_get.http_method}"
    status_code   = 200
		response_models = {
			"application/json" = "Empty"
    }

    depends_on = ["aws_api_gateway_method.sans_api_images_public_get"]
}

//pages
resource "aws_api_gateway_method_response" "sans_api_pages_options" {
    rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
    resource_id   = "${aws_api_gateway_resource.sans_api_pages.id}"
    http_method   = "${aws_api_gateway_method.sans_api_pages_options.http_method}"
    status_code   = 200
		response_models = {
			"application/json" = "Empty"
    }		
		response_parameters = { 
			"method.response.header.Access-Control-Allow-Headers" = true 
			"method.response.header.Access-Control-Allow-Methods" = true 
			"method.response.header.Access-Control-Allow-Origin" = true 
		}

    depends_on = ["aws_api_gateway_method.sans_api_pages_options"]
}

resource "aws_api_gateway_method_response" "sans_api_pages_get" {
    rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
    resource_id   = "${aws_api_gateway_resource.sans_api_pages.id}"
    http_method   = "${aws_api_gateway_method.sans_api_pages_get.http_method}"
    status_code   = 200
		response_models = {
			"application/json" = "Empty"
    }

    depends_on = ["aws_api_gateway_method.sans_api_pages_get"]
}

resource "aws_api_gateway_method_response" "sans_api_pages_post" {
    rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
    resource_id   = "${aws_api_gateway_resource.sans_api_pages.id}"
    http_method   = "${aws_api_gateway_method.sans_api_pages_post.http_method}"
    status_code   = 200
		response_models = {
			"application/json" = "Empty"
    }

    depends_on = ["aws_api_gateway_method.sans_api_pages_post"]
}

resource "aws_api_gateway_method_response" "sans_api_pages_pageid_options" {
    rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
    resource_id   = "${aws_api_gateway_resource.sans_api_pages_pageid.id}"
    http_method   = "${aws_api_gateway_method.sans_api_pages_pageid_options.http_method}"
    status_code   = 200
		response_models = {
			"application/json" = "Empty"
    }		
		response_parameters = { 
			"method.response.header.Access-Control-Allow-Headers" = true 
			"method.response.header.Access-Control-Allow-Methods" = true 
			"method.response.header.Access-Control-Allow-Origin" = true 
		}

    depends_on = ["aws_api_gateway_method.sans_api_pages_pageid_options"]
}

resource "aws_api_gateway_method_response" "sans_api_pages_pageid_get" {
    rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
    resource_id   = "${aws_api_gateway_resource.sans_api_pages_pageid.id}"
    http_method   = "${aws_api_gateway_method.sans_api_pages_pageid_get.http_method}"
    status_code   = 200
		response_models = {
			"application/json" = "Empty"
    }

    depends_on = ["aws_api_gateway_method.sans_api_pages_pageid_get"]
}

resource "aws_api_gateway_method_response" "sans_api_pages_pageid_put" {
    rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
    resource_id   = "${aws_api_gateway_resource.sans_api_pages_pageid.id}"
    http_method   = "${aws_api_gateway_method.sans_api_pages_pageid_put.http_method}"
    status_code   = 200
		response_models = {
			"application/json" = "Empty"
    }

    depends_on = ["aws_api_gateway_method.sans_api_pages_pageid_put"]
}

resource "aws_api_gateway_method_response" "sans_api_pages_pageid_delete" {
    rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
    resource_id   = "${aws_api_gateway_resource.sans_api_pages_pageid.id}"
    http_method   = "${aws_api_gateway_method.sans_api_pages_pageid_delete.http_method}"
    status_code   = 200
		response_models = {
			"application/json" = "Empty"
    }

    depends_on = ["aws_api_gateway_method.sans_api_pages_pageid_delete"]
}

//cookies
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
//folders
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

resource "aws_api_gateway_integration" "sans_api_folders_folderid_resize_options" {
  rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
  resource_id   = "${aws_api_gateway_resource.sans_api_folders_folderid_resize.id}"
  http_method   = "${aws_api_gateway_method.sans_api_folders_folderid_resize_options.http_method}"
  type          = "MOCK"
	request_templates = {
    "application/json" = <<EOF
{"statusCode": 200}
EOF
}

  depends_on = ["aws_api_gateway_method.sans_api_folders_folderid_resize_options"]
}

resource "aws_api_gateway_integration" "sans_api_folders_folderid_resize_post" {
  rest_api_id = "${aws_api_gateway_rest_api.sans_api.id}"
  resource_id = "${aws_api_gateway_method.sans_api_folders_folderid_resize_post.resource_id}"
  http_method = "${aws_api_gateway_method.sans_api_folders_folderid_resize_post.http_method}"

	content_handling        = "CONVERT_TO_TEXT"
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.sans_folders_resize_post.invoke_arn}"

  depends_on = ["aws_api_gateway_method.sans_api_folders_folderid_resize_post"]
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

//albums
resource "aws_api_gateway_integration" "sans_api_albums_options" {
  rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
  resource_id   = "${aws_api_gateway_resource.sans_api_albums.id}"
  http_method   = "${aws_api_gateway_method.sans_api_albums_options.http_method}"
  type          = "MOCK"
	request_templates = {
    "application/json" = <<EOF
{"statusCode": 200}
EOF
}

  depends_on = ["aws_api_gateway_method.sans_api_albums_options"]
}

resource "aws_api_gateway_integration" "sans_api_albums_get" {
  rest_api_id = "${aws_api_gateway_rest_api.sans_api.id}"
  resource_id = "${aws_api_gateway_method.sans_api_albums_get.resource_id}"
  http_method = "${aws_api_gateway_method.sans_api_albums_get.http_method}"

	content_handling        = "CONVERT_TO_TEXT"
	integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.sans_albums_getall.invoke_arn}"

  depends_on = ["aws_api_gateway_method.sans_api_albums_get"]
}

resource "aws_api_gateway_integration" "sans_api_albums_post" {
  rest_api_id = "${aws_api_gateway_rest_api.sans_api.id}"
  resource_id = "${aws_api_gateway_method.sans_api_albums_post.resource_id}"
  http_method = "${aws_api_gateway_method.sans_api_albums_post.http_method}"

	content_handling        = "CONVERT_TO_TEXT"
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.sans_albums_create.invoke_arn}"

  depends_on = ["aws_api_gateway_method.sans_api_albums_post"]
}

resource "aws_api_gateway_integration" "sans_api_albums_albumid_options" {
  rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
  resource_id   = "${aws_api_gateway_resource.sans_api_albums_albumid.id}"
  http_method   = "${aws_api_gateway_method.sans_api_albums_albumid_options.http_method}"
  type          = "MOCK"
	request_templates = {
    "application/json" = <<EOF
{"statusCode": 200}
EOF
}

  depends_on = ["aws_api_gateway_method.sans_api_albums_albumid_options"]
}

resource "aws_api_gateway_integration" "sans_api_albums_albumid_get" {
  rest_api_id = "${aws_api_gateway_rest_api.sans_api.id}"
  resource_id = "${aws_api_gateway_method.sans_api_albums_albumid_get.resource_id}"
  http_method = "${aws_api_gateway_method.sans_api_albums_albumid_get.http_method}"

	content_handling        = "CONVERT_TO_TEXT"
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.sans_albums_get.invoke_arn}"

  depends_on = ["aws_api_gateway_method.sans_api_albums_albumid_get"]
}

resource "aws_api_gateway_integration" "sans_api_albums_albumid_put" {
  rest_api_id = "${aws_api_gateway_rest_api.sans_api.id}"
  resource_id = "${aws_api_gateway_method.sans_api_albums_albumid_put.resource_id}"
  http_method = "${aws_api_gateway_method.sans_api_albums_albumid_put.http_method}"

	content_handling        = "CONVERT_TO_TEXT"
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.sans_albums_update.invoke_arn}"

  depends_on = ["aws_api_gateway_method.sans_api_albums_albumid_put"]
}

resource "aws_api_gateway_integration" "sans_api_albums_albumid_delete" {
  rest_api_id = "${aws_api_gateway_rest_api.sans_api.id}"
  resource_id = "${aws_api_gateway_method.sans_api_albums_albumid_delete.resource_id}"
  http_method = "${aws_api_gateway_method.sans_api_albums_albumid_delete.http_method}"

	content_handling        = "CONVERT_TO_TEXT"
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.sans_albums_delete.invoke_arn}"

  depends_on = ["aws_api_gateway_method.sans_api_albums_albumid_delete"]
}

resource "aws_api_gateway_integration" "sans_api_albums_albumid_images_options" {
  rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
  resource_id   = "${aws_api_gateway_resource.sans_api_albums_albumid_images.id}"
  http_method   = "${aws_api_gateway_method.sans_api_albums_albumid_images_options.http_method}"
  type          = "MOCK"
	request_templates = {
    "application/json" = <<EOF
{"statusCode": 200}
EOF
}

  depends_on = ["aws_api_gateway_method.sans_api_albums_albumid_images_options"]
}

resource "aws_api_gateway_integration" "sans_api_albums_albumid_images_get" {
  rest_api_id = "${aws_api_gateway_rest_api.sans_api.id}"
  resource_id = "${aws_api_gateway_method.sans_api_albums_albumid_images_get.resource_id}"
  http_method = "${aws_api_gateway_method.sans_api_albums_albumid_images_get.http_method}"

	content_handling        = "CONVERT_TO_TEXT"
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.sans_albums_images_get.invoke_arn}"

  depends_on = ["aws_api_gateway_method.sans_api_albums_albumid_images_get"]
}


//events
resource "aws_api_gateway_integration" "sans_api_events_options" {
  rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
  resource_id   = "${aws_api_gateway_resource.sans_api_events.id}"
  http_method   = "${aws_api_gateway_method.sans_api_events_options.http_method}"
  type          = "MOCK"
	request_templates = {
    "application/json" = <<EOF
{"statusCode": 200}
EOF
}

  depends_on = ["aws_api_gateway_method.sans_api_events_options"]
}

resource "aws_api_gateway_integration" "sans_api_events_get" {
  rest_api_id = "${aws_api_gateway_rest_api.sans_api.id}"
  resource_id = "${aws_api_gateway_method.sans_api_events_get.resource_id}"
  http_method = "${aws_api_gateway_method.sans_api_events_get.http_method}"

	content_handling        = "CONVERT_TO_TEXT"
	integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.sans_events_getall.invoke_arn}"

  depends_on = ["aws_api_gateway_method.sans_api_events_get"]
}

resource "aws_api_gateway_integration" "sans_api_events_post" {
  rest_api_id = "${aws_api_gateway_rest_api.sans_api.id}"
  resource_id = "${aws_api_gateway_method.sans_api_events_post.resource_id}"
  http_method = "${aws_api_gateway_method.sans_api_events_post.http_method}"

	content_handling        = "CONVERT_TO_TEXT"
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.sans_events_create.invoke_arn}"

  depends_on = ["aws_api_gateway_method.sans_api_events_post"]
}

resource "aws_api_gateway_integration" "sans_api_events_eventid_options" {
  rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
  resource_id   = "${aws_api_gateway_resource.sans_api_events_eventid.id}"
  http_method   = "${aws_api_gateway_method.sans_api_events_eventid_options.http_method}"
  type          = "MOCK"
	request_templates = {
    "application/json" = <<EOF
{"statusCode": 200}
EOF
}

  depends_on = ["aws_api_gateway_method.sans_api_events_eventid_options"]
}

resource "aws_api_gateway_integration" "sans_api_events_eventid_get" {
  rest_api_id = "${aws_api_gateway_rest_api.sans_api.id}"
  resource_id = "${aws_api_gateway_method.sans_api_events_eventid_get.resource_id}"
  http_method = "${aws_api_gateway_method.sans_api_events_eventid_get.http_method}"

	content_handling        = "CONVERT_TO_TEXT"
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.sans_events_get.invoke_arn}"

  depends_on = ["aws_api_gateway_method.sans_api_events_eventid_get"]
}

resource "aws_api_gateway_integration" "sans_api_events_eventid_put" {
  rest_api_id = "${aws_api_gateway_rest_api.sans_api.id}"
  resource_id = "${aws_api_gateway_method.sans_api_events_eventid_put.resource_id}"
  http_method = "${aws_api_gateway_method.sans_api_events_eventid_put.http_method}"

	content_handling        = "CONVERT_TO_TEXT"
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.sans_events_update.invoke_arn}"

  depends_on = ["aws_api_gateway_method.sans_api_events_eventid_put"]
}

resource "aws_api_gateway_integration" "sans_api_events_eventid_delete" {
  rest_api_id = "${aws_api_gateway_rest_api.sans_api.id}"
  resource_id = "${aws_api_gateway_method.sans_api_events_eventid_delete.resource_id}"
  http_method = "${aws_api_gateway_method.sans_api_events_eventid_delete.http_method}"

	content_handling        = "CONVERT_TO_TEXT"
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.sans_events_delete.invoke_arn}"

  depends_on = ["aws_api_gateway_method.sans_api_events_eventid_delete"]
}

//messages
resource "aws_api_gateway_integration" "sans_api_messages_options" {
  rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
  resource_id   = "${aws_api_gateway_resource.sans_api_messages.id}"
  http_method   = "${aws_api_gateway_method.sans_api_messages_options.http_method}"
  type          = "MOCK"
	request_templates = {
    "application/json" = <<EOF
{"statusCode": 200}
EOF
}

  depends_on = ["aws_api_gateway_method.sans_api_messages_options"]
}

resource "aws_api_gateway_integration" "sans_api_messages_get" {
  rest_api_id = "${aws_api_gateway_rest_api.sans_api.id}"
  resource_id = "${aws_api_gateway_method.sans_api_messages_get.resource_id}"
  http_method = "${aws_api_gateway_method.sans_api_messages_get.http_method}"

	content_handling        = "CONVERT_TO_TEXT"
	integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.sans_messages_getall.invoke_arn}"

  depends_on = ["aws_api_gateway_method.sans_api_messages_get"]
}

resource "aws_api_gateway_integration" "sans_api_messages_post" {
  rest_api_id = "${aws_api_gateway_rest_api.sans_api.id}"
  resource_id = "${aws_api_gateway_method.sans_api_messages_post.resource_id}"
  http_method = "${aws_api_gateway_method.sans_api_messages_post.http_method}"

	content_handling        = "CONVERT_TO_TEXT"
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.sans_messages_create.invoke_arn}"

  depends_on = ["aws_api_gateway_method.sans_api_messages_post"]
}

resource "aws_api_gateway_integration" "sans_api_messages_messageid_options" {
  rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
  resource_id   = "${aws_api_gateway_resource.sans_api_messages_messageid.id}"
  http_method   = "${aws_api_gateway_method.sans_api_messages_messageid_options.http_method}"
  type          = "MOCK"
	request_templates = {
    "application/json" = <<EOF
{"statusCode": 200}
EOF
}

  depends_on = ["aws_api_gateway_method.sans_api_messages_messageid_options"]
}

resource "aws_api_gateway_integration" "sans_api_messages_messageid_get" {
  rest_api_id = "${aws_api_gateway_rest_api.sans_api.id}"
  resource_id = "${aws_api_gateway_method.sans_api_messages_messageid_get.resource_id}"
  http_method = "${aws_api_gateway_method.sans_api_messages_messageid_get.http_method}"

	content_handling        = "CONVERT_TO_TEXT"
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.sans_messages_get.invoke_arn}"

  depends_on = ["aws_api_gateway_method.sans_api_messages_messageid_get"]
}

resource "aws_api_gateway_integration" "sans_api_messages_messageid_put" {
  rest_api_id = "${aws_api_gateway_rest_api.sans_api.id}"
  resource_id = "${aws_api_gateway_method.sans_api_messages_messageid_put.resource_id}"
  http_method = "${aws_api_gateway_method.sans_api_messages_messageid_put.http_method}"

	content_handling        = "CONVERT_TO_TEXT"
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.sans_messages_update.invoke_arn}"

  depends_on = ["aws_api_gateway_method.sans_api_messages_messageid_put"]
}

resource "aws_api_gateway_integration" "sans_api_messages_messageid_delete" {
  rest_api_id = "${aws_api_gateway_rest_api.sans_api.id}"
  resource_id = "${aws_api_gateway_method.sans_api_messages_messageid_delete.resource_id}"
  http_method = "${aws_api_gateway_method.sans_api_messages_messageid_delete.http_method}"

	content_handling        = "CONVERT_TO_TEXT"
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.sans_messages_delete.invoke_arn}"

  depends_on = ["aws_api_gateway_method.sans_api_messages_messageid_delete"]
}

//images
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

resource "aws_api_gateway_integration" "sans_api_images_public_options" {
  rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
  resource_id   = "${aws_api_gateway_resource.sans_api_images_public.id}"
  http_method   = "${aws_api_gateway_method.sans_api_images_public_options.http_method}"
  type          = "MOCK"
	request_templates = {
    "application/json" = <<EOF
{"statusCode": 200}
EOF
}

  depends_on = ["aws_api_gateway_method.sans_api_images_public_options"]
}

resource "aws_api_gateway_integration" "sans_api_images_public_get" {
  rest_api_id = "${aws_api_gateway_rest_api.sans_api.id}"
  resource_id = "${aws_api_gateway_method.sans_api_images_public_get.resource_id}"
  http_method = "${aws_api_gateway_method.sans_api_images_public_get.http_method}"

	content_handling        = "CONVERT_TO_TEXT"
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.sans_images_getpublic.invoke_arn}"

  depends_on = ["aws_api_gateway_method.sans_api_images_public_get"]
}

//pages
resource "aws_api_gateway_integration" "sans_api_pages_options" {
  rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
  resource_id   = "${aws_api_gateway_resource.sans_api_pages.id}"
  http_method   = "${aws_api_gateway_method.sans_api_pages_options.http_method}"
  type          = "MOCK"
	request_templates = {
    "application/json" = <<EOF
{"statusCode": 200}
EOF
}

  depends_on = ["aws_api_gateway_method.sans_api_pages_options"]
}

resource "aws_api_gateway_integration" "sans_api_pages_get" {
  rest_api_id = "${aws_api_gateway_rest_api.sans_api.id}"
  resource_id = "${aws_api_gateway_method.sans_api_pages_get.resource_id}"
  http_method = "${aws_api_gateway_method.sans_api_pages_get.http_method}"

	content_handling        = "CONVERT_TO_TEXT"
	integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.sans_pages_getall.invoke_arn}"

  depends_on = ["aws_api_gateway_method.sans_api_pages_get"]
}

resource "aws_api_gateway_integration" "sans_api_pages_post" {
  rest_api_id = "${aws_api_gateway_rest_api.sans_api.id}"
  resource_id = "${aws_api_gateway_method.sans_api_pages_post.resource_id}"
  http_method = "${aws_api_gateway_method.sans_api_pages_post.http_method}"

	content_handling        = "CONVERT_TO_TEXT"
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.sans_pages_create.invoke_arn}"

  depends_on = ["aws_api_gateway_method.sans_api_pages_post"]
}

resource "aws_api_gateway_integration" "sans_api_pages_pageid_options" {
  rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
  resource_id   = "${aws_api_gateway_resource.sans_api_pages_pageid.id}"
  http_method   = "${aws_api_gateway_method.sans_api_pages_pageid_options.http_method}"
  type          = "MOCK"
	request_templates = {
    "application/json" = <<EOF
{"statusCode": 200}
EOF
}

  depends_on = ["aws_api_gateway_method.sans_api_pages_pageid_options"]
}

resource "aws_api_gateway_integration" "sans_api_pages_pageid_get" {
  rest_api_id = "${aws_api_gateway_rest_api.sans_api.id}"
  resource_id = "${aws_api_gateway_method.sans_api_pages_pageid_get.resource_id}"
  http_method = "${aws_api_gateway_method.sans_api_pages_pageid_get.http_method}"

	content_handling        = "CONVERT_TO_TEXT"
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.sans_pages_get.invoke_arn}"

  depends_on = ["aws_api_gateway_method.sans_api_pages_pageid_get"]
}

resource "aws_api_gateway_integration" "sans_api_pages_pageid_put" {
  rest_api_id = "${aws_api_gateway_rest_api.sans_api.id}"
  resource_id = "${aws_api_gateway_method.sans_api_pages_pageid_put.resource_id}"
  http_method = "${aws_api_gateway_method.sans_api_pages_pageid_put.http_method}"

	content_handling        = "CONVERT_TO_TEXT"
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.sans_pages_update.invoke_arn}"

  depends_on = ["aws_api_gateway_method.sans_api_pages_pageid_put"]
}

resource "aws_api_gateway_integration" "sans_api_pages_pageid_delete" {
  rest_api_id = "${aws_api_gateway_rest_api.sans_api.id}"
  resource_id = "${aws_api_gateway_method.sans_api_pages_pageid_delete.resource_id}"
  http_method = "${aws_api_gateway_method.sans_api_pages_pageid_delete.http_method}"

	content_handling        = "CONVERT_TO_TEXT"
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.sans_pages_delete.invoke_arn}"

  depends_on = ["aws_api_gateway_method.sans_api_pages_pageid_delete"]
}

//cookies
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
//folders
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
    status_code   = "${aws_api_gateway_method_response.sans_api_folders_post.status_code}"
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

resource "aws_api_gateway_integration_response" "sans_api_folders_folderid_resize_options" {
    rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
    resource_id   = "${aws_api_gateway_resource.sans_api_folders_folderid_resize.id}"
    http_method   = "${aws_api_gateway_method.sans_api_folders_folderid_resize_options.http_method}"
    status_code   = "${aws_api_gateway_method_response.sans_api_folders_folderid_resize_options.status_code}"
    response_parameters = {
			"method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
			"method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT,DELETE'",
			"method.response.header.Access-Control-Allow-Origin" = "'*'"
    }
    depends_on = ["aws_api_gateway_integration.sans_api_folders_folderid_resize_options"]
}

resource "aws_api_gateway_integration_response" "sans_api_folders_folderid_resize_post" {
    rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
    resource_id   = "${aws_api_gateway_resource.sans_api_folders_folderid_resize.id}"
    http_method   = "${aws_api_gateway_method.sans_api_folders_folderid_resize_post.http_method}"
    status_code   = "${aws_api_gateway_method_response.sans_api_folders_folderid_resize_post.status_code}"
		response_templates = { 
			"application/json" = "null"
    }		

    depends_on = ["aws_api_gateway_integration.sans_api_folders_folderid_resize_post"]
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

//albums
resource "aws_api_gateway_integration_response" "sans_api_albums_options" {
    rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
    resource_id   = "${aws_api_gateway_resource.sans_api_albums.id}"
    http_method   = "${aws_api_gateway_method.sans_api_albums_options.http_method}"
    status_code   = "${aws_api_gateway_method_response.sans_api_albums_options.status_code}"
    response_parameters = {
			"method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
			"method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT,DELETE'",
			"method.response.header.Access-Control-Allow-Origin" = "'*'"
    }
    depends_on = ["aws_api_gateway_integration.sans_api_albums_options"]
}

resource "aws_api_gateway_integration_response" "sans_api_album_get" {
    rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
    resource_id   = "${aws_api_gateway_resource.sans_api_albums.id}"
    http_method   = "${aws_api_gateway_method.sans_api_albums_get.http_method}"
    status_code   = "${aws_api_gateway_method_response.sans_api_albums_get.status_code}"
		response_templates = { 
			"application/json" = "null"
    }		

    depends_on = ["aws_api_gateway_integration.sans_api_albums_get"]
}

resource "aws_api_gateway_integration_response" "sans_api_albums_post" {
    rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
    resource_id   = "${aws_api_gateway_resource.sans_api_albums.id}"
    http_method   = "${aws_api_gateway_method.sans_api_albums_post.http_method}"
    status_code   = "${aws_api_gateway_method_response.sans_api_albums_post.status_code}"
		response_templates = { 
			"application/json" = "null"
    }		

    depends_on = ["aws_api_gateway_integration.sans_api_albums_post"]
}

resource "aws_api_gateway_integration_response" "sans_api_albums_albumid_options" {
    rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
    resource_id   = "${aws_api_gateway_resource.sans_api_albums_albumid.id}"
    http_method   = "${aws_api_gateway_method.sans_api_albums_albumid_options.http_method}"
    status_code   = "${aws_api_gateway_method_response.sans_api_albums_albumid_options.status_code}"
    response_parameters = {
			"method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
			"method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT,DELETE'",
			"method.response.header.Access-Control-Allow-Origin" = "'*'"
    }
    depends_on = ["aws_api_gateway_integration.sans_api_albums_albumid_options"]
}

resource "aws_api_gateway_integration_response" "sans_api_albums_albumid_get" {
    rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
    resource_id   = "${aws_api_gateway_resource.sans_api_albums_albumid.id}"
    http_method   = "${aws_api_gateway_method.sans_api_albums_albumid_get.http_method}"
    status_code   = "${aws_api_gateway_method_response.sans_api_albums_albumid_get.status_code}"
		response_templates = { 
			"application/json" = "null"
    }		

    depends_on = ["aws_api_gateway_integration.sans_api_albums_albumid_get"]
}

resource "aws_api_gateway_integration_response" "sans_api_albums_albumid_put" {
    rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
    resource_id   = "${aws_api_gateway_resource.sans_api_albums_albumid.id}"
    http_method   = "${aws_api_gateway_method.sans_api_albums_albumid_put.http_method}"
    status_code   = "${aws_api_gateway_method_response.sans_api_albums_albumid_put.status_code}"
		response_templates = { 
			"application/json" = "null"
    }		

    depends_on = ["aws_api_gateway_integration.sans_api_albums_albumid_put"]
}

resource "aws_api_gateway_integration_response" "sans_api_albums_albumid_delete" {
    rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
    resource_id   = "${aws_api_gateway_resource.sans_api_albums_albumid.id}"
    http_method   = "${aws_api_gateway_method.sans_api_albums_albumid_delete.http_method}"
    status_code   = "${aws_api_gateway_method_response.sans_api_albums_albumid_delete.status_code}"
		response_templates = { 
			"application/json" = "null"
    }		

    depends_on = ["aws_api_gateway_integration.sans_api_albums_albumid_delete"]
}

resource "aws_api_gateway_integration_response" "sans_api_albums_albumid_images_options" {
    rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
    resource_id   = "${aws_api_gateway_resource.sans_api_albums_albumid_images.id}"
    http_method   = "${aws_api_gateway_method.sans_api_albums_albumid_images_options.http_method}"
    status_code   = "${aws_api_gateway_method_response.sans_api_albums_albumid_images_options.status_code}"
    response_parameters = {
			"method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
			"method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT,DELETE'",
			"method.response.header.Access-Control-Allow-Origin" = "'*'"
    }
    depends_on = ["aws_api_gateway_integration.sans_api_albums_albumid_images_options"]
}

resource "aws_api_gateway_integration_response" "sans_api_albums_albumid_images_get" {
    rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
    resource_id   = "${aws_api_gateway_resource.sans_api_albums_albumid_images.id}"
    http_method   = "${aws_api_gateway_method.sans_api_albums_albumid_images_get.http_method}"
    status_code   = "${aws_api_gateway_method_response.sans_api_albums_albumid_images_get.status_code}"
		response_templates = { 
			"application/json" = "null"
    }		

    depends_on = ["aws_api_gateway_integration.sans_api_albums_albumid_images_get"]
}

//events
resource "aws_api_gateway_integration_response" "sans_api_events_options" {
    rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
    resource_id   = "${aws_api_gateway_resource.sans_api_events.id}"
    http_method   = "${aws_api_gateway_method.sans_api_events_options.http_method}"
    status_code   = "${aws_api_gateway_method_response.sans_api_events_options.status_code}"
    response_parameters = {
			"method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
			"method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT,DELETE'",
			"method.response.header.Access-Control-Allow-Origin" = "'*'"
    }
    depends_on = ["aws_api_gateway_integration.sans_api_events_options"]
}

resource "aws_api_gateway_integration_response" "sans_api_event_get" {
    rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
    resource_id   = "${aws_api_gateway_resource.sans_api_events.id}"
    http_method   = "${aws_api_gateway_method.sans_api_events_get.http_method}"
    status_code   = "${aws_api_gateway_method_response.sans_api_events_get.status_code}"
		response_templates = { 
			"application/json" = "null"
    }		

    depends_on = ["aws_api_gateway_integration.sans_api_events_get"]
}

resource "aws_api_gateway_integration_response" "sans_api_events_post" {
    rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
    resource_id   = "${aws_api_gateway_resource.sans_api_events.id}"
    http_method   = "${aws_api_gateway_method.sans_api_events_post.http_method}"
    status_code   = "${aws_api_gateway_method_response.sans_api_events_post.status_code}"
		response_templates = { 
			"application/json" = "null"
    }		

    depends_on = ["aws_api_gateway_integration.sans_api_events_post"]
}

resource "aws_api_gateway_integration_response" "sans_api_events_eventid_options" {
    rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
    resource_id   = "${aws_api_gateway_resource.sans_api_events_eventid.id}"
    http_method   = "${aws_api_gateway_method.sans_api_events_eventid_options.http_method}"
    status_code   = "${aws_api_gateway_method_response.sans_api_events_eventid_options.status_code}"
    response_parameters = {
			"method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
			"method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT,DELETE'",
			"method.response.header.Access-Control-Allow-Origin" = "'*'"
    }
    depends_on = ["aws_api_gateway_integration.sans_api_events_eventid_options"]
}

resource "aws_api_gateway_integration_response" "sans_api_events_eventid_get" {
    rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
    resource_id   = "${aws_api_gateway_resource.sans_api_events_eventid.id}"
    http_method   = "${aws_api_gateway_method.sans_api_events_eventid_get.http_method}"
    status_code   = "${aws_api_gateway_method_response.sans_api_events_eventid_get.status_code}"
		response_templates = { 
			"application/json" = "null"
    }		

    depends_on = ["aws_api_gateway_integration.sans_api_events_eventid_get"]
}

resource "aws_api_gateway_integration_response" "sans_api_events_eventid_put" {
    rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
    resource_id   = "${aws_api_gateway_resource.sans_api_events_eventid.id}"
    http_method   = "${aws_api_gateway_method.sans_api_events_eventid_put.http_method}"
    status_code   = "${aws_api_gateway_method_response.sans_api_events_eventid_put.status_code}"
		response_templates = { 
			"application/json" = "null"
    }		

    depends_on = ["aws_api_gateway_integration.sans_api_events_eventid_put"]
}

resource "aws_api_gateway_integration_response" "sans_api_events_eventid_delete" {
    rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
    resource_id   = "${aws_api_gateway_resource.sans_api_events_eventid.id}"
    http_method   = "${aws_api_gateway_method.sans_api_events_eventid_delete.http_method}"
    status_code   = "${aws_api_gateway_method_response.sans_api_events_eventid_delete.status_code}"
		response_templates = { 
			"application/json" = "null"
    }		

    depends_on = ["aws_api_gateway_integration.sans_api_events_eventid_delete"]
}

//messagess
resource "aws_api_gateway_integration_response" "sans_api_messages_options" {
    rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
    resource_id   = "${aws_api_gateway_resource.sans_api_messages.id}"
    http_method   = "${aws_api_gateway_method.sans_api_messages_options.http_method}"
    status_code   = "${aws_api_gateway_method_response.sans_api_messages_options.status_code}"
    response_parameters = {
			"method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
			"method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT,DELETE'",
			"method.response.header.Access-Control-Allow-Origin" = "'*'"
    }
    depends_on = ["aws_api_gateway_integration.sans_api_messages_options"]
}

resource "aws_api_gateway_integration_response" "sans_api_messages_get" {
    rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
    resource_id   = "${aws_api_gateway_resource.sans_api_messages.id}"
    http_method   = "${aws_api_gateway_method.sans_api_messages_get.http_method}"
    status_code   = "${aws_api_gateway_method_response.sans_api_messages_get.status_code}"
		response_templates = { 
			"application/json" = "null"
    }		

    depends_on = ["aws_api_gateway_integration.sans_api_messages_get"]
}

resource "aws_api_gateway_integration_response" "sans_api_messages_post" {
    rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
    resource_id   = "${aws_api_gateway_resource.sans_api_messages.id}"
    http_method   = "${aws_api_gateway_method.sans_api_messages_post.http_method}"
    status_code   = "${aws_api_gateway_method_response.sans_api_messages_post.status_code}"
		response_templates = { 
			"application/json" = "null"
    }		

    depends_on = ["aws_api_gateway_integration.sans_api_messages_post"]
}

resource "aws_api_gateway_integration_response" "sans_api_messages_messageid_options" {
    rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
    resource_id   = "${aws_api_gateway_resource.sans_api_messages_messageid.id}"
    http_method   = "${aws_api_gateway_method.sans_api_messages_messageid_options.http_method}"
    status_code   = "${aws_api_gateway_method_response.sans_api_messages_messageid_options.status_code}"
    response_parameters = {
			"method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
			"method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT,DELETE'",
			"method.response.header.Access-Control-Allow-Origin" = "'*'"
    }
    depends_on = ["aws_api_gateway_integration.sans_api_messages_messageid_options"]
}

resource "aws_api_gateway_integration_response" "sans_api_messages_messageid_get" {
    rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
    resource_id   = "${aws_api_gateway_resource.sans_api_messages_messageid.id}"
    http_method   = "${aws_api_gateway_method.sans_api_messages_messageid_get.http_method}"
    status_code   = "${aws_api_gateway_method_response.sans_api_messages_messageid_get.status_code}"
		response_templates = { 
			"application/json" = "null"
    }		

    depends_on = ["aws_api_gateway_integration.sans_api_messages_messageid_get"]
}

resource "aws_api_gateway_integration_response" "sans_api_messages_messageid_put" {
    rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
    resource_id   = "${aws_api_gateway_resource.sans_api_messages_messageid.id}"
    http_method   = "${aws_api_gateway_method.sans_api_messages_messageid_put.http_method}"
    status_code   = "${aws_api_gateway_method_response.sans_api_messages_messageid_put.status_code}"
		response_templates = { 
			"application/json" = "null"
    }		

    depends_on = ["aws_api_gateway_integration.sans_api_messages_messageid_put"]
}

resource "aws_api_gateway_integration_response" "sans_api_messages_messageid_delete" {
    rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
    resource_id   = "${aws_api_gateway_resource.sans_api_messages_messageid.id}"
    http_method   = "${aws_api_gateway_method.sans_api_messages_messageid_delete.http_method}"
    status_code   = "${aws_api_gateway_method_response.sans_api_messages_messageid_delete.status_code}"
		response_templates = { 
			"application/json" = "null"
    }		

    depends_on = ["aws_api_gateway_integration.sans_api_messages_messageid_delete"]
}

//images
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

resource "aws_api_gateway_integration_response" "sans_api_images_public_options" {
    rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
    resource_id   = "${aws_api_gateway_resource.sans_api_images_public.id}"
    http_method   = "${aws_api_gateway_method.sans_api_images_public_options.http_method}"
    status_code   = "${aws_api_gateway_method_response.sans_api_images_public_options.status_code}"
    response_parameters = {
			"method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
			"method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT,DELETE'",
			"method.response.header.Access-Control-Allow-Origin" = "'*'"
    }
    depends_on = ["aws_api_gateway_integration.sans_api_images_public_options"]
}

resource "aws_api_gateway_integration_response" "sans_api_images_public_get" {
    rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
    resource_id   = "${aws_api_gateway_resource.sans_api_images_public.id}"
    http_method   = "${aws_api_gateway_method.sans_api_images_public_get.http_method}"
    status_code   = "${aws_api_gateway_method_response.sans_api_images_public_get.status_code}"
		response_templates = { 
			"application/json" = "null"
    }		

    depends_on = ["aws_api_gateway_integration.sans_api_images_public_get"]
}

//pages
resource "aws_api_gateway_integration_response" "sans_api_pages_options" {
    rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
    resource_id   = "${aws_api_gateway_resource.sans_api_pages.id}"
    http_method   = "${aws_api_gateway_method.sans_api_pages_options.http_method}"
    status_code   = "${aws_api_gateway_method_response.sans_api_pages_options.status_code}"
    response_parameters = {
			"method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
			"method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT,DELETE'",
			"method.response.header.Access-Control-Allow-Origin" = "'*'"
    }
    depends_on = ["aws_api_gateway_integration.sans_api_pages_options"]
}

resource "aws_api_gateway_integration_response" "sans_api_pages_get" {
    rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
    resource_id   = "${aws_api_gateway_resource.sans_api_pages.id}"
    http_method   = "${aws_api_gateway_method.sans_api_pages_get.http_method}"
    status_code   = "${aws_api_gateway_method_response.sans_api_pages_get.status_code}"
		response_templates = { 
			"application/json" = "null"
    }		

    depends_on = ["aws_api_gateway_integration.sans_api_pages_get"]
}

resource "aws_api_gateway_integration_response" "sans_api_pages_post" {
    rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
    resource_id   = "${aws_api_gateway_resource.sans_api_pages.id}"
    http_method   = "${aws_api_gateway_method.sans_api_pages_post.http_method}"
    status_code   = "${aws_api_gateway_method_response.sans_api_pages_post.status_code}"
		response_templates = { 
			"application/json" = "null"
    }		

    depends_on = ["aws_api_gateway_integration.sans_api_pages_post"]
}

resource "aws_api_gateway_integration_response" "sans_api_pages_pageid_options" {
    rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
    resource_id   = "${aws_api_gateway_resource.sans_api_pages_pageid.id}"
    http_method   = "${aws_api_gateway_method.sans_api_pages_pageid_options.http_method}"
    status_code   = "${aws_api_gateway_method_response.sans_api_pages_pageid_options.status_code}"
    response_parameters = {
			"method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
			"method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT,DELETE'",
			"method.response.header.Access-Control-Allow-Origin" = "'*'"
    }
    depends_on = ["aws_api_gateway_integration.sans_api_pages_pageid_options"]
}

resource "aws_api_gateway_integration_response" "sans_api_pages_pageid_get" {
    rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
    resource_id   = "${aws_api_gateway_resource.sans_api_pages_pageid.id}"
    http_method   = "${aws_api_gateway_method.sans_api_pages_pageid_get.http_method}"
    status_code   = "${aws_api_gateway_method_response.sans_api_pages_pageid_get.status_code}"
		response_templates = { 
			"application/json" = "null"
    }		

    depends_on = ["aws_api_gateway_integration.sans_api_pages_pageid_get"]
}

resource "aws_api_gateway_integration_response" "sans_api_pages_pageid_put" {
    rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
    resource_id   = "${aws_api_gateway_resource.sans_api_pages_pageid.id}"
    http_method   = "${aws_api_gateway_method.sans_api_pages_pageid_put.http_method}"
    status_code   = "${aws_api_gateway_method_response.sans_api_pages_pageid_put.status_code}"
		response_templates = { 
			"application/json" = "null"
    }		

    depends_on = ["aws_api_gateway_integration.sans_api_pages_pageid_put"]
}

resource "aws_api_gateway_integration_response" "sans_api_pages_pageid_delete" {
    rest_api_id   = "${aws_api_gateway_rest_api.sans_api.id}"
    resource_id   = "${aws_api_gateway_resource.sans_api_pages_pageid.id}"
    http_method   = "${aws_api_gateway_method.sans_api_pages_pageid_delete.http_method}"
    status_code   = "${aws_api_gateway_method_response.sans_api_pages_pageid_delete.status_code}"
		response_templates = { 
			"application/json" = "null"
    }		

    depends_on = ["aws_api_gateway_integration.sans_api_pages_pageid_delete"]
}

//cookies
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
	             , "aws_api_gateway_integration.sans_api_folders_folderid_resize_options"
	             , "aws_api_gateway_integration.sans_api_folders_folderid_resize_post"
	             , "aws_api_gateway_integration.sans_api_folders_folderid_images_imageid_options"
	             , "aws_api_gateway_integration.sans_api_folders_folderid_images_imageid_delete"
	             , "aws_api_gateway_integration.sans_api_albums_options"
	             , "aws_api_gateway_integration.sans_api_albums_get"
	             , "aws_api_gateway_integration.sans_api_albums_post"
	             , "aws_api_gateway_integration.sans_api_albums_albumid_options"
	             , "aws_api_gateway_integration.sans_api_albums_albumid_get"
	             , "aws_api_gateway_integration.sans_api_albums_albumid_put"
	             , "aws_api_gateway_integration.sans_api_albums_albumid_delete"
	             , "aws_api_gateway_integration.sans_api_albums_albumid_images_options"
	             , "aws_api_gateway_integration.sans_api_albums_albumid_images_get"
	             , "aws_api_gateway_integration.sans_api_events_options"
	             , "aws_api_gateway_integration.sans_api_events_get"
	             , "aws_api_gateway_integration.sans_api_events_post"
	             , "aws_api_gateway_integration.sans_api_events_eventid_options"
	             , "aws_api_gateway_integration.sans_api_events_eventid_get"
	             , "aws_api_gateway_integration.sans_api_events_eventid_put"
	             , "aws_api_gateway_integration.sans_api_events_eventid_delete"
	             , "aws_api_gateway_integration.sans_api_messages_options"
	             , "aws_api_gateway_integration.sans_api_messages_get"
	             , "aws_api_gateway_integration.sans_api_messages_post"
	             , "aws_api_gateway_integration.sans_api_messages_messageid_options"
	             , "aws_api_gateway_integration.sans_api_messages_messageid_get"
	             , "aws_api_gateway_integration.sans_api_messages_messageid_put"
	             , "aws_api_gateway_integration.sans_api_messages_messageid_delete"
	             , "aws_api_gateway_integration.sans_api_images_options"
	             , "aws_api_gateway_integration.sans_api_images_get"
	             , "aws_api_gateway_integration.sans_api_images_post"
	             , "aws_api_gateway_integration.sans_api_images_imageid_options"
	             , "aws_api_gateway_integration.sans_api_images_imageid_get"
	             , "aws_api_gateway_integration.sans_api_images_imageid_put"
	             , "aws_api_gateway_integration.sans_api_images_imageid_delete"
	             , "aws_api_gateway_integration.sans_api_images_public_options"
	             , "aws_api_gateway_integration.sans_api_images_public_get"
	             , "aws_api_gateway_integration.sans_api_pages_options"
	             , "aws_api_gateway_integration.sans_api_pages_get"
	             , "aws_api_gateway_integration.sans_api_pages_post"
	             , "aws_api_gateway_integration.sans_api_pages_pageid_options"
	             , "aws_api_gateway_integration.sans_api_pages_pageid_get"
	             , "aws_api_gateway_integration.sans_api_pages_pageid_put"
	             , "aws_api_gateway_integration.sans_api_pages_pageid_delete"
	             , "aws_api_gateway_integration.sans_api_cookies_options"
	             , "aws_api_gateway_integration.sans_api_cookies_get"
							 ]
}

resource "aws_api_gateway_base_path_mapping" "sans_api" {
  api_id      = "${aws_api_gateway_rest_api.sans_api.id}"
  stage_name  = "${aws_api_gateway_deployment.sans_api.stage_name}"
  domain_name = "${aws_api_gateway_domain_name.sans_api.domain_name}"
	base_path = "v1" 
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

//lambda permissions
//folders
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

resource "aws_lambda_permission" "sans_api_sans_folders_resize_post" {
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.sans_folders_resize_post.arn}"
  principal     = "apigateway.amazonaws.com"
  source_arn = "${aws_api_gateway_rest_api.sans_api.execution_arn}/*/POST/folders/{folderid}/resize"
}

//albums
resource "aws_lambda_permission" "sans_api_sans_albums_getall" {
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.sans_albums_getall.arn}"
  principal     = "apigateway.amazonaws.com"
  source_arn = "${aws_api_gateway_rest_api.sans_api.execution_arn}/*/GET/albums"
}

resource "aws_lambda_permission" "sans_api_sans_albums_create" {
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.sans_albums_create.arn}"
  principal     = "apigateway.amazonaws.com"
  source_arn = "${aws_api_gateway_rest_api.sans_api.execution_arn}/*/POST/albums"
}

resource "aws_lambda_permission" "sans_api_sans_albums_get" {
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.sans_albums_get.arn}"
  principal     = "apigateway.amazonaws.com"
  source_arn = "${aws_api_gateway_rest_api.sans_api.execution_arn}/*/GET/albums/{albumid}"
}

resource "aws_lambda_permission" "sans_api_sans_albums_update" {
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.sans_albums_update.arn}"
  principal     = "apigateway.amazonaws.com"
  source_arn = "${aws_api_gateway_rest_api.sans_api.execution_arn}/*/PUT/albums/{albumid}"
}

resource "aws_lambda_permission" "sans_api_sans_albums_delete" {
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.sans_albums_delete.arn}"
  principal     = "apigateway.amazonaws.com"
  source_arn = "${aws_api_gateway_rest_api.sans_api.execution_arn}/*/DELETE/albums/{albumid}"
}

resource "aws_lambda_permission" "sans_api_sans_albums_images_get" {
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.sans_albums_images_get.arn}"
  principal     = "apigateway.amazonaws.com"
  source_arn = "${aws_api_gateway_rest_api.sans_api.execution_arn}/*/GET/albums/{albumid}/images"
}

//events
resource "aws_lambda_permission" "sans_api_sans_events_getall" {
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.sans_events_getall.arn}"
  principal     = "apigateway.amazonaws.com"
  source_arn = "${aws_api_gateway_rest_api.sans_api.execution_arn}/*/GET/events"
}

resource "aws_lambda_permission" "sans_api_sans_events_create" {
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.sans_events_create.arn}"
  principal     = "apigateway.amazonaws.com"
  source_arn = "${aws_api_gateway_rest_api.sans_api.execution_arn}/*/POST/events"
}

resource "aws_lambda_permission" "sans_api_sans_events_get" {
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.sans_events_get.arn}"
  principal     = "apigateway.amazonaws.com"
  source_arn = "${aws_api_gateway_rest_api.sans_api.execution_arn}/*/GET/events/{eventid}"
}

resource "aws_lambda_permission" "sans_api_sans_events_update" {
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.sans_events_update.arn}"
  principal     = "apigateway.amazonaws.com"
  source_arn = "${aws_api_gateway_rest_api.sans_api.execution_arn}/*/PUT/events/{eventid}"
}

resource "aws_lambda_permission" "sans_api_sans_events_delete" {
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.sans_events_delete.arn}"
  principal     = "apigateway.amazonaws.com"
  source_arn = "${aws_api_gateway_rest_api.sans_api.execution_arn}/*/DELETE/events/{eventid}"
}

//messages
resource "aws_lambda_permission" "sans_api_sans_messages_getall" {
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.sans_messages_getall.arn}"
  principal     = "apigateway.amazonaws.com"
  source_arn = "${aws_api_gateway_rest_api.sans_api.execution_arn}/*/GET/messages"
}

resource "aws_lambda_permission" "sans_api_sans_messages_create" {
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.sans_messages_create.arn}"
  principal     = "apigateway.amazonaws.com"
  source_arn = "${aws_api_gateway_rest_api.sans_api.execution_arn}/*/POST/messages"
}

resource "aws_lambda_permission" "sans_api_sans_messages_get" {
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.sans_messages_get.arn}"
  principal     = "apigateway.amazonaws.com"
  source_arn = "${aws_api_gateway_rest_api.sans_api.execution_arn}/*/GET/messages/{messageid}"
}

resource "aws_lambda_permission" "sans_api_sans_messages_update" {
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.sans_messages_update.arn}"
  principal     = "apigateway.amazonaws.com"
  source_arn = "${aws_api_gateway_rest_api.sans_api.execution_arn}/*/PUT/messages/{messageid}"
}

resource "aws_lambda_permission" "sans_api_sans_messages_delete" {
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.sans_messages_delete.arn}"
  principal     = "apigateway.amazonaws.com"
  source_arn = "${aws_api_gateway_rest_api.sans_api.execution_arn}/*/DELETE/messages/{messageid}"
}

//images
resource "aws_lambda_permission" "sans_api_sans_images_getall" {
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.sans_images_getall.arn}"
  principal     = "apigateway.amazonaws.com"
  source_arn = "${aws_api_gateway_rest_api.sans_api.execution_arn}/*/GET/folders/{folderid}/images"
}

resource "aws_lambda_permission" "sans_api_sans_images_getpublic" {
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.sans_images_getpublic.arn}"
  principal     = "apigateway.amazonaws.com"
  source_arn = "${aws_api_gateway_rest_api.sans_api.execution_arn}/*/GET/images/public"
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

//pages
resource "aws_lambda_permission" "sans_api_sans_pages_getall" {
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.sans_pages_getall.arn}"
  principal     = "apigateway.amazonaws.com"
  source_arn = "${aws_api_gateway_rest_api.sans_api.execution_arn}/*/GET/pages"
}

resource "aws_lambda_permission" "sans_api_sans_pages_create" {
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.sans_pages_create.arn}"
  principal     = "apigateway.amazonaws.com"
  source_arn = "${aws_api_gateway_rest_api.sans_api.execution_arn}/*/POST/pages"
}

resource "aws_lambda_permission" "sans_api_sans_pages_get" {
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.sans_pages_get.arn}"
  principal     = "apigateway.amazonaws.com"
  source_arn = "${aws_api_gateway_rest_api.sans_api.execution_arn}/*/GET/pages/{pageid}"
}

resource "aws_lambda_permission" "sans_api_sans_pages_update" {
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.sans_pages_update.arn}"
  principal     = "apigateway.amazonaws.com"
  source_arn = "${aws_api_gateway_rest_api.sans_api.execution_arn}/*/PUT/pages/{pageid}"
}

resource "aws_lambda_permission" "sans_api_sans_pages_delete" {
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.sans_pages_delete.arn}"
  principal     = "apigateway.amazonaws.com"
  source_arn = "${aws_api_gateway_rest_api.sans_api.execution_arn}/*/DELETE/pages/{pageid}"
}

//cookies
resource "aws_lambda_permission" "sans_api_sans_cookies_get" {
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.sans_cookies_get.arn}"
  principal     = "apigateway.amazonaws.com"
  source_arn = "${aws_api_gateway_rest_api.sans_api.execution_arn}/*/GET/cookies"
}

