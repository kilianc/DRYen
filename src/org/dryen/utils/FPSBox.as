package org.dryen.utils
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import org.dryen.controls.Button;
	import org.dryen.display.UIAlign;
	import org.dryen.display.UIComponent;
	
	public class FPSBox extends UIComponent
	{
		private var _updateLabeltimer:Timer;
		private var _label_tf:TextField;
		private var _fps:int;
		private var _incFramerateBtn:Button;
		private var _decFramerateBtn:Button;
		private var _elapsedTime:uint;
		
		public function FPSBox(masked:Boolean=false)
		{
			super(masked);
			
			_updateLabeltimer = new Timer(1000);
			
			_label_tf = new TextField();
			
			_incFramerateBtn = new Button(true);
			_decFramerateBtn = new Button(true);
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		override public function init():void
		{
			_background.alpha = .5
			_background.color = 0x555555;
			
			_label_tf.selectable = false;
			_label_tf.tabEnabled = false;
			_label_tf.htmlText = "<P ALIGN='CENTER'><FONT FACE=\"Arial\" SIZE=\"10\" COLOR=\"#FFFFFF\">FPS: -/-</FONT></P>";
			
			_incFramerateBtn.setSize(10, 10);
			_decFramerateBtn.setSize(10, 10);
			
			_incFramerateBtn.init();
			_decFramerateBtn.init();
			
			super.init();
		}
		
		override public function initPlacement():void
		{
			super.initPlacement();
			
			_label_tf.width = width;
			_label_tf.height = 12 + 2;
			UIAlign.to(UIAlign.MIDDLE_CENTER, _label_tf, this);
			
			_incFramerateBtn.align(UIAlign.BOTTOM_RIGHT, this, { y: _incFramerateBtn.height+1 });
			_decFramerateBtn.align(UIAlign.BOTTOM_RIGHT, this, { y: _incFramerateBtn.height+1, x: -_incFramerateBtn.width-1 });
		}
		
		override protected function addChilds():void
		{
			super.addChilds();
			
			addChild(_label_tf);
			addChild(_incFramerateBtn);
			addChild(_decFramerateBtn);
		}
		
		private function onAddedToStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			_incFramerateBtn.addEventListener(MouseEvent.CLICK, onFPSBtnClick);
			_decFramerateBtn.addEventListener(MouseEvent.CLICK, onFPSBtnClick);
			
			_decFramerateBtn.buttonMode = true;
			_incFramerateBtn.buttonMode = true;
			
			addEventListener(Event.ENTER_FRAME, updateFPS);
			
			_updateLabeltimer.addEventListener(TimerEvent.TIMER, updateLabel);
			_updateLabeltimer.start();
			_elapsedTime = getTimer();
		}
		
		public function updateFPS(e:Event):void
		{
			++_fps;
		}
		
		public function updateLabel(e:TimerEvent):void
		{
			_elapsedTime = getTimer();
			_fps = _fps > stage.frameRate ? stage.frameRate : _fps;
			_label_tf.htmlText = "<P ALIGN='CENTER'><FONT FACE=\"Arial\" SIZE=\"10\" COLOR=\"#FFFFFF\">FPS: " + _fps + "/" + stage.frameRate + "</FONT></P>";
			_fps = 0;
		}
		
		private function onFPSBtnClick(e:MouseEvent):void
		{
			var btn:Button = Button(e.currentTarget);
		
			if(btn == _incFramerateBtn) stage.frameRate += 5;
			else if(stage.frameRate > 5)stage.frameRate -= 5;
		}
		
		public function stop():void
		{
			removeEventListener(Event.ENTER_FRAME, updateFPS);
			
			_updateLabeltimer.removeEventListener(TimerEvent.TIMER, updateLabel);
			_updateLabeltimer.stop();
		}
	}
}