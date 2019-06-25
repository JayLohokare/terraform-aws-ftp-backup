resource "aws_ssm_parameter" "ftp_config" {
  name        = "ftp_config"
  description = "FTP Server Configuration used in AHMS ftp-to-s3-transfer lambda"
  type        = "SecureString"
  value       = "${data.template_file.ftp_config_json.rendered}"
}

data "template_file" "ftp_config_json" {
  template = "${file("${path.module}/credentials/ftp-configuration.json")}"
}