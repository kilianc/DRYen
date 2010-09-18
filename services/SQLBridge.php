<?php

class SQLBridge
{
	var $dbLink;
	var $dbHost   = '';
	var $dbName   = '';
	var $dbuser   = '';
	var $dbpasswd = '';

	function SQLBridge()
	{
		$this->dbLink = mysql_connect($this->dbHost, $this->dbuser, $this->dbpasswd);
		mysql_select_db ($this->dbName, $this->dbLink);
	}

	function select($queries_list)
	{
		foreach($queries_list as $key => $query_data)
		{
			$query_data["sql"] = _decrypt($query_data["sql"]);

			if(!empty($query_data["fieldToIndex"]))
				$query_data["fieldToIndex"] = _decrypt($query_data["fieldToIndex"]);

			if($this->_checkQuery($query_data["sql"]))
				trigger_error ("You can use onlye the SELECT mysql statement", E_USER_ERROR);

			$result = mysql_query($query_data["sql"], $this->dbLink);

			if(!$result)
			{
				$response["data"][$key] = false;
				continue;
			}

			$row_index = 0;

			while($result_row = mysql_fetch_assoc($result))
			{
				$response["data"][$key][] = $result_row;

				if(empty($query_data["fieldToIndex"])) continue;

				$response["indexes"][$key][$query_data["fieldToIndex"].":".$result_row[$query_data["fieldToIndex"]]] = $row_index++;
			}
		}

		return $response;
	}

	function _checkQuery($sql)
	{
		return preg_match("/insert/i", $sql) || preg_match("/update/i", $sql);
	}
	
	function _xor_encode($source, $key)
	{
		$source_length = strlen($source);
		$key_byte = 0;
		
		for($i = 0; i < strlen($key_byte); $i++)
			$key_byte ^= ord($key[i]);

		for ($i = 0; $i < $source_length; $i++)
			$source[$i] = chr(ord($InputString[$i]) ^ $key_byte);

	    return $source;
	}
}