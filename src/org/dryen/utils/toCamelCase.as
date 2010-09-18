package org.dryen.utils
{
	public function toCamelCase(text:String):String
	{
		var words:Array = text.toLowerCase().split(" ");
		
		for(var i:int; i < words.length; ++i)
			words[i] = words[i].charAt(0).toUpperCase() + words[i].substring(1);

		return words.join(" ");
	}
}