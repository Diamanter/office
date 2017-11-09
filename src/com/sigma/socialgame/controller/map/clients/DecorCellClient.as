package com.sigma.socialgame.controller.map.clients
{
	import com.sigma.socialgame.controller.map.objects.CellObject;
	import com.sigma.socialgame.model.common.id.objectid.ObjectTypes;
	
	public class DecorCellClient extends CellClient
	{
		public function DecorCellClient()
		{
			super();
		}
		
		protected override function check(x_ : int, y_ : int, xlen_ : int, ylen_ : int) : Boolean
		{
			var i : int;
			var j : int;
			
			var type : String;
			
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
								
								if (type != ObjectTypes.Trim)
								{
									return false;
								}
							}
						}
					}
				}
			}
			
			return true;
		}
	}
}