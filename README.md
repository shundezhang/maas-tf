# maas-tf

```
ansible-playbook -i inventories/lenovo/hosts laptop.yaml -u shunde 

ansible-playbook -i inventories/testflinger/hosts testflinger.yaml -u ubuntu
```

copy tf files only:
```
ansible-playbook -i inventories/testflinger/hosts testflinger.yaml -u ubuntu --tags copy_tf_scripts
```

Sunbeam:
```
export TF_VAR_maas_api_key="$(lxc exec maas --project maas-repro -- maas apikey --username admin)"
terraform apply
```