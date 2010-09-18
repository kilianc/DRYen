package org.dryen.display
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.IBitmapDrawable;
	import flash.events.Event;
	import flash.filters.BitmapFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class BitmapDisplayTarget extends Bitmap
	{
		public static const PRE_RENDER:String = "PRE_RENDER";
		public static const POST_RENDER:String = "POST_RENDER";
		
		private var _render_bmpd:BitmapData;
		
		private var _preRenderFiltersList:Vector.<BitmapFilter>;
		private var _postRenderFiltersList:Vector.<BitmapFilter>;
		private var _preRenderFiltersListLength:int;
		private var _postRenderFiltersListLength:int;
		
		private var _preRenderColorTransformList:Vector.<ColorTransform>;
		private var _postRenderColorTransformList:Vector.<ColorTransform>;
		private var _preRenderColorTransformListLength:int;
		private var _postRenderColorTransformListLength:int;
		
		private var _renderFilterPoint:Point;
		
		private var _renderWidth:Number;
		private var _renderHeight:Number;
		
		private var _transparent:Boolean;
		private var _bgColor:uint;
		private var _smoothing:Boolean;
		private var _pixelSnapping:String;
		
		private var _target:IBitmapDrawable;
		
		public function BitmapDisplayTarget(target:IBitmapDrawable, transparent:Boolean = true, bgColor:uint = 0xFF0000, pixelSnapping:String = "auto", smoothing:Boolean = false)
		{
			super(null, pixelSnapping, smoothing);
			
			_transparent = transparent;
			_bgColor = bgColor;
			_smoothing = smoothing;
			_pixelSnapping = pixelSnapping;
			
			if(target) _target = target;
			
			_preRenderFiltersList = new Vector.<BitmapFilter>();
			_postRenderFiltersList = new Vector.<BitmapFilter>();
			_preRenderColorTransformList = new Vector.<ColorTransform>();
			_postRenderColorTransformList = new Vector.<ColorTransform>();
			
			_renderFilterPoint = new Point();
		}
		
		public function setRenderSize(width:Number, height:Number):void
		{
			_renderWidth = width;
			_renderHeight = height;
			
			_render_bmpd = new BitmapData(_renderWidth, _renderHeight, _transparent, _bgColor);
			
			bitmapData = _render_bmpd;
			smoothing = _smoothing;
			pixelSnapping = _pixelSnapping;
		}
		
		public function render(e:Event=null):void
		{
			var i:int;
			
			dispatchEvent(new Event(PRE_RENDER));
			
			_render_bmpd.lock();
			
			for(i = 0; i < _preRenderColorTransformListLength; ++i)
				_render_bmpd.colorTransform(rect, _preRenderColorTransformList[i]);
			
			for(i = 0; i < _preRenderFiltersListLength; ++i)
				_render_bmpd.applyFilter(_render_bmpd, _render_bmpd.rect, _renderFilterPoint, _preRenderFiltersList[i]);
			
			_render_bmpd.draw(_target, null, null, BlendMode.ADD);
			
			for(i = 0; i < _postRenderFiltersListLength; ++i)
				_render_bmpd.applyFilter(_render_bmpd, _render_bmpd.rect, _renderFilterPoint, _postRenderFiltersList[i]);
			
			for(i = 0; i < _postRenderColorTransformListLength; ++i)
				_render_bmpd.colorTransform(rect, _postRenderColorTransformList[i]);
			
			_render_bmpd.unlock();	
			
			dispatchEvent(new Event(POST_RENDER));
		}
		
		private function addPreRenderFilter(filter:BitmapFilter):void
		{
			_preRenderFiltersList.push(filter);
			_preRenderFiltersListLength = _preRenderFiltersList.length;
		}
		
		private function addPostRenderFilter(filter:BitmapFilter):void
		{
			_postRenderFiltersList.push(filter);
			_postRenderFiltersListLength = _postRenderFiltersList.length;
		}
		
		public function addRenderFilter(filter:BitmapFilter, position:String):void
		{
			if(position == POST_RENDER) return addPostRenderFilter(filter);
			if(position == PRE_RENDER) return addPreRenderFilter(filter);
		}
		
		private function addPreRenderColorTransform(filter:ColorTransform):void
		{
			_preRenderColorTransformList.push(filter);
			_preRenderColorTransformListLength = _preRenderColorTransformList.length;
		}
		
		private function addPostRenderColorTransform(filter:ColorTransform):void
		{
			_postRenderColorTransformList.push(filter);
			_postRenderColorTransformListLength = _postRenderColorTransformList.length;
		}
		
		public function addRenderColorTransform(filter:ColorTransform, position:String):void
		{
			if(position == POST_RENDER) return addPostRenderColorTransform(filter);
			if(position == PRE_RENDER) return addPreRenderColorTransform(filter);
		}
		
		public function get rect():Rectangle
		{
			return _render_bmpd.rect;
		}
	}
}