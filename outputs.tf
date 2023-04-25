output "ids" {
  description = "Map of bucket IDs"
  value       = { for key, bucket in google_storage_bucket.this : key => bucket["id"] }
}

output "urls" {
  description = "Map of bucket URLs"
  value       = { for key, bucket in google_storage_bucket.this : key => bucket["url"] }
}
