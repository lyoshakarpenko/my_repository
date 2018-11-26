#
# Cookbook:: mycookbook
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.
docker_service 'default' do
    action [:create, :start]
end

docker_image 'registry' do
    tag '2'
    action :pull
end

docker_container 'registry' do
    repo 'registry'
    tag '2'
    restart_policy 'unless-stopped'
    port '5000:5000'
end

template '/etc/docker/daemon.json' do
    source 'daemon.json'
    owner 'root'
    group 'root'
    mode '0755'
    action :create
end
