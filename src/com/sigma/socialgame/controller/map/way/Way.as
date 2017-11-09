package com.sigma.socialgame.controller.map.way
{
	public class Way
	{
		private var _way : Vector.<WayPoint>;
		
		public function Way()
		{
			_way = new Vector.<WayPoint>();
		}
		
		public function get way():Vector.<WayPoint>
		{
			return _way;
		}

		public function set way(value:Vector.<WayPoint>):void
		{
			_way = value;
		}
		
		public function toString() : String
		{
			return _way.toString();
		}
	}
}