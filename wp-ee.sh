### Instala Easy Engine
read -r -p $'\n\nInstala Easy Engine? S ou [N] ' response
if [[ "$response" =~ ^([sS])+$ ]]
	then
	wget -qO ee rt.cx/ee && sudo bash ee
	read -rsp $'\nEasy Engine instalado com sucesso!\n' -n 1 -t 5
fi



### Instala Wordpress
read -r -p $'\n\nInstala Wordpress com Redis e PHP7? S ou [N] ' response
if [[ "$response" =~ ^([sS])+$ ]]
	then

	### Coleta info
	read -p "Entre com o dominio (meusite.com): " -e domain
	read -p "Defina usuario (login) para Wordpress: " -e wp_user
	read -p "Defina senha (login) para Wordpress: " -e wp_pass

	### Altera arquivo ee.conf
	rm /etc/ee/ee.conf
	echo '# EasyEngine Configuration' >> /etc/ee/ee.conf
	echo '#' >> /etc/ee/ee.conf
	echo '# All commented values are the application default' >> /etc/ee/ee.conf
	echo '#' >> /etc/ee/ee.conf
	echo >> /etc/ee/ee.conf
	echo '[ee]' >> /etc/ee/ee.conf
	echo >> /etc/ee/ee.conf
	echo '### Toggle application level debug (does not toggle framework debugging)' >> /etc/ee/ee.conf
	echo '# debug = false' >> /etc/ee/ee.conf
	echo >> /etc/ee/ee.conf
	echo '### Where external (third-party) plugins are loaded from' >> /etc/ee/ee.conf
	echo '# plugin_dir = /var/lib/ee/plugins/' >> /etc/ee/ee.conf
	echo >> /etc/ee/ee.conf
	echo '### Where all plugin configurations are loaded from' >> /etc/ee/ee.conf
	echo '# plugin_config_dir = /etc/ee/plugins.d/' >> /etc/ee/ee.conf
	echo >> /etc/ee/ee.conf
	echo '### Where external templates are loaded from' >> /etc/ee/ee.conf
	echo '# template_dir = /var/lib/ee/templates/' >> /etc/ee/ee.conf
	echo >> /etc/ee/ee.conf
	echo '[log.logging]' >> /etc/ee/ee.conf
	echo >> /etc/ee/ee.conf
	echo '### Where the log file lives (no log file by default)' >> /etc/ee/ee.conf
	echo 'file = /var/log/ee/ee.log' >> /etc/ee/ee.conf
	echo >> /etc/ee/ee.conf
	echo '### The level for which to log.  One of: info, warn, error, fatal, debug' >> /etc/ee/ee.conf
	echo 'level = debug' >> /etc/ee/ee.conf
	echo >> /etc/ee/ee.conf
	echo '### Whether or not to log to console' >> /etc/ee/ee.conf
	echo 'to_console = false' >> /etc/ee/ee.conf
	echo >> /etc/ee/ee.conf
	echo '### Whether or not to rotate the log file when it reaches `max_bytes`' >> /etc/ee/ee.conf
	echo 'rotate = true' >> /etc/ee/ee.conf
	echo >> /etc/ee/ee.conf
	echo '### Max size in bytes that a log file can grow until it is rotated.' >> /etc/ee/ee.conf
	echo 'max_bytes = 512000' >> /etc/ee/ee.conf
	echo >> /etc/ee/ee.conf
	echo '### The maximun number of log files to maintain when rotating' >> /etc/ee/ee.conf
	echo 'max_files = 7' >> /etc/ee/ee.conf
	echo >> /etc/ee/ee.conf
	echo '[stack]' >> /etc/ee/ee.conf
	echo >> /etc/ee/ee.conf
	echo '### IP address that will be used in Nginx configurations while installing' >> /etc/ee/ee.conf
	echo 'ip-address = 127.0.0.1' >> /etc/ee/ee.conf
	echo >> /etc/ee/ee.conf
	echo '[mysql]' >> /etc/ee/ee.conf
	echo >> /etc/ee/ee.conf
	echo '### MySQL database grant host name' >> /etc/ee/ee.conf
	echo 'grant-host = localhost' >> /etc/ee/ee.conf
	echo >> /etc/ee/ee.conf
	echo '### Ask for MySQL db name while site creation' >> /etc/ee/ee.conf
	echo 'db-name = true' >> /etc/ee/ee.conf
	echo >> /etc/ee/ee.conf
	echo '### Ask for MySQL user name while site creation' >> /etc/ee/ee.conf
	echo 'db-user = true' >> /etc/ee/ee.conf
	echo >> /etc/ee/ee.conf
	echo '[wordpress]' >> /etc/ee/ee.conf
	echo >> /etc/ee/ee.conf
	echo '### Ask for WordPress prefix while site creation' >> /etc/ee/ee.conf
	echo 'prefix = true' >> /etc/ee/ee.conf
	echo >> /etc/ee/ee.conf
	echo '### User name for WordPress sites' >> /etc/ee/ee.conf
	echo "user = $wp_user " >> /etc/ee/ee.conf
	echo >> /etc/ee/ee.conf
	echo '### Password for WordPress sites' >> /etc/ee/ee.conf
	echo "password = $wp_pass " >> /etc/ee/ee.conf
	echo >> /etc/ee/ee.conf
	echo '### EMail for WordPress sites' >> /etc/ee/ee.conf
	echo 'email =' >> /etc/ee/ee.conf
	echo >> /etc/ee/ee.conf
	echo '[update]' >> /etc/ee/ee.conf
	echo >> /etc/ee/ee.conf
	echo '### If enabled, load a plugin named `update` either from the Python module' >> /etc/ee/ee.conf
	echo '### `ee.cli.plugins.example` or from the file path' >> /etc/ee/ee.conf
	echo '### `/var/lib/ee/plugins/example.py`' >> /etc/ee/ee.conf
	echo 'enable_plugin = true' >> /etc/ee/ee.conf
	echo >> /etc/ee/ee.conf
	echo '[sync]' >> /etc/ee/ee.conf
	echo '### If enabled, load a plugin named `update` either from the Python module' >> /etc/ee/ee.conf
	echo '### `ee.cli.plugins.example` or from the file path' >> /etc/ee/ee.conf
	echo '### `/var/lib/ee/plugins/example.py`' >> /etc/ee/ee.conf
	echo 'enable_plugin = true' >> /etc/ee/ee.conf

	### Instalando Wordpress
	ee site create www.$domain --wpredis --php7
	read -rsp $'\nWordpress com Redis e PHP7 instalado com sucesso!\n' -n 1 -t 5
	cat /etc/mysql/conf.d/my.cnf
	read -rsp $'\n\nSalve os dados de acesso de HTTP Auth\npara acessar URL do PHPmyadmin e root para fazer login.\n\nTecle ENTER para continuar...\n'
fi



### Instala SSL LE
read -r -p $'\n\nInstala certificado SSL LE para o site? S ou [N] ' response
if [[ "$response" =~ ^([sS])+$ ]]
	then
		if [[ ! "$domain" ]]
			then
			read -p "Entre com o dominio (meusite.com): " -e domain
		fi

	read -p "Entre com e-mail para certificado SSL: " -e email 
	var=$(awk '/root/{print NR; exit}'  /etc/nginx/sites-enabled/$domain)
	var=$(( var + 2 ))
	sed -i "$var i\ \ \ \ location ~ /.well-known {" /etc/nginx/sites-enabled/$domain
	var=$(( var + 1 ))
	sed -i "$var i\ \ \ \ \ \ \ \ allow all;" /etc/nginx/sites-enabled/$domain
	var=$(( var + 1 ))
	sed -i "$var i\ \ \ \ \ \ \ \ root /var/www/$domain/htdocs;" /etc/nginx/sites-enabled/$domain
	var=$(( var + 1 ))
	sed -i "$var i\ \ \ \ }" /etc/nginx/sites-enabled/$domain
	systemctl restart nginx.service

		if [[ ! -d /opt/letsencrypt ]]
			then
			git clone https://github.com/letsencrypt/letsencrypt /opt/letsencrypt
		fi

	bash /opt/letsencrypt/letsencrypt-auto certonly --webroot -w /var/www/html -d $domain -d www.$domain --email $email --text --agree-tos
	ee site update $domain -le
fi



# Configurar FTP
read -r -p $'\n\nConfigura FTP? S ou [N] ' response
if [[ "$response" =~ ^([sS])+$ ]]
	then
	echo
	echo 'Defina uma senha de acesso para acesso ao FTP!'
	echo
	passwd www-data
	grep www-data /etc/passwd
	sed -i '/www-data:x:33:33:www-data:\/var\/www:\/usr\/sbin\/nologin/c\www-data:x:33:33:www-data:/var/www:/bin/bash' /etc/passwd
	var=$(ifconfig | awk '/inet addr/{print substr($2,6); exit}')
fi



### Instala Mautic
read -r -p $'\n\nInstala Mautic (como subdominio)? S ou [N] ' response
if [[ "$response" =~ ^([sS])+$ ]]
	then
		if [[ ! "$domain" ]]
			then
			read -p "Entre com o dominio (meusite.com): " -e domain
		fi

	read -p "Entre com o subdominio: " -e subdomain
	read -rsp $'\nMautic sera instalado em '$subdomain'.'$domain' .\n\nTecle ENTER para continuar...\n'
	apt-get -y install php5.6-intl php7.0-intl
	ee site create $subdomain.$domain --mysql
	cd /var/www/$subdomain.$domain/htdocs/
	wget --level=0 https://www.mautic.org/download/latest
	apt install unzip
	unzip latest
	rm latest
	chown -R www-data:www-data .
	chmod -R g+rw /var/www/$subdomain.$domain/htdocs/
	rm /etc/nginx/sites-available/$subdomain.$domain
	echo 'server {' >> /etc/nginx/sites-available/$subdomain.$domain
	echo 'listen 80;' >> /etc/nginx/sites-available/$subdomain.$domain
	echo 'listen [::]:80;' >> /etc/nginx/sites-available/$subdomain.$domain
	echo "server_name $subdomain.$domain www.$subdomain.$domain;" >> /etc/nginx/sites-available/$subdomain.$domain
	echo >> /etc/nginx/sites-available/$subdomain.$domain
	echo "access_log /var/log/nginx/$subdomain.$domain.access.log rt_cache;" >> /etc/nginx/sites-available/$subdomain.$domain
	echo "error_log /var/log/nginx/$subdomain.$domain.error.log;" >> /etc/nginx/sites-available/$subdomain.$domain
	echo >> /etc/nginx/sites-available/$subdomain.$domain
	echo "root /var/www/$subdomain.$domain/htdocs;" >> /etc/nginx/sites-available/$subdomain.$domain
	echo >> /etc/nginx/sites-available/$subdomain.$domain
	echo 'index index.php index.html index.htm;' >> /etc/nginx/sites-available/$subdomain.$domain
	echo >> /etc/nginx/sites-available/$subdomain.$domain
	echo 'charset utf-8;' >> /etc/nginx/sites-available/$subdomain.$domain
	echo >> /etc/nginx/sites-available/$subdomain.$domain
	echo '# redirect index.php to root' >> /etc/nginx/sites-available/$subdomain.$domain
	echo 'rewrite ^/index.php/(.*) /$1  permanent;' >> /etc/nginx/sites-available/$subdomain.$domain
	echo >> /etc/nginx/sites-available/$subdomain.$domain
	echo '# redirect some entire folders' >> /etc/nginx/sites-available/$subdomain.$domain
	echo 'rewrite ^/(vendor|translations|build)/.* /index.php break;' >> /etc/nginx/sites-available/$subdomain.$domain
	echo >> /etc/nginx/sites-available/$subdomain.$domain
	echo 'location / {' >> /etc/nginx/sites-available/$subdomain.$domain
	echo '    try_files $uri /index.php$is_args$args;' >> /etc/nginx/sites-available/$subdomain.$domain
	echo '}' >> /etc/nginx/sites-available/$subdomain.$domain
	echo 'location ~ \.php$ {' >> /etc/nginx/sites-available/$subdomain.$domain
	echo '    try_files $uri =404;' >> /etc/nginx/sites-available/$subdomain.$domain
	echo '    include fastcgi_params;' >> /etc/nginx/sites-available/$subdomain.$domain
	echo '    fastcgi_pass php;' >> /etc/nginx/sites-available/$subdomain.$domain
	echo '}' >> /etc/nginx/sites-available/$subdomain.$domain
	echo >> /etc/nginx/sites-available/$subdomain.$domain
	echo '# Deny everything else in /app folder except Assets folder in bundles' >> /etc/nginx/sites-available/$subdomain.$domain
	echo 'location ~ /app/bundles/.*/Assets/ {' >> /etc/nginx/sites-available/$subdomain.$domain
	echo '    allow all;' >> /etc/nginx/sites-available/$subdomain.$domain
	echo '    access_log off;' >> /etc/nginx/sites-available/$subdomain.$domain
	echo '}' >> /etc/nginx/sites-available/$subdomain.$domain
	echo 'location ~ /app/ { deny all; }' >> /etc/nginx/sites-available/$subdomain.$domain
	echo >> /etc/nginx/sites-available/$subdomain.$domain
	echo '# Deny everything else in /addons or /plugins folder except Assets folder in bundles' >> /etc/nginx/sites-available/$subdomain.$domain
	echo 'location ~ /(addons|plugins)/.*/Assets/ {' >> /etc/nginx/sites-available/$subdomain.$domain
	echo '    allow all;' >> /etc/nginx/sites-available/$subdomain.$domain
	echo '    access_log off;' >> /etc/nginx/sites-available/$subdomain.$domain
	echo '}' >> /etc/nginx/sites-available/$subdomain.$domain
	echo 'location ~ /(addons|plugins)/ { deny all; }' >> /etc/nginx/sites-available/$subdomain.$domain
	echo >> /etc/nginx/sites-available/$subdomain.$domain
	echo '# Deny all php files in themes folder' >> /etc/nginx/sites-available/$subdomain.$domain
	echo 'location ~* ^/themes/(.*)\.php {' >> /etc/nginx/sites-available/$subdomain.$domain
	echo '    deny all;' >> /etc/nginx/sites-available/$subdomain.$domain
	echo '}' >> /etc/nginx/sites-available/$subdomain.$domain
	echo >> /etc/nginx/sites-available/$subdomain.$domain
	echo "# Don't log favicon" >> /etc/nginx/sites-available/$subdomain.$domain
	echo 'location = /favicon.ico {' >> /etc/nginx/sites-available/$subdomain.$domain
	echo '    log_not_found off;' >> /etc/nginx/sites-available/$subdomain.$domain
	echo '    access_log off;' >> /etc/nginx/sites-available/$subdomain.$domain
	echo '}' >> /etc/nginx/sites-available/$subdomain.$domain
	echo >> /etc/nginx/sites-available/$subdomain.$domain
	echo "# Don't log robots" >> /etc/nginx/sites-available/$subdomain.$domain
	echo 'location = /robots.txt  {' >> /etc/nginx/sites-available/$subdomain.$domain
	echo '    access_log off;' >> /etc/nginx/sites-available/$subdomain.$domain
	echo '    log_not_found off;' >> /etc/nginx/sites-available/$subdomain.$domain
	echo '}' >> /etc/nginx/sites-available/$subdomain.$domain
	echo >> /etc/nginx/sites-available/$subdomain.$domain
	echo '# Deny yml, twig, markdown, init file access' >> /etc/nginx/sites-available/$subdomain.$domain
	echo 'location ~* /(.*)\.(?:markdown|md|twig|yaml|yml|ht|htaccess|ini)$ {' >> /etc/nginx/sites-available/$subdomain.$domain
	echo '    deny all;' >> /etc/nginx/sites-available/$subdomain.$domain
	echo '    access_log off;' >> /etc/nginx/sites-available/$subdomain.$domain
	echo '    log_not_found off;' >> /etc/nginx/sites-available/$subdomain.$domain
	echo '}' >> /etc/nginx/sites-available/$subdomain.$domain
	echo >> /etc/nginx/sites-available/$subdomain.$domain
	echo "include /var/www/$subdomain.$domain/conf/nginx/*.conf;" >> /etc/nginx/sites-available/$subdomain.$domain
	echo '}' >> /etc/nginx/sites-available/$subdomain.$domain
	sed -i '2ialways_populate_raw_post_data = -1' /etc/php/5.6/fpm/php.ini
	ee stack restart
	read -rsp $'\n\nMautic instalado com sucesso!\n' -n 1 -t 5
fi



### Instala PHPmyadmin
read -r -p $'\n\nInstala PHPmyadmin? S ou [N] ' response
if [[ "$response" =~ ^([sS])+$ ]]
	then
	curl -sS https://getcomposer.org/installer | php -- --filename=composer --install-dir=/usr/local/bin
	ee stack install --phpmyadmin
	cd /var/www/22222/htdocs/db/pma/
	composer install --no-dev
	read -rsp $'\n\nPHPmyadmin instalado com sucesso!\nAcesse o PHPmyadmin: mysite.com:22222/db/pma\n' -n 1 -t 5
fi



### Remove Postfix
read -r -p $'\n\nRemove Postfix? S ou [N] ' response
if [[ "$response" =~ ^([sS])+$ ]]
	then
	read -rsp $'\n\nRemovendo Postfix.\n\n' -n 1 -t 5
	ee stack remove --postfix
	ee stack purge --postfix
	ee stack restart
	read -rsp $'\n\nPostfix removido!\n' -n 1 -t 5
fi