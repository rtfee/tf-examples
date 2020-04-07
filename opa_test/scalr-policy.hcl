  
version = "v1"

policy "resource" {
    enabled = true
    enforcement_level = "hard-mandatory"
}

policy "instance_types" {
    enabled = true
    enforcement_level = "hard-mandatory"
}

policy "enfore_ami_owners" {
    enabled = true
    enforcement_level = "advisory"
}
