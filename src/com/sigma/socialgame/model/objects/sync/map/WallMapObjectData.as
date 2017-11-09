package com.sigma.socialgame.model.objects.sync.map
{
	import com.sigma.socialgame.model.objects.config.object.WallObjectData;

	public class WallMapObjectData extends MapObjectData
	{
		private var _x : int;
		private var _wall : int;
		
		public function WallMapObjectData()
		{
			super();
		}
		
		public function get x() : int
		{
			return _x;
		}
		
		public function set x(x_ : int) : void
		{
			_x = x_;
		}
		
		public function get wall() : int
		{
			return _wall;
		}
		
		public function set wall(wall_ : int) : void
		{
			_wall = wall_;	
		}
		
		public function get width() : int
		{
			return (storeObject.object as WallObjectData).width;
		}
		
		public override function toString() : String
		{
			return super.toString() + "\nX: " + _x + "\nWall: " + _wall;
		}

		public function get sides():int
		{
			return (storeObject.object as WallObjectData).sides;
		}
	}
}