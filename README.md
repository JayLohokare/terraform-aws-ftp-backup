# Automated data transfer from SFTP to AWS S3

move-ftp-files-to-s3<br>
Contains the NodeJS Lambda code for transfering the data

provision<br>
Contains the Terraform code (AWS Lambda + Cloud-watch + S3)

Change SFTP credentials and AWS access credentials (terraform.tfvars) to make the code run


```
$ cd move-ftp-files-to-s3
$ npm run build:for:deployment
$ cd dist
$ zip -r Lambda-Deployment.zip . ../node_modules/
```
<br>
```
$ cd ../../provision
$ terraform init
$ terraform apply
```
