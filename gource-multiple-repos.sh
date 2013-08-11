#!/usr/bin/env bash
# Generates combinedlog out of multiple repositories.
# Utilizes the lsgit command found in https://github.com/ermagana/dotfiles/blob/master/bin/lsgit
# Original Source: https://gist.github.com/anonymous/884376
# Example:
# <this.sh>
dirs=(`lsgit | sed -r 's/(\w)\s.*/\1/' | cut -c3- | sort -f | grep "^[^ ]"`)
 
i=0
for repo in ${dirs[@]}; do
	echo $repo
	# 1. Generate a Gource custom log files for each repo. This can be facilitated by the --output-custom-log FILE option of Gource as of 0.29:
	logfile="gource.$i.log"
	gource --output-custom-log "${logfile}" ${repo}
	# 2. If you want each repo to appear on a separate branch instead of merged onto each other (which might also look interesting), you can use a 'sed' regular expression to add an extra parent directory to the path of the files in each project:
	sed -i -E "s#(.+)\|#\1|/${repo}#" ${logfile}
	logs[$i]=$logfile
	let i=$i+1
done
 
combined_log="combinedlog.txt"
cat ${logs[@]} | sort -n > $combined_log
rm ${logs[@]}
 
echo "Committers:"
cat $combined_log | awk -F\| {'print  $2'} | sort | uniq
echo "======================"
 
echo "Suggested call:"
echo "gource --key --user-image-dir avatars --seconds-per-day .1 combinedlog.txt"
# if you have ffmpeg you can uncomment the lines below
# outfile="gource.mp4"
# time gource $combined_log \
# 	-s 0.4 \
# 	-i 0 \
# 	--highlight-users \
# 	--highlight-dirs \
# 	--file-extensions \
# 	--hide mouse \
# 	--key \
# 	--stop-at-end \
# 	--output-ppm-stream - | ffmpeg -y -b 3000K -r 60 -f image2pipe -vcodec ppm -i - -vcodec libx264 -vpre default $outfile
# rm $combined_log