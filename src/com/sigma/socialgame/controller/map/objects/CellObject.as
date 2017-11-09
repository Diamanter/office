package com.sigma.socialgame.controller.map.objects
{
	import com.sigma.socialgame.common.map.MapRotation;
	import com.sigma.socialgame.model.objects.config.object.CellObjectData;
	import com.sigma.socialgame.model.objects.sync.map.CellMapObjectData;

	public class CellObject extends MapObject
	{
		public function CellObject()
		{
			
		}
		
		public function get x() : int
		{
			return cellMapObject.x;
		}
		
		public function set x(x_ : int) : void
		{
			cellMapObject.x = x_;
		}
		
		public function get y() : int
		{
			return cellMapObject.y;
		}
		
		public function set y(y_ : int) : void
		{
			cellMapObject.y = y_;
		}
		
		
		public function get rotation() : int
		{
			return cellMapObject.rotation;
		}
		
		public function set rotation(rot_ : int) : void
		{
			cellMapObject.rotation = rot_;
		}
		
		public function get width() : int
		{
			return cellObject.width;
		}
		
		public function get height() : int
		{
			return cellObject.height;
		}
		
		public function get sides() : int
		{
			return cellObject.sides;
		}
		
		public function get xLength() : int
		{
			if (cellMapObject.rotation == MapRotation.NorthWest || cellMapObject.rotation == MapRotation.SouthEast)
				return height;
			
			return width;
		}
		
		public function get yLength() : int
		{
			if (cellMapObject.rotation == MapRotation.NorthWest || cellMapObject.rotation == MapRotation.SouthEast)
				return width;
			
			return height;
		}
		
		protected function get cellMapObject() : CellMapObjectData
		{
			return mapObject as CellMapObjectData;
		}
		
		protected function get cellObject() : CellObjectData
		{
			return mapObject.storeObject.object as CellObjectData
		}
		
		public override function toString() : String
		{
			return "MapObject: " + mapObject; 
		}
	}
}