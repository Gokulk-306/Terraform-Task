output "us_east_1_public_ip" {
  value = aws_instance.web_us_east_1.public_ip
}

output "us_east_2_public_ip" {
  value = aws_instance.web_us_east_2.public_ip
}
