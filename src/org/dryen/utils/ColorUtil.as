package org.dryen.utils
{
	
	public class ColorUtil
	{	
		public static function RGBToHSB(color:uint):Object
		{
			var r:uint = color >> 16;
			var g:uint = color >> 8 & 0xFF;
			var b:uint = color & 0xFF;
			
			//normalize all to the range 0 - 1
			var red:Number = r / 0xff;
			var green:Number = g / 0xff;
			var blue:Number = b / 0xff;
			
			var max:Number = Math.max(red, green, blue);
			var min:Number = Math.min(red, green, blue);
			var delta:Number = max - min;
			
			var hue:Number = 0;
			var saturation:Number = 0;
			var brightness:Number = max;
			
			if(delta != 0)
			{
				if(brightness != 0)
				{
					saturation = delta / max;
				}
				
				var tempR:Number = (max - red) / delta;
				var tempG:Number = (max - green) / delta;
				var tempB:Number = (max - blue) / delta;
				
				switch(max)
				{
					case red:
						hue = tempB - tempG;
						break;
					case green:
						hue = 2 + tempR - tempB;
						break;
					case blue:
						hue = 4 + tempG - tempR;
						break;
				}
				hue /= 6;
			}
			if(hue < 0) hue++;
			if(hue > 1) hue--;
			
			//update hue to 0 - 360, saturation and brightness to 0 - 100
			return { h: hue * 360, s: saturation * 100, b: brightness * 100};
		}
		
		public static function HSBToRGB(hsb:Object):uint
		{
			//normalize all to 0 - 1
			var hue:Number = hsb.h / 360 % 1;
			var saturation:Number = hsb.s / 100;
			var brightness:Number = hsb.b / 100;
			
			if(saturation == 0)
			{
				//gray
				return (brightness * 0xff) << 16 | brightness * 0xff << 8 | brightness * 0xff;
			}
			
			var red:Number = 0;
			var green:Number = 0;
			var blue:Number = 0;
			
			var h:Number = hue * 6;
			var i:Number = Math.floor(h);
			var f:Number = h - i;
			var p:Number = brightness * (1 - saturation);
			var q:Number = brightness * (1 - f * saturation);
			//skip r and s because they could cause confusion with red and saturation
			var t:Number = brightness * (1 - (1 - f) * saturation);
			
			switch(i)
			{
				case 0:
					red = brightness;
					green = t;
					blue = p;
					break;
				case 1:
					red = q;
					green = brightness;
					blue = p;
					break;
				case 2:
					red = p;
					green = brightness
					blue = t;
					break;
				case 3:
					red = p
					green = q;
					blue = brightness;
					break;
				case 4:
					red = t;
					green = p;
					blue = brightness;
					break;
				case 5:
					red = brightness;
					green = p;
					blue = q;
					break;
			}
			
			//normalize all to range between 0 - 255
			red = Math.round(red * 0xff);
			green = Math.round(green * 0xff);
			blue = Math.round(blue * 0xff);
			
			return (brightness * red) << 16 | (brightness * green) << 8 | brightness * blue; 
		}
	}
}