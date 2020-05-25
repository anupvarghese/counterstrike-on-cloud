### Run CS 1.6 server on Azure/AWS

### Steps

- Install terraform, azure cli/awscli are installed

```
brew install terraform azure-cli awscli
```

#### Azure 

- Login to Azure

```
az login
```

- Get subscription id

```
az account list
```

- Provision a service principal for CLI access

```
az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/<subscription-id>"
```

#### Secrets

Keep the secrets in `secret.tfvars` as 

```terraform
region = "eastasia"
subscription_id = "your subsciption id"
client_id       = "your client id"
tenant_id       = "your tenant id"
```


#### AWS 

Create secret key and access key add that in secrets

#### Secrets

Keep the secrets in `secret.tfvars` as 

```terraform
access_key = "your access key"
secret_key = "your secret key"
region       = "ap-southeast-1"
instance_type       = "t3.micro"
availability_zone = "ap-southeast-1a"
# check if the AMI is available in the region
instance_ami = "ami-01c54eee4ab8725c0"
```


#### Start (from aws/azure folder)

```
terraform init
terraform plan  -var-file="secret.tfvars"
terraform apply  -var-file="secret.tfvars"
```

#### Stop

```
terraform destroy  -var-file="secret.tfvars"
```

