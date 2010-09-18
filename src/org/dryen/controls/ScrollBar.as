package org.dryen.controls
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Expo;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.dryen.display.UIAlign;
	import org.dryen.display.UIComponent;
	import org.dryen.events.UIEvent;
	
	public class ScrollBar extends UIComponent
	{
		private var _handler:ScrollBarHandler;
		private var _target:UIComponent;
		private var _pressY:Number;
		private var _handlerY:Number;
		private var _assetsList:Object;
		private var _ratio:Number;
		
		public var margin:int = 0;
		public var handlerColor:uint = 0xdbbc88;
		public var autoHide:Boolean = true;
		public var scrollEase:Function = com.greensock.easing.Expo.easeOut;
		public var easeTime:Number = 1;
		public var inside:Boolean;
		
		public function ScrollBar(masked:Boolean=true)
		{
			super(false);
			
			_width = 10;
		}
		
		public function set assetsList(value:Object):void
		{
			_assetsList = value;
		}
		
		override public function init():void
		{
			_handler = new ScrollBarHandler();
			_handler.background.color = handlerColor;
			
			_handler.buttonMode = true;
			_handler.init();
			
			super.init();
			
			addEventListener(Event.ADDED_TO_STAGE, function(e:Event):void {
				stage.addEventListener(MouseEvent.MOUSE_UP, onHandlerRelease);
			});
		}
		
		override protected function addChilds():void
		{
			super.addChilds();
			
			addChild(_handler);
		}
		
		public function reset():void
		{
			_handler.y = 0;
		}
		
		public function attachTo(target:UIComponent):void
		{
			//se era già attaccato lo stacco
			if(_target)
			{
				_target.removeEventListener(Event.RESIZE, onTargetResize);
				
				_target.container.removeEventListener(Event.RESIZE, onTargetResize);
				
				_handler.removeEventListener(MouseEvent.MOUSE_DOWN, onHandlerPress);
				
				background.removeEventListener(MouseEvent.CLICK, onBackgroundClick);
			}
			
			//se gli passo un elemento lo attacco, se gli passo null no (stacco se era attaccato)
			if(target)
			{
				_target = target;
				
				_target.addEventListener(Event.RESIZE, onTargetResize);
				
				_target.container.addEventListener(Event.RESIZE, onTargetResize);
				
				_handler.addEventListener(MouseEvent.MOUSE_DOWN, onHandlerPress);
				
				background.addEventListener(MouseEvent.CLICK, onBackgroundClick);
				
				onTargetResize();
			}
		}
		
		public function onHandlerPress(e:MouseEvent):void
		{
			_pressY = stage.mouseY;
			_handlerY = _handler.y;
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		}
		
		public function onHandlerRelease(e:MouseEvent):void
		{
			if(!stage) return;
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		}
		
		public function onMouseMove(e:MouseEvent):void
		{
			var newY:Number = _handlerY + stage.mouseY - _pressY;
			
			if(newY < 0) newY = 0;
			if((newY + _handler.height) > height) newY = height - _handler.height;
			
			_handler.y = newY;
		}
		
		public function onHandlerMove(e:Event):void
		{
			TweenLite.to(_target.container, easeTime * uint(!_handler.isTweening), { y: -(_handler.y / _ratio), ease: scrollEase });
		}
		
		public function onBackgroundClick(e:MouseEvent):void
		{
			_handler.isTweening = true;
			
			var newY:Number = e.localY < _handler.y ? e.localY : e.localY - _handler.height;
			
			TweenLite.to(_handler, easeTime, { y: newY, ease: scrollEase, onComplete: function():void {
				_handler.isTweening = false;
			}});
		}
				
		public function updateHandlerHeight():void
		{
			var newH:Number = height * _ratio;
			if(newH > height) newH = height;
			
			var newY:Number = -_target.container.y * _ratio;
			if((newY + newH) > height) newY = height - newH;
			
			_handler.height = newH;
			_handler.y = newY;
			
			if(autoHide && newH == height) 
			{
				_handler.visible = false;
				background.visible = false;
			}
			else
			{
				_handler.visible = true;
				background.visible = true;
			}
		}
		
		public function onTargetMove(e:Event):void
		{
			if(inside) return;

			x = _target.x + _target.width - width + margin;
			y = _target.y;
		}
		
		public function onTargetResize(e:Event=null):void
		{
			_ratio = _target.height / _target.container.height;
			
			if(!inside)
			{
				x = _target.x + _target.width - width + margin;
				y = _target.y;
			}
			
			height = _target.height;
			
			updateHandlerHeight();
		}
		
		override public function initPlacement():void
		{
			super.initPlacement();
			
			_handler.align(UIAlign.CENTER, this);
		}		
	}
}