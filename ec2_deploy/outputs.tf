output "instance_data" {
    value = aws_instance.first_ec2
    description = "Details about deployed ec2 instance"
}

output "ami_data" {
    value = {
        name = data.aws_ami.amazon_ami.name,
        id = data.aws_ami.amazon_ami.id
    }
}