# image\_crawler v1.0.3
This is an image crawler in pure shell script, which could download the images (actually the image URLs on the web) once given a keyword. It fakes to visit Google Image/Baidu Image, using the keywords you provide to perform like a human search, and then parse and record the results(image urls) returned by Google or Baidu. Once you have the image urls, you could download the real images using any script languages you like. This tool could also be used to compare the search quality and relevance between Google Image and Baidu Image.

## How to use it?
* Input: A file named query\_list.txt, per keyword per line.
* Usage: 
	$./image\_crawler.sh google num;
	* google could be replaced by baidu
	* num is the number of images you want to download for a given keyword.
* Output: The script will generate a directory named google/(or baidu/ as you choosed), which contains files of the format: "i\_objURL-list\_keyword[i]", i is the ith keyword in the query\_list.txt. In each of these files contain num lines, per image url per line.

## Performance
I've tested this script with 10 keywords (just as in the query\_list.txt), each keyword crawling 300 results using Google. Results are as follows:
[siyuanh@unix14 ~/imagecrawler]$ time ./image\_crawler.sh google 300
     0.396u 1.298s 0:31.91 5.2%	0+0k 0+23472io 0pf+0w
It's acceptable I think. And in the future I'll tweak it into a more concurrent version.

# Note:
It works perfectly in linux platform(Ubuntu, Red Hat, etc.).
But it complains fault in Mac OS X terminal when crawling images from google(crawling from baidu is OK), because the sed utility is somewhat different in Mac and Linux platforms. Maybe I'll look into and fix it in the future.


# Contacts:
Siyuan Hua (siyuanh@andrew.cmu.edu)

Thanks, :)
