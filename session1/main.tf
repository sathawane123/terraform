resource "aws_iam_user" "one" {
  name = "Demo_user1"
  tags = {
    Name = "shubhamsath"
    purpose = "tettaform user creation"
    enddate = "07/02/2022"
  }
}

resource "aws_iam_user" "two" {
  name = "Demo_user2"
  tags = {
    Name = "shubhamsath"
    purpose = "tettaform user creation"
    enddate = "07/02/2022"
  }
}


resource "aws_iam_user" "three" {
  name = "Demo_user3"
  tags = {
    Name = "shubhamsath"
    purpose = "tettaform user creation"
    enddate = "07/02/2022"
  }
}

resource "aws_iam_group_membership" "Dev" {
  name = "member"

  users = [
    aws_iam_user.one.name,
    aws_iam_user.two.name,
    aws_iam_user.three.name
  ]

  group = aws_iam_group.trainee.name
}

resource "aws_iam_group" "trainee" {
  name = "test-group"
}

resource "aws_s3_bucket" "b" {
  bucket = "terraform-shubham-bucket31"

 tags = {
   Name        = "tf bucket"
    Environment = "Dev"
  }
}