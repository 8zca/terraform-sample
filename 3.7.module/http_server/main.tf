variable instance_type {
}

resource aws_security_group default {
  name = "ec2"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource aws_instance default {
  ami = "ami-0f9ae750e8274075b"
  vpc_security_group_ids = [aws_security_group.default.id]
  instance_type = var.instance_type

  tags = {
    Name = "example"
  }

  user_data = <<EOF
    #!/bin/bash
    yum install -y httpd
    systemctl start httpd.service
  EOF
}

# public_dnsという名前で作成されたinstanceのpublic_dnsを出力
output public_dns {
  value = aws_instance.default.public_dns
}