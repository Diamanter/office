package com.sigma.socialgame.model.objects.config.object
{
	public class CellObjectData extends ObjectData
	{
		private var _width : int;
		private var _height : int;
		
		private var _sides : int;
		
		public function CellObjectData()
		{
			super();
		}

		public function get width():int
		{
			return _width;
		}

		public function set width(value:int):void
		{
			_width = value;
		}

		public function get height():int
		{
			return _height;
		}

		public function set height(value:int):void
		{
			_height = value;
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
			return super.toString() + "\nWidth: " + _width + "\nHeight: " + _height + "\nSides: " + _sides;
		}
	}
}