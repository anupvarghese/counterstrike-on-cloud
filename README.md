### Run CS 1.6 server on Azure

### Steps

- Install terraform, azure cli are installed

```
brew install terraform azure-cli
```

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

#### Start

```
terraform init
terraform plan  -var-file="secret.tfvars"
terraform apply  -var-file="secret.tfvars"
```

#### Stop

```
terraform destroy  -var-file="secret.tfvars"
```
