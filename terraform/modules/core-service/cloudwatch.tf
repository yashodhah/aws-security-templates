resource "aws_cloudwatch_log_group" "this" {
  name = local.name
  tags = local.tags
}