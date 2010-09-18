package org.dryen.controls
{
	import flash.events.Event;
	import flash.media.SoundMixer;
	import flash.utils.ByteArray;
	
	import org.dryen.display.Application;
	import org.dryen.display.UIComponent;
	
	public class Equalizer extends UIComponent
	{
		private var _barsNb:int;
		private var _barsIndex:int;
		private var _barsWidth:int;
		private var _barsSpacing:int;
		
		private var _sampleValue:Number;
		private var _sampleIndex:int;
		private var _samplesPerBar:int;
		private var _samplesBA:ByteArray;
		
		private var _started:Boolean;
		
		public var color:uint;
		public var colorAlpha:Number;
		
		public function Equalizer(barsNb:int, barsSpacing:int=0, masked:Boolean=false)
		{
			super(masked);
			
			_barsNb = barsNb;
			_barsSpacing = barsSpacing;
			_samplesBA = new ByteArray();
		}
		
		override public function init() : void
		{
			_barsWidth = _width / _barsNb;
			_samplesPerBar = 256 / _barsNb;
			
			super.init();
		}
		
		public function start():void
		{
			_started = true;
			addEventListener(Event.ENTER_FRAME, draw);
		}
		
		public function stop():void
		{
			_started = false;
			addEventListener(Event.ENTER_FRAME, draw);
		}
		
		public function draw(e:Event):void
		{
			try
			{
				SoundMixer.computeSpectrum(_samplesBA, true, 1);
				
				graphics.clear();
				graphics.beginFill(color, colorAlpha);
				
				for(_barsIndex = 0; _barsIndex < _barsNb; ++_barsIndex)
				{
					for(_sampleValue = 0, _sampleIndex = 0; _sampleIndex < _samplesPerBar; ++_sampleIndex)
						_sampleValue += _samplesBA.readFloat();
					
					graphics.drawRect(_barsIndex * _barsWidth, _height, _barsWidth - _barsSpacing, int(-_height * (_sampleValue / _samplesPerBar)));
				}
			}
			catch (error:Error) {/* Application.log(error.message);*/ }
		}
	}
}