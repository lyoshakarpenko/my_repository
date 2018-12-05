def data = "curl http://192.168.0.111:5000/v2/mytomcat/tags/list".execute().text.tokenize('","')
def tags = []
for (i in 6 .. (data.size() -2)) {
    tags.add(data.get(i))
}
return tags