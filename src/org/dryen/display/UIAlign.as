package org.dryen.display
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	public class UIAlign
	{
		//single align
		public static const LEFT:String = "LEFT";
		public static const CENTER:String = "CENTER";
		public static const RIGHT:String = "RIGHT";
		public static const TOP:String = "TOP";
		public static const MIDDLE:String = "MIDDLE";
		public static const BOTTOM:String = "BOTTOM";
		//bidirectional align
		public static const TOP_CENTER:String = "TOP_CENTER";
		public static const TOP_LEFT:String = "TOP_LEFT";
		public static const TOP_RIGHT:String = "TOP_RIGHT";
		public static const MIDDLE_CENTER:String = "MIDDLE_CENTER";
		public static const MIDDLE_LEFT:String = "MIDDLE_LEFT";
		public static const MIDDLE_RIGHT:String = "MIDDLE_RIGHT";
		public static const BOTTOM_CENTER:String = "BOTTOM_CENTER";
		public static const BOTTOM_LEFT:String = "BOTTOM_LEFT";
		public static const BOTTOM_RIGHT:String = "BOTTOM_RIGHT";
		
		public static function to(position:String, target:DisplayObject, parent:DisplayObject, offset:Object = null, snapToPixel:Boolean = false):void
		{
			if(!parent) throw new Error("Parent container must be not null");
			
			offset = offset ? offset : new Object();
			offset.x = offset.x ? offset.x : 0;
			offset.y = offset.y ? offset.y : 0;
			
			switch(position)
			{
				case UIAlign.CENTER:
					target.x = snapToPixel ? Math.round((parent.width - target.width) * .5 + offset.x) : (parent.width - target.width) * .5 + offset.x;
					break;
				case UIAlign.LEFT:
					target.x = 0
					break;
				case UIAlign.RIGHT:
					target.x = snapToPixel ? Math.round(parent.width - target.width + offset.x) : parent.width - target.width + offset.x;
					break;
				case UIAlign.TOP:
					target.y = snapToPixel ? Math.round(0 + offset.y) : 0 + offset.y;
					break;
				case UIAlign.MIDDLE:
					target.y = snapToPixel ? Math.round((parent.height - target.height) * .5 + offset.y) : (parent.height - target.height) * .5 + offset.y;
					break;
				case UIAlign.BOTTOM:
					target.y = snapToPixel ? Math.round(parent.height - target.height + offset.y) : parent.height - target.height + offset.y;
					break;
				case UIAlign.BOTTOM_CENTER:
					target.x = snapToPixel ? Math.round((parent.width - target.width) * .5 + offset.x) : (parent.width - target.width) * .5 + offset.x;
					target.y = snapToPixel ? Math.round(parent.height - target.height + offset.y) : parent.height - target.height + offset.y;
					break;
				case UIAlign.BOTTOM_LEFT:
					target.x = snapToPixel ? Math.round(0 + offset.x) : 0 + offset.x;
					target.y = snapToPixel ? Math.round(parent.height - target.height + offset.y) : parent.height - target.height + offset.y;
					break;
				case UIAlign.BOTTOM_RIGHT:
					target.x = snapToPixel ? Math.round(parent.width - target.width + offset.x) : parent.width - target.width + offset.x;
					target.y = snapToPixel ? Math.round(parent.height - target.height + offset.y) : parent.height - target.height + offset.y;
					break;
				case UIAlign.MIDDLE_CENTER:
					target.x = snapToPixel ? Math.round((parent.width - target.width) * .5 + offset.x) : (parent.width - target.width) * .5 + offset.x;
					target.y = snapToPixel ? Math.round((parent.height - target.height) * .5 + offset.y) : (parent.height - target.height) * .5 + offset.y;
					break;
				case UIAlign.MIDDLE_LEFT:
					target.x = snapToPixel ? Math.round(0 + offset.x) : 0 + offset.x;
					target.y = snapToPixel ? Math.round((parent.height - target.height) * .5 + offset.y) : (parent.height - target.height) * .5 + offset.y;
					break;
				case UIAlign.MIDDLE_RIGHT:
					target.x = snapToPixel ? Math.round(parent.width - target.width + offset.x) : parent.width - target.width + offset.x;
					target.y = snapToPixel ? Math.round((parent.height - target.height) * .5 + offset.y) : (parent.height - target.height) * .5 + offset.y;
					break;
				case UIAlign.TOP_CENTER:
					target.x = snapToPixel ? Math.round((parent.width - target.width) * .5 + offset.x) : (parent.width - target.width) * .5 + offset.x;
					target.y = snapToPixel ? Math.round(0 + offset.y) : 0 + offset.y;
					break;
				case UIAlign.TOP_LEFT:
					target.x = snapToPixel ? Math.round(0 + offset.x) : 0 + offset.x;
					target.y = snapToPixel ? Math.round(0 + offset.y) : 0 + offset.y;
					break;
				case UIAlign.TOP_RIGHT:
					target.x = snapToPixel ? Math.round(parent.width - target.width + offset.x) : parent.width - target.width + offset.x;
					target.y = snapToPixel ? Math.round(0 + offset.y) : 0 + offset.y;
					break;
			}
		}
	}
}