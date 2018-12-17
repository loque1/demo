data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

resource "aws_api_gateway_rest_api" "update" {
  name = "Update DynaoDB API"
  description = "Terraform integration"
}
resource "aws_api_gateway_resource" "update" {
  rest_api_id = "${aws_api_gateway_rest_api.update.id}"
  parent_id = "${aws_api_gateway_rest_api.update.root_resource_id}"
  path_part = "/update"
}

resource "aws_api_gateway_method" "updatePost" {
  rest_api_id = "${aws_api_gateway_rest_api.update.id}"
  resource_id = "${aws_api_gateway_resource.update.id}"
  http_method = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "request_method_integration" {
  rest_api_id = "${aws_api_gateway_rest_api.update.id}"
  resource_id = "${aws_api_gateway_method.updatePost.id}"
  http_method = "${aws_api_gateway_method.updatePost.http_method}"
  type        = "AWS"
  uri         = "arn:aws:apigateway:${data.aws_region.current.name}:lambda:path/2015-03-31/functions/arn:aws:lambda:${data.aws_region.current.name}:${data.aws_caller_identity.current.accont_id}:function:${var.lambda}/invocations"

  # AWS lambdas can only be invoked with the POST method
  integration_http_method = "POST"
}

# lambda => GET response
resource "aws_api_gateway_method_response" "response_method" {
  rest_api_id = "${aws_api_gateway_rest_api.update.id}"
  resource_id = "${aws_api_gateway_method.updatePost.id}"
  http_method = "${aws_api_gateway_integration.request_method_integration.http_method}"
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }
}

# Response for: GET /update
resource "aws_api_gateway_integration_response" "response_method_integration" {
  rest_api_id = "${aws_api_gateway_rest_api.update.id}"
  resource_id = "${aws_api_gateway_method.updatePost.id}"
  http_method = "${aws_api_gateway_method_response.response_method.http_method}"
  status_code = "${aws_api_gateway_method_response.response_method.status_code}"

  response_templates = {
    "application/json" = ""
  }
}

resource "aws_lambda_permission" "allow_api_gateway" {
  function_name = "${var.lambda}"
  statement_id  = "AllowExecutionFromApiGateway"
  action        = "lambda:InvokeFunction"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.update.id}/*/${aws_api_gateway_method_response.response_method.http_method}${aws_api_gateway_resource.update.path_part}"
}
