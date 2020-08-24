provider "aws" {
  # region入力不要になる
  region = "ap-northeast-1"
  profile = "8zca"
}

module dev_server {
  source = "./http_server"
  instance_type = "t3.micro"
}

# module側でoutputされたpublic_dnsを標準出力する
output public_dns {
  value = module.dev_server.public_dns
}