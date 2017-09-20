<?php
	desc("Migrate the database");
	task('db:migrate', function(){
		system("./bin/phinx migrate");
	});

	desc("Create a phinx db migration (desc)");
	task("db:create_migration", function($args){
		$desc = (!empty($args['desc'])) ? $args['desc'] : 'default migration';
        	system("./bin/phinx create ".$desc);
	});
