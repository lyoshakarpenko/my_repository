def version
node ("master"){
    stage('Build') {
        git branch: 'task6', credentialsId: '7feb6873-abb9-4156-9b24-aa6d125348f3', url: 'https://github.com/lyoshakarpenko/my_repository.git'
        sh 'chmod 700 gradlew'
        sh './gradlew'
        sh './gradlew task increment'
        sh './gradlew build'
        version = sh(returnStdout: true, script: 'cat gradle.properties | grep "version"')
        version = version.replace("version=", "")
        version = version.substring(0,5)
        nexusArtifactUploader artifacts: [[artifactId: 'gradleSample', classifier: '', file: 'build/libs/gradleSample.war', type: 'war']], credentialsId: '09760f58-a600-4300-b94e-7903497f4391', groupId: '', nexusUrl: '192.168.0.111:8081/nexus', nexusVersion: 'nexus2', protocol: 'http', repository: 'snapshots', version: "$version"
    }
    stage('Deploy tomcat1') {
        node ("tomcat1"){
         deploytom(1,version)
        }
    }
    stage('Deploy tomcat2') {
        node ("tomcat2"){
         deploytom(2,version)
        }
    }
    stage('Push git'){ 
        withCredentials([usernamePassword(credentialsId: '7feb6873-abb9-4156-9b24-aa6d125348f3', passwordVariable: 'gitPass', usernameVariable: 'gitUser')]) {
            sh """ git commit -m "increment version to ${version}" "gradle.properties" """
            sh 'git push https://${gitUser}:${gitPass}@github.com/lyoshakarpenko/my_repository.git task6'
            sh 'git checkout master'
            sh 'git pull'
            sh 'git checkout --theirs gradle.properties'
            sh 'git add gradle.properties'
            sh 'git merge task6'
            sh 'git push https://${gitUser}:${gitPass}@github.com/lyoshakarpenko/my_repository.git master'
            version = 'v'+version
            sh """git tag -a ${version}  -m ${version} """
            sh 'git push https://${gitUser}:${gitPass}@github.com/lyoshakarpenko/my_repository.git master --tags'
        }
   }
}

def deploytom(argN,version){
    sh 'sudo chmod 777 /usr/share/tomcat/webapps'
    sh """ curl -X POST "http://192.168.0.111/jkmanager?cmd=update&from=list&w=lb&sw=tomcat${argN}&vwa=1" """
    sh """curl "http://192.168.0.111:8081/nexus/content/repositories/snapshots/gradleSample/${version}/gradleSample-${version}.war"  -o /usr/share/tomcat/webapps/gradleSample.war"""
    sh 'sudo chmod 777 /usr/share/tomcat/webapps/gradleSample.war'
    sleep(5)
    def versionN = sh(returnStdout: true, script: """curl http://192.168.0.1${argN}:8080/gradleSample/ | grep "version" """)
    versionN = versionN.replace("version=", "")
    versionN = versionN.substring(0,5)
    if( version == versionN ) {
        println "OK"
    }else{
        error "ERROR deploy tomcat${argN}!!!"
    }
    sh """curl -X POST "http://192.168.0.111/jkmanager?cmd=update&from=list&w=lb&sw=tomcat${argN}&vwa=0" """
}
