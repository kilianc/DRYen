package org.dryen.display.particles
{
	import flash.display.BitmapData;
	import flash.display.Shape;
	
	
	public class CircleParticle extends BaseParticle
	{
		public function CircleParticle(radius:Number = 1, color:uint = 0xffffff, alpha:Number = 1)
		{
			var shape:Shape = new Shape();
			shape.graphics.beginFill(color, alpha);
			shape.graphics.drawCircle(radius, radius, radius);
			
			var figure:BitmapData = new BitmapData(shape.width, shape.height, true, 0);
			figure.draw(shape);
			
			super(figure);
		}
	}
}