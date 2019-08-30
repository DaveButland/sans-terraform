resource "aws_dynamodb_table" "sans_website_folders" {
  name           = "sans-folders"
  billing_mode   = "PROVISIONED"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "userId"
  range_key      = "folderId"

  attribute {
    name = "folderId"
    type = "S"
  }

  attribute {
    name = "userId"
    type = "S"
  }

/*
  ttl {
    attribute_name = "TimeToExist"
    enabled        = false
  }
*/
}

resource "aws_dynamodb_table" "sans_website_albums" {
  name           = "sans-albums"
  billing_mode   = "PROVISIONED"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "userid"
  range_key      = "albumid"

  attribute {
    name = "userid"
    type = "S"
  }

  attribute {
    name = "albumid"
    type = "S"
  }

/*
  ttl {
    attribute_name = "TimeToExist"
    enabled        = false
  }
*/
}

resource "aws_dynamodb_table" "sans_website_pages" {
  name           = "sans-pages"
  billing_mode   = "PROVISIONED"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "userId"
  range_key      = "pageId"

  attribute {
    name = "pageId"
    type = "S"
  }

  attribute {
    name = "userId"
    type = "S"
  }

/*
  ttl {
    attribute_name = "TimeToExist"
    enabled        = false
  }
*/
}

resource "aws_dynamodb_table" "sans_website_images" {
  name           = "sans-images"
  billing_mode   = "PROVISIONED"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "userId"
  range_key      = "imageId"

  attribute {
    name = "userId"
    type = "S"
  }

  attribute {
    name = "imageId"
    type = "S"
  }

  attribute {
    name = "folderId"
    type = "S"
  }

/*
  ttl {
    attribute_name = "TimeToExist"
    enabled        = false
  }
*/

  global_secondary_index {
    name               = "userid-folderid-index"
    hash_key           = "userId"
    range_key          = "folderId"
    write_capacity     = 1
    read_capacity      = 1
    projection_type    = "ALL"
  }
}

resource "aws_dynamodb_table" "sans_website_events" {
  name           = "sans-events"
  billing_mode   = "PROVISIONED"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "userid"
  range_key      = "eventid"

  attribute {
    name = "userid"
    type = "S"
  }

  attribute {
    name = "eventid"
    type = "S"
	}
}

resource "aws_dynamodb_table" "sans_website_messages" {
  name           = "sans-messages"
  billing_mode   = "PROVISIONED"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "userid"
  range_key      = "messageid"

  attribute {
    name = "userid"
    type = "S"
  }

  attribute {
    name = "messageid"
    type = "S"
	}
}

resource "aws_dynamodb_table" "sans_website_users" {
  name           = "sans-users"
  billing_mode   = "PROVISIONED"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "userid"
  
  attribute {
    name = "userid"
    type = "S"
  }
}

resource "aws_dynamodb_table" "sans_website_references" {
  name           = "sans-references"
  billing_mode   = "PROVISIONED"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "userid"
	range_key      = "referenceid"
  
  attribute {
    name = "userid"
    type = "S"
  }

	attribute {
		name = "referenceid"
		type = "S"
	}
}


