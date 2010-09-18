package org.dryen.display.particles
{
	import flash.display.BitmapData;
	import flash.events.*;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	public class SnowFlake extends BitmapDataParticle
	{
		/*
		 * direction constants
		*/
		public static const LEFT:int = -1;
		public static const NONE:int = 0;
		public static const RIGHT:int = 1;
		public static const RANDOM:int = 2;
		
		private var _direction:int;
		private var _wind:Number;
		private var _windDirection:int;
		private var _gravity:Number;
		private var _z:Number;
		private var _hStep:Number;
		private var _vStep:Number;
		private var _sizeVariationPercent:Number;
		private var _originalBitmapData:BitmapData;
		
		public var boundingBox:Rectangle;
		
		public function SnowFlake(figure:BitmapData, boundingBox:Rectangle, sizeVariationPercent:Number = .9, wind:Number = .5, windDirection:int = SnowFlake.RANDOM, gravity:Number = 1)
		{
			super(figure);
			
			_sizeVariationPercent = sizeVariationPercent;
			_wind = wind;
			_windDirection = windDirection;
			_gravity = gravity;
			
			this.boundingBox = boundingBox;
			
			_originalBitmapData = _bitmapData;
			_bitmapData = new BitmapData(_size + _size * sizeVariationPercent, _size + _size * sizeVariationPercent, true, 0);
			
			init();
		}
		
		public function init():void
		{
			var sizeVariationPercent:Number = _sizeVariationPercent - Math.random() * _sizeVariationPercent * 2;
			var size:Number = _size * sizeVariationPercent;
			size *= size < 0 ? -1 : 1;
			
			_z = Math.random() * 1.5 + .1; //used as z-index
			_direction = _windDirection == RANDOM ? (Math.random() < .5 ? -1 : 1) : _windDirection;
			_hStep = _wind * _direction * _z;
			_vStep = _gravity * _gravity * size * _z;
			
			position.x = Math.random() * boundingBox.width;
			position.y = Math.random() * boundingBox.height;
			
			bitmapData.fillRect(bitmapData.rect, 0);
			bitmapData.draw(_originalBitmapData, new Matrix(1 + sizeVariationPercent, 0 , 0, 1 + sizeVariationPercent), new ColorTransform(1, 1, 1, _z), null, null, true);
		}
		
		override public function update(e:Event=null):void
		{
			position.x += _hStep * Math.sin(position.y * 0.05);
			position.y += _vStep;
			
			if(!boundingBox.contains(position.x, position.y)) init();
		}
	}
}