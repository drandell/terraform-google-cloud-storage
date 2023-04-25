SET GOOGLE_APPLICATION_CREDENTIALS=key.json
terraform init 
terraform plan -out plan
terraform apply 