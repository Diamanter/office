package com.sigma.socialgame.model.common.id.objectid
{
	public class ObjectIdentifier
	{
		private var _id : String;
		
		public function ObjectIdentifier()
		{
		}
		
		public function equals(obj_ : ObjectIdentifier) : Boolean
		{
			var objId : ObjectIdentifier = obj_;
			
			if (_id == objId.id)
			{
				return true;
			}
			
			return false;
		}

		public function clone() : ObjectIdentifier
		{
			var newObjId : ObjectIdentifier = new ObjectIdentifier();
			
			newObjId.id = _id;
			
			return newObjId;
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