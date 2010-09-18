<?php

class CalculateTotalBytes
{
	var $cacheDir = '../../cache/queue_loader/';
	
	/**
	* Calculate and cache a request size
	* @returns the request size;
	*/
	function calculate($request)
	{
		$cacheName = md5(serialize($request));
		$requestSize = $this->_getCache($cacheName);
		
		if(!$requestSize)
		{
			foreach($request as $url)
			{
				$plain_path = '../../../../swf/' . $url;
				$encoded_path = explode("/", $url);
				$encoded_path = '../../cache/get_encrypted/' . md5(urldecode($encoded_path[2]));
				$base64path = explode('get/', $url);
				$base64path = explode('/', array_pop($base64path));
			
				if(file_exists($plain_path))
					$requestSize += filesize($plain_path);
				elseif(file_exists($encoded_path))
					$requestSize += filesize($encoded_path);
				elseif(@$file = file_get_contents("http://{$_SERVER["SERVER_NAME"]}{$_SERVER["SCRIPT_NAME"]}/../../getencoded.php?path={$base64path[1]}"))
					$requestSize += strlen($file);
				elseif(preg_match("/http:\/\//i", $url))
					$requestSize += strlen(file_get_contents($url));
				else
					trigger_error("File not found: ".$encoded_path. "\n $url", E_USER_ERROR);
			}
			
			$this->_putCache($cacheName, $requestSize);
		}
		
		return $requestSize;
	}
	
	function _getCache($cacheName)
	{
		if(file_exists($this->cacheDir . $cacheName))
			return file_get_contents($this->cacheDir . $cacheName);
		else
			return false;
	}
	
	function _putCache($cacheName, $requestSize)
	{
		file_put_contents($this->cacheDir . $cacheName, $requestSize);
	}
}