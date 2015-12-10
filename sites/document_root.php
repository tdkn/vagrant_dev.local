<?php
$_SERVER['DOCUMENT_ROOT'] = str_replace($_SERVER['SCRIPT_NAME'], '', $_SERVER['SCRIPT_FILENAME']);

if(isset($_SERVER['HTTP_PROXY_CONNECTION'])) {
    unset($_SERVER['HTTP_PROXY_CONNECTION']);
}

if(isset($_SERVER['HTTP_CACHE_CONTROL'])) {
    unset($_SERVER['HTTP_CACHE_CONTROL']);
}

$_SERVER['REQUEST_URI'] = str_replace(array(
    'http://' . $_SERVER['HTTP_HOST'],
    'https://' . $_SERVER['HTTP_HOST']
), '', $_SERVER['REQUEST_URI']);
