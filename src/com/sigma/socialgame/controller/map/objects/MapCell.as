package com.sigma.socialgame.controller.map.objects
{
	import com.sigma.socialgame.common.logger.LogLevel;
	import com.sigma.socialgame.common.logger.LogModule;
	import com.sigma.socialgame.common.logger.Logger;
	import com.sigma.socialgame.model.common.id.objectid.ObjectTypes;

	public class MapCell
	{
		private var _x : int;
		private var _y : int;
		private var _objects : Vector.<CellObject>;
		
		public function MapCell()
		{
			_objects = new Vector.<CellObject>();
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
		
		public function get onlyTrim() : Boolean
		{
			for each (var co : CellObject in _objects)
			{
				if (co.storeObject.storeObject.object.type != ObjectTypes.Trim)
					return false;
			}
			
			return true;
		}
		
		public function get empty() : Boolean
		{
			return _objects.length == 0;
		}
		
		public function get objects() : Vector.<CellObject>
		{
			return _objects;
		}
		
		public function addObject(obj_ : CellObject) : void
		{
			_objects.push(obj_);
		}
		
		public function removeObject(obj_ : CellObject) : void
		{
			var ind : int = _objects.indexOf(obj_);
			
			if (ind == -1)
			{
				Logger.message("Trying to remove nonexistent object.", "MapCell", LogLevel.Error, LogModule.Controller);
				Logger.message(obj_.toString(), "", LogLevel.Error, LogModule.Controller);
				
				return;
			}
			
			_objects.splice(ind, 1);
		}
		
		public function contains(obj_ : CellObject) : Boolean
		{
			 return _objects.indexOf(obj_) != -1;
		}
		
		public function toString():String
		{
			var str : String = "X: " + _x + "\nY: " + _y + "\nObjects: "; 
			
			for each (var mo : CellObject in _objects)
			{
				str += "\n" + mo;
			}
			
			return str;
		}
	}
}