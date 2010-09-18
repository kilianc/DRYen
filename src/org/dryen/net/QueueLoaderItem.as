package org.dryen.net
{
	public class QueueLoaderItem
	{
		public var type:uint;
		public var obfuscation:String;
		public var url:String;
		public var target:String;
		public var scope:Object;
		public var rfr:RemoteFileReference;
		
		public function QueueLoaderItem(type:uint, url:String, target:String, scope:Object, obfuscation:String)
		{
			this.type = type;
			this.obfuscation = obfuscation;
			this.url = url;
			this.target = target;
			this.scope = scope;
		}
	}
}