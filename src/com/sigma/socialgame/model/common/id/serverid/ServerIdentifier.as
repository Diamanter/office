package com.sigma.socialgame.model.common.id.serverid
{
	public class ServerIdentifier
	{
		private var _id : String;
		
		public function ServerIdentifier()
		{
		}
		
		public function equals(servId_:IServerIdentifier):Boolean
		{
			return _id == (servId_ as ServerIdentifier).id;
		}
		
		public function clone():IServerIdentifier
		{
			var newServId : ServerIdentifier = new ServerIdentifier();
			
			newServId.id = _id;
			
			return newServId;
		}

		public function get id():String
		{
			return _id;
		}

		public function set id(value:String):void
		{
			_id = value;
		}

		public function toString() : String
		{
			return "Id: " + _id;
		}
	}
}