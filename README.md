# cd-python-docker-gitlab-jenkins

Project purpose is to make understanding to the beginners of CD/CI on ubuntu 16.04.

Create continuous delivery for python enviroment using docker,gitlab and jenkins.

During this tutorial we will set up

    A Git repository (using GitLab) for our sources and docker registery using gitlab to store images,
    A Jenkins to create our build.
    
starting GitLab and docker registery:
 
 Note :- Make changes to variable as per requirement of your enviroment.
 
 ./1startGitLab.sh

Once gitlab is started it set the password as per your requirement also registry is setup no need to setup diffrent diffrent registery for docker.

Create project app on gitlab server by accessing http://localhost:10080

We like to notify Jenkins about changes. Therefore go to http://localhost:10080/root/app/hooks  and create a webhook for push events with the URL http://<IpOfHostMachine>:8090/git/notifyCommit?url=http://<IpOfHostMachine>:10080/root/app.git

commit the projects to our Git repository.

Note:- change the password variable as per you set on gitlab server.

./2createProjectsAndCommitToGitLab.sh

Add below lines on host server in /etc/docker/daemon.json

{
    "insecure-registries": ["gitlab.spay.com:4567"]
}



Now we are ready to start our Continuous Delivery (!) server Jenkins: :-)

./3startJenkins.sh

Server will be access able on http://<IpOfHostMachine>:8090 and password can be found executing below command on host server "docker exec -it jenkins cat /var/jenkins_home/secrets/initialAdminPassword"

Setting up the jenkins.

1) Install docker build and publish plugin.
2) Create free style propject .
3)Source Code Management -> git set the server details
4)Build Triggers -> Poll SCM -> H/5 * * * * -> checks git changes
5)Build Environment -> check on "Delete workspace before build starts"
6)Build 
Repository Name -> root/app/
tag -> v-1.0
Docker Host URI ->  tcp://yourip:2375
Docker registry URL -> https://gitlab.example.com:4567 -> use https as well as hostname.
Registry credentials

save the project changes now you can see the build is built and you can check your project repority the build is create.

If any issue you can mail me at sidluckie@gmail.com
