package org.dryen.display.particles
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	public class SandLightParticle extends BitmapDataParticle
	{
		protected var _image:BitmapData;
		protected var _boundingBox:Rectangle;
		protected var _pixels:Vector.<uint>;
		protected var _pixelsNb:int;
		protected var _friction:Number = 1;
		protected var _light:Number;
		protected var _currentColor:Number;
		protected var _alpha:uint;
		protected var _velocity:Number;
		protected var _mouseProxy:DisplayObject;
		
		public var emit:Boolean;
		
		public function SandLightParticle(figure:BitmapData, image:BitmapData, mouseProxy:DisplayObject, velocity:Number=5)
		{
			super(figure, -1, -1);
			
			_image = image;
			_boundingBox = image.rect;
			_pixels = _bitmapData.getVector(_rect);
			_pixels.fixed = true;
			_pixelsNb = _pixels.length;
			_velocity = velocity;
			_mouseProxy = mouseProxy;
		}
		
		public function init():void
		{
			if(!emit) return;
			
			position.x = _mouseProxy.mouseX + Math.random() * 40 - 20;
			position.y = _mouseProxy.mouseY + Math.random() * 40 - 20;
		}
		
		override public function update(e:Event = null):void
		{
			position.x -= position.y * _friction * .1;
			position.y += _velocity * _friction * 10;
			/*
			position.x -= 1; 
			position.y += _velocity;*/
			
			if(!_boundingBox.contains(position.x, position.y)) init();
			
			_currentColor = _image.getPixel(position.x, position.y);
			_light = _currentColor / 0xffffff;
			_friction = 1 - _light + .001;
			_alpha = uint(0xff * (_light ? _light : .3)) << 24;
//			trace(_alpha.toString(16), _light);
//			trace(_currentColor.toString(16), _light.toString(16), _friction.toString(16), _alpha.toString(16));
			
			for(var i:int; i < _pixelsNb; ++i) {
				_pixels[i] = _alpha | uint(_pixels[i] << 8 >>> 8);
			}
			
			_bitmapData.setVector(_rect, _pixels);
		}
	}
}