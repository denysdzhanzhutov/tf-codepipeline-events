resource "aws_sns_topic" "codepipeline-topic" {
  name = "codepipeline-topic"
}

resource "aws_sns_topic_subscription" "target" {
  for_each  = toset(["denys.dzhanzhutov@gmail.com"])
  topic_arn = aws_sns_topic.codepipeline-topic.arn
  protocol  = "email"
  endpoint  = each.value
}

resource "aws_cloudwatch_event_rule" "codepipeline-event-rule" {
  name        = "codepipeline-event-rule"

  event_pattern = jsonencode({
    "source": ["aws.codepipeline"],
    "detail-type": ["CodePipeline Stage Execution State Change"]
  })
}

resource "aws_cloudwatch_event_target" "sns" {
  rule      = aws_cloudwatch_event_rule.codepipeline-event-rule.name
  target_id = "SendToSNS"
  arn       = aws_sns_topic.codepipeline-topic.arn
}

resource "aws_sns_topic_policy" "default" {
  arn    = aws_sns_topic.codepipeline-topic.arn
  policy = data.aws_iam_policy_document.sns_topic_policy.json
}

data "aws_iam_policy_document" "sns_topic_policy" {
  statement {
    effect  = "Allow"
    actions = ["SNS:Publish"]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }

    resources = [aws_sns_topic.codepipeline-topic.arn]
  }
}




provider "aws" {
  region = var.aws_region
}

locals {
  common_tags = {
    Project_Name = var.project_name
    Environment  = var.environment
    Account_ID   = var.account_id
    Region       = var.aws_region
  }
}

module "ec2_instance_module" {
  source         = "./module/ec2_instance_module"
  ami            = "ami-0a3c3a20c09d6f377" # ami: aws linux machine
  instance_type  = "t2.micro"
  instance_name  = "production_instance"
  tags           = local.common_tags
}

module "parameter_store_module" {
  source               = "./module/parameter_store_module"
  parameter_store_name = var.parameter_store_name
  tags                 = local.common_tags
}

module "code_pipeline_module" {
  source                   = "./module/code_pipeline_module"
  instance_name            = module.ec2_instance_module.instance_details.instance_name
  FullRepositoryId         = var.FullRepositoryId
  BranchName               = var.BranchName
  CodeStarConnectionArn    = var.CodeStarConnectionArn
  s3BucketNameForArtifacts = var.s3BucketNameForArtifacts
  tags                     = local.common_tags
}




# ----------------------------------------------------------------
# ---------------------- OUTPUT SECTION --------------------------
# ----------------------------------------------------------------


output "parameter_store_name" {
  value = module.parameter_store_module.parameter_store_name
}
output "module_ec2_instance_details" {
  value = module.ec2_instance_module.instance_details
}
output "ec2_instance_ssh_details" {
  value = "ssh -i d:/work/key/aws.pem ec2-user@${module.ec2_instance_module.instance_details.public_dns}"
}
