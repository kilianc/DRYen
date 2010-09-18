package org.dryen.events
{
	import flash.events.Event;
	
	public class SoundExtEvent extends Event
	{
		public static const PAUSE:String = "pause";
		public static const STOP:String = "stop";
		
		public function SoundExtEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}