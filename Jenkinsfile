properties([
  disableConcurrentBuilds(),
  buildDiscarder(logRotator(numToKeepStr: '10', daysToKeepStr: '30')),
  pipelineTriggers([
    upstream(
      threshold: 'SUCCESS',
      upstreamProjects: triqsProject
    )
  ])
])

node('docker') {
  stage("debian-package") { timeout(time: 1, unit: 'HOURS') {
    checkout scm
    withCredentials([file(credentialsId: 'gpg-sign-key', variable: 'SECRET')]) {
      sh 'cp $SECRET secret.gpg'
    }
    def img = docker.build("flatironinstitute/triqs-debian-package:${env.BRANCH_NAME}", "-f Dockerfile.debian-package .")
    img.inside {
      sh 'tar czf debrepo.tgz -C $REPO .'
    }
    sh "docker rmi --no-prune ${img.imageName()}"
    archiveArtifacts(artifacts: 'debrepo.tgz')
  } }
}
