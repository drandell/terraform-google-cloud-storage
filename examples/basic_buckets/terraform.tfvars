buckets = {
  "my-awesome-bucket-adfgth" : {
    project  = "billing-budgets"
    location = "us-west1",
    lifecycle_rule : [
      {
        condition : {
          age = 1
        }
        action : {
          type = "AbortIncompleteMultipartUpload"
        }
      },
      {
        condition : {
          age = 3
        }
        action : {
          type = "Delete"
        }
      }
    ]
  },
  "my-awesome-website-tyyughgft" : {
    project  = "billing-budgets"
    location = "us-west1"
    website : {
      main_page_suffix = "/"
    }
    role_bindings : {
      "roles/storage.admin" : [
        "user:danielrandell@outlook.com"
      ]
    }
  }
}