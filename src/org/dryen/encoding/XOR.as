package org.dryen.encoding
{
	import flash.utils.ByteArray;

	public class XOR
	{
		private static var bytes:ByteArray;
		
		public static function encodeBytes(source:ByteArray, key:String):void
		{
			if(!bytes) bytes = new ByteArray();
			
			var byte:int;
			var keyByte:int;
			
			for(var i:int; i < key.length; ++i)
				keyByte ^= key.charCodeAt(i);
			
			source.position = 0;
			
			while(byte = source.readByte())
				bytes.writeByte(byte ^ keyByte);
			
			source.clear();
			source.writeBytes(bytes);
		}
		
		public static function encodeString(source:String, key:String):String
		{
			var result:String = "";
			var sourceLength:int = source.length;
			var keyByte:int;
			
			for(var i:int; i < key.length; ++i)
				keyByte ^= key.charCodeAt(i);
			
			for(i=0; i < sourceLength; ++i)
				result += String.fromCharCode(source.charCodeAt(i) ^ keyByte);
			
			return result;
		}
	}
}