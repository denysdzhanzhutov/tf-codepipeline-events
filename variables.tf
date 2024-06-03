variable "aws_region" {
  type        = string
  description = "AWS region where resources will be provisioned"
  default     = "us-east-1" # Replace with your desired default region
}

# ----------------------------------------------------------------
# ---------------------- AWS Resource Tags -----------------------
# ----------------------------------------------------------------


# variable "ssh_allowed_ip" {
#   type    = string
#   default = "0.0.0.0/0"
# }



# ----------------------------------------------------------------
# ---------------------- AWS Resource Tags -----------------------
# ----------------------------------------------------------------



variable "project_name" {
  type    = string
  default = "Requip"
}

variable "environment" {
  type    = string
  default = "Production"
}

variable "account_id" {
  type    = string
  default = "201633445759"
}

# ----------------------------------------------------------------
# --------------- AWS PARAMETER STORE VARIABLES ------------------
# ----------------------------------------------------------------

variable "parameter_store_name" {
  type        = string
  description = "Name of the AWS SSM Parameter Store"
  default     = "/project/be"
}

# ----------------------------------------------------------------
# --------------- AWS CodePipeline VARIABLES ---------------------
# ----------------------------------------------------------------

variable "FullRepositoryId" {
  type        = string
  description = "Repository used in code pipeline"
  default     = "denysdzhanzhutov/codepipeline"
}

variable "BranchName" {
  type        = string
  description = "Select branch from repository "
  default     = "main"
}

variable "s3BucketNameForArtifacts" {
  type        = string
  description = "S3 bucket to store the source code artifacts"
  default     = "example-artifact-bucket-743gf783gf4379yf4389hf3"
}

variable "CodeStarConnectionArn" {
  type        = string
  description = "Existing connection of github/bitbucket with AWS Coestart"
  default     = "arn:aws:codestar-connections:us-east-1:201633445759:connection/2625c888-aefc-466f-a1fa-c03bd81a8392"
}
