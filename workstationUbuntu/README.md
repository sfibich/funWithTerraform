# Examples 1:
The following would prompt to approve the plan and use the default password provided in the variables file.  This is not recommended as the password is exposed in this repository.

`
terraform apply
`
# Examples 2:
The following would automatically approve the plan and use the password N3wP@ssw0rd inplace of the default password provided in the variables file.

`
terraform apply --auto-approve -var="password=N3wP@ssw0rd"
`
