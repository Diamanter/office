package com.sigma.socialgame.controller.map.objects
{
	import com.sigma.socialgame.common.logger.LogLevel;
	import com.sigma.socialgame.common.logger.LogModule;
	import com.sigma.socialgame.common.logger.Logger;

	public class MapWall
	{
		private var _wall : int;
		private var _x : int;
		private var _objects : Vector.<WallObject>;
		
		public function MapWall()
		{
			_objects = new Vector.<WallObject>();
		}

		public function get wall():int
		{
			return _wall;
		}

		public function set wall(value:int):void
		{
			_wall = value;
		}

		public function get x():int
		{
			return _x;
		}

		public function set x(value:int):void
		{
			_x = value;
		}

		public function get empty() : Boolean
		{
			return _objects.length == 0;
		}
		
		public function get objects() : Vector.<WallObject>
		{
			return _objects;
		}
		
		public function addObject(obj_ : WallObject) : void
		{
			_objects.push(obj_);
		}
		
		public function removeObject(obj_ : WallObject) : void
		{
			var ind : int = _objects.indexOf(obj_);
			
			if (ind == -1)
			{
				Logger.message("Trying to remove nonexistent object.", "MapWall", LogLevel.Error, LogModule.Controller);
				Logger.message(obj_.toString(), "", LogLevel.Error, LogModule.Controller);
				
				return;
			}
			
			_objects.splice(ind, 1);
		}
		
		public function contains(obj_ : WallObject) : Boolean
		{
			return _objects.indexOf(obj_) != -1;
		}
		
		public function toString():String
		{
			var str : String = "Wall: " + _wall + "\nX: " + _x + "\nObjects: "; 
			
			for each (var mo : WallObject in _objects)
			{
				str += "\n" + mo;
			}
			
			return str;
		}
	}
}