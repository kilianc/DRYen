package org.dryen.display
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;

	public class Image extends UIComponent
	{
		protected var _bitmap:Bitmap;
		protected var _bitmapData:BitmapData;
		protected var _autoSize:Boolean;
		
		public function Image(bitmapData:BitmapData = null, masked:Boolean = false)
		{
			super(masked);
			
			_autoSize = true;
			_bitmapData = bitmapData;
			_bitmap = new Bitmap();
		}
		
		override public function init():void
		{
			bitmapData = _bitmapData;
			
			super.init();
		}
		
		override protected function addChilds():void
		{
			super.addChilds();
			
			container.addChild(_bitmap);
		}
		
		public function set bitmapData(value:BitmapData):void
		{
			_bitmapData = value;
			_bitmap.bitmapData = _bitmapData;
			_bitmap.smoothing = true;
			_bitmap.pixelSnapping = PixelSnapping.ALWAYS;
		
			if(_autoSize) setSize(_bitmapData.width, _bitmapData.height);
		}
		
		public function get bitmapData():BitmapData
		{
			return _bitmapData;
		}
		
		public function get bitmap():Bitmap
		{
			return _bitmap;
		}
		
		public function set autoSize(value:Boolean):void
		{
			if(_autoSize == value) return;
			
			_autoSize = value;
			
			if(!_bitmapData || !_autoSize) return;
			
			setSize(_bitmapData.width, _bitmapData.height);
		}
		
		public function get autoSize():Boolean
		{
			return _autoSize;
		}
		
		override public function set width(value:Number):void
		{
			super.width = value;
			
			if(_mask_sh || !_bitmapData) return;
			
			_bitmap.width = value;
		}
		
		override public function set height(value:Number):void
		{
			super.height = value;
			
			if(_mask_sh || !_bitmapData) return;
			
			_bitmap.height = value;
		}
		
		override public function setSize(width:Number, height:Number):void
		{
			super.setSize(width, height);
			
			if(_mask_sh || !_bitmapData) return;
			
			_bitmap.width = width;
			_bitmap.height = height;
		}
	}
}