resource "aws_cognito_user_pool" "sans_website" {
  name = "sans-website"
	auto_verified_attributes = [ "email" ]

/*
        "MfaConfiguration": "OFF", 
        "VerificationMessageTemplate": {
            "DefaultEmailOption": "CONFIRM_WITH_CODE"
        }, 
        "AdminCreateUserConfig": {
            "UnusedAccountValidityDays": 7, 
            "AllowAdminCreateUserOnly": false
        }, 
        "Policies": {
            "PasswordPolicy": {
                "RequireLowercase": true, 
                "RequireSymbols": true, 
                "RequireNumbers": true, 
                "MinimumLength": 8, 
                "RequireUppercase": true
            }
        }, 
        "EmailConfiguration": {}, 
        "UserPoolTags": {}, 
        "LambdaConfig": {}
*/

  schema {
		name = "email"
    attribute_data_type = "String" 
    required = true 
    mutable = true
    developer_only_attribute = false 
    
		string_attribute_constraints {
      min_length = 0 
			max_length = 2048
    } 
  } 

	/*
{
        "SchemaAttributes": [
            {
                "Name": "sub", 
                "StringAttributeConstraints": {
                    "MinLength": "1", 
                    "MaxLength": "2048"
                }, 
                "DeveloperOnlyAttribute": false, 
                "Required": true, 
                "AttributeDataType": "String", 
                "Mutable": false
            }, 
            {
                "Name": "name", 
                "StringAttributeConstraints": {
                    "MinLength": "0", 
                    "MaxLength": "2048"
                }, 
                "DeveloperOnlyAttribute": false, 
                "Required": false, 
                "AttributeDataType": "String", 
                "Mutable": true
            }, 
            {
                "Name": "given_name", 
                "StringAttributeConstraints": {
                    "MinLength": "0", 
                    "MaxLength": "2048"
                }, 
                "DeveloperOnlyAttribute": false, 
                "Required": false, 
                "AttributeDataType": "String", 
                "Mutable": true
            }, 
            {
                "Name": "family_name", 
                "StringAttributeConstraints": {
                    "MinLength": "0", 
                    "MaxLength": "2048"
                }, 
                "DeveloperOnlyAttribute": false, 
                "Required": false, 
                "AttributeDataType": "String", 
                "Mutable": true
            }, 
            {
                "Name": "middle_name", 
                "StringAttributeConstraints": {
                    "MinLength": "0", 
                    "MaxLength": "2048"
                }, 
                "DeveloperOnlyAttribute": false, 
                "Required": false, 
                "AttributeDataType": "String", 
                "Mutable": true
            }, 
            {
                "Name": "nickname", 
                "StringAttributeConstraints": {
                    "MinLength": "0", 
                    "MaxLength": "2048"
                }, 
                "DeveloperOnlyAttribute": false, 
                "Required": false, 
                "AttributeDataType": "String", 
                "Mutable": true
            }, 
            {
                "Name": "preferred_username", 
                "StringAttributeConstraints": {
                    "MinLength": "0", 
                    "MaxLength": "2048"
                }, 
                "DeveloperOnlyAttribute": false, 
                "Required": false, 
                "AttributeDataType": "String", 
                "Mutable": true
            }, 
            {
                "Name": "profile", 
                "StringAttributeConstraints": {
                    "MinLength": "0", 
                    "MaxLength": "2048"
                }, 
                "DeveloperOnlyAttribute": false, 
                "Required": false, 
                "AttributeDataType": "String", 
                "Mutable": true
            }, 
            {
                "Name": "picture", 
                "StringAttributeConstraints": {
                    "MinLength": "0", 
                    "MaxLength": "2048"
                }, 
                "DeveloperOnlyAttribute": false, 
                "Required": false, 
                "AttributeDataType": "String", 
                "Mutable": true
            }, 
            {
                "Name": "website", 
                "StringAttributeConstraints": {
                    "MinLength": "0", 
                    "MaxLength": "2048"
                }, 
                "DeveloperOnlyAttribute": false, 
                "Required": false, 
                "AttributeDataType": "String", 
                "Mutable": true
            }, 
            {
                "Name": "email", 
                "StringAttributeConstraints": {
                    "MinLength": "0", 
                    "MaxLength": "2048"
                }, 
                "DeveloperOnlyAttribute": false, 
                "Required": true, 
                "AttributeDataType": "String", 
                "Mutable": true
            }, 
            {
                "AttributeDataType": "Boolean", 
                "DeveloperOnlyAttribute": false, 
                "Required": false, 
                "Name": "email_verified", 
                "Mutable": true
            }, 
            {
                "Name": "gender", 
                "StringAttributeConstraints": {
                    "MinLength": "0", 
                    "MaxLength": "2048"
                }, 
                "DeveloperOnlyAttribute": false, 
                "Required": false, 
                "AttributeDataType": "String", 
                "Mutable": true
            }, 
            {
                "Name": "birthdate", 
                "StringAttributeConstraints": {
                    "MinLength": "10", 
                    "MaxLength": "10"
                }, 
                "DeveloperOnlyAttribute": false, 
                "Required": false, 
                "AttributeDataType": "String", 
                "Mutable": true
            }, 
            {
                "Name": "zoneinfo", 
                "StringAttributeConstraints": {
                    "MinLength": "0", 
                    "MaxLength": "2048"
                }, 
                "DeveloperOnlyAttribute": false, 
                "Required": false, 
                "AttributeDataType": "String", 
                "Mutable": true
            }, 
            {
                "Name": "locale", 
                "StringAttributeConstraints": {
                    "MinLength": "0", 
                    "MaxLength": "2048"
                }, 
                "DeveloperOnlyAttribute": false, 
                "Required": false, 
                "AttributeDataType": "String", 
                "Mutable": true
            }, 
            {
                "Name": "phone_number", 
                "StringAttributeConstraints": {
                    "MinLength": "0", 
                    "MaxLength": "2048"
                }, 
                "DeveloperOnlyAttribute": false, 
                "Required": false, 
                "AttributeDataType": "String", 
                "Mutable": true
            }, 
            {
                "AttributeDataType": "Boolean", 
                "DeveloperOnlyAttribute": false, 
                "Required": false, 
                "Name": "phone_number_verified", 
                "Mutable": true
            }, 
            {
                "Name": "address", 
                "StringAttributeConstraints": {
                    "MinLength": "0", 
                    "MaxLength": "2048"
                }, 
                "DeveloperOnlyAttribute": false, 
                "Required": false, 
                "AttributeDataType": "String", 
                "Mutable": true
            }, 
            {
                "Name": "updated_at", 
                "NumberAttributeConstraints": {
                    "MinValue": "0"
                }, 
                "DeveloperOnlyAttribute": false, 
                "Required": false, 
                "AttributeDataType": "Number", 
                "Mutable": true
            }
        ], 
    }
}
*/

}

resource "aws_cognito_user_pool_domain" "sans_website" {
  domain       = "sans-website"
  user_pool_id = "${aws_cognito_user_pool.sans_website.id}"
}

resource "aws_cognito_resource_server" "sans_website" {
  identifier = "test"
  name = "test"  
  user_pool_id = "${aws_cognito_user_pool.sans_website.id}"

  scope {
    scope_name = "user"
		scope_description = "Just a user"
  }
}

resource "aws_cognito_user_pool_client" "sans_website" {
  name = "sans-website"
  user_pool_id = "${aws_cognito_user_pool.sans_website.id}"

	callback_urls = [ "https://d31ajfwgnb8bq0.cloudfront.net/" ]
	logout_urls = [ "https://d31ajfwgnb8bq0.cloudfront.net/signout" ]
//	generate_secret = false
	refresh_token_validity = 30
	allowed_oauth_flows = [ "code" ] 
	allowed_oauth_flows_user_pool_client = true
	allowed_oauth_scopes = ["test/user"]
	supported_identity_providers = [ "COGNITO" ]
//	default_redirect_uri - (Optional) The default redirect URI. Must be in the list of callback URLs.
//	explicit_auth_flows - (Optional) List of authentication flows (ADMIN_NO_SRP_AUTH, CUSTOM_AUTH_FLOW_ONLY, USER_PASSWORD_AUTH).

	read_attributes = [
    "address", 
    "birthdate", 
    "email", 
    "email_verified", 
    "family_name", 
    "gender", 
    "given_name", 
    "locale", 
    "middle_name", 
    "name", 
    "nickname", 
    "phone_number", 
    "phone_number_verified", 
    "picture", 
    "preferred_username", 
    "profile", 
    "updated_at", 
    "website", 
    "zoneinfo"
  ]

	write_attributes = [
    "address", 
    "birthdate", 
    "email", 
    "family_name", 
    "gender", 
    "given_name", 
    "locale", 
    "middle_name", 
    "name", 
    "nickname", 
    "phone_number", 
    "picture", 
    "preferred_username", 
    "profile", 
    "updated_at", 
    "website", 
    "zoneinfo"
  ]
}

