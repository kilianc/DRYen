package org.dryen.net
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Shader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.text.StyleSheet;
	import flash.utils.ByteArray;
	
	import org.dryen.display.Application;
	import org.dryen.display.Image;
	import org.dryen.encoding.Base64;
	import org.dryen.utils.Library;
	
	import ru.etcs.utils.FontLoader;
	
	[Event(name="complete", type="flash.events.Event")]
	[Event(name="httpStatus", type="flash.events.HTTPStatusEvent")]
	[Event(name="init", type="flash.events.Event")]
	[Event(name="ioError", type="flash.events.IOErrorEvent")]
	[Event(name="open", type="flash.events.Event")]
	[Event(name="progress", type="flash.events.ProgressEvent")]
	[Event(name="securityError", type="flash.events.SecurityErrorEvent")]
	[Event(name="unload", type="flash.events.Event")]
	
	public class Loader extends EventDispatcher
	{
		//static confuguration
		public static var useObfuscationCache:Boolean = false;
		public static var obfuscationServiceBasePath:String = "../";
		public static var verbose:Boolean;
		public static var globalObfuscation:String = "OFF";
		private static var _obfuscationByteArray:ByteArray;
		
		private var _loaderType:uint;
		
		//internal loaders
		private var _dataLoader:URLLoader;
		private var _encryptedDataLoader:URLLoader;
		private var _displayLoader:flash.display.Loader;
		private var _fontLoader:FontLoader;
		
		private var _request:URLRequest;
		
		//data holders
		private var _image:Image;
		private var _bitmapData:BitmapData;
		private var _bitmap:Bitmap;
		private var _xml:XML;
		private var _library:Library;
		private var _styleSheet:StyleSheet;
		private var _swf:DisplayObject;
		private var _bin:ByteArray;
		private var _txt:String;
		private var _shader:Shader;
		
		private var _decryptedData:ByteArray;
		
		public function Loader()
		{
			super();
			
			_dataLoader = new URLLoader();
			_displayLoader = new flash.display.Loader();
			_fontLoader = new FontLoader();
			_request = new URLRequest();
			
			_encryptedDataLoader = new URLLoader();
			_encryptedDataLoader.dataFormat = URLLoaderDataFormat.BINARY;
			
			_obfuscationByteArray = new ByteArray();
			
			configureEvents();
		}
		
		private function configureEvents():void
		{
			_dataLoader.addEventListener(Event.COMPLETE, onLoadComplete);
			_dataLoader.addEventListener(Event.COMPLETE, dispatchEvent);
			_dataLoader.addEventListener(Event.OPEN, dispatchEvent);
			_dataLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, dispatchEvent);
			_dataLoader.addEventListener(IOErrorEvent.IO_ERROR, dispatchEvent);
			_dataLoader.addEventListener(ProgressEvent.PROGRESS, dispatchEvent);
			_dataLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, dispatchEvent);
			
			_encryptedDataLoader.addEventListener(Event.COMPLETE, onEncryptedLoadComplete);
			_encryptedDataLoader.addEventListener(Event.OPEN, dispatchEvent);
			_encryptedDataLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, dispatchEvent);
			_encryptedDataLoader.addEventListener(IOErrorEvent.IO_ERROR, dispatchEvent);
			_encryptedDataLoader.addEventListener(ProgressEvent.PROGRESS, dispatchEvent);
			_encryptedDataLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, dispatchEvent);
			
			_displayLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete);
			_displayLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, unload);
			_displayLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, dispatchEvent);
			_displayLoader.contentLoaderInfo.addEventListener(Event.INIT, dispatchEvent);
			_displayLoader.contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS, dispatchEvent);
			_displayLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, dispatchEvent);
			_displayLoader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, dispatchEvent);
			
			_fontLoader.addEventListener(Event.COMPLETE, notifyFonts);
			_fontLoader.addEventListener(Event.COMPLETE, dispatchEvent);
		}

		public function loadURL(url:String, loaderType:uint, obfuscation:String = "AUTO", loaderContext:LoaderContext=null):void
		{
			_loaderType = loaderType;
			_request.url = url;
			
			if(obfuscation == "ON" || globalObfuscation == "ON" && obfuscation == "AUTO")
			{
				_request.url = obfuscateURL(_request.url);
				_encryptedDataLoader.load(_request);
				return;
			}
			
			_dataLoader.dataFormat = URLLoaderDataFormat.TEXT;
			
			switch(_loaderType)
			{
				case LoaderType.IMAGE:
				case LoaderType.BITMAP:
				case LoaderType.BITMAPDATA:
				case LoaderType.SWF:
				case LoaderType.LIBRARY:
					
					_displayLoader.contentLoaderInfo.addEventListener(Event.OPEN, dispatchEvent);
					_displayLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, dispatchEvent);
					_displayLoader.unload();
					_displayLoader.load(_request, loaderContext);
					
					break;
				
				case LoaderType.FONT:
				case LoaderType.SHADER:
				case LoaderType.BINARY:
					
					_dataLoader.dataFormat = URLLoaderDataFormat.BINARY;
					
				case LoaderType.XML:
				case LoaderType.STYLESHEET:
				case LoaderType.TEXT:
					
					_dataLoader.load(_request);
					
					break;
				
				default:
					throw new Error("Unknow LoaderType");
			}
		}
		
		public function close():void
		{
			try {
				_displayLoader.contentLoaderInfo.removeEventListener(Event.OPEN, dispatchEvent);
				_displayLoader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, dispatchEvent);
				_displayLoader.close();
			}
			catch(e:Error) {}
			
			try {
				_dataLoader.close();
			}
			catch(e:Error) {}
			
			try {
				_encryptedDataLoader.close();
			}
			catch(e:Error) {}
			
			try {
				_fontLoader.close();
			}
			catch(e:Error) {}
		}

		private function onEncryptedLoadComplete(e:Event):void
		{
			_decryptedData = _encryptedDataLoader.data as ByteArray;
			_decryptedData.inflate();
			_decryptedData = Base64.decode(_decryptedData.readUTFBytes(_decryptedData.length));
			
			switch(_loaderType)
			{
				case LoaderType.IMAGE:
				case LoaderType.BITMAP:
				case LoaderType.BITMAPDATA:
				case LoaderType.SWF:
				case LoaderType.LIBRARY:
					
					_displayLoader.unload();
					_displayLoader.loadBytes(_decryptedData);
					
					break;
				
				case LoaderType.FONT:
				case LoaderType.SHADER:
				case LoaderType.BINARY:
				case LoaderType.XML:
				case LoaderType.STYLESHEET:
				case LoaderType.TEXT:
					
					_dataLoader.data = ByteArray(_decryptedData);
					_dataLoader.dispatchEvent(new Event(Event.COMPLETE));
					
					break;
				
				default:
					throw new Error("Unknow LoaderType");
			}
		}
		
		private function onLoadComplete(e:Event):void
		{
			_displayLoader.contentLoaderInfo.removeEventListener(Event.OPEN, dispatchEvent);
			_displayLoader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, dispatchEvent);

			switch(_loaderType)
			{
				case LoaderType.BITMAPDATA:
				case LoaderType.BITMAP:
					
					_bitmap = Bitmap(_displayLoader.content);
					_bitmapData = _bitmap.bitmapData;
					break;
				
				case LoaderType.IMAGE:
				
					_bitmap = Bitmap(_displayLoader.content);
					_bitmapData = _bitmap.bitmapData;
					_image = new Image(_bitmapData);
					break;
				
				case LoaderType.SWF:
					
					_swf = _displayLoader.content;
					break;
				
				case LoaderType.LIBRARY:
				
					_library = new Library(_displayLoader.content, _displayLoader.contentLoaderInfo.applicationDomain);
					break;
				
				case LoaderType.FONT:
					
					_fontLoader.loadBytes(_dataLoader.data as ByteArray);
					e.stopImmediatePropagation();
					break;
				
				case LoaderType.BINARY:
					
					_bin = _dataLoader.data;
					break;
				
				case LoaderType.SHADER:
					
					_shader = new Shader(_dataLoader.data as ByteArray);
					break;
				
				case LoaderType.XML:
					
					_xml = new XML(_dataLoader.data);
					break;
				
				case LoaderType.STYLESHEET:
					
					_styleSheet = new StyleSheet();
					_styleSheet.parseCSS(_dataLoader.data);
					break;
				
				case LoaderType.TEXT:
					
					_txt = _dataLoader.data;
					break;
			}
		}
		
		private function notifyFonts(e:Event):void
		{
			Application.log("> New fonts embedded, currently fonts aviable:");
			for(var i:int; i < _fontLoader.fonts.length; ++i) Application.log(" > '" + _fontLoader.fonts[i].fontName + "' : '" + _fontLoader.fonts[i].fontStyle + "' : '" + _fontLoader.fonts[i].fontType + "'");
		}
		
		private function unload(e:Event):void
		{
			_displayLoader.unload();
		}
		
		public function get loaderType():uint
		{
			return _loaderType;
		}
		
		public static function obfuscateURL(url:String):String
		{
			_obfuscationByteArray.writeUTFBytes(url);
			
			url = obfuscationServiceBasePath + "get/" + int(useObfuscationCache) + "/" + escape(Base64.encode(_obfuscationByteArray));
			
			_obfuscationByteArray.clear();
			
			if(verbose) Application.log(" > Obfuscating url (Cache " + (useObfuscationCache ? "ON" : "OFF") + "): " + url);
			
			return url;
		}
		
		public function get image():Image
		{
			return _image;
		}
		
		public function get bitmap():Bitmap
		{
			return _bitmap;
		}
		
		public function get bitmapData():BitmapData
		{
			return _bitmapData;
		}
		
		public function get swf():DisplayObject
		{
			return _swf;
		}
		
		public function get bin():ByteArray
		{
			return _bin;
		}
		
		public function get text():String
		{
			return _txt;
		}
		
		public function get xml():XML
		{
			return _xml;
		}
		
		public function get styleSheet():StyleSheet
		{
			return _styleSheet;
		}
		
		public function get library():Library
		{
			return _library;
		}
		
		public function get shader():Shader
		{
			return _shader;
		}
	}
}