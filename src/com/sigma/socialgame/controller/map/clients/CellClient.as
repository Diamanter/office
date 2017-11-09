package com.sigma.socialgame.controller.map.clients
{
	import com.sigma.socialgame.common.logger.LogLevel;
	import com.sigma.socialgame.common.logger.LogModule;
	import com.sigma.socialgame.common.logger.Logger;
	import com.sigma.socialgame.controller.map.objects.CellObject;
	import com.sigma.socialgame.model.objects.config.object.available.AvailableData;
	import com.sigma.socialgame.model.objects.config.object.available.AvailableTypes;
	import com.sigma.socialgame.model.objects.config.object.available.MoveAvailableData;

	public class CellClient extends MapClient
	{
		public function CellClient()
		{
			super();
		}
		
		public function rotate(rot_:int):Boolean
		{
			if (!checkRot(rot_))
				return false;
			
			cellObject.rotation = rot_;
			
			mapController.rotateCellObject(cellObject);
			
			return true;
		}
		
		public function move(x_:int, y_:int, send : Boolean):Boolean
		{
			if (!checkPos(x_, y_))
				return false;
			
			cellObject.x = x_;
			cellObject.y = y_;
			
			//mapController.moveCellObject(cellObject, send);
			
			return true;
		}
		
		public function checkPos(x_ : int, y_ : int) : Boolean
		{
			return check(x_, y_, cellObject.xLength, cellObject.yLength);
		}
		
		public function checkRot(rot_ : int ) : Boolean
		{
			if (Math.abs(rot_ - cellObject.rotation) == 2)
			{
				return check(cellObject.x, cellObject.y, cellObject.xLength, cellObject.yLength);
			}
			else
			{
				return check(cellObject.x, cellObject.y, cellObject.yLength, cellObject.xLength);
			}
		}
		
		protected function check(x_ : int, y_ : int, xlen_ : int, ylen_ : int) : Boolean
		{
			Logger.message("Using abstract function \"check\".", "MapControllerClient", LogLevel.Warning, LogModule.Controller);
			
			return false;
		}
		
		public function get canMoveX() : Boolean
		{
			for each (var avail : AvailableData in cellObject.mapObject.storeObject.object.available)
			{
				if (avail.type == AvailableTypes.Move)
				{
					return (avail as MoveAvailableData).moveX;
				}
			}
			
			return false;
		}
		
		public function get canMoveY() : Boolean
		{
			for each (var avail : AvailableData in cellObject.mapObject.storeObject.object.available)
			{
				if (avail.type == AvailableTypes.Move)
				{
					return (avail as MoveAvailableData).moveY;
				}
			}
			
			return false;
		}
		
		public function get canRotate() : Boolean
		{
			for each (var avail : AvailableData in cellObject.mapObject.storeObject.object.available)
			{
				if (avail.type == AvailableTypes.Rotate)
				{
					return true;
				}
			}
			
			return false;
		}
		
		public function get cellObject() : CellObject
		{
			return mapObject as CellObject;
		}
		
		public override function toString():String
		{
			return "CellObject: " + cellObject.toString();
		}
	}
}