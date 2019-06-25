# resource "aws_cloudwatch_event_rule" "source_two_event_rule" {
#   name = "source-two-event"
#   description = "Fires every five minutes"
#   schedule_expression = "cron(0/5 * * * ? *)"
# }

# resource "aws_cloudwatch_event_target" "move_files_to_destination_two" {
#   rule = "${aws_cloudwatch_event_rule.source_two_event_rule.name}"
#   target_id = "move-files-to-destination-two"
#   arn = "${module.move_ftp_files_to_s3_lambda.function_arn}"
#   input = "${data.template_file.source_destination_two_config.rendered}"
# }

# data "template_file" "source_destination_two_config" {
#   template = <<DOC
# {
#   "ftp_path": "$${ftp_path}",
#   "s3_bucket": "$${bucket_name}"
# }
# DOC

#   vars {
#     ftp_path = "/htdocs/source-two"
#     bucket_name = "${aws_s3_bucket.destination_two_bucket.bucket}"
#   }
# }





# resource "aws_lambda_permission" "source_two_invokes_lambda" {
#   statement_id = "source_two_invokes_lambda"
#   action = "lambda:InvokeFunction"
#   function_name = "${module.move_ftp_files_to_s3_lambda.function_arn}"
#   principal = "events.amazonaws.com"
#   source_arn = "${aws_cloudwatch_event_rule.source_two_event_rule.arn}"
# }