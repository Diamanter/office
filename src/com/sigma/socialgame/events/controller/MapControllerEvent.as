package com.sigma.socialgame.events.controller
{
	import com.sigma.socialgame.controller.ControllerNames;
	import com.sigma.socialgame.controller.map.objects.CellObject;
	import com.sigma.socialgame.controller.map.objects.WallObject;

	public class MapControllerEvent extends ControllerEvent
	{
		public static const Inited : String = "mapcInited";
		public static const Started : String = "mapcStarted";
		public static const Synced : String = "mapcSynced";
		
		public static const CellObjectAdded : String = "mapcCellObjectAdded";
		public static const CellObjectRemoved : String = "mapcCelObjectRemoved";
		
		public static const NewCellObject : String = "mapcNewCellObject";
		public static const NewWallObject : String = "mapcNewWallObject";
		
		public static const WallObjectAdded : String = "mapcCellObjectAdded";
		public static const WallObjectRemoved : String = "mapcCellObjectRemoveD";
		
		public static const DimenstionChanged : String = "mapcDimensionChanged";
		
		private var _width : int;
		private var _height : int;
		
		private var _cellObject : CellObject;
		private var _wallObject : WallObject;
		
		public function MapControllerEvent(type:String)
		{
			super(type, ControllerNames.MapController);
		}

		public function get wallObject():WallObject
		{
			return _wallObject;
		}

		public function set wallObject(value:WallObject):void
		{
			_wallObject = value;
		}

		public function get cellObject():CellObject
		{
			return _cellObject;
		}

		public function set cellObject(value:CellObject):void
		{
			_cellObject = value;
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


	}
}