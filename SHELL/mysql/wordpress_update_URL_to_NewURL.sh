####################################################################
# File Name: wordpress_update_URL_to_NewURL.sh
# Author: Anqiao
# Mail: ay1114it01@gmail.com
# Created Time: Tue 22 Aug 2017 08:26:53 PM UTC
# Funciont: Convertir tots url de wordpress(articles,url_home,siteurl..etc) a https(New Url) 
#===================================================================
#!/bin/bash
#------------------------variables requiriments---------------------
mysql_user='root'
mysql_pass='root'
mysql_db='test'

#------------------------variables default---------------------
packages_requirements=(mysql)
url=`mysql -u"$mysql_user" -p"$mysql_pass" $mysql_db -ss -e "SELECT option_value FROM wp_options WHERE option_name = 'home' OR option_name = 'siteurl';" | tail -n 1 | sed -e "s/^/'/;s/$/'/"`
if [ -z `echo $url | grep 'https'` ];then
	new_url=`echo $url | sed 's/http/https/g'`
else
	new_url=$url
fi
#-------------------------------------------------------------------

check_packages_requeriments(){
	pack_not_installed=""
	for i in `echo ${packages_requirements[*]}`;do
		if [ ! `which $i &> /dev/null; echo $?` -eq 0 ];then
			pack_not_installed="$pack_not_installed "$i
		fi
	done
	if [ -n "$pack_not_installed" ];then
		echo "No installed$pack_not_installed"
		exit 11
	fi
}

update_URL_to_NewURL(){
	mysql -u"$mysql_user" -p"$mysql_pass" $mysql_db -ss -e "UPDATE wp_options SET option_value = replace(option_value, $url, $new_url) WHERE option_name = 'home' OR option_name = 'siteurl';"
	mysql -u"$mysql_user" -p"$mysql_pass" $mysql_db -ss -e "UPDATE wp_posts SET guid = replace(guid, $url, $new_url);"
	mysql -u"$mysql_user" -p"$mysql_pass" $mysql_db -ss -e "UPDATE wp_posts SET post_content = replace(post_content,$url, $new_url);"
	mysql -u"$mysql_user" -p"$mysql_pass" $mysql_db -ss -e "UPDATE wp_postmeta SET meta_value = REPLACE(meta_value,$url, $new_url);"
}

check_packages_requeriments	
update_URL_to_NewURL
