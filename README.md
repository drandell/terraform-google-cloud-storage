## Google Storage Buckets Module

A modern GCS Terraform module.
If you require a GCS module that supports a terraform version < 1.3.0 than i suggest using the official [terraform-google-cloud-storage](https://github.com/terraform-google-modules/terraform-google-cloud-storage) module.

<!-- BEGIN_TF_DOCS -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_buckets"></a> [buckets](#input\_buckets) | (Optional) Map of GCS buckets to create | <pre>map(object({<br>    location = string,<br>    project  = string,<br>    cors = optional(set(object({<br>      max_age_seconds = optional(number),<br>      method          = optional(list(string)),<br>      origin          = optional(list(string)),<br>      response_header = optional(list(string))<br>    })), [])<br>    default_event_based_hold        = optional(bool, false)<br>    enable_autoclass                = optional(bool, false),<br>    enable_versioning               = optional(bool, false),<br>    force_destroy                   = optional(bool, false),<br>    custom_placement_data_locations = optional(set(string), []),<br>    kms_key_name                    = optional(string),<br>    labels                          = optional(map(string), {}),<br>    lifecycle_rule = optional(set(object({<br>      action = object({<br>        storage_class = optional(string),<br>        type          = string<br>      }),<br>      condition = object({<br>        age                        = optional(number),<br>        created_before             = optional(string),<br>        custom_time_before         = optional(string),<br>        days_since_custom_time     = optional(number),<br>        days_since_noncurrent_time = optional(number),<br>        matches_prefix             = optional(list(string)),<br>        matches_storage_class      = optional(list(string)),<br>        matches_suffix             = optional(list(string)),<br>        noncurrent_time_before     = optional(string),<br>        num_newer_versions         = optional(number),<br>        with_state                 = optional(string)<br>      })<br>    })), []),<br>    logging = optional(object({<br>      log_bucket        = string,<br>      log_object_prefix = optional(string)<br>      }),<br>      {<br>        log_bucket = null<br>    }),<br>    public_access_prevention = optional(string, "inherited"),<br>    requester_pays           = optional(bool, false),<br>    retention_policy = optional(object({<br>      is_locked        = optional(bool, false),<br>      retention_period = number<br>      }),<br>      {<br>        retention_period = null<br>    }),<br>    role_bindings               = optional(map(set(string)), {})<br>    storage_class               = optional(string, "STANDARD"),<br>    uniform_bucket_level_access = optional(bool, false),<br>    website = optional(object({<br>      main_page_suffix = optional(string),<br>      not_found_page   = optional(string)<br>    }))<br>  }))</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ids"></a> [ids](#output\_ids) | Map of bucket IDs |
| <a name="output_urls"></a> [urls](#output\_urls) | Map of bucket URLs |

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0, < 2.0.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 4.0.0, < 6.0.0 |
<!-- END_TF_DOCS -->

### Service Account

A service account with the following roles must be used to provision the resources of this module:

* Storage Admin: `roles/storage.admin`

### APIs

A project with the following APIs enabled must be used to host the resources of this module:

Cloud Storage API: `storage.googleapis.com`
