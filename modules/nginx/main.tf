output "user_data_script" {
  value       = filebase64("${path.module}/user_data.sh")

}

