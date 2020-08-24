provider "aws" {
  # region入力不要になる
  region = "ap-northeast-1"
}

# variable はCLIから上書き可能
variable "my_instance_type" {
  default = "t3.micro"
}

# localsを使うとCLIから上書き不可
locals {
  my_local_instance_type = "t3.micro"
}

# resource リソースの種類 リソース名 {} 
# プロバイダーがawsの場合はaws_*
# リソース名は任意の名前
resource "aws_instance" "example" {
  ami = "ami-0f9ae750e8274075b"

  # インスタンスを指定
  # instance_type = "t3.micro"

  # インスタンスに変数を利用
  instance_type = var.my_instance_type

  # インスタンスにローカル変数を利用 (CLIから上書き不可)
  # instance_type = local.my_local_instance_type

  tags = {
    Name = "example"
  }

  user_data = <<EOF
    #!/bin/bash
    yum install -y httpd
    systemctl start httpd.service
  EOF
}
