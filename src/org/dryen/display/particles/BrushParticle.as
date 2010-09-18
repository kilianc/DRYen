package org.dryen.display.particles
{
	import fl.motion.AdjustColor;
	
	import flash.display.BitmapData;
	import flash.display.Shader;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	public class BrushParticle extends BitmapDataParticle
	{
		protected var _image:BitmapData;
		protected var _imageW:int;
		protected var _boundingBox:Rectangle;
		protected var _brushPixels:Vector.<uint>;
		protected var _brushPixelsNb:int;
		protected var _currentColor:uint;
		
		public var graphicWidth:Number;
		public var graphicHeight:Number;
		public var velocity:Number;
		public var mouseProxy:Object;
		
		public function BrushParticle(figure:BitmapData, image:BitmapData, shader:Shader, x:Number = 0, y:Number = 0, mouseProxy:Object = null)
		{
			super(figure, x, y);
			
			_image = image;
			_imageW = image.width;
			_boundingBox = image.rect;
			_brushPixels = _bitmapData.getVector(_rect);
			_brushPixels.fixed = true;
			_brushPixelsNb = _brushPixels.length;
			
			this.graphicWidth = 100 * Math.random();
			this.graphicHeight = 50 * Math.random();
			this.velocity = .05 * Math.random() + 0.05;
			this.mouseProxy = mouseProxy;
		}

		override public function update(e:Event=null):void
		{
			position.x = mouseProxy.mouseX - 10 * Math.random();
			position.y = mouseProxy.mouseY - 10 * Math.random();
			
//			position.x = Math.random() * _boundingBox.width;
//			position.y = Math.random() * _boundingBox.height;
			
			if(!_boundingBox.contains(position.x, position.y)) return;
			
			_currentColor = _image.getPixel(position.x, position.y);
			
			for(var i:int; i < _brushPixelsNb; ++i) _brushPixels[i] = (_brushPixels[i] >>> 24) << 24 | _currentColor;
			
			_bitmapData.setVector(_rect, _brushPixels);
		}
	}
}