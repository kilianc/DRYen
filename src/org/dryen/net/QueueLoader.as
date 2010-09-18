package org.dryen.net
{	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.NetConnection;
	import flash.net.Responder;
	
	import org.dryen.display.Application;
	import org.dryen.events.QueueLoaderEvent;
	
	[Event(name="complete", type="flash.events.Event")]
	[Event(name="httpStatus", type="flash.events.HTTPStatusEvent")]
	[Event(name="ioError", type="flash.events.IOErrorEvent")]
	[Event(name="open", type="flash.events.Event")]
	[Event(name="progress", type="flash.events.ProgressEvent")]
	[Event(name="securityError", type="flash.events.SecurityErrorEvent")]
	[Event(name="queueItempOpen", type="events.QueueLoaderEvent")]
	[Event(name="queueItempComplete", type="events.QueueLoaderEvent")]

	public class QueueLoader extends EventDispatcher
	{
		private var _queueList:Vector.<QueueLoaderItem>;
		private var _defaultScope:Object;
		private var _loader:Loader;
		private var _isLoading:Boolean;
		
		private var _bytesTotal:uint;
		private var _bytesLoaded:uint;
		private var _calculateTotalBytesService:NetConnection;
		private var _calculateTotalBytesResponder:Responder;
		
		public var calculateTotalBytesServiceName:String = "CalculateTotalBytes.calculate";
		public var calculateTotalBytesServiceURL:String = "../frontend/scripts/amfphp/gateway.php";
		public var calculateTotalBytes:Boolean;
		
		public function QueueLoader(scope:Object, calculateTotalBytes:Boolean = false)
		{
			super();
			
			_defaultScope = scope;
			this.calculateTotalBytes = calculateTotalBytes;
			_queueList = new Vector.<QueueLoaderItem>();
			_loader = new Loader();
			
			_loader.addEventListener(Event.OPEN, dispatchQueueItemOpen);
			_loader.addEventListener(Event.COMPLETE, putContent);
			_loader.addEventListener(Event.COMPLETE, dispatchQueueItemComplete);
			_loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, dispatchEvent);
			_loader.addEventListener(IOErrorEvent.IO_ERROR, dispatchEvent);
			_loader.addEventListener(ProgressEvent.PROGRESS, onLoadProgress);
			_loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, dispatchEvent);
			
			_calculateTotalBytesService = new NetConnection();
			_calculateTotalBytesResponder = new Responder(onLoadBytesTotalComplete, onLoadBytesTotalFail);
		}

		public function add(type:uint, url:String, referenceName:String = "", scope:Object = null, obfuscation:String = "AUTO"):void
		{
			_queueList.push(new QueueLoaderItem(type, url, referenceName, scope ? scope : _defaultScope, obfuscation));
		}
		
		public function start():void
		{
			if(_isLoading) throw new Error("Multiple calls to start method, before the end of queue");
			
			_loader.addEventListener(Event.COMPLETE, loadNext);
			
			_isLoading = true;
			
			dispatchEvent(new Event(Event.OPEN));
			
			calculateTotalBytes ? loadBytesTotal() : loadNext();
		}
		
		public function stop():void
		{
			_loader.removeEventListener(Event.COMPLETE, loadNext);

			_loader.close();
			
			_queueList = new Vector.<QueueLoaderItem>();
			
			_isLoading = false;
		}
		
		private function loadBytesTotal():void
		{
			var urls:Object = new Array();
			
			for(var i:int; i < _queueList.length; ++i)
			{
				if(_queueList[i].obfuscation == "ON" || (Loader.globalObfuscation == "ON" && _queueList[i].obfuscation == "AUTO"))
					urls.push(Loader.obfuscateURL(_queueList[i].url));
				else
					urls.push(_queueList[i].url);
			}
			
			_calculateTotalBytesService.connect(calculateTotalBytesServiceURL);
			_calculateTotalBytesService.call(calculateTotalBytesServiceName, _calculateTotalBytesResponder, urls);
		}
		
		private function onLoadBytesTotalFail(e:Object):void
		{
			Application.log(" > onLoadBytesTotalFail: " + e.faultString + ", in " + e.faultDetail);
		}
		
		private function onLoadBytesTotalComplete(e:Object):void
		{
			_calculateTotalBytesService.close();
			
			_bytesTotal = int(e);
			
			Application.log(" > onLoadBytesTotalComplete: " + _bytesTotal + " bytes");
			
			loadNext();
		}
		
		private function loadNext(e:Event = null):void
		{
			if(_queueList.length)
				_loader.loadURL(_queueList[0].url, _queueList[0].type, _queueList[0].obfuscation);
			else
			{
				_isLoading = false;
				_bytesLoaded = 0;
				_bytesTotal = 0;
				dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		private function putContent(e:Event):void
		{
			var queueItem:Object = _queueList[0];
			
			switch(_loader.loaderType)
		    {
		    	case LoaderType.XML:
			    
					queueItem.scope[queueItem.target] = _loader.xml;
			    	break;

				case LoaderType.STYLESHEET:
			    
					queueItem.scope[queueItem.target] = _loader.styleSheet;
			    	break;
			    
				case LoaderType.IMAGE:
			    
					queueItem.scope[queueItem.target] = _loader.image;
			    	break;
				
				case LoaderType.BITMAP:
					
					queueItem.scope[queueItem.target] = _loader.bitmap;
					break;
				
				case LoaderType.BITMAPDATA:
					
					queueItem.scope[queueItem.target] = _loader.bitmapData;
					break;
				
			    case LoaderType.LIBRARY:
			    
					queueItem.scope[queueItem.target] = _loader.library;
			    	break;
				
			    case LoaderType.SWF:
					queueItem.scope[queueItem.target] = _loader.swf;
			    	break;
				
				case LoaderType.TEXT:
				
					queueItem.scope[queueItem.target] = _loader.text;
					break;
				
				case LoaderType.BINARY:
					
					queueItem.scope[queueItem.target] = _loader.bin;
					break;
				
				case LoaderType.SHADER:
					
					queueItem.scope[queueItem.target] = _loader.shader;
					break;
		    }
		}
		
		private function dispatchQueueItemOpen(e:Event):void
		{
			var ev:QueueLoaderEvent = new QueueLoaderEvent(QueueLoaderEvent.QUEUE_ITEM_OPEN);
			ev.data = { queueItem: _queueList[0] };
			dispatchEvent(ev);
		}
		
		private function dispatchQueueItemComplete(e:Event):void
		{
			var ev:QueueLoaderEvent = new QueueLoaderEvent(QueueLoaderEvent.QUEUE_ITEM_COMPLETE);
			ev.data = { queueItem: _queueList.shift() };
			dispatchEvent(ev);
		}

		private function onLoadProgress(e:ProgressEvent):void
		{
			if(calculateTotalBytes)
			{
				if(e.bytesLoaded == e.bytesTotal) 
				{
					_bytesLoaded += e.bytesTotal;
					e.bytesLoaded = _bytesLoaded;
				}
				else e.bytesLoaded = _bytesLoaded + e.bytesLoaded;
				
				e.bytesTotal = _bytesTotal;
			}
			
			dispatchEvent(e);
		}
		
		public function get isLoading():Boolean
		{
			return _isLoading;
		}
	}
}