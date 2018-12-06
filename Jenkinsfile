def mybranch='task10'
node ("master"){
    stage('Build') {
        git branch: mybranch, url: 'https://github.com/lyoshakarpenko/my_repository.git'
        sh """ sed -i 's/.*'"'version'"'.*/'"default['mytomcat']['version']='${tags}'"'/' ~/workspace/${mybranch}/mytomcat/attributes/default.rb"""
        sh """ sed -i 's/^version.*/'"version '${tags}'"'/' ~/workspace/${mybranch}/mytomcat/metadata.rb"""
        sh """ sed -i "s/mytomcat.*/"'mytomcat"'": "'"='" ${tags}"'"'"/" ~/workspace/${mybranch}/environments/${mybranch}.json"""
        dir('mytomcat') {
            sh 'berks install && berks upload'
        }
        sh """knife environment from file environments/${mybranch}.json"""
        withCredentials([usernamePassword(credentialsId: 'ffd53c33-3869-473e-a341-241972733ee1', passwordVariable: 'nodePass', usernameVariable: 'nodeUser')]) {
            sh """knife ssh node-1 "sudo chef-client" -x ${nodeUser} -P ${nodePass}"""
        }
    }
    stage('Push git'){ 
        withCredentials([usernamePassword(credentialsId: 'f038d5ad-bb4d-4f7a-aa4c-3a78f0647e68', passwordVariable: 'gitPass', usernameVariable: 'gitUser')]) {
            sh """ git commit -m "change version to ${tags}" "mytomcat/metadata.rb" "mytomcat/attributes/default.rb" "environments/task10.json" """
            sh """git push https://${gitUser}:${gitPass}@github.com/lyoshakarpenko/my_repository.git ${mybranch}"""
        }
    }
}
