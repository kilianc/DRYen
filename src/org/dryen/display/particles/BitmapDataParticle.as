package org.dryen.display.particles
{
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class BitmapDataParticle implements IParticle
	{
		protected var _size:Number;
		protected var _bitmapData:BitmapData;
		protected var _rect:Rectangle;
		
		public var position:Point;
		
		//chain
		public var next:IParticle;
		public var prev:IParticle;
		
		public function BitmapDataParticle(figure:BitmapData, x:Number = 0, y:Number = 0)
		{
			_bitmapData = figure;
			_size = _bitmapData.width;
			_rect = _bitmapData.rect;
			position = new Point(x, y);
		}
		
		public function set x(value:Number):void
		{
			position.x = value;
		}
		
		public function get x():Number
		{
			return position.x;
		}
		
		public function set y(value:Number):void
		{
			position.y = value;
		}
		
		public function get y():Number
		{
			return position.y;
		}
		
		public function move(x:Number, y:Number):void
		{
			position.x = x;
			position.y = y;
		}
		
		public function get bitmapData():BitmapData
		{
			return _bitmapData;
		}
		
		public function get rect():Rectangle
		{
			return _rect;
		}
		
		public function update(e:Event = null):void { }
		
		public function destroy():void { }
	}
}