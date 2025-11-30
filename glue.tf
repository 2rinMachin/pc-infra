resource "aws_glue_catalog_database" "exports_db" {
  name = "${var.project_name}-${var.stage}-ingesta"
}

resource "aws_glue_catalog_table" "users" {
  name          = "${var.project_name}-${var.stage}-users"
  database_name = aws_glue_catalog_database.exports_db.name

  storage_descriptor {
    location = "s3://${aws_s3_bucket.ingesta.bucket}/users"


    input_format  = "org.apache.hadoop.mapred.TextInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"

    ser_de_info {
      serialization_library = "org.openx.data.jsonserde.JsonSerDe"
    }

    columns {
      name = "tenant_id"
      type = "string"
    }

    columns {
      name = "user_id"
      type = "string"
    }

    columns {
      name = "email"
      type = "string"
    }

    columns {
      name = "username"
      type = "string"
    }

    columns {
      name = "role"
      type = "string"
    }
  }
}

resource "aws_glue_catalog_table" "orders" {
  name          = "${var.project_name}-${var.stage}-orders"
  database_name = aws_glue_catalog_database.exports_db.name

  storage_descriptor {
    location = "s3://${aws_s3_bucket.ingesta.bucket}/orders"


    input_format  = "org.apache.hadoop.mapred.TextInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"

    ser_de_info {
      serialization_library = "org.openx.data.jsonserde.JsonSerDe"
    }

    columns {
      name = "tenant_id"
      type = "string"
    }

    columns {
      name = "order_id"
      type = "string"
    }

    columns {
      name = "client"
      type = "struct<tenant_id:string,user_id:string>"
    }

    columns {
      name = "items"
      type = "array<struct<product:struct<tenant_id:string,product_id:string>,quantity:int>>"
    }

    columns {
      name = "status"
      type = "string"
    }

    columns {
      name = "created_at"
      type = "timestamp"
    }

    columns {
      name = "cook_id"
      type = "string"
    }

    columns {
      name = "dispatcher_id"
      type = "string"
    }

    columns {
      name = "driver_id"
      type = "string"
    }

    columns {
      name = "history"
      type = "array<struct<user:struct<tenant_id:string,user_id:string>,status:string,date:timestamp>>"
    }
  }
}

resource "aws_glue_catalog_table" "products" {
  name          = "${var.project_name}-${var.stage}-products"
  database_name = aws_glue_catalog_database.exports_db.name

  storage_descriptor {
    location = "s3://${aws_s3_bucket.ingesta.bucket}/products"


    input_format  = "org.apache.hadoop.mapred.TextInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"

    ser_de_info {
      serialization_library = "org.openx.data.jsonserde.JsonSerDe"
    }

    columns {
      name = "tenant_id"
      type = "string"
    }

    columns {
      name = "product_id"
      type = "string"
    }

    columns {
      name = "name"
      type = "string"
    }

    columns {
      name = "price"
      type = "double"
    }

    columns {
      name = "image_url"
      type = "string"
    }
  }
}
