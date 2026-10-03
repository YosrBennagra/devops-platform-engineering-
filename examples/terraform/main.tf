terraform {
  required_version = ">= 1.6.0"

  # Shared/production usage should configure a protected remote backend.
  # Never commit local state files.
}

variable "environment" {
  type        = string
  description = "Environment identity such as dev, staging or prod."

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "environment must be dev, staging or prod."
  }
}

locals {
  common_tags = {
    environment = var.environment
    owner       = "platform"
    managed_by  = "terraform"
  }
}

# Add provider-specific resources only after defining:
# - state boundary;
# - account/project and region;
# - identity;
# - network ownership;
# - failure domain;
# - destroy/replacement behavior.
