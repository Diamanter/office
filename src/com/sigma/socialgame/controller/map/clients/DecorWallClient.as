package com.sigma.socialgame.controller.map.clients
{
	import com.sigma.socialgame.controller.map.objects.WallObject;
	import com.sigma.socialgame.model.common.id.objectid.ObjectTypes;

	public class DecorWallClient extends WallClient
	{
		public function DecorWallClient()
		{
			super();
		}
		
		protected override function check(wall_:int, x_:int):Boolean
		{
			if (wall_ != 1 && wall_ != 0)
				return false;
			
			var i : int;
			
			var type : String;
			
			var mapL : int = (wall_ == 0 ? mapController.width : mapController.height);
			
			for (i = x_; i < x_ + wallObject.width; i++)
			{
				if (i >= mapL || i < 0)
					return false;

				if (!mapController.walls[wall_][i].empty)
				{
					for each (var obj : WallObject in mapController.walls[wall_][i].objects)
					{
						if (!obj.mapObject.storeObject.storeId.equals(wallObject.mapObject.storeObject.storeId))
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
			
			return true;
		}
	}
}