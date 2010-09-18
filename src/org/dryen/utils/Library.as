package org.dryen.utils
{
	import flash.display.BitmapData;
	import flash.system.ApplicationDomain;
	import flash.text.Font;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	public class Library
	{
		private var _applicationDomain:ApplicationDomain;
		
		public function Library(content:Object, applicationDomain:ApplicationDomain)
		{
			_applicationDomain = applicationDomain;
		}
		
     	public function getFont(className:String):Font
     	{  		
     		return new (_applicationDomain.getDefinition(className))();
     	}
     	
     	public function getBitmapData(className:String, transparent:Boolean = true, fillColor:uint = 0):BitmapData
     	{
     		return new (_applicationDomain.getDefinition(className))(0, 0, transparent, fillColor);
     	}
     	
     	public function getLibraryItem(className:String, ...args):*
     	{
			/*
			* sarebbe stato figo fare così
			* var params:Array = new Array();
			* for (var i:uint=0; i < args.length; i++) params.push("args[" + i + "]");
			* return eval("new " + className + "(" + params.join(",") + ");");
			*/

			var libItemClass:Class = _applicationDomain.getDefinition(className) as Class;
     		var libItem:*;
     		
     		switch(args.length)
     		{
     			case 0:
     				libItem = new libItemClass();
     			break;
     			case 1:
     				libItem = new libItemClass(args[0]);
     			break;
     			case 2:
     				libItem = new libItemClass(args[0], args[1]);
     			break;
     			case 3:
     				libItem = new libItemClass(args[0], args[1], args[2]);
     			break;
     			case 4:
     				libItem = new libItemClass(args[0], args[1], args[2], args[3]);
     			break;
     			case 5:
     				libItem = new libItemClass(args[0], args[1], args[2], args[3], args[4]);
     			break;
     			case 6:
     				libItem = new libItemClass(args[0], args[1], args[2], args[3], args[4], args[5]);
     			break;
     			case 7:
     				libItem = new libItemClass(args[0], args[1], args[2], args[3], args[4], args[5], args[6]);
     			break;
     			case 8:
     				libItem = new libItemClass(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7]);
     			break;
     			case 9:
     				libItem = new libItemClass(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8]);
     			break;
     			case 10:
     				libItem = new libItemClass(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9]);
     			break;
     		}
     		return libItem;
     	}	
	}
}