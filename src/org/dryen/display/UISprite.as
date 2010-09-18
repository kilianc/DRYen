package org.dryen.display
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	
	/**
	 * This class extends Sprite and add some feature, it dispatchs
	 * a resize event every time it is scaled or its childs move or resize.
	 * Dimensions are owerrided by a 0,0 acsis logic based on content position and dimensions.
	 * @author kilian
	 * 
	 */
	public class UISprite extends Sprite
	{
		private var _contentRect:Rectangle;
		private var _oldContentRect:Rectangle;
		private var _dispatchResizeEvent:Boolean;
		private var _boundsTimer:Timer;
		
		public function UISprite(dispatchResize:Boolean = false)
		{
			super();
			
			this.dispatchResizeEvent = dispatchResize;
		}
		
		override public function get width():Number
		{
			_contentRect = getBounds(this);
			return _contentRect.right;
		}
		
		override public function get height():Number
		{
			_contentRect = getBounds(this);
			return _contentRect.bottom;
		}
		
		public function set dispatchResizeEvent(value:Boolean):void
		{
			if(value == _dispatchResizeEvent) return;
			
			_dispatchResizeEvent = value;
			
			if(_dispatchResizeEvent) 
			{
				_contentRect = getBounds(this);
				
				_boundsTimer = new Timer(10);
				_boundsTimer.addEventListener(TimerEvent.TIMER, checkToDispatchResizeEvent);
				_boundsTimer.start();
			}
			else
			{
				_boundsTimer.stop();
				_boundsTimer.removeEventListener(TimerEvent.TIMER, checkToDispatchResizeEvent);
				_boundsTimer = null;
			}
		}
		
		public function get dispatchResizeEvent():Boolean
		{
			return _dispatchResizeEvent;
		}

		private function checkToDispatchResizeEvent(e:TimerEvent):void
		{
			_oldContentRect = _contentRect;
			_contentRect = getBounds(this);
			_oldContentRect.equals(_contentRect) ? null : dispatchEvent(new Event(Event.RESIZE));
		}
	}
}