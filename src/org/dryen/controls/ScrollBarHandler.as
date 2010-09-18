package org.dryen.controls
{

	import org.dryen.display.Image;
	import org.dryen.display.UIAlign;
	import org.dryen.display.UIComponent;
	
	public class ScrollBarHandler extends UIComponent
	{
		private var _topAsset:Image;
		private var _middleAsset:Image;
		private var _bottomAssets:Image;
		private var _point:Image;
		
		public var isTweening:Boolean;
		
		public function ScrollBarHandler()
		{
			super(false);
			
			isTweening = false;
		}
		
		public function set assetsList(value:Object):void
		{
			_topAsset = value.handlerTop;
			_middleAsset = value.handlerMiddle;
			_bottomAssets = value.handlerBottom;
			if(value.handlerPoint) _point = value.handlerPoint; 
		}
		
		override public function init():void
		{
			/*
			 * da implementare assets 
			*/
			
			super.init();
		}
		
		override protected function addChilds():void
		{
			super.addChilds();
			
			if(_topAsset)
			{
				addChild(_topAsset);
				addChild(_middleAsset);
				addChild(_bottomAssets);
				addChild(_point);
			}
		}
	}
}