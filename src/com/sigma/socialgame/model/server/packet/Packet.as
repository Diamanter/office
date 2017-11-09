package com.sigma.socialgame.model.server.packet
{
	public class Packet
	{
		private var _type : String;
		private var _user : String;
		private var _session : String;
		private var _version : String;
		
		private var _data : XML;
		
		public function Packet()
		{
		}

		public function get type() : String
		{
			return _type;
		}
		
		public function set type(value:String):void
		{
			_type = value;
		}
		
		public function get data():XML
		{
			return _data;
		}

		public function set data(value:XML):void
		{
			_data = value;
		}

		public function get user():String
		{
			return _user;
		}

		public function set user(value:String):void
		{
			_user = value;
		}

		public function get session():String
		{
			return _session;
		}

		public function set session(value:String):void
		{
			_session = value;
		}

		public function get version():String
		{
			return _version;
		}

		public function set version(value:String):void
		{
			_version = value;
		}

		public function toString() : String
		{
			return "Type: " + _type + "\nUser: " + _user + "\nSession: " + _session + "\nVersion: " + _version + "\nData: " + _data.toXMLString();
		}
	}
}