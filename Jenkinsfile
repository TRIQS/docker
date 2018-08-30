properties([
  disableConcurrentBuilds(),
  buildDiscarder(logRotator(numToKeepStr: '10', daysToKeepStr: '30'))
])

def platforms = [:]

def packagePlatforms = ["xenial", "bionic"]
for (int i = 0; i < packagePlatforms.size(); i++) {
  def platform = packagePlatforms[i]
  platforms["package-$platform"] = { -> node('docker') {
    stage("package-$platform") { timeout(time: 1, unit: 'HOURS') {
      checkout scm
      sh 'git submodule foreach git fetch --tags'
      withCredentials([file(credentialsId: 'gpg-sign-key', variable: 'SECRET')]) {
	sh 'cp $SECRET secret.gpg'
      }
      def img = docker.build("flatironinstitute/triqs-package-$platform:${env.BRANCH_NAME}", "-f Dockerfile.package-$platform .")
      img.inside('-v /etc/passwd:/etc/passwd -v /etc/group:/etc/group') {
	sh """#!/bin/bash -ex
	  mkdir test/triqs/run
	  cd test/triqs/run
	  cmake ..
	  make -j2
	  make test
	"""
	sh "tar czf ${platform}.tgz -C \$REPO ."
      }
      sh "docker rmi --no-prune ${img.imageName()}"
      archiveArtifacts(artifacts: "${platform}.tgz")
    } }
  } }
}

try {
  parallel platforms
} catch (err) {
  emailext(
    subject: "\$PROJECT_NAME - Build # \$BUILD_NUMBER - FAILED",
    body: """\$PROJECT_NAME - Build # \$BUILD_NUMBER - FAILED

$err

Check console output at \$BUILD_URL to view full results.

Building \$BRANCH_NAME for \$CAUSE
\$JOB_DESCRIPTION

Chages:
\$CHANGES

End of build log:
\${BUILD_LOG,maxLines=60}
    """,
    to: 'nwentzell@flatironinstitute.org, dsimon@flatironinstitute.org',
    recipientProviders: [
    ],
    replyTo: '$DEFAULT_REPLYTO'
  )
  throw err
}
