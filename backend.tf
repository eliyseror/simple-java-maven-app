terraform {
  backend "s3" {
    bucket = "eli-bucket-github"
    key    = "path/to/my/key"
    region = "us-west-2"
  }
}
