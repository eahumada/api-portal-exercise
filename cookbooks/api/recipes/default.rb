#
# Cookbook:: api
# Recipe:: default
#
# Copyright:: 2020, The Authors, All Rights Reserved.

remote_directory "/opt/people-api" do
    source 'people-api'
    files_owner 'root'                                                                 
    files_group 'root'
    files_mode '0750'
    action :create
    recursive true                                                                    
end