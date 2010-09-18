package org.dryen.events
{
	public class UIEvent extends DynamicEvent
	{
		public static const SHOW_START:String = "showStart";
		public static const SHOW_COMPLETE:String = "showComplete";
		public static const HIDE_START:String = "hideStart";
		public static const HIDE_COMPLETE:String = "hideComplete";
		
		public function UIEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}