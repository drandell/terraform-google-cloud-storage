locals {

  role_bindings_flat = flatten([
    for key, bucket in var.buckets : [
      for role, members in bucket["role_bindings"] : {
        key     = "${key}-${role}"
        bucket  = key
        role    = role
        members = members
      }
    ]
  ])
  role_bindings = { for binding in local.role_bindings_flat : binding["key"] => binding }
}

resource "google_storage_bucket" "this" {
  for_each = var.buckets

  name                        = each.key
  location                    = each.value["location"]
  project                     = each.value["project"]
  default_event_based_hold    = each.value["default_event_based_hold"]
  force_destroy               = each.value["force_destroy"]
  public_access_prevention    = each.value["public_access_prevention"]
  requester_pays              = each.value["requester_pays"]
  storage_class               = upper(each.value["storage_class"])
  uniform_bucket_level_access = each.value["uniform_bucket_level_access"]
  labels                      = each.value["labels"]

  autoclass {
    enabled = each.value["enable_autoclass"]
  }

  versioning {
    enabled = each.value["enable_versioning"]
  }

  dynamic "cors" {
    for_each = each.value["cors"]

    content {
      max_age_seconds = cors.value["max_age_seconds"]
      method          = cors.value["method"]
      origin          = cors.value["origin"]
      response_header = cors.value["response_header"]
    }
  }

  dynamic "custom_placement_config" {
    for_each = length(each.value["custom_placement_data_locations"]) >= 2 ? [each.value["custom_placement_data_locations"]] : []

    content {
      data_locations = custom_placement_config.value[0]
    }
  }

  dynamic "encryption" {
    for_each = each.value["kms_key_name"] != null ? [each.value["kms_key_name"]] : []

    content {
      default_kms_key_name = encryption.value[0]
    }
  }

  dynamic "logging" {
    for_each = each.value["logging"]["log_bucket"] != null ? [each.value["logging"]] : []

    content {
      log_bucket        = logging.value["log_bucket"]
      log_object_prefix = logging.value["log_object_prefix"]
    }
  }

  dynamic "lifecycle_rule" {
    for_each = each.value["lifecycle_rule"]

    content {

      action {
        type          = lifecycle_rule.value["action"]["type"]
        storage_class = lifecycle_rule.value["action"]["storage_class"]
      }

      condition {
        age                        = lifecycle_rule.value["condition"]["age"]
        created_before             = lifecycle_rule.value["condition"]["created_before"]
        with_state                 = lifecycle_rule.value["condition"]["with_state"] != null ? upper(lifecycle_rule.value["condition"]["with_state"]) : null
        matches_storage_class      = [for storage_class in coalesce(lifecycle_rule.value["condition"]["matches_storage_class"], []) : upper(storage_class)]
        matches_prefix             = lifecycle_rule.value["condition"]["matches_prefix"]
        matches_suffix             = lifecycle_rule.value["condition"]["matches_suffix"]
        num_newer_versions         = lifecycle_rule.value["condition"]["num_newer_versions"]
        custom_time_before         = lifecycle_rule.value["condition"]["custom_time_before"]
        days_since_custom_time     = lifecycle_rule.value["condition"]["days_since_custom_time"]
        days_since_noncurrent_time = lifecycle_rule.value["condition"]["days_since_noncurrent_time"]
        noncurrent_time_before     = lifecycle_rule.value["condition"]["noncurrent_time_before"]
      }
    }
  }

  dynamic "retention_policy" {
    for_each = each.value["retention_policy"]["retention_period"] != null ? [each.value["retention_policy"]] : []

    content {
      is_locked        = retention_policy.value["is_locked"]
      retention_period = retention_policy.value["retention_period"]
    }
  }

  dynamic "website" {
    for_each = each.value["website"] != null ? [each.value["website"]] : []

    content {
      main_page_suffix = website.value["main_page_suffix"]
      not_found_page   = website.value["not_found_page"]
    }
  }
}

resource "google_storage_bucket_iam_binding" "this" {
  for_each = local.role_bindings

  bucket  = google_storage_bucket.this[each.value["bucket"]].name
  role    = each.value["role"]
  members = each.value["members"]
}
