package org.dryen.display.particles
{
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.geom.Rectangle;

	public interface IParticle
	{
		function get x():Number;
		function get y():Number;
		
		function set x(value:Number):void;
		function set y(value:Number):void;
		function move(x:Number, y:Number):void;
		
		function get bitmapData():BitmapData;
		function get rect():Rectangle;
		
		function update(e:Event = null):void;
		function destroy():void;
	}
}