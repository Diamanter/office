package com.sigma.socialgame.controller.map.objects
{
	import com.sigma.socialgame.model.objects.config.object.WallObjectData;
	import com.sigma.socialgame.model.objects.sync.map.WallMapObjectData;

	public class WallObject extends MapObject
	{
		public function WallObject()
		{
		}

		public function get wall():int
		{
			return wallMapObject.wall;
		}

		public function set wall(value:int):void
		{
			wallMapObject.wall = value;
		}

		public function get x():int
		{
			return wallMapObject.x;
		}

		public function set x(value:int):void
		{
			wallMapObject.x = value;
		}

		public function get width() : int
		{
			return wallObject.width;
		}
		
		public function get sides() : int
		{
			return wallObject.sides;
		}
		
		protected function get wallMapObject() : WallMapObjectData
		{
			return mapObject as WallMapObjectData;
		}
		
		protected function get wallObject() : WallObjectData
		{
			return mapObject.storeObject.object as WallObjectData;
		}
		
		public override function toString() : String
		{
			return "MapObject: " + mapObject; 
		}
	}
}