package org.dryen.display.particles
{
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	public class ShootingStar extends BitmapDataParticle
	{
		public var velocity:Number;
		public var velocityVariation:Number;
		public var angle:Number;
		public var angleVariation:Number;
		public var boundingBox:Rectangle;
		
		private var _vStep:Number;
		private var _hStep:Number;
		
		public function ShootingStar(figure:BitmapData, boundingBox:Rectangle, velocity:Number = 2, velocityVariationPercent:Number = .2, angle:Number = 5, angleVariationPercent:Number = .2)
		{
			super(figure);
			
			this.velocityVariation = velocity * velocityVariationPercent;
			this.velocity = velocity + Math.random() * this.velocityVariation * 2 - this.velocityVariation;
			this.boundingBox = boundingBox;
			
			this.angleVariation = angle * angleVariationPercent;
			this.angle = angle + Math.random() * angleVariation * 2 - angleVariation;
			
			_vStep = velocity;
			_hStep = angle * velocity;
			
			init();
		}
		
		public function init():void
		{
			position.x = Math.random() * boundingBox.width;
			position.y = 0;
		}
		
		override public function update(e:Event = null):void
		{
			position.x -= velocity * angle;
			position.y += velocity;
			
			if(!boundingBox.contains(position.x, position.y)) init();
		}
	}
}