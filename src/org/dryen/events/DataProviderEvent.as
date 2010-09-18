package org.dryen.events
{
	public class DataProviderEvent extends DynamicEvent
	{
		public static const COMPLETE:String = "complete";
		public static const ERROR:String = "error";
		
		public var indexes:Object;
		public var faultString:String;
		public var faultDetail:String;
		public var faultCode:String;
		
		public function DataProviderEvent(type:String, response:Object, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			
			if(response.faultString)
			{
				faultCode = response.faultCode;
				faultDetail = response.faultDetail;
				faultString = response.faultString;
			}
			else
			{
				data = response.data;
				indexes = response.indexes;
			}
		}
	}
}