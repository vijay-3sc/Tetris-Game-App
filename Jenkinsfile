pipeline{
    agent any
    environment{
        ACR_AUTH = credentials('acr_creds')
        ACR_LOGIN_SERVER = 'vijay.azurecr.io'
        REGISTRY_NAME = 'vijay'
        REPO_NAME = 'tetris'
    }
    stages{
        stage('git checkout'){
            steps{
                checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/vijay-3sc/Tetris-Game-App.git']])
            }
        }
        stage('build docker image'){
            steps{
                sh 'docker buildx prune --force'
                sh 'docker build -t ${ACR_LOGIN_SERVER}/${REPO_NAME}:$BUILD_NUMBER .'
            }
        }
        stage('push image'){
            steps{
                withCredentials([usernamePassword(credentialsId: 'acr_creds', passwordVariable: 'password', usernameVariable: 'username')]) {
                sh 'docker login -u ${username} -p ${password} ${ACR_LOGIN_SERVER}'
                sh 'docker push ${ACR_LOGIN_SERVER}/${REPO_NAME}:$BUILD_NUMBER'
                }
            }
        }
        stage('install Azure CLI'){
            steps{
                sh 'sudo apt install curl'
                sh 'curl -sL https://aka.ms/InstallAzureCli | bash'
                sh 'sudo apt install py3-pip'
                sh 'sudo apt install gcc musl-dev python3-dev libffi-dev openssl-dev cargo make'
                sh 'sudo apt pip install --upgrade pip'
                sh 'sudo apt pip install azure-cli'
            }
        }
        stage('deploy web app'){
            steps{
                withCredentials([azureServicePrincipal('acrprincipal')]) {
                sh 'az login --service-principal -u ${AZURE_CLIENT_ID} -p ${AZURE_CLIENT_SECRET} --tenant ${AZURE_TENANT_ID}'
                }
                withCredentials([usernamePassword(credentialsId: 'acr_creds', passwordVariable: 'password', usernameVariable: 'username')]) {
                sh 'az webapp config container set --name tetris-game --resource-group payment --docker-custom-image-name ${ACR_LOGIN_SERVER}/${REPO_NAME}:$BUILD_NUMBER --docker-registry-server-url https://{ACR_LOGIN_SERVER} --docker-registry-server-user ${username} --docker-registry-server-password ${password}'
                }
            }
        }
    }
}
