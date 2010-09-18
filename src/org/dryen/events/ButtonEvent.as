package org.dryen.events
{
	public class ButtonEvent extends DynamicEvent
	{
		public static const CHANGE_STATE:String = "changeState";
		
		public function ButtonEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}