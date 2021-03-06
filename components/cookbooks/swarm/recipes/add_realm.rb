require 'json'

cloud_name = node[:workorder][:cloud][:ciName]
container_service = node[:workorder][:services][:container][cloud_name][:ciAttributes]
realm = node[:workorder][:rfcCi]

docker = "docker"
docker = docker + " -H=#{container_service[:endpoint]}" if !container_service[:endpoint].empty?
Chef::Log.debug("DOCKER: #{docker}")

ruby_block "create network #{node[:realm]}" do
  block do
    network = "network create -d overlay #{node[:realm]} 2>&1"
    Chef::Log.info(network)
    result = `#{docker} #{network}`
    if $?.success?
      Chef::Log.info(result)
    elsif result.match("already exists")
      Chef::Log.info(result)
    else
      raise result
    end
  end
end
