pipeline {
    agent {
        label 'terraform' 
    }
    tools {
        "org.jenkinsci.plugins.terraform.TerraformInstallation" "myterraform"
    }
    parameters {
        string(name: 'WORKSPACE', defaultValue: 'development', description:'setting up workspace for terraform')
    }
    environment {
        TF_HOME = tool('myterraform')
        TF_LOG = "WARN"
        PATH = "$TF_HOME:$PATH"
    }
    stages {
            stage('TerraformInit'){
            steps {
                dir('/home/jenkinsuser/terraform/'){
                    sh "terraform init -input=false"
                    sh "echo \$PWD"
                    sh "whoami"
                }
            }
        }
        stage('TerraformValidate'){
            steps {
                dir('/home/jenkinsuser/terraform/'){
                    sh "terraform validate"
                }
            }
        }
        stage('TerraformFormat') {
            dir(''/home/jenkinsuser/terraform/') {
            sh "terraform fmt" 
          }
                }
                }
        stage('TerraformPlan'){
            steps {
                dir(){
                    script {
                        try {
                            sh "terraform workspace new ${params.WORKSPACE}"
                        } catch (err) {
                            sh "terraform workspace select ${params.WORKSPACE}"
                        }
                        sh "terraform plan -out terraform.tfplan;echo \$? > status"
                        stash name: "terraform-plan", includes: "terraform.tfplan"
                    }
                }
            }
        }
        
        stage('TerraformApply'){
            steps {
                script{
                    def apply = false
                    try {
                        input message: 'Can you please confirm the apply', ok: 'Ready to Apply the Config'
                        apply = true
                    } catch (err) {
                        apply = false
                         currentBuild.result = 'UNSTABLE'
                    }
                    if(apply){
                        dir('/home/jenkinsuser/terraform/'){
                            unstash "terraform-plan"
                            sh 'terraform apply terraform.tfplan' 
                        }
                    }
                }
            }
        }
    }
}
