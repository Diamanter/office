package com.sigma.socialgame.model.objects.config.object
{
	public class WallObjectData extends ObjectData
	{
		private var _width : int;
		private var _sides : int;
		private var _isDoor : Boolean = false;
		
		public function WallObjectData()
		{
			super();
		}

		public function get isDoor():Boolean
		{
			return _isDoor;
		}

		public function set isDoor(value:Boolean):void
		{
			_isDoor = value;
		}

		public function get width():int
		{
			return _width;
		}

		public function set width(value:int):void
		{
			_width = value;
		}

		public function get sides():int
		{
			return _sides;
		}

		public function set sides(value:int):void
		{
			_sides = value;
		}
		
		public override function toString() : String
		{
			return super.toString() + "Width: " + _width + "\nSides: " + _sides + "\nIsDoor: " + _isDoor; 
		}
	}
}