<?php

$use_cache = isset($_GET["cache"]) && $_GET["cache"] == "1";
$file_path = "../../swf/" . base64_decode(urldecode($_GET["path"]));

if(!isset($_GET["path"]) || empty($_GET["path"]) || !file_exists($file_path))
{
	header("HTTP/1.0 404 Not Found"); 
	die("<pre>don't be stupid, " . base64_decode(urldecode($_GET["path"])) . "</pre>");
}

$file_name = md5($_GET["path"]);

if(!file_exists("cache/get_encrypted/$file_name") || !$use_cache)
{
	$file_content = gzdeflate(base64_encode(file_get_contents($file_path)));
	file_put_contents("cache/get_encrypted/$file_name", $file_content);
}

$gmdate_mod = gmdate("D, d M Y H:i:s", filemtime("cache/get_encrypted/$file_name"));

if(!strstr($gmdate_mod, "GMT"))	$gmdate_mod .= " GMT";

header("Accept-Ranges: bytes");
header("Last-Modified: " . $gmdate_mod);
header("Content-Transfer-Encoding: binary");
header("Content-Type: application/octet-stream;");
header("Content-Length: " . filesize("cache/get_encrypted/$file_name"));
header("Content-Disposition: attachment; filename=\"$file_name\";");
header("Cache-Control: max-age=9999, must-revalidate");
header("Expires: " . $gmdate_mod);

readfile("cache/get_encrypted/$file_name");