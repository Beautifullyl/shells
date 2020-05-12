#!/usr/bin/env bash

#有一个参数，是指定IP
echo "处理中。。。。。。"
printf "统计访问来源主机TOP 100和分别对应出现的总次数" > web_cal_data.txt
#1.awk把文件逐行的读入，以\t为默认分隔符将每行切片,$1是第一个元素
#2.sort默认是从小到大，uniq -c表示显示该主机重复出现的次数
#3.-n 按照数值大小排序 -r表示逆序
#4.head -n指定显示头部内容的行数
#5.最后写入文件
{ echo web_log.tsv|awk -F'\t' '{print $1}'|sort|uniq -c|sort -nr|head -n 100;} >> web_cal_data.txt 
printf "统计访问来源主机TOP 100 IP和分别对应出现的总次数">> web_cal_data.txt
#grep使用正则表达式搜索文本，^表示以后面开头的元素，[]表示范围
{ echo web_log.tsv|awk -F'\t' '{print $1}'|grep -E "^[0-9]"|sort|uniq -c|sort -nr|head -n 100; } >> web_cal_data.txt
printf "统计最频繁被访问的URL TOP 100"> web_cal_data.txt
{ echo web_log.tsv|awk -F'\t' '{print $5}'|sort|uniq -c|sort -nr|head -n 100; }>> web_cal_data.txt
printf "统计不同响应状态码的出现次数和对应百分比">> web_cal_data.txt
#END后的语句是每行数据处理完后执行
{ echo web_log.tsv| awk '{a[$6]++;s+=1}END{for (i in a) printf "%s %d %6.6f%%\n", i, a[i], a[i]/s*100}'|sort; } >> web_cal_data.txt
printf "分别统计不同4XX状态码对应的TOP 10 URL和对应出现的总次数">> web_cal_data.txt
printf "403:">> web_cal_data.txt
{ echo web_log.tsv|awk -F'\t' '{if($6=="403")print $5,$6}'|sort|uniq -c|sort -nr|head -n 100; } >> web_cal_data.txt
printf "404:">> web_cal_data.txt
{ echo web_log.tsv|awk -F'\t' '{if($6=="404")print $5,$6}'|sort|uniq -c|sort -nr|head -n 100; }>> web_cal_data.txt
printf "给定URL输出TOP 100访问来源主机">> web_cal_data.txt
#url参数
url=$1
if [ "$url" = "-h" ]||[ "$url" = "-help" ];then
	echo '-------------------------------------------'
        echo '-- 本脚本用于统计 web_log.tsv 中以下数据 --'
	echo '-------------------------------------------'
        echo '-h/-help 输出帮助文档'
	echo '统计访问来源主机TOP 100和分别对应出现的总次数'
        echo '统计访问来源主机TOP 100 IP和分别对应出现的总次数'
	echo '统计最频繁被访问的URL TOP 100'
	echo '统计不同响应状态码的出现次数和对应百分比'
	echo '分别统计不同4XX状态码对应的TOP 10 URL和对应出现的总次数'
	echo '给定url 指定url,给定URL输出TOP 100访问来源主机 '
else 
	{ echo web_log.tsv|awk -F'\t' '{if("$5"=="'"$url"'")print "$1","$5"}'|sort|uniq -c|sort -nr|head -n 100 }>> web_cal_data.txt
fi
echo "处理完成"
