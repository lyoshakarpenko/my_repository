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
            sh 'sudo chmod 777 /usr/share/tomcat/webapps'
            sh 'curl "http://192.168.0.111:8081/nexus/content/repositories/snapshots/gradleSample/1.0.2/gradleSample-1.0.2.war"  -o /usr/share/tomcat/webapps/gradleSample.war'
            sh 'sudo chmod 777 /usr/share/tomcat/webapps/gradleSample.war'
            sh 'curl -X POST "http://192.168.0.111/jkmanager?cmd=update&from=list&w=lb&sw=tomcat1&vwa=1"'
            sh 'sudo systemctl restart tomcat'
            sleep(5)
            def versionN = sh(returnStdout: true, script: 'curl http://192.168.0.11:8080/gradleSample/ | grep "version"')
            versionN = versionN.replace("version=", "")
            versionN = versionN.substring(0,5)
            if( version == versionN ) {
                println "same"
            }else{
                println "not same"
            }
            sh 'curl -X POST "http://192.168.0.111/jkmanager?cmd=update&from=list&w=lb&sw=tomcat1&vwa=0"'
        }
    }
    stage('Deploy tomcat2') {
        node ("tomcat2"){
            sh 'sudo chmod 777 /usr/share/tomcat/webapps'
            sh 'curl "http://192.168.0.111:8081/nexus/content/repositories/snapshots/gradleSample/1.0.2/gradleSample-1.0.2.war"  -o /usr/share/tomcat/webapps/gradleSample.war'
            sh 'sudo chmod 777 /usr/share/tomcat/webapps/gradleSample.war'
            sh 'curl -X POST "http://192.168.0.111/jkmanager?cmd=update&from=list&w=lb&sw=tomcat2&vwa=1"'
            sh 'sudo systemctl restart tomcat'
            sleep(5)
            def versionN = sh(returnStdout: true, script: 'curl http://192.168.0.12:8080/gradleSample/ | grep "version"')
            versionN = versionN.replace("version=", "")
            versionN = versionN.substring(0,5)
            if( version == versionN ) {
                println "same"
            }else{
                println "not same"
            }
            sh 'curl -X POST "http://192.168.0.111/jkmanager?cmd=update&from=list&w=lb&sw=tomcat2&vwa=0"'
        }
    }
    stage('Push git'){ 
        withCredentials([usernamePassword(credentialsId: '7feb6873-abb9-4156-9b24-aa6d125348f3', passwordVariable: 'gitPass', usernameVariable: 'gitUser')]) {
            sh 'git commit -ma "gradle.properties"'
            sh 'git push https://${gitUser}:${gitPass}@github.com/lyoshakarpenko/my_repository.git task6'
            sh 'git stash'
            sh 'git checkout master'
            sh 'git merge task6'
            sh 'git push https://${gitUser}:${gitPass}@github.com/lyoshakarpenko/my_repository.git master'
            sh """git tag -a ${version}  -m "my version" """
            sh 'git push https://${gitUser}:${gitPass}@github.com/lyoshakarpenko/my_repository.git master --tags'
        }
   }
}
