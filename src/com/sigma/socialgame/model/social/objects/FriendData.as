package com.sigma.socialgame.model.social.objects
{
	public class FriendData
	{
		private var _uid : String;
		
		private var _lastName : String;
		private var _firstName : String;
		
		private var _name :String;
		
		public function FriendData()
		{
		}

		public function get uid():String
		{
			return _uid;
		}

		public function set uid(value:String):void
		{
			_uid = value;
		}

		public function get lastName():String
		{
			return _lastName;
		}

		public function set lastName(value:String):void
		{
			_lastName = value;
		}

		public function get firstName():String
		{
			return _firstName;
		}

		public function set firstName(value:String):void
		{
			_firstName = value;
		}

		public function get name():String
		{
			return _name;
		}

		public function set name(value:String):void
		{
			_name = value;
		}

		public function toString() : String
		{
			return "Uid: " + _uid + " Last: " + _lastName + " First: " + _firstName + " Name: " + _name;
		}
	}
}