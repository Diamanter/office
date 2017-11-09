package com.sigma.socialgame.common.utils
{
	public class Map
	{
		private var _values : Array;
		private var _keys : Array;
		
		private var _map : Object;
		
		public function Map()
		{
			_values = new Array();
			_keys = new Array();
			
			_map = new Object();
		}
		
		public function push(value : Object, key : Object) : void
		{
			var ind : int = find(key);
			
			if (ind != -1)
			{
				return;
			}
			
			var valind : uint = _values.push(value) - 1;
			var keyind : uint = _keys.push(key) - 1;
			
			_map[_keys[keyind]] = valind;
		}
		
		public function get(key : Object) : Object
		{
			var ind : int = find(key);
			
			if (ind != -1)
			{
				return _values[ind];
			}
			
			return null;
		}
		
		public function remove(key : Object) : Object
		{
			var ind : int = find(key);
			
			if (ind == -1)
			{
				return null;
			}
			
			_keys.splice(ind, 1);
			
			return _values.splice(ind, 1)[0];
		}
		
		protected function find(key : Object) : int
		{
			var i : int;
			
			for (i = 0; i < _keys.length; i++)
			{
				if (_keys[i] == key)
				{
					break;
				}
			}
			
			if (i < _keys.length)
			{
				return i;
			}
			
			return -1;
		}
		
		public function toString() : String
		{
			var i : int;
			
			var str : String = "";
			
			for (i = 0; i < _keys.length; i++)
			{
				str += "V: " + _values[i] + " K: " + _keys[i] + "\n";
			}
			
			return str;
		}
	}
}