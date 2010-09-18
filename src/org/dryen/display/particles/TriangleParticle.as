package org.dryen.display.particles
{
	import flash.display.BitmapData;
	import flash.display.Shape;
	
	public class TriangleParticle extends BaseParticle
	{
		public function TriangleParticle(width:Number = 1, height:Number = 1, color:uint = 0xffffff, alpha:Number = 1)
		{
			var shape:Shape = new Shape();
			shape.graphics.beginFill(color, alpha);
			shape.graphics.moveTo(0, height);
			shape.graphics.lineTo(width, height);
			shape.graphics.lineTo(width * .5, 0);
			shape.graphics.lineTo(0, height);
			
			var figure:BitmapData = new BitmapData(shape.width, shape.height, true, 0);
			figure.draw(shape);
			
			super(figure);
		}
	}
}