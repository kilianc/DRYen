package org.dryen.events
{
	public class QueueLoaderEvent extends DynamicEvent
	{
		public static const QUEUE_ITEM_OPEN:String = "queueItemOpen";
		public static const QUEUE_ITEM_COMPLETE:String = "queueItemComplete";
		
		public function QueueLoaderEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}