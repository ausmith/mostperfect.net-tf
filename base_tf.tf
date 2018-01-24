data "terraform_remote_state" "base" {
  backend = "s3"

  config {
    bucket = "mostperfect-tf-state"
    key    = "mostperfect-net-state-prod"
    region = "us-east-1"
  }
}
