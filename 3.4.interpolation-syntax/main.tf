provider "aws" {
  # region入力不要になる
  region = "ap-northeast-1"

  # profile
  profile = "8zca"
}

# variable はCLIから上書き可能
variable "my_instance_type" {
  default = "t3.micro"
}

# localsを使うとCLIから上書き不可
locals {
  my_local_instance_type = "t3.micro"
}

# セキュリティグループ
resource "aws_security_group" "example_ec2" {
  name = "example-ec2-sg"

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

# テンプレートの定義
data template_file httpd_user_data {
  template = file("./user_data.sh.tpl")

  vars = {
    package = "httpd"
  }
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

  # security-group
  vpc_security_group_ids = [aws_security_group.example_ec2.id]

  tags = {
    Name = "example"
  }

  # httpdを通常通り使うパターン
  # user_data = file("./user_data.sh")

  # テンプレートを使うパターン
  user_data = data.template_file.httpd_user_data.rendered
}
