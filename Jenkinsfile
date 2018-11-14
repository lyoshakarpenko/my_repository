def version
def mybranch='task7'
def myurl='192.168.0.111:5000'
node ("master"){
    stage('Build') {
        git branch: mybranch, credentialsId: '7feb6873-abb9-4156-9b24-aa6d125348f3', url: 'https://github.com/lyoshakarpenko/my_repository.git'
        sh 'chmod 700 gradlew'
        sh './gradlew'
        sh './gradlew task increment'
        sh './gradlew build'
        version = FindVersion('cat gradle.properties')
        nexusArtifactUploader artifacts: [[artifactId: 'gradleSample', classifier: '', file: 'build/libs/gradleSample.war', type: 'war']], credentialsId: '09760f58-a600-4300-b94e-7903497f4391', groupId: '', nexusUrl: '192.168.0.111:8081/nexus', nexusVersion: 'nexus2', protocol: 'http', repository: 'snapshots', version: "$version"
    }
    stage('Deploy'){
        deploytom(version, myurl)
    }
    

    stage('Push git'){ 
        withCredentials([usernamePassword(credentialsId: '7feb6873-abb9-4156-9b24-aa6d125348f3', passwordVariable: 'gitPass', usernameVariable: 'gitUser')]) {
            sh """ git commit -m "increment version to ${version}" "gradle.properties" """
            sh """git push https://${gitUser}:${gitPass}@github.com/lyoshakarpenko/my_repository.git ${mybranch}"""
            sh 'git checkout master'
            sh 'git pull'
            sh 'git checkout --theirs gradle.properties'
            sh 'git add gradle.properties'
            sh """git merge ${mybranch}"""
            sh 'git push https://${gitUser}:${gitPass}@github.com/lyoshakarpenko/my_repository.git master'
            version = 'v'+version
            sh """git tag -a ${version}  -m ${version} """
            sh 'git push https://${gitUser}:${gitPass}@github.com/lyoshakarpenko/my_repository.git master --tags'
        }
    }
}

def deploytom(version, myurl){
    sh """docker build -t mytomcat:${version} --build-arg version=${version} ."""
    sh """docker tag mytomcat:${version} ${myurl}/mytomcat:${version}"""
    sh """docker push ${myurl}/mytomcat:${version}"""
    def flag = sh(returnStdout: true, script: ' docker service ls | grep -c "tom" || true')
    println flag
    if (flag[0] == "0"){
        sh """docker service create --name tom --replicas 1 --publish 8080:8080 ${myurl}/mytomcat:${version}"""
    }else {
        sh """docker service update --image ${myurl}/mytomcat:${version} tom"""
    }
    sleep(5)
    def versionN = FindVersion('curl http://192.168.0.111:8080/gradleSample/')
    if( version == versionN ){
        println "OK"
    }else{
        error "ERROR"
    }
}

def FindVersion(myfunk){
    def versionN = sh(returnStdout: true, script: """${myfunk} | grep "version" """)
    versionN = versionN.replace("version=", "")
    versionN = versionN.substring(0,5)
    return versionN
}
