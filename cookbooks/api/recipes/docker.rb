execute "Docker build" do
    command "cd /opt/people-api/ && docker build -t people-api ."
end

execute "Docker run" do
    command "cd /opt/people-api/ && docker run -dit -p '3010:3010' --restart always people-api"
end