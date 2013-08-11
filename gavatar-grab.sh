#!/usr/bin/env bash
#Original source: https://gist.github.com/icco/867524

# Size in pixels you want, must be less than 512
size='90'
gravdir="avatars"
if [ ! -d $gravdir ]; then
	mkdir $gravdir
fi

dirs=(`lsgit | sed -r 's/(\w)\s.*/\1/' | cut -c3- | sort -f`)
 
for repo in ${dirs[@]}
do
	# A sad way to not make the next loop delimit on spaces
	IFS='
'
	for emailuser in `git --git-dir=$repo/.git --work-tree=$repo log --pretty=format:"%ae|%an" | sort -f | uniq`
	do
		email=`echo $emailuser | cut -d'|' -f1`
		user=`echo $emailuser | cut -d'|' -f2`
		if [ ! -f $gravdir/$user.png ]; then
			echo "grab $user's gravatar email: $email"
			hash=`echo -n $email | awk '{print tolower($0)}' | tr -d '\n ' | md5sum --text | tr -d '\- '`
			url="http://www.gravatar.com/avatar/$hash?d=404&s=$size"

			if [ $(curl --write-out %{http_code} --silent --output /dev/null $url) -eq 200 ]; then
				# Alright, grab the file, store it.
				curl -s $url > $gravdir/$user.png
			fi
		fi
	done
done