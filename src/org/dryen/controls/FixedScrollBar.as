package org.dryen.controls
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Expo;
	
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.dryen.display.UIAlign;
	import org.dryen.display.UIComponent;
	import org.dryen.events.DynamicEvent;
	
	public class FixedScrollBar extends UIComponent
	{
		protected var _handler:ScrollBarHandler;
		protected var _target:UIComponent;
		protected var _pressY:Number;
		protected var _handlerY:Number;
		
		public var margin:int = 0;
		public var handlerColor:uint = 0xdbbc88;
		public var handlerHeight:uint = 50;
		public var autoHide:Boolean = true;
		public var scrollEase:Function = com.greensock.easing.Expo.easeOut;
		public var easeTime:Number = 1;
		
		public function FixedScrollBar()
		{
			super(false);
			_width = 5;
		}
		
		override public function init():void
		{
			_background.buttonMode = true;
			_background.alpha = 0;
			
			_handler = new ScrollBarHandler();
			_handler.background.color = handlerColor;
			_handler.buttonMode = true;
			_handler.init();
			
			super.init();
			
			addEventListener(Event.ADDED_TO_STAGE, function(e:Event):void {
				stage.addEventListener(MouseEvent.MOUSE_UP, onHandlerRelease);
			});
		}
		
		override public function initPlacement():void
		{
			super.initPlacement();
			
			_handler.setSize(_width, handlerHeight);
			_handler.background.draw();
			_handler.align(UIAlign.CENTER, this);
		}
		
		override protected function addChilds():void
		{
			super.addChilds();
			addChild(_handler);
		}
		
		public function attachTo(target:UIComponent):void
		{
			if(_target)
			{
				_target.removeEventListener(Event.RESIZE, onTargetResize);
				_target.container.removeEventListener(Event.RESIZE, onTargetResize);
				_handler.removeEventListener(MouseEvent.MOUSE_DOWN, onHandlerPress);
				background.removeEventListener(MouseEvent.CLICK, onBackgroundClick);
			}
			
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
			if((newY + _handler.height) > height) newY = Math.round(height - _handler.height);
			
			_handler.y = newY;
			
			TweenLite.to(_target.container, easeTime * uint(!_handler.isTweening), { y: -(_target.container.height - _height) * (_handler.y / (_height - _handler.height)), ease: scrollEase });
		}
		
		public function onBackgroundClick(e:MouseEvent):void
		{
			_handler.isTweening = true;
			
			var newY:Number = e.localY < _handler.y ? e.localY : e.localY - _handler.height;
			
			TweenLite.to(_handler, easeTime, { y: newY, ease: scrollEase, onComplete: function():void {
				_handler.isTweening = false;
			}});
				
			TweenLite.to(_target.container, easeTime, { y: -(_target.container.height - _height) * (newY / (_height - _handler.height)), ease: scrollEase });
		}
		
		public function onTargetResize(e:Event=null):void
		{
			visible = (autoHide && _target.container.height < _target.height);
			
			height = _target.height;
		}
	}
}