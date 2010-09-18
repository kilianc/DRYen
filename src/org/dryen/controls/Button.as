package org.dryen.controls
{
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import org.dryen.display.UIAlign;
	import org.dryen.display.UIComponent;
	import org.dryen.events.ButtonEvent;
	
	[Event(name="changeState", type="events.ButtonEvent")]

	public class Button extends UIComponent
	{
		protected var _label:String;
		protected var _labelHtml:String;
		protected var _label_tf:TextField;
		protected var _state:String;
		
		public var defaultBehavior:Boolean;
		public var autoWidth:Boolean;
		
		public function Button(masked:Boolean = false)
		{
			super(masked);
			
			_state = ButtonState.UP;
		}
		
		override public function init():void
		{
			buttonMode = true;
			mouseChildren = false;

			_label_tf = new TextField();
			_label_tf.tabEnabled = false;
			_label_tf.selectable = false;
			_label_tf.mouseEnabled = false;
			_label_tf.embedFonts = Boolean(styleSheet);
			_label_tf.styleSheet = styleSheet;
			_label_tf.autoSize = TextFieldAutoSize.LEFT;
			
			if(_label) _label_tf.text = _label;
			if(_labelHtml) _label_tf.htmlText = _labelHtml;
			
			addEventListener(MouseEvent.ROLL_OVER, onMouseOver);
			addEventListener(MouseEvent.ROLL_OUT, onMouseOut);
			addEventListener(MouseEvent.CLICK, onClick);
			
			if(defaultBehavior)
			{
				addEventListener(ButtonEvent.CHANGE_STATE, onChangeState);
				onChangeState(null);
			}
			
			super.init();
			
			if(autoWidth && (_label || _labelHtml)) width = _container.width;
			
			UIAlign.to(UIAlign.MIDDLE_CENTER, _label_tf, this);
		}
		
		override protected function addChilds():void
		{
			super.addChilds();
			
			_container.addChild(_label_tf);
		}
		
		public function get label():String
		{
			return _label_tf.text;
		}
		
		public function set label(text:String):void
		{
			_label = text;
			
			if(!initialized) return;
			
			_label_tf.text = _label;
			
			if(autoWidth) width = _label_tf.width;

			initPlacement();
		}
		
		public function get labelHtml():String
		{
			return _labelHtml;
		}
		
		public function set labelHtml(htmlText:String):void
		{
			_labelHtml = htmlText;
			
			if(!initialized) return;
			
			_label_tf.htmlText = _labelHtml;
			
			if(autoWidth) width = _label_tf.width;
			
			initPlacement();
		}
		
		public function get state():String
		{
			return _state;
		}
		
		public function set state(state:String):void
		{
			if(_state == state) return;
			
			switch(state)
			{
				case ButtonState.UP:
					_state = ButtonState.UP;
					break;
				
				case ButtonState.UP_OVER:
					_state = ButtonState.UP_OVER;
					break;
				
				case ButtonState.DOWN:
					_state = ButtonState.DOWN;
					break;
				
				case ButtonState.DOWN_OVER:
					_state = ButtonState.DOWN_OVER;
					break;
				
				default:
					throw new Error("INVALID BUTTON STATUS: " + state);
			}
			
			dispatchEvent(new ButtonEvent(ButtonEvent.CHANGE_STATE));
		}
		
		private function onMouseOver(e:MouseEvent):void
		{
			state = (_state == ButtonState.UP) ? ButtonState.UP_OVER : ButtonState.DOWN_OVER;
		}
		
		private function onMouseOut(e:MouseEvent):void
		{
			state = (state == ButtonState.UP_OVER) ? ButtonState.UP : ButtonState.DOWN;
		}
		
		private function onClick(e:MouseEvent):void
		{
			state = ButtonState.DOWN_OVER;
		}
		
		protected function onChangeState(e:Event):void
		{
			switch(_state)
			{
				case ButtonState.UP:
					alpha = .5;
					break;
				
				case ButtonState.UP_OVER:
					alpha = 1;
					break;
				
				case ButtonState.DOWN:
					alpha = .5;
					break;
				
				case ButtonState.DOWN_OVER:
					alpha = 1;
					break;
				
				case ButtonState.DISABLED:
					alpha = .5;
					break;
			}
		}
	}
}