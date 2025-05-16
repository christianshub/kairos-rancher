# Kairos Rancher structure

## TODO

- Check whats inside the PostgreSQL database
- deploy rancher on it

## Structure

- `builder/` creates kairos images
- `provisioner/` creates kairos ready VMs

## Run

```bash
terraform init -upgrade
terraform apply -parallelism=1 -lock=false
```
