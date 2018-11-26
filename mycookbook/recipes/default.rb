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

bash 'tuning_registry' do
    code <<-EOF
        echo {'"insecure-registries"' : [ '"192.168.0.11:5000"' ]} >> /etc/docker/daemon.json
        systemctl restart docker
    EOF
end