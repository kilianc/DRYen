package org.dryen.display.particles
{
	public class HSBParticle extends BaseParticle
	{
		protected var _colorHSB:Object;
		
		public function HSBParticle(figure:BitmapData = null, size:Number = 1, color:uint = 0xffffffff)
		{
			super(figure, size, color);
			
			_colorHSB = ColorUtil.RGBToHSB(_color);
		}
		
		public function set hue(value:Number):void
		{
			_colorHSB.h = value;
			_color = ColorUtil.HSBToRGB(_colorHSB);
		}
		
		public function get hue():Number
		{
			return _colorHSB.h;
		}
		
		public function set brightness(value:Number):void
		{
			_colorHSB.b = value;
			_color = ColorUtil.HSBToRGB(_colorHSB);
		}
		
		public function get brightness():Number
		{
			return _colorHSB.b;
		}
		
		public function set saturation(value:Number):void
		{
			_colorHSB.s = value;
			_color = ColorUtil.HSBToRGB(_colorHSB);
		}
		
		public function get saturation():Number
		{
			return _colorHSB.s;
		}
	}
}