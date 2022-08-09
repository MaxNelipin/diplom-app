pipeline {
    agent {label  'master'}

    stages {
        stage('Git checkout') {
            steps {
                script {
                def scmVars = checkout([$class: 'GitSCM', branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[credentialsId: '61598dad-3af2-4217-9c7d-6f1e152edb14', url: 'git@github.com:MaxNelipin/diplom-app.git']]])
                env.GIT_COMMIT = scmVars.GIT_COMMIT
                env.GIT_TAG = scmVars.GIT_TAG
                echo "${scmVars.GIT_TAG}"
                echo "${scmVars.GIT_COMMIT}"
                }

            }
        }
        stage('Build image') {
            steps {
                script {
                if (env.GIT_TAG == "null" ){
                    withCredentials([file(credentialsId: '3f382b0d-3fe4-4406-b5e1-5268b1215588', variable: 'KEY_GIT')]) {
                    sh "DOCKER_BUILDKIT=1 docker build --ssh github=${KEY_GIT} -t cr.yandex/crpis219qro17q8kksal/nginxapp:${env.GIT_COMMIT} ."
                     }
                }else {
                    withCredentials([file(credentialsId: '3f382b0d-3fe4-4406-b5e1-5268b1215588', variable: 'KEY_GIT')]) {
                    sh "DOCKER_BUILDKIT=1 docker build --ssh github=${KEY_GIT} -t cr.yandex/crpis219qro17q8kksal/nginxapp:${env.GIT_TAG} ."
                    }
                    withCredentials([file(credentialsId: 'YC_REGISTRY', variable: 'KEY_YC_REGISTRY')]) {
                    sh "cat ${KEY_YC_REGISTRY} | docker login  --username json_key --password-stdin cr.yandex"
                    sh "docker push cr.yandex/crpis219qro17q8kksal/nginxapp:${env.GIT_TAG}"
                    }



            }
            }
        }

        }
    }
}