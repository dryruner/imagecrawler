#!/bin/bash
# $2 is the number of images you wanna crawl£¬$1 == "baidu" or "google", which
# is the source of the images you wanna crawl. You could try twice and get the 
# objURLs from baidu and google respectively. 

from=$1;
num=$2;


down_page()
{
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
				wget -t 3 -q "http://image.baidu.com/i?ct=201326592&cl=2&lm=-1&tn=baiduimagejson&istype=2&s=0&word=${query}&ie=utf-8&pn=$((($i-1)*60))&rn=60" -O $from/${k}_${query}_${i};

				cat $from/${k}_${query}_${i}|grep objURL|awk -F'"' '{print $4}' >> $from/${k}_objURL-list_${query}
			done

			if [ $remain -ne 0 ];then
				wget -t 3 -q "http://image.baidu.com/i?ct=201326592&cl=2&lm=-1&tn=baiduimagejson&istype=2&s=0&word=${query}&ie=utf-8&pn=$((($i-1)*60))&rn=${remain}" -O $from/${k}_${query}_${i};
				cat $from/${k}_${query}_${i}|grep objURL|awk -F'"' '{print $4}'|sed 's/     //g' >> $from/${k}_objURL-list_${query}
			fi
		
			rm -rf $from/${k}_${query}*
		
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
				wget -t 3 -q -e robots=off -U Mozilla "http://images.google.com/images?q=${query}&start=$((($i-1)*20))&sout=1" -O $from/${k}_${query}_${i};
				cat $from/${k}_${query}_${i}|sed 's/href/\n/g'|sed 's/imgurl=/HSY/g'|sed 's/&amp;imgrefurl/HSY/g'|grep HSY|awk -F'HSY' '{print $2}' >> $from/${k}_objURL-list_${query};
			done
			
			if [ $remain -ne 0 ];then
				wget -t 3 -q -e robots=off -U Mozilla "http://images.google.com/images?q=${query}&start=$((($i-1)*20))&sout=1&num=${remain}" -O $from/${k}_${query}_${i};
				cat $from/${k}_${query}_${i}|sed 's/href/\n/g'|sed 's/imgurl=/HSY/g'|sed 's/&amp;imgrefurl/HSY/g'|grep HSY|awk -F'HSY' '{print $2}' >> $from/${k}_objURL-list_${query};
			fi

			rm -rf $from/${k}_${query}*

			k=$(($k+1));
		done < query_list.txt

	fi
}

### main() ###
down_page $num
