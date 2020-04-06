package terraform

import input.tfplan as tfplan

allowed_platforms = ["aws", "azurerm", "google"]


allowed_instance_types = {
    "aws": ["t1.micro", "t1.small", "t2.nano", "t2.small","t3.nano"],
    "google": ["f1-micro","g1-small", "n1-standard-1", "n1-standard-2"],
    "azurerm": ["Basic_A0", "Basic_A1", "Basic_A2", "Standard_D1_v2", "Standard_DS1_v2", "Standard_DS2_v2"]
}

res := tfplan.resource_changes

resources := [r | r = res[_]; allowed_platforms[_] == r.provider_name]


contains(arr, elem) {
  arr[_] = elem
}


# Check instance types

#Azure
deny[msg] {
    r = res[_]
    r.provider_name == "azurerm"
    instance_types = allowed_instance_types[r.provider_name]
    not contains(instance_types, r.change.after.vm_size)
    msg := sprintf("Instance type '%s' is not allowed on cloud '%s'",
                    [r.change.after.vm_size, r.provider_name])
}

#EC2
deny[msg] {
    r = res[_]
    r.provider_name == "aws"
    instance_types = allowed_instance_types[r.provider_name]
    not contains(instance_types, r.change.after.instance_type)
    msg := sprintf("Instance type '%s' is not allowed on cloud '%s'",
                    [r.change.after.instance_type, r.provider_name])
}

#GCE
deny[msg] {
    r = res[_]
    r.provider_name == "google"
    instance_types = allowed_instance_types[r.provider_name]
    not contains(instance_types, r.change.after.machine_type)
    msg := sprintf("Instance type '%s' is not allowed on cloud '%s'",
                    [r.change.after.machine_type, r.provider_name])
}
