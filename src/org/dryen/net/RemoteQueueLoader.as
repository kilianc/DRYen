package org.dryen.net
{
	import flash.events.Event;
	
	public class RemoteQueueLoader extends QueueLoader
	{
		private var _xmlLoader:org.dryen.net.Loader;
		private var _autoStart:Boolean;
		
		public function RemoteQueueLoader(scope:Object, calculateTotalBytes:Boolean=false)
		{
			super(scope, calculateTotalBytes);
			
			_xmlLoader = new Loader();
			_xmlLoader.addEventListener(Event.COMPLETE, createQueue);
		}
		
		public function loadXMLQueue(url:String):void
		{
			_xmlLoader.loadURL(url, LoaderType.XML);
		}
		
		private function createQueue(e:Event):void
		{
			var xml:XML = _xmlLoader.xml;
			var basePath:String;
			
			for(var i:uint=0; i < _xmlLoader.xml.children().length(); i++)
			{
				basePath = String(xml.item[i].@basePath) ? String(xml.item[i].@basePath) : String(xml.@basePath);
				
				switch(String(xml.item[i].@type))
				{
					case "xml":
						add(LoaderType.XML, basePath + xml.item[i].@url, xml.item[i].@referenceName);
						break;
					case "image":
						add(LoaderType.IMAGE, basePath + xml.item[i].@url , xml.item[i].@referenceName);
						break;
					case "bitmap":
						add(LoaderType.BITMAP, basePath + xml.item[i].@url, xml.item[i].@referenceName);
						break;
					case "bitmapData":
						add(LoaderType.BITMAPDATA, basePath + xml.item[i].@url, xml.item[i].@referenceName);
						break;
					case "library":
						add(LoaderType.LIBRARY, basePath + xml.item[i].@url, xml.item[i].@referenceName);
						break;
					case "font":
						add(LoaderType.FONT, basePath + xml.item[i].@url);
						break;
					case "stylesheet":
						add(LoaderType.STYLESHEET, basePath + xml.item[i].@url, xml.item[i].@referenceName);
						break;
					case "swf":
						add(LoaderType.SWF, basePath + xml.item[i].@url, xml.item[i].@referenceName);
						break;
					case "text":
						add(LoaderType.TEXT, basePath + xml.item[i].@url, xml.item[i].@referenceName);
						break;
					case "binary":
						add(LoaderType.BINARY, basePath + xml.item[i].@url, xml.item[i].@referenceName);
						break;
				}
			}
			
			start();
		}
	}
}