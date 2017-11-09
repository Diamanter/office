package com.sigma.socialgame.controller.map
{
	import com.sigma.socialgame.controller.ControllerManager;
	import com.sigma.socialgame.controller.ControllerNames;
	import com.sigma.socialgame.controller.map.objects.CellObject;
	import com.sigma.socialgame.controller.map.objects.MapCell;
	import com.sigma.socialgame.controller.map.way.Way;
	import com.sigma.socialgame.controller.map.way.WayChain;
	import com.sigma.socialgame.controller.map.way.WayPoint;
	import com.sigma.socialgame.model.common.id.objectid.ObjectTypes;
	
	import flash.geom.Point;
	
	import org.osmf.layout.AbsoluteLayoutFacet;

	public class WayFactory
	{
		private static var _way : Way;
		private static var _chain : Vector.<WayChain>;
		private static var _tempMap : Vector.<Vector.<Boolean>>;
		
		private static var _start : WayPoint;
		private static var _finish : WayPoint;
		
		private static var _currInd : int;
		private static var _currChain : WayChain;
		
		private static var _bias : Array = [[1, 0], [-1, 0], [0, 1], [0, -1]];
		
		public static function createWay(start_ : Point, finish_ : Point) : Way
		{
			initData(start_, finish_);
			
			calcChain();
			
			if (_way == null)
			{
				calcChain(true);
			}
			
			return _way;
		}
		
		private static function calcChain(ignore_ : Boolean = false) : void
		{
			for (_currInd = 0, _currChain = _chain[_currInd]; _currInd != _chain.length; _currInd++)
			{
				_currChain = _chain[_currInd];
				
				if (addChain(ignore_))
				{
					buildWay();
					
					break;
				}
			}
		}
		
		private static function addChain(ignore_ : Boolean) : Boolean
		{
			_tempMap[_currChain.point.x][_currChain.point.y] = true;
			
			if (_currChain.point.x == _finish.x && _currChain.point.y == _finish.y)
			{
				return true;
			}
			
			var next : WayPoint = new WayPoint();
			
			for (var i : int = 0; i < 4; i++)
			{
				next.x = _currChain.point.x + _bias[i][0];
				next.y = _currChain.point.y + _bias[i][1];
				
				if (next.x == _finish.x && next.y == _finish.y)
				{
					return true;
				}
				
				if (next.x >= 0 && next.x < mapController.width && next.y >= 0 && next.y < mapController.height)
				{
					if (emptyCell(next) || ignore_)
					{
						if (_tempMap[next.x][next.y] == false)
						{
							_chain.push(new WayChain(next.x, next.y, _currChain));
						}
					}
				}
			}
			
			return false;
		}

		private static function emptyCell(point : WayPoint) : Boolean
		{
			var cell : MapCell = mapController.cells[point.x][point.y];
			
			for each (var cellObject : CellObject in cell.objects)
			{
				if (cellObject.storeObject.storeObject.object.type != ObjectTypes.Trim)
					return false;
			}
			
			return true;
		}
		
		private static function buildWay() : void
		{
			_way = new Way();
			
			for (var end : WayChain = _currChain; end != null; end = end.prev)
			{
				_way.way.push(new WayPoint(end.point.x, end.point.y));
			}
			
			_way.way = _way.way.reverse();
		}
		
		private static function initData(start_ : Point, finish_ : Point) : void
		{
			_way = null;
			
			_start = new WayPoint(start_.x, start_.y);
			_finish = new WayPoint(finish_.x, finish_.y);
			
			_chain = new Vector.<WayChain>();
			
			_tempMap = new Vector.<Vector.<Boolean>>();
			
			for (var i : int = 0; i < mapController.width; i++)
			{
				_tempMap[i] = new Vector.<Boolean>();
				
				for (var j : int = 0; j < mapController.height; j++)
				{
					_tempMap[i][j] = false;
				}
			}
			
			var newChain : WayChain = new WayChain(_start.x, _start.y);
			
			_chain.push(newChain);
		}
		
		private static function get mapController() : MapController
		{
			return ControllerManager.instance.getController(ControllerNames.MapController) as MapController;
		}
	}
}