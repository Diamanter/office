package com.sigma.socialgame.model.objects.sync.map
{
	import com.sigma.socialgame.model.objects.config.object.CellObjectData;

	public class CellMapObjectData extends MapObjectData
	{
		private var _x : int;
		private var _y : int;
		
		private var _rotation : int;
		
		public function CellMapObjectData()
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
		
		public function get y() : int
		{
			return _y;
		}
		
		public function set y(y_ : int) : void
		{
			_y = y_;
		}
		
		public function get width() : int
		{
			return (storeObject.object as CellObjectData).width;
		}
		
		public function get height() : int
		{
			return (storeObject.object as CellObjectData).height;
		}
		
		public function get rotation() : int
		{
			return _rotation;
		}
		
		public function set rotation(rot_ : int) : void
		{
			_rotation = rot_;	
		}
		
		public override function toString() : String
		{
			return super.toString() + "\nX: " + _x + "\nY: " + _y + "\nRot: " + _rotation; 
		}

		public function get sides():int
		{
			return (storeObject.object as CellObjectData).sides;
		}
	}
}