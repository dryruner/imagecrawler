# image\_crawler v1.0.4
This is an image crawler in pure shell script, which could download the images (actually the image URLs on the web) once given a keyword. It fakes to visit Google Image/Baidu Image, using the keywords you provide to perform like a human search, and then parse and record the results(image urls) returned by Google or Baidu. Once you have the image urls, you could download the real images using any script languages you like. This tool could also be used to compare the search quality and relevance between Google Image and Baidu Image.

## What's NEW?
* Now it supports both wget and curl!
* Performance is enhanced ~10X faster, increasing the parallelism by utilizing multi-process background jobs in bash.
* Baidu/Google image search urls are updated. This script was created ~5 years ago, and things have changed a lot since then, both baidu and google changed their image search query parameters and rules. So I took quite a few time this weekend to figure out what's the change, and update the script to make it work again.
* A python script is introduced to decode the baidu image objURL. I planned to do it in bash script originally, but you need to introduce a hashtable, damn complicated to make it work in bash only... So I'll leave it as a TODO now - to update this python script to the bash script with the same functionality.

## TODO:
* Continue to improve the performance.
* Adding proxy support? 
* Implement the python equivalent to decode the baidu image url.
* ...

## How to use it?
* Input: A file named query\_list.txt, per keyword per line.
* Usage: 
	$./image\_crawler.sh google <num>;
	* google could be replaced by baidu
	* <num> is the number of images you want to download for a given keyword.
* Output: The script generates a directory named google/(or baidu/ as you choosed), which contains files of the format: "i\_objURL-list\_keyword[i]", i is the ith keyword in the query\_list.txt. In each of these files contain num lines, per image url per line.

## Performance
I've tested this script with 10 keywords (just as in the query\_list.txt), each keyword crawling 300 results using Google.<br/> 
Results are as follows:<br/>
[unix14 ~/imagecrawler]$ time ./image\_crawler.sh google 300 <br/>
real	0m5.766s
user	0m2.425s
sys	0m2.254s

[unix14 ~/imagecrawler]$ time ./image\_crawler.sh baidu 300 <br/>
real	0m11.419s
user	0m1.254s
sys	0m1.044s

The result is not bad, and in the future I'll tweak it into a more concurrent version. <br/>

# Note:
It works in any platform that supports bash, egrep, awk, python, wget | curl. So, Ubuntu, MacOS, etc.
