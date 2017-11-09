package com.sigma.socialgame.controller.map.way
{
	public class WayChain
	{
		private var _point : WayPoint;
		
		private var _prev : WayChain;
		
		public function WayChain(x_ : int = 0, y_ : int = 0, prev_ : WayChain = null)
		{
			_point = new WayPoint();
			
			_point.x = x_;
			_point.y = y_;
			
			_prev = prev_;
		}

		public function get point():WayPoint
		{
			return _point;
		}

		public function set point(value:WayPoint):void
		{
			_point = value;
		}

		public function get prev():WayChain
		{
			return _prev;
		}

		public function set prev(value:WayChain):void
		{
			_prev = value;
		}


	}
}