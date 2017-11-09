package com.sigma.socialgame.controller.map.way
{
	public class WayPoint
	{
		private var _x : int;
		private var _y : int;
		private var _needToAddAtEnd : Boolean;
		
		public function WayPoint(x_ : int = 0, y_ : int = 0, needToAddAtEnd_ : Boolean = true)
		{
			_x = x_;
			_y = y_;
			_needToAddAtEnd = needToAddAtEnd_;
		}
		
		public function get needToAddAtEnd():Boolean
		{
			return _needToAddAtEnd;
		}

		public function get x():int
		{
			return _x;
		}

		public function set x(value:int):void
		{
			_x = value;
		}

		public function get y():int
		{
			return _y;
		}

		public function set y(value:int):void
		{
			_y = value;
		}

		public function toString() : String
		{
			return "X: " + _x + " Y: " + _y;
		}

	}
}