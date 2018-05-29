node {

def mvnHome 

//Checking out from git
   stage('Code Checkout') {
      git url: 'https://github.com/dariniv/spring.git', branch: 'development'
      mvnHome = tool 'mvn-3.5.2'
   }

// Compiling and building projects
   stage('Compile & Build') {
     sh "${mvnHome}/bin/mvn clean install -DskipTests"
     stash 'working-copy'
}

// Unit testing and results
  stage ('Tests & Results')
  parallel one: {
        unstash 'working-copy'
        sh "${mvnHome}/bin/mvn test -Diterations=1"
        junit '**/target/surefire-reports/TEST-*.xml'
    }


// Sonarqube analysis
   stage('SonarQube analysis') {
     script {
        env.SONARID = readFile '/usr/src/test.txt'
          }
       sh  "/var/lib/jenkins/plugins/sonar/sonar-runner -Dsonar.host.url=https://sonarcloud.io -Dsonar.projectKey=greyam -Dsonar.sources=spring-petclinic-common/src/test/java -Dsonar.organization=greyamp  -Dsonar.login=${env.SONARID}"
  }


// Get snapshot version and Building docker image   
 
script {
   def  version = "mvn  help\\:evaluate -Dexpression=project.version | grep -e '^[^\\[]'"
   proversion = sh(script: "${version}", returnStdout: true)
}

//Build project specific images
   stage('Build image') {

      sh  "docker build -f Dockerfile . -t dariniv/${proversion}"
}

//push image to dockerhub
   stage('Push image') {
            docker.withRegistry('https://registry.hub.docker.com',  '605b0519-9017-47ec-8e78-6d95c5957e0a') {
            sh "docker push dariniv/${proversion}"
   }
  }
 }
