<?php

/**
 * Displays site name.
 */
function siteName()
{
    return config('name');
}

/**
 * Displays site version.
 */
function siteVersion()
{
    return config('version');
}

/**
 * Website navigation.
 */
function navMenu($sep = ' | ')
{
    $nav_menu = '';

    foreach (config('nav_menu') as $uri => $name) {
        $nav_menu .= '<a href="/'.(config('pretty_uri') || $uri == '' ? '' : '?page=').$uri.'">'.$name.'</a>'.$sep;
    }

    return trim($nav_menu, $sep);
}

/**
 * Displays page title. It takes the data from 
 * URL, it replaces the hyphens with spaces and 
 * it capitalizes the words.
 */
function pageTitle()
{
    $page = isset($_GET['page']) ? htmlspecialchars($_GET['page']) : 'Home';

    return ucwords(str_replace(array('-', '_'), ' ', $page));
}

/**
 * Displays page content. It takes the data from 
 * the static pages inside the pages/ directory.
 * When not found, display the 404 error page.
 */
function pageContent(Smarty $smarty)
{
    $page = isset($_GET['page']) ? $_GET['page'] : 'home';

    switch ($page) {
        case 'processing_games':
            $path = getcwd().'/'.config('processing_games_path');
            $filesTemp = array_diff(scandir($path), array('.', '..'));
            $files = array();
            foreach ($filesTemp as $f){
                if(preg_match('/^\w+[.]pde$/', $f)){
                    $files[] = $f;
                }
            }
            $smarty->assign('processingGames', $files);
            $smarty->assign('processingGamesPath', config('processing_games_path'));
            break;
    }

    $path = getcwd() . '/' . config('content_path') . '/' . $page . '.html';
    if (file_exists(filter_var($path, FILTER_SANITIZE_URL))) {
        return file_get_contents($path);
    } else {
        return file_get_contents(config('content_path') . '/404.html');
    }
}


/**
 * Starts everything and displays the template.
 */
function run()
{
    $tpl = new SMTemplate();
    $smarty = $tpl->getSmarty();
    $smarty->assign('pageTitle', pageTitle());
    $smarty->assign('pageContent', pageContent($smarty));
    $smarty->assign('navMenu', navMenu());
    $smarty->assign('siteName', siteName());
    $smarty->assign('siteVersion', siteVersion());
    $tpl->render('template');
}
