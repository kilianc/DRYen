package org.dryen.net
{
	import flash.events.AsyncErrorEvent;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.NetConnection;
	import flash.net.Responder;
	
	import org.dryen.encoding.XOR;
	import org.dryen.events.DataProviderEvent;
	
	[Event(name="error", type="events.DataProviderEvent")]
	[Event(name="complete", type="events.DataProviderEvent")]
	
	[Event(name="asyncError", type="flash.events.AsyncErrorEvent")]
	[Event(name="ioError", type="flash.events.IOErrorEvent")]
	[Event(name="netStatus", type="flash.events.NetStatusEvent")]
	[Event(name="securityError", type="flash.events.SecurityErrorEvent")]
	
	public class DataProvider extends EventDispatcher
	{
		private const SERVICE_NAME:String = "SQLBridge.select";
		
		private var _dataProviderService:NetConnection;
		private var _dataProviderResponder:Responder;
		
		private var _queryList:Object;
		private var _data:Object;
		
		public var gatewayUrl:String;
		
		public function DataProvider(gatewayUrl:String)
		{
			super();
			
			this.gatewayUrl = gatewayUrl;
			_queryList = new Object();
		}
		
		public function get connected():Boolean
		{
			return _dataProviderService.connected;
		}
		
		public function addQuery(label:String, sql:String, fieldToIndex:String = ""):void
		{
			_queryList[label] = { sql: sql, fieldToIndex: fieldToIndex };
		}
		
		public function execute():void
		{
			if(!_dataProviderService)
			{
				_dataProviderService = new NetConnection();
				_dataProviderService.addEventListener(AsyncErrorEvent.ASYNC_ERROR, dispatchEvent);
				_dataProviderService.addEventListener(IOErrorEvent.IO_ERROR, dispatchEvent);
				_dataProviderService.addEventListener(NetStatusEvent.NET_STATUS, dispatchEvent);
				_dataProviderService.addEventListener(SecurityErrorEvent.SECURITY_ERROR, dispatchEvent);
				
				_dataProviderResponder = new Responder(onLoadDataComplete, onLoadDataFail);
			}
			
			_dataProviderService.connect(gatewayUrl);
			_dataProviderService.call(SERVICE_NAME, _dataProviderResponder, _queryList);
		}
		
		private function onLoadDataComplete(data:Object):void
		{
			_data = data;
			_dataProviderService.close();
			dispatchEvent(new DataProviderEvent(DataProviderEvent.COMPLETE, _data));
		}
		
		private function onLoadDataFail(error:Object):void
		{
			_dataProviderService.close();
			dispatchEvent(new DataProviderEvent(DataProviderEvent.ERROR, error));
		}
		
		public function get data():Object
		{
			return _data;
		}
	}
}