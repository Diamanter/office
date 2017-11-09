package com.sigma.socialgame.model.objects.sync.id
{
	public class ReservedIdObject
	{
		private var _id : String = "0";
		private var _idType : String;
		
		public function ReservedIdObject()
		{
		}

		public function get id():String
		{
			return _id;
		}

		public function set id(value:String):void
		{
			_id = value;
		}

		public function get idType():String
		{
			return _idType;
		}

		public function set idType(value:String):void
		{
			_idType = value;
		}


	}
} 
