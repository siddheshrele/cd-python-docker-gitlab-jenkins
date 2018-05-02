#! /bin/bash
#Created by siddhesh rele email id:- sidluckie@gmail.com
#Create a gitlab server with docker registery enable
#chnage "hname" as per your requirement.

path=/srv/gitlab
hname=gitlab.example.com
vname=gitlab
days=1095

mkdir -p $path/ssl

#genrates ssl certificate with hostname 
openssl req -x509 -nodes -days $days -newkey rsa:2048 -keyout $path/ssl/certificate.key -out $path/ssl/certificate.crt -subj '/CN='$hname''

#Changes certificate permission to 600
chmod 600 $path/ssl/certificate.key
chmod 600 $path/ssl/certificate.crt


#Create docker contaioner with gitlab image
docker run --detach \
        --hostname  $hname \
        --publish 443:443 --publish 10080:10080  --publish 2044:22  \
        --publish 4567:4567 \
        --name gitlab \
        --restart always \
        --volume $path/config:/etc/gitlab \
        --volume $path/logs:/var/log/gitlab \
        --volume $path/data:/var/opt/gitlab \
        --volume $path/ssl:/etc/gitlab/ssl:ro \
        gitlab/gitlab-ce:latest

#externally enables registry config
cat <<EOT >> /srv/gitlab/config/gitlab.rb
external_url "http://$hname:10080"
registry_external_url 'https://$hname:4567'
#nginx['redirect_http_to_https'] = true
nginx['ssl_certificate'] = "/etc/gitlab/ssl/certificate.crt"
nginx['ssl_certificate_key'] = "/etc/gitlab/ssl/certificate.key"
registry_nginx['ssl_certificate'] = "/etc/gitlab/ssl/certificate.crt"
registry_nginx['ssl_certificate_key'] = " /etc/gitlab/ssl/certificate.key"
EOT

#Reconfigure gitlab to enable registry
docker exec -it $vname gitlab-ctl reconfigure

#Restart gitlab service
docker exec -it $vname gitlab-ctl restart


echo "NOTE: Please allow a couple of minutes for the GitLab application to start."
echo "Port: 10080 to access the GIT UI and registery port is 4567"

