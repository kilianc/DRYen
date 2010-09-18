package org.dryen.controls
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Expo;
	
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import org.dryen.display.UIComponent;
	import org.dryen.events.DRYenEvent;
	import org.dryen.net.QueueLoader;

	public class ProgressBar extends UIComponent
	{
		private var _target:QueueLoader;
		
		private var _loading_tf:TextField;
		private var _loadingPercent_tf:TextField;
		private var _loadingLine:Shape;
		private var _loadingLineBg:Shape;
		private var _triangle:Shape;
		
		private var _fontName:String;
		
		public function ProgressBar(target:QueueLoader, fontName:String, masked:Boolean=false, snapToPixel:Boolean=false)
		{
			super(masked, snapToPixel);
			
			this.target = target;
			_fontName = fontName;
			
			_loading_tf = new TextField();
			_loadingPercent_tf = new TextField();
			
			_loadingLineBg = new Shape();
			_loadingLine = new Shape();
			_triangle = new Shape();
		}
		
		override public function init() : void
		{
			var sideSize:uint = 5;
			_triangle.graphics.beginFill(0xffffff);
			_triangle.graphics.lineTo(sideSize*.5, sideSize);
			_triangle.graphics.lineTo(-sideSize*.5, sideSize);
			_triangle.graphics.lineTo(0, 0);
			_triangle.graphics.endFill();

//			_loading_tf.embedFonts = true;
			_loading_tf.autoSize = TextFieldAutoSize.LEFT;
//			_loadingPercent_tf.embedFonts = true;
			_loadingPercent_tf.width = 40;
			
			_loadingLineBg.graphics.beginFill(0xCCCCCC);
			_loadingLineBg.graphics.drawRect(0, 0, width, height);
			_loadingLineBg.graphics.endFill();
			
			_loadingLine.graphics.beginFill(0xFFFFFF);
			_loadingLine.graphics.drawRect(0, 0, 1, height);
			_loadingLine.graphics.endFill();
			
			super.init();
		}
		
		override public function placeChilds() : void
		{
			_loadingLine.y = _loading_tf.y + _loading_tf.height + 15;
			//_loadingLine.filters = [new GlowFilter(0xFFFFFF, 1, 2, 2, 2, 3)];
			_loadingLineBg.y = _loadingLine.y;
			_triangle.y = _loadingLineBg.y + _loadingLineBg.height + 5;
			_loadingPercent_tf.y = _triangle.y + 5;
		}
		
		override protected function addChilds() : void
		{
			addChild(_loading_tf);
			addChild(_loadingPercent_tf);
			addChild(_loadingLineBg);
			addChild(_loadingLine);
			addChild(_triangle);
			
			super.addChilds();
		}
		
		public function onQlStart(e:Event):void
		{
			
		}
		
		public function onQlProgress(e:ProgressEvent):void
		{
			if(!e.bytesTotal) return;
			var easeingTime:Number = .5;
			TweenLite.to(_loadingLine, easeingTime, { ease: com.greensock.easing.Expo.easeOut, width: width * e.bytesLoaded / e.bytesTotal });
			TweenLite.to(_triangle, easeingTime, { ease: com.greensock.easing.Expo.easeOut, x: uint(width * e.bytesLoaded / e.bytesTotal) });
			TweenLite.to(_loadingPercent_tf, easeingTime, { ease: com.greensock.easing.Expo.easeOut, x: uint(width * e.bytesLoaded / e.bytesTotal) - _loadingPercent_tf.width * .5 });
			
			_loadingPercent_tf.htmlText = "<P ALIGN=\"CENTER\"><FONT FACE=\""+_fontName+"\" SIZE=\"10\" COLOR=\"#555555\">" + uint(e.bytesLoaded / e.bytesTotal * 100)+ "</FONT></P>";
		}
		
		public function onQlAdvance(e:DRYenEvent):void
		{
			var pre:String = "<FONT FACE=\""+_fontName+"\" SIZE=\"10\" COLOR=\"#555555\" LETTERSPACING=\"1\">";
			var post:String = "</FONT>";
			
			switch(e.item.type)
			{
				case QueueLoader.XML:
					_loading_tf.htmlText = pre +"loading xml ..." + post;
				break;
				case QueueLoader.IMG:
					_loading_tf.htmlText = pre +"loading assets ..." + post;
				break;
				case QueueLoader.CSS:
					_loading_tf.htmlText = pre +"loading stylesheets ..." + post;
				break;
				case QueueLoader.LIB:
					_loading_tf.htmlText = pre +"loading libraries ..." + post;
				break;
				case QueueLoader.SWF:
					_loading_tf.htmlText = pre +"loading components ..." + post;
				break;
			}
		}
		
		public function onQlComplete(e:Event):void
		{
			_target.removeEventListener(ProgressEvent.PROGRESS, onQlProgress);
			_loading_tf.visible = true;
			_loading_tf.htmlText = "<FONT FACE=\""+_fontName+"\" SIZE=\"10\" COLOR=\"#555555\" LETTERSPACING=\"1\">loading compete!</FONT>";
			
			_loadingLine.visible = true;
		}
		
		public function set target(value:QueueLoader):void
		{
			if(_target)
			{
				_target.removeEventListener(DRYenEvent.INIT, onQlStart);
				_target.removeEventListener(DRYenEvent.QUEUE_ADVANCE, onQlAdvance);
				_target.removeEventListener(ProgressEvent.PROGRESS, onQlProgress);
				_target.removeEventListener(Event.COMPLETE, onQlComplete);
			}
			
			_target = value;
			_target.addEventListener(DRYenEvent.INIT, onQlStart);
			_target.addEventListener(Event.COMPLETE, onQlComplete);
			_target.addEventListener(DRYenEvent.QUEUE_ADVANCE, onQlAdvance);
			_target.addEventListener(ProgressEvent.PROGRESS, onQlProgress);
		}
	}
}