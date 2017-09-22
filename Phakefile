<?php
	define('DEPLOY_PATH', '/srv/www/simple-php-website/current');
	task('default', 'echo "Phake is working"');	

	group('db', function(){
		task('migrate', function(){
			system(DEPLOY_PATH."/bin/phinx -c".DEPLOY_PATH."/phinx.yml migrate -e production");
		});

		task("create_migration", function($args){
			$desc = (!empty($args['desc'])) ? $args['desc'] : 'default migration';
	        	system(DEPLOY_PATH."/bin/phinx -c".DEPLOY_PATH."/phinx.yml create ".$desc);
		});
	});
