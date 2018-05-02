#! /bin/bash

#Commits code to your gitlab server
#Created by siddhesh rele email id:- sidluckie@gmail.com
# use same credentials for git as for gitlab user

echo "precondition: create project 'app' in gitlab"
echo "The default user is 'root' and the pw is as you set on gitlab server"

TARGETFOLDER=~/Development
GITLAB_USER=root
GITLAB_PW=password

createProjectAndCommitToGitLab(){
	local projectName=$1
	local targetPath=$TARGETFOLDER/$projectName
	echo "=== $targetPath ==="
	
	rm -fr $targetPath

	echo "--- Cloning..."
	git clone http://$GITLAB_USER:$GITLAB_PW@localhost:10080/root/$projectName.git $targetPath
	git config user.name $GITLAB_USER #don't use --global!
	git config credential.helper cache #caches password for 15 min
	
	echo "--- Copying..."
	cp -r $projectName $TARGETFOLDER
	
	echo "--- Committing..."
	local currentPath=`pwd`;
	cd $targetPath
	git add .
	git commit -m "inital commit"
	git push -u origin master
	cd $currentPath
}

createProjectAndCommitToGitLab app




