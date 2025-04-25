resource "null_resource" "Code_IAC-github-repo" {
  provisioner "local-exec" {
    #command = "cd ../Code_IAC_Jenkins_Trivy_Docker && terraform init && terraform apply -auto-approve"
    command = "cd 00.Code_IAC-github-repo && terraform init && terraform apply -auto-approve"
  }
}

resource "null_resource" "Code_IAC_Selfhosted-Runner-and-Trivy" {
  provisioner "local-exec" {
    #command = "cd ../Code_IAC_Jenkins_Trivy_Docker && terraform init && terraform apply -auto-approve"
    command = "cd 01.Code_IAC_Selfhosted-Runner-and-Trivy && terraform init && terraform apply -auto-approve"
  }
  depends_on = [null_resource.Code_IAC-github-repo]
}

resource "null_resource" "Code_IAC_SonarQube" {
  provisioner "local-exec" {
    #command = "cd ../Code_IAC_Splunk && terraform init && terraform apply -auto-approve"
    command = "cd 02.Code_IAC_SonarQube && terraform init && terraform apply -auto-approve"
  }
  depends_on = [null_resource.Code_IAC_Selfhosted-Runner-and-Trivy]
}

resource "null_resource" "Code_IAC_Terraform_box" {
  provisioner "local-exec" {
    #command = "cd ../Code_IAC_Splunk && terraform init && terraform apply -auto-approve"
    command = "cd 03.Code_IAC_Terraform_box && terraform init && terraform apply -auto-approve"
  }
  depends_on = [null_resource.Code_IAC_SonarQube]
}
