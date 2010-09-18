package org.dryen.display
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;

	public class UIBackground extends Sprite
	{
		protected var _width:Number=0;
		protected var _height:Number=0;
		
		public var color:uint;
		public var pattern:BitmapData;
		public var repeat:String;
	    
		public function UIBackground()
		{
			super();
			
			color = 0xCCCCCC;
			repeat = UIRepeat.NONE;
		}
		
		public function move(x:Number, y:Number):void
		{
			super.x = x;
			super.y = y;
		}
		
		override public function get width():Number
		{
			return _width;
		}
		
		override public function set width(value:Number):void
		{
			_width = value;
		}
		
		override public function get height():Number
		{
			return _height;
		}
		
		override public function set height(value:Number):void
		{
			_height = value;
		}
		
		public function setSize(width:Number, height:Number):void
		{
			_width = width;
			_height = height;
		}
		
		public function drawPattern(drawableObj:DisplayObject):void
		{
			pattern = new BitmapData(drawableObj.width, drawableObj.height, true, 0);
			pattern.draw(drawableObj);
		}
		
		override public function get opaqueBackground():Object { return null; } //deprecated by Dryen		
		override public function set opaqueBackground(value:Object):void {}     //deprecated by Dryen
				
		public function draw(e:Event = null):void
		{
			var bgw:Number;
			var bgh:Number;
			
			graphics.clear();
				
			if(pattern)
			{
				graphics.beginBitmapFill(pattern);
				
				switch(repeat)
				{
					case UIRepeat.NONE:
						
						bgw = pattern.width;
						bgh = pattern.height;
						break;
					
					case UIRepeat.XY:
						
						bgw = _width;
						bgh = _height;
						break;
					
					case UIRepeat.X:
						
						bgw = _width;
						bgh = pattern.height;
						break;
					
					case UIRepeat.Y:
					
						bgw = pattern.width;
						bgh = _height;
						break;
					
					default:
						throw new Error("Invalid repeat property, use one of UIAlign class.");
				}
			}
			else
			{
				bgw = _width;
				bgh = _height;
				graphics.beginFill(color, 1);
			}
				
			graphics.drawRect(0, 0, bgw, bgh);
		}
	}
}