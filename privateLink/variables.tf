variable "target_subscription_id" {
  type = string
  description = "The Azure Target Subscription Id resources will be created in. (Provided at run time or in TF_VAR_target_subscription_id enviorment variable)"

  validation {
    condition = length(var.target_subscription_id) == 36
    error_message = "The target_subscription_id does not match the length requirement."
  }
}

