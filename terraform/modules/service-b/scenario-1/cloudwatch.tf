resource "aws_cloudwatch_log_group" "this" {
  name = "${local.name}-lg"
  tags = local.tags
}