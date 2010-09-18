package org.dryen.display.particles
{
	import flash.display.BitmapData;
	import flash.display.Shape;
	
	public class StarParticle extends BaseParticle
	{
		public function StarParticle(width:Number = 1, height:Number = 1, color:uint = 0xffffff, alpha:Number = 1)
		{
			var shape:Shape = new Shape();
			shape.graphics.beginFill(color, alpha);
			shape.graphics.drawEllipse(0, 0, width, height);
			
			var figure:BitmapData = new BitmapData(shape.width, shape.height, true, 0);
			figure.draw(shape);
			
			super(figure);
		}
	}
}