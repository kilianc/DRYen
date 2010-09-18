package org.dryen.display
{
	import flash.display.DisplayObject;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	import org.dryen.utils.FPSBox;
	import org.dryen.utils.MemoryBox;
	
	public class Application extends UIComponent
	{
		private static var _instance:Application;
		
		private var _contextLabel:String;
		private var _contextUrl:String;
		private var _stageReady:Boolean;
		protected var _debugMode:Boolean;
		
		public static var log:Function;
		
		public function Application(debug:Boolean = true, showContexLink:Boolean = true, showToggleFs:Boolean = true, contextLabel:String = "DRYen extends Yourself", contextUrl:String = "http://www.dryen.org")
		{	
			super();
			
			if(_instance) throw new Error("Application is a singleton class, use getInstance() instead.");
			
			_instance = this;
			_contextLabel = contextLabel;
			_contextUrl = contextUrl;
			_debugMode = debug;
			log = _debugMode ? trace : function(s:*):void {};
			
			loaderInfo.addEventListener(Event.COMPLETE, onLoadVarsComplete);
			
			setupContexMenu(showContexLink, showToggleFs);
		}

		protected function onLoadVarsComplete(e:Event):void
		{
			removeEventListener(Event.COMPLETE, onLoadVarsComplete);
			
			var parametersTable:Vector.<String> = new Vector.<String>();
			for(var paramName:String in loaderInfo.parameters)
				parametersTable.push(" > " + paramName +" = \""+loaderInfo.parameters[paramName]+"\"");
			
			if(parametersTable.length)
			{
				log("> Aviable variables:");
				log(parametersTable.join("\n"));
			}
			else log("> No variables aviable");
			
			setupStage();
		}

		private function setupStage():void
		{
			stage.addEventListener(Event.RESIZE, checkStageReady);
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.stageFocusRect = false;
			
			if(!_stageReady) checkStageReady(null);
		}
		
		private function setupContexMenu(showContexLink:Boolean, showToggleFs:Boolean):void
		{
			var cm:ContextMenu = new ContextMenu();
			cm.hideBuiltInItems();
			
			if(showContexLink)
			{
				var cmi:ContextMenuItem = new ContextMenuItem(_contextLabel);
				cmi.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, function(e:ContextMenuEvent):void {
					navigateToURL(new URLRequest(_contextUrl));
				});
				
				cm.customItems.push(cmi);
			}
			
			if(showToggleFs)
			{
				var cmiFs:ContextMenuItem = new ContextMenuItem("Toggle FullScreen");
				cmiFs.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, function(e:ContextMenuEvent):void {
					stage.displayState = stage.displayState == StageDisplayState.FULL_SCREEN ? StageDisplayState.NORMAL : StageDisplayState.FULL_SCREEN;
				});
				
				cm.customItems.push(cmiFs);
			}
			
            this.contextMenu = cm;
		}
		
		protected function checkStageReady(e:Event):void
		{
			if(!stage.stageWidth)
			{
				log("> Waiting for stage ready...");
				return;
			}
			
			_stageReady = true;
			
			stage.removeEventListener(Event.RESIZE, checkStageReady);
			stage.addEventListener(Event.RESIZE, onStageResize);
			
			onStageResize();
			
			log("> Stage ready, now we start!");
			
			init();
		}
		
		protected function onStageResize(e:Event = null):void 
		{
			setSize(stage.stageWidth, stage.stageHeight);
		}
	}
}