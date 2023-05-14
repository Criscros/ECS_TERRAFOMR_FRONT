variable "cluster_name" {
  type        = string
  description = "(Optional) - The name of the cluster if the cluster does not exist"
}
variable "container_definitions" {
}
variable "task_family" {}
variable "execution_role_arn" {}
variable "task_role_arn" {}
variable "subnets" {}
variable "security_groups" {}
