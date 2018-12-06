def tagsUrl = 'http://192.168.0.111:5000/v2/mytomcat/tags/list' 
def data = new URL(tagsUrl).getText()
def list = new groovy.json.JsonSlurper().parseText(data)
return list.tags
