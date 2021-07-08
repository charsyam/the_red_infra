variable "region" {
  description = "region"
  default     = "ap-northeast-2"
}

variable "vpc_cidr_block" {
  default = "172.31.0.0/16"
}

variable "use_default" {
  default = true
}

variable "ami" {
  description = "AMI that will be used for the instance"
  default     = "ami-04876f29fd3a5e8ba"
}

variable "num" {
  description = "How many instances should be created"
  default     = 1
}

variable "availability_zone" {
  default     = "ap-northeast-2a"
}

variable "instance_type" {
  description = "Instance Type"
  default     = "t3a.small"
}

variable "root_volume_size" {
  description = "Specify the root volume size"
  default     = "30"
}

variable "root_volume_type" {
  description = "Specify the root volume type. Masters MUST have at least gp2"
  default     = "gp3"
}

variable "extra_volumes" {
  description = "Extra volumes for each instance"
  default     = []
}

variable "security_group_ids" {
  description = "Firewall IDs to use for these instances"
  type        = list
  default     = ["sg-07a2c68872e0cfc9f"]
}

variable "iam_instance_profile" {
  description = "The instance profile to be used for these instances"
  default     = ""
}

variable "associate_public_ip_address" {
  description = "Associate a public IP address with the instances"
  default     = true
}

// TODO: Maybe use a list instead and provision keys through cloudinit
variable "key_name" {
  description = "The SSH key to use for these instances."
  default = "charsyam"
}

variable "hostname_format" {
  description = "Format the hostname inputs are index+1, region, cluster_name"
  default     = "%[3]s-instance%[1]d-%[2]s"
}

variable "extra_volume_name_format" {
  description = "Printf style format for naming the extra volumes. Inputs are cluster_name and instance ID."
  default     = "extra-volumes-%s-%s"
}
