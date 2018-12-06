#
# Cookbook:: mytomcat
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.
docker_service 'default' do
    action [:create, :start]
end

docker_image "#{node['mytomcat']['url']}/mytomcat" do
    tag node['version']
    action :pull
end

ENV['flag']='0'
ENV['flag']=`docker ps -a | grep '8080->' -c`
puts "#{ENV['flag'][0]}" 
case ENV['flag'][0]
    when '0'
    docker_container 'mytomcat_blue' do
        repo "#{node['mytomcat']['url']}/mytomcat"
        tag node['mytomcat']['version']
        port '8080:8080'
    end	
    docker_container 'mytomcat_green' do
        action [:kill, :delete]
    end
    else
    docker_container 'mytomcat_green' do
        repo "#{node['mytomcat']['url']}/mytomcat"
        tag node['mytomcat']['version']
        port '8081:8080'
    end
    docker_container 'mytomcat_blue' do
        action [:kill, :delete]
    end
end
