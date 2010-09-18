package org.dryen.utils
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.filters.BitmapFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public function createBitmapDataVector(holder:DisplayObjectContainer, filter:BitmapFilter = null, colorTransform:ColorTransform = null, transparent:Boolean = true, fillColor:uint = 0):Vector.<BitmapData>
	{
		var child:DisplayObject;
		var childBounds:Rectangle
		var bmpd:BitmapData;
		var bmpdList:Vector.<BitmapData> = new Vector.<BitmapData>();
		var filterDestPoint:Point = new Point();
		
		for(var i:uint; i < holder.numChildren; ++i)
		{
			child = holder.getChildAt(i);
			childBounds = child.getBounds(child);
			
			bmpd = new BitmapData(childBounds.width, childBounds.height, transparent, fillColor);
			bmpd.draw(child, null, null, null, childBounds, true);
			
			if(filter) bmpd.applyFilter(bmpd, bmpd.rect, filterDestPoint, filter);
			if(colorTransform) bmpd.colorTransform(bmpd.rect, colorTransform);
			
			bmpdList.push(bmpd);
		}
		
		return bmpdList;
	}
}