#!/bin/bash
# $2 is the number of images you wanna crawl£¬$1 == "baidu" or "google", which
# is the source of the images you wanna crawl. You could try twice and get the 
# objURLs from baidu and google respectively. 

# Debug options
#set -o xtrace

###################### Config BEGIN ################################

from=$1;
num=$2;
CRAWLER=
OUTPUT_FLAG=-O     # For curl using '-o' instead.
RETRY_FLAG=-t      # Default retrying flag (for wget). For curl using '--retry <num>'.
RETRY_NUM=3        # Crawler retries <num> times if here's a connection issue.
QUITE_FLAG=-q      # Turning off crawler's logging output. For curl using '-s'.
FOLLOW_REDIRECT=   # Following the redirection, in case 301 moved was returned. For curl using '-L'.
ROBOTS_CMD="-e robots=off"  # wget only, do not honor robots.txt rules.
USERAGENT_FLAG=-U  # For curl, using '-A'
USERAGENT_STRING="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/53.0.2785.116 Safari/537.36"

########################## Congig END ##################################

function DetectEnv() {
	which wget > /dev/null 2>&1
	if [ $? -eq 0 ];then
		CRAWLER=wget
		echo -e "Using wget as crawler...\n"
	else
		which curl > /dev/null 2>&1
		if [ $? -eq 0 ];then
			CRAWLER=curl
			OUTPUT_FLAG=-o
			RETRY_FLAG=--retry
			QUITE_FLAG=-s
			FOLLOW_REDIRECT=-L
			ROBOTS_CMD=
			USERAGENT_FLAG=-A
			echo -e "Using curl as crawler...\n"
		else
			echo -e "Neither wget nor curl was found, please check your system environment, aborting..."
			exit 1
		fi
	fi
}

function DownPage() {
	if [ -e $from ];then
		rm -rf $from;
	fi
	mkdir $from;
	local k=1;

	if [ "$from" = "baidu" ];then
		round=$(($num/60));
		remain=$(($num - ${round}*60));

		while read query
		do
			touch $from/${k}_objURL-list_${query};
			for((i=1;i<=$round;i++))
			do
				(
				$CRAWLER $RETRY_FLAG $RETRY_NUM $USERAGENT_FLAG "$USERAGENT_STRING" "http://image.baidu.com/search/acjson?tn=resultjson_com&ipn=rj&ct=201326592&word=${query}&ie=utf-8&oe=utf-8&pn=$((($i-1)*60))&rn=60" $OUTPUT_FLAG $from/${k}_${query}_${i};
				cat $from/${k}_${query}_${i}| egrep '"objURL":".*?"' -o | awk -F'"' '{print $4}' >> $from/${k}_objURL-list_${query}
				) &
			done
			if [ $remain -ne 0 ];then
				(
				$CRAWLER $RETRY_FLAG $RETRY_NUM $USERAGENT_FLAG "$USERAGENT_STRING" "http://image.baidu.com/search/acjson?tn=resultjson_com&ipn=rj?ct=201326592&word=${query}&ie=utf-8&oe=utf-8&pn=$((($i-1)*60))&rn=${remain}" $OUTPUT_FLAG $from/${k}_${query}_${i};
				cat $from/${k}_${query}_${i}| egrep '"objURL":".*?"' -o | awk -F'"' '{print $4}' >> $from/${k}_objURL-list_${query}
				) &
			fi

      # Waiting for background jobs to finish before removing temporary files.
			wait
			(
			python decode_objurl.py $from/${k}_objURL-list_${query} $from/${k}_decoded_objURL-list_${query}
			rm -rf $from/${k}_${query}* 
			rm -rf $from/${k}_objURL-list_${query}
			) &
		
			k=$(($k+1));
		done < query_list.txt
	elif [ "$from" = "google" ];then
		round=$(($num/20));
		remain=$(($num - ${round}*20));

		while read query
		do
			touch $from/${k}_objURL-list_${query};
			for((i=1;i<=$round;i++))
			do
				(
				$CRAWLER $RETRY_FLAG $RETRY_NUM $ROBOTS_CMD $FOLLOW_REDIRECT $USERAGENT_FLAG "$USERAGENT_STRING" "http://images.google.com/images?q=${query}&start=$((($i-1)*20))&sout=1" $OUTPUT_FLAG $from/${k}_${query}_${i};
				# Non-greedy mode, to match only image url src part.
				cat $from/${k}_${query}_${i}| egrep 'src="http.*?"' -o | awk -F'"' '{print $2}' >> $from/${k}_objURL-list_${query};
				) &
			done
			
			if [ $remain -ne 0 ];then
				(
				$CRAWLER $RETRY_FLAG $RETRY_NUM $ROBOTS_CMD $FOLLOW_REDIRECT $USERAGENT_FLAG "$USERAGENT_STRING" "http://images.google.com/images?q=${query}&start=$((($i-1)*20))&sout=1&num=${remain}" $OUTPUT_FLAG $from/${k}_${query}_${i};
			# Non-greedy mode, to match only image url src part.
				cat $from/${k}_${query}_${i}| egrep 'src="http.*?"' -o | awk -F'"' '{print $2}' >> $from/${k}_objURL-list_${query}
				) &
			fi

			# Waiting for background jobs to finish before removing temporary files.
			wait
			rm -rf $from/${k}_${query}* &

			k=$(($k+1));
		done < query_list.txt
	fi
}

### main() ###
DetectEnv
DownPage $num
wait
