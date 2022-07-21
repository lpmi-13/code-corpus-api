output "instance_public_ip" {
  description = "Public IP address of the bastion host"
  value       = aws_instance.bastion-host.public_ip
}
