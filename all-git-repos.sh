#!/bin/bash
#Script to get all repositories under a user from bitbucket
#Original Source: http://haroldsoh.com/2011/10/07/clone-all-repos-from-a-bitbucket-source/
#Usage: getAllRepos.sh [user] [login]
#		user: is the account your trying to pull repos from
#		login: is the user login you will use to authenticate 
#			    access to the user account

repoinfo=$(curl -u ${2} https://bitbucket.org/api/1.0/users/${1})

for repo_name in `echo $repoinfo | python -mjson.tool | grep \"name\" | cut -f4 -d\" | sort -f`
do
	# echo "$repo_name"
	if [ ! -d "$repo_name" ]; then
		echo "Cloning : $repo_name"
		git clone git@bitbucket.org:${1}/$repo_name.git
	else
		echo "Updating repo: $repo_name"
		git --git-dir=$repo_name/.git --work-tree=$repo_name pull --all 2>/dev/null ||
		git --git-dir=$repo_name/.git pull --all
	fi
done