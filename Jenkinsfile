pipeline {
    agent {
        label 'terraform'
    }
    tools {
         "org.jenkinsci.plugins.terraform.TerraformInstallation" "myterraform"
    }
    parameters {
        string(name: 'WORKSPACE', defaultValue: 'development', description: 'setting up workspace')
    }
    environment {
        TF_HOME = tool('terraform')
        TF_LOG = "WARN"
        PATH = "$TF_HOME:$PATH"

    }
    stages{
        stage('terraform init') {
            steps {
                dir('/home/jenkinsuser/terraform/') {
                    sh "terraform init -input=false"
                    sh "echo \$PWD"
                    sh "whoami"
                    
                }
            }
        }
        stage('terraform format') {
            steps{
                dir('/home/jenkinsuser/terraform/') {
                    sh "terraform fmt -list=false -write=false -diff=true -check=true"
                }
            }
        }
        stage('terraformPlan') {
            steps {
                dir('/home/jenkinsuser/terraform/') {
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
        stage('terraformApply') { 
            steps { 
                script {
                    def apply = false
                    try {
                        input message: 'Can you please confirm the apply', ok: 'Ready to Apply the Config'
                        apply = true
                    }catch (err) { 
                        apply = false 
                        currentBuild.result = 'UNSTABLE'
                    }
                    if(apply) {
                        dir('jenkins-terraform-pipeline/ec2_pipeline/'){
                            unstash "terraform-plan"
                            sh 'terraform apply terraform.tfplan'
                    }
                }
            }
        }

    }
}
}

