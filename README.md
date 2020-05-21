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

#### Start

```
terraform plan
terraform apply
```

#### Stop

```
terraform destroy
```
