pipeline {
    agent {label  'kubeagentcustom'}

    stages {
        stage('Git checkout') {
            steps {
                script {
                def scmVars = checkout([$class: 'GitSCM', branches: [[name: '*/main']], extensions: [[$class: 'CloneOption', noTags: false, shallow: false, depth: 0, reference: '']], userRemoteConfigs: [[credentialsId: '61598dad-3af2-4217-9c7d-6f1e152edb14', url: 'git@github.com:MaxNelipin/diplom-app.git']]])
                TAG = gitTagName()
                env.GIT_COMMIT = scmVars.GIT_COMMIT
                env.GIT_TAG = TAG
                echo "${env.GIT_TAG}"
                echo "${scmVars.GIT_COMMIT}"
                }

            }
        }
        stage('Build,pull and deploy image') {
            steps {

                script {
                if (env.GIT_TAG == "null" ){
                    container('docker') {
                    withCredentials([file(credentialsId: '3f382b0d-3fe4-4406-b5e1-5268b1215588', variable: 'KEY_GIT')]) {
                        sh "DOCKER_BUILDKIT=1 docker build --ssh github=${KEY_GIT} --build-arg CACHEBUST=\$(date +%s) -t cr.yandex/crpis219qro17q8kksal/nginxapp:${env.GIT_COMMIT} ."
                    }
                    withCredentials([file(credentialsId: 'YC_REGISTRY', variable: 'KEY_YC_REGISTRY')]) {
                        sh "cat ${KEY_YC_REGISTRY} | docker login  --username json_key --password-stdin cr.yandex"
                        sh "docker push cr.yandex/crpis219qro17q8kksal/nginxapp:${env.GIT_COMMIT}"
                    }
                    }


                }else {
                    container('docker') {
                    withCredentials([file(credentialsId: '3f382b0d-3fe4-4406-b5e1-5268b1215588', variable: 'KEY_GIT')]) {
                        sh "DOCKER_BUILDKIT=1 docker build --ssh github=${KEY_GIT} --build-arg CACHEBUST=\$(date +%s) -t cr.yandex/crpis219qro17q8kksal/nginxapp:${env.GIT_TAG} ."
                        }
                    withCredentials([file(credentialsId: 'YC_REGISTRY', variable: 'KEY_YC_REGISTRY')]) {
                        sh "cat ${KEY_YC_REGISTRY} | docker login  --username json_key --password-stdin cr.yandex"
                        sh "docker push cr.yandex/crpis219qro17q8kksal/nginxapp:${env.GIT_TAG}"
                        }
                    }
                    container('jnlp') {
                    withKubeConfig([credentialsId: 'jenkins-admin-stage-cluster-kube', serverUrl: 'https://51.250.76.159']) {
                        env.nameImage = "cr.yandex/crpis219qro17q8kksal/nginxapp:${env.GIT_TAG}"
                        sh 'envsubst < deployment.yaml | kubectl apply -f -'
                        }
                    }
                    }
             }


         }
    }
   }
}


   /** @return The tag name, or `null` if the current commit isn't a tag. */
String gitTagName() {
    commit = getCommit()
    if (commit) {
        desc = sh(script: "git describe --tags ${commit}", returnStdout: true)?.trim()
        echo desc
        if (isTag(desc)) {
            return desc
        }
    }
    return null
}

/** @return The tag message, or `null` if the current commit isn't a tag. */
String gitTagMessage() {
    name = gitTagName()
    msg = sh(script: "git tag -n10000 -l ${name}", returnStdout: true)?.trim()
    if (msg) {
        return msg.substring(name.size()+1, msg.size())
    }
    return null
}

String getCommit() {
    return sh(script: 'git rev-parse HEAD', returnStdout: true)?.trim()
}

@NonCPS
boolean isTag(String desc) {
    match = desc =~ /.+-[0-9]+-g[0-9A-Fa-f]{6,}$/
    result = !match
    match = null // prevent serialisation
    return result
}
