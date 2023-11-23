variable "buckets" {
  default     = {}
  description = "(Optional) Map of GCS buckets to create"
  type = map(object({
    location = string,
    project  = string,
    cors = optional(set(object({
      max_age_seconds = optional(number),
      method          = optional(list(string)),
      origin          = optional(list(string)),
      response_header = optional(list(string))
    })), []),
    default_event_based_hold        = optional(bool, false),
    enable_autoclass                = optional(bool, false),
    terminal_storage_class          = optional(string, null)
    enable_object_retention         = optional(bool, false),
    enable_versioning               = optional(bool, false),
    force_destroy                   = optional(bool, false),
    custom_placement_data_locations = optional(set(string), []),
    kms_key_name                    = optional(string),
    labels                          = optional(map(string), {}),
    lifecycle_rule = optional(set(object({
      action = object({
        storage_class = optional(string),
        type          = string
      }),
      condition = object({
        age                        = optional(number),
        created_before             = optional(string),
        custom_time_before         = optional(string),
        days_since_custom_time     = optional(number),
        days_since_noncurrent_time = optional(number),
        matches_prefix             = optional(list(string)),
        matches_storage_class      = optional(list(string)),
        matches_suffix             = optional(list(string)),
        noncurrent_time_before     = optional(string),
        num_newer_versions         = optional(number),
        with_state                 = optional(string)
      })
    })), []),
    logging = optional(object({
      log_bucket        = string,
      log_object_prefix = optional(string)
      }),
      {
        log_bucket = null
    }),
    public_access_prevention = optional(string, "inherited"),
    requester_pays           = optional(bool, false),
    retention_policy = optional(object({
      is_locked        = optional(bool, false),
      retention_period = number
      }),
      {
        retention_period = null
    }),
    role_bindings               = optional(map(set(string)), {})
    storage_class               = optional(string, "STANDARD"),
    uniform_bucket_level_access = optional(bool, false),
    website = optional(object({
      main_page_suffix = optional(string),
      not_found_page   = optional(string)
    }))
  }))
}
