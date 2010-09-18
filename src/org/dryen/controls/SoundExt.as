package org.dryen.controls
{
	import com.greensock.TweenLite;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	
	import org.dryen.events.SoundExtEvent;
	
	[Event(name="fadeOutComplete", type="events.SoundExtEvent")]
	[Event(name="fadeInComplete", type="events.SoundExtEvent")]
	
	public class SoundExt extends EventDispatcher
	{
		private var _sound:Sound;
		private var _channel:SoundChannel;
		private var _pausePos:Number;
		private var _soundTransform:SoundTransform;
		private var _volume:Number;
		private var _loop:Boolean;
		
		public var isPlaying:Boolean;
		
		public function SoundExt()
		{
			super();
			
			_volume = 1;
			_pausePos = 0;
			
			_soundTransform = new SoundTransform(_volume);
		}
		
		public function set volume(value:Number):void
		{
			_volume = value;
			_soundTransform.volume = _volume;
			
			if(_channel) _channel.soundTransform = _soundTransform;
		}
		
		public function get volume():Number
		{
			return _volume;
		}
		
		public function load(soundURL:String):void
		{
			_sound = new Sound(new URLRequest(soundURL));
		}
		
		public function play(fadeTime:Number=0, loop:Boolean=false):void
		{
			_loop = loop;
			
			if(isPlaying) return;
			
			volume = 0;

			_channel = _sound.play(_pausePos, 0, _soundTransform);
			
			TweenLite.to(this, fadeTime, { volume: 1 });
			
			_channel.addEventListener(Event.SOUND_COMPLETE, onSoundComplete, false, 0, true);
			
			isPlaying = true;
		}
		
		private function onSoundComplete(e:Event):void
		{
			if(_loop)
			{
				_channel = _sound.play(0, 0, _soundTransform);
				_channel.addEventListener(Event.SOUND_COMPLETE, onSoundComplete, false, 0, true);
			}
			else
				_stop(false);
		}
		
		public function pause(fadeTime:Number=0):void
		{
			if(!isPlaying) return;
			
			if(fadeTime)
				TweenLite.to(this, fadeTime, { volume: 1, onComplete: _pause });
			else
				_pause();
		}
		
		private function _pause():void
		{
			if(isPlaying)
			{
				_pausePos = _channel.position;
				_channel.stop();
				
				isPlaying = false;
			}
			
			dispatchEvent(new SoundExtEvent(SoundExtEvent.PAUSE));
		}
		
		public function stop(fadeTime:Number = 0):void
		{
			if(fadeTime && isPlaying)
				TweenLite.to(this, fadeTime, { volume: 0, onComplete: _stop });
			else
				_stop();
		}
		
		private function _stop(dispatchEnd:Boolean=true):void
		{
			if(isPlaying)
			{
				_pausePos = 0;
				_channel.stop();
				
				isPlaying = false;
				
				if(_sound && _sound.isBuffering) _sound.close();
			}
			
			dispatchEvent(new SoundExtEvent(SoundExtEvent.STOP));
		}
	}
}