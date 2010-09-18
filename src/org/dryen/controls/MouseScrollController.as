package org.dryen.controls
{
	import com.greensock.OverwriteManager;
	import com.greensock.TweenLite;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;

	public class MouseScrollController extends EventDispatcher
	{
		private var _seconds:uint;
		private var _factor:Object;
		private var _container:DisplayObjectContainer;
		private var _content:DisplayObject;
		
		public function MouseScrollController(container:DisplayObjectContainer=null, content:DisplayObject=null, seconds:uint=3)
		{
			super();
			
			this.container = container;
			this.content = content;
			
			_seconds = seconds;
		}

		public function set content(content:DisplayObject):void
		{
			_content = content;
			
			if(_content && _container) updateTweenFactor();
		}
		
		public function get content():DisplayObject {
			return _content;
		}
		
		public function set container(container:DisplayObjectContainer):void
		{
			if(_container)
				_container.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			
			_container = container;
			
			if(_container)
				_container.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			
			if(_content && _container) updateTweenFactor();
		}
		
		public function get container():DisplayObjectContainer
		{
			return _container;
		}

		public function updateTweenFactor():void
		{
			if(!_content || !_container) return;
			
			_factor = { 
				x: (_content.width - _container.width) / _container.width,
				y: (_content.height - _container.height) / _container.height
			};
		}
		
		private function onMouseMove(e:MouseEvent):void
		{
			TweenLite.to(_content, _seconds, { x: (-_container.mouseX * _factor.x), y: (-_container.mouseY * _factor.y), overwrite: OverwriteManager.ALL_IMMEDIATE });
		}
		
		public function stopAll():void
		{
			TweenLite.killTweensOf(_content);
		}
	}
}