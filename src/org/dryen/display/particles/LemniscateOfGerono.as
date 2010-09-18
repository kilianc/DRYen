package org.dryen.display.particles
{
	import flash.display.BitmapData;
	import flash.events.Event;

	public class LemniscateOfGerono extends BitmapDataParticle
	{
		private var _t:Number = Math.random();
		private var _tSin:Number;
		
		private var _offsetX:Number = 0;
		private var _offsetY:Number = 0;
		
		public var graphicWidth:Number;
		public var graphicHeight:Number;
		public var velocity:Number;
		
		public function LemniscateOfGerono(figure:BitmapData, graphWidth:Number = 100, graphHeight:Number = 50, velocity:Number = .05,  x:Number = 0, y:Number = 0)
		{
			super(figure);
			
			this.graphicWidth = graphWidth;
			this.graphicHeight = graphHeight;
			this.velocity = velocity;
			
			_offsetX = x;
			_offsetY = y;
		}
		
		override public function update(e:Event=null) : void
		{
			_t += velocity;
			_tSin = Math.sin(_t);
			position.x = _offsetX + graphicWidth * _tSin;
			position.y = _offsetY + graphicHeight * Math.cos(_t) * _tSin;
		}
	}
}