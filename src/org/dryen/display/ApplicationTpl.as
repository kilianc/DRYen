package org.dryen.display
{
	[SWF(backgroundColor='0xFFFFFF', frameRate='61')]
	
	public final class ApplicationTpl extends Application
	{
		public function ApplicationTpl(debug:Boolean=true, showContexLink:Boolean=true, showToggleFs:Boolean=true, contextLabel:String="DRYen extends Yourself", contextUrl:String="http://www.dryen.org")
		{
			super(debug, showContexLink, showToggleFs, contextLabel, contextUrl);
		}
		
		override public function init():void
		{
//			put code here
			
			super.init();
		}
		
		override public function placeChilds():void
		{
			super.placeChilds();
			
//			put code here
		}
		
		override protected function addChilds():void
		{
			super.addChilds();
			
//			put code here
			
		}
	}
}