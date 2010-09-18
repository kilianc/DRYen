package org.dryen.net
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	
	public class RemoteFileReference extends EventDispatcher
	{
		private var _fileLoader:URLLoader;
		private var _fileSize:Number = -1;
		
		public function RemoteFileReference()
		{
			super();
		}
		
		public function loadFileInfo(url:String):void
		{
			_fileLoader = new URLLoader();
			_fileLoader.dataFormat = URLLoaderDataFormat.BINARY;
			_fileLoader.addEventListener(ProgressEvent.PROGRESS, onProgress);
			_fileLoader.load(new URLRequest(url));
		}
		
		private function onProgress(e:ProgressEvent):void
		{
			_fileLoader.close();
			_fileLoader.removeEventListener(ProgressEvent.PROGRESS, onProgress);
			_fileSize = e.bytesTotal;
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		public function get fileSize():Number
		{
			return _fileSize;
		}
	}
}