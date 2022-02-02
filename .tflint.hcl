config {
  varfile = ["examples/test.tfvars"]
}

rule "terraform_unused_declarations" {
  enabled = true
}