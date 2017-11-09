package com.sigma.socialgame.controller.map.clients
{
	import com.sigma.socialgame.controller.map.objects.CellObject;
	import com.sigma.socialgame.controller.map.objects.MapObject;
	import com.sigma.socialgame.model.common.id.objectid.ObjectTypes;

	public class WorkerClient extends CellClient
	{
		public function WorkerClient()
		{
			super();
		}

		public override function get canRotate():Boolean
		{
			return true;
		}
		
		public function isThereWorkspace(x_ : int, y_ : int) : MapObject
		{
			var i : int;
			var j : int;
			
			var type : String;
			
			var hasWorkspace : Boolean = false;
			var mo : MapObject;
			
			if (x_ >= mapController.width || x_ < 0)
				return null;
			
			if (y_ >= mapController.height || y_ < 0)
				return null;
				
			if (!mapController.cells[x_][y_].empty)
			{
				for each (var obj : CellObject in mapController.cells[x_][y_].objects)
				{
					if (!obj.mapObject.storeObject.storeId.equals(cellObject.mapObject.storeObject.storeId))
					{
						type = obj.mapObject.storeObject.object.type;
						
						if (type == ObjectTypes.Workspace)
						{
							mo = obj;
						}
					}
				}
			}
			
			return mo;
		}
		
		protected override function check(x_ : int, y_ : int, xlen_ : int, ylen_ : int) : Boolean
		{
			var i : int;
			var j : int;
			
			var type : String;
			
			var hasWorkspace : Boolean = false;
			
			for (i = x_; i < x_ + xlen_; i++)
			{
				if (i >= mapController.width || i < 0)
					return false;
				
				for (j = y_; j < y_ + ylen_; j++)
				{
					if (j >= mapController.height || j < 0)
						return false;
					
					if (!mapController.cells[i][j].empty)
					{
						for each (var obj : CellObject in mapController.cells[i][j].objects)
						{
							if (!obj.mapObject.storeObject.storeId.equals(cellObject.mapObject.storeObject.storeId))
							{
								type = obj.mapObject.storeObject.object.type;
								
								if (type != ObjectTypes.Trim && type != ObjectTypes.Workspace)
								{
									return false;
								}
								else if (type == ObjectTypes.Workspace)
								{
									hasWorkspace = true;
								}
							}
						}
					}
				}
			}
			
			if (!hasWorkspace)
				return false;
		
			return true;
		}
	}
}