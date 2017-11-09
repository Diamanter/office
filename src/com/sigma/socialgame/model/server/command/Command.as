package com.sigma.socialgame.model.server.command
{
	public class Command
	{
		private var _group : String;
		private var _type : String;
		private var _props : Array;
		
		public function Command() 
		{
			_props = new Array();
		}
		
		public function get group() : String
		{
			return _group;
		}
		
		public function set group(group_ : String)  : void
		{
			_group = group_;
		}
		
		public function get type() : String
		{
			return _type;
		}
		
		public function set type(type_ : String) : void
		{
			_type = type_;
		}
		
		public function get props() : Array
		{
			return _props;
		}
		
		public function set props(props_ : Array) : void
		{
			_props = props_;
		}
		
		public function toString() : String
		{
			return "Type: " + _type + "\nGroup: " + _group + "\nProps: " + _props;
		}
	}
}