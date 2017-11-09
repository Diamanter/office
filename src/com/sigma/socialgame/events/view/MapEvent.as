package com.sigma.socialgame.events.view
{
	import starling.events.Event;
	import flash.geom.Point;
	
	public class MapEvent extends Event
	{
		public static const MapMoved : String = "mMapMoved";
		public static const MapZoomed : String = "mMapZoomed";
		
		public static const CellMouse : String = "mCellMouse";
		public static const WallMouse : String = "mWallMouse";
		
		public static const MapClicked : String = "mMapClicked";
		
		public static const StartMove : String = "mStartMove";
		public static const EndMove : String = "mEndMove";
		
		private var _coords : Point;
		
		public function MapEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}

		public function get coords():Point
		{
			return _coords;
		}

		public function set coords(value:Point):void
		{
			_coords = value;
		}

	}
}