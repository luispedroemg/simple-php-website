<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <title>{$title} | {$siteName}</title>
    <style type="text/css">
        .wrap { max-width: 720px; margin: 50px auto; padding: 30px 40px; text-align: center; box-shadow: 0 4px 25px -4px #9da5ab; }
        article { text-align: left; padding: 40px; line-height: 150%; }
    </style>
    <script type="text/javascript" src="https://cs.nyu.edu/~kapp/cs101/processing_on_the_web/processing.js"></script>
</head>
<body>
<div class="wrap">

    <header>
        <h2>{$siteName}</h2>
        <nav class="menu">
            {$navMenu}
        </nav>
    </header>

    <article>
        <h3>{$pageTitle}</h3>
        {$pageContent}
        {if isset($processingGames)}
            {include file="processing-games.tpl"}
        {/if}
    </article>

    <footer><small>&copy;{$siteName}.<br>{$siteVersion}</small></footer>
</div>
</body>
</html>
