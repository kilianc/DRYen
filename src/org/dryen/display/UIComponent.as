package org.dryen.display
{
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.BitmapFilter;
	import flash.text.StyleSheet;
	import flash.utils.ByteArray;
	
	[Event(name="resize", type="flash.events.Event")]
	[Event(name="hideStart", type="events.UIEvent")]
	[Event(name="hideComplete", type="events.UIEvent")]
	[Event(name="showStart", type="events.UIEvent")]
	[Event(name="showComplete", type="events.UIEvent")]

	public class UIComponent extends Sprite
	{
		protected var _width:Number=0;
		protected var _height:Number=0;
		
		protected var _initialized:Boolean;
		protected var _masked:Boolean;
		protected var _background:UIBackground;
		protected var _container:UISprite;
		protected var _mask_sh:Shape;
		protected var _onResize:Boolean;
		
		public var data:Object;
		public var styleSheet:StyleSheet;
		
		public function UIComponent(masked:Boolean = false)
		{
			super();
			
			_background = new UIBackground();
			_container = new UISprite();
			_container.mask = _mask_sh = masked ? new Shape() : null; 
		}
		
		public function move(x:Number, y:Number):void
		{
			super.x = x;
			super.y = y;
		}
		
		override public function get width():Number
		{
			return _width;
		}
		
		override public function set width(value:Number):void
		{
			_width = value;
			_background.width = _width;
			
			if(_mask_sh && _initialized) drawMask();
			
			dispatchEvent(new Event(Event.RESIZE));
		}
		
		override public function get height():Number
		{
			return _height;
		}
		
		override public function set height(value:Number):void
		{
			_height = value;
			_background.height = _height;
			
			if(_mask_sh && _initialized) drawMask();
			
			dispatchEvent(new Event(Event.RESIZE));
		}
		
		public function setSize(width:Number, height:Number):void
		{
			_width = width;
			_height = height;
			_background.setSize(_width, _height);
			
			if(_mask_sh && _initialized) drawMask();
			
			dispatchEvent(new Event(Event.RESIZE));
		}
		
		protected function drawMask():void
		{
			_mask_sh.graphics.clear();
			_mask_sh.graphics.beginFill(0x000000);
			_mask_sh.graphics.drawRect(0, 0, _width, _height);
		}
		
		public function set scale(value:Number):void
		{
			scaleX = scaleY = value;
		}
		
		public function get scale():Number
		{
			return scaleX;
		}
		
		public function init():void
		{
			if(_initialized)
				throw new Error("Double init call, in: " + Object(this).constructor + " first implement the destroy method");
			
			initPlacement();
			onResize();
			addChilds();
			
			_initialized = true;
			
			activateOnResize(true);
		}
		
		public function initPlacement():void
		{
			if(_mask_sh) drawMask();
		}
		
		protected function addChilds():void
		{
			addChild(_background);
			addChild(_container);
			
			if(_mask_sh) addChild(_mask_sh);
		}
		
		public function activateOnResize(value:Boolean):void
		{
			if(_onResize == value) return;
			
			if(value) addEventListener(Event.RESIZE, onResize);
			else removeEventListener(Event.RESIZE, onResize);
		}
		
		public function onResize(e:Event = null):void
		{
			
		}
		
		override public function get opaqueBackground():Object { return null; }
		override public function set opaqueBackground(value:Object):void {}     //deprecated by Dryen
		
		public function get background():UIBackground
		{
			return _background;
		}
		
		public function get container():UISprite
		{
			return _container;
		}
		
		protected function get initialized():Boolean
		{
			return _initialized;
		}
		
		public function destroy():void
		{
			_initialized = false;
			
			if(_onResize) removeEventListener(Event.RESIZE, onResize);
		}
		
		public function addFilter(value:BitmapFilter):void
		{
			var tmpArray:Array = super.filters;
			tmpArray.push(value);
			super.filters = tmpArray;
		}
		
		public function align(position:String, parent:DisplayObject, offset:Object = null, snapToPixel:Boolean = false):void
		{
			UIAlign.to(position, this, parent, offset, snapToPixel);
		}
		
		public function clone():UIComponent
		{
			var bytes:ByteArray = new ByteArray();
			bytes.writeObject(this);
			bytes.position = 0;
			
			return bytes.readObject() as UIComponent;
		}
	}
}