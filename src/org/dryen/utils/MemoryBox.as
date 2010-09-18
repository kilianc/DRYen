package org.dryen.utils
{
	import flash.events.TimerEvent;
	import flash.system.System;
	import flash.text.TextField;
	import flash.utils.Timer;
	
	import org.dryen.display.UIAlign;
	import org.dryen.display.UIComponent;
	
	public class MemoryBox extends UIComponent
	{
		private var _updateLabeltimer:Timer;
		private var _label_tf:TextField;
		private var _maxMemory:Number = 0;
		private var _currentMemory:Number = 0;
		private var _megabyteFraction:Number = 1 / (1024 * 1024);
		
		public function MemoryBox(masked:Boolean=false)
		{
			super(masked);
			
			_updateLabeltimer = new Timer(1000);
			
			_label_tf = new TextField();
			
			trace();
		}
		
		override public function init():void
		{
			_background.alpha = .5
			_background.color = 0x555555;
			
			_label_tf.selectable = false;
			_label_tf.tabEnabled = false;
			updateLabel(null);
			
			super.init();
			
			_updateLabeltimer.addEventListener(TimerEvent.TIMER, updateLabel);
			_updateLabeltimer.start();
		}
		
		override public function initPlacement():void
		{
			super.initPlacement();
			
			_label_tf.width = width;
			_label_tf.height = 12 + 2;
			UIAlign.to(UIAlign.MIDDLE_CENTER, _label_tf, this);
		}
		
		override protected function addChilds():void
		{
			super.addChilds();
			
			addChild(_label_tf);
		}
		
		public function updateLabel(e:TimerEvent):void
		{
			_currentMemory = System.totalMemory * _megabyteFraction;
			_maxMemory = _currentMemory > _maxMemory ? _currentMemory : _maxMemory;
			
			_label_tf.htmlText = "<P ALIGN='CENTER'><FONT FACE=\"Arial\" SIZE=\"10\" COLOR=\"#FFFFFF\">RAM: " + _currentMemory.toFixed(2) + "/" + _maxMemory.toFixed(2) + "MB</FONT></P>";
		}
		
	}
}