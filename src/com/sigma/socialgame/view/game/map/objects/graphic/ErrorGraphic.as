package com.sigma.socialgame.view.game.map.objects.graphic
{
	import com.sigma.socialgame.controller.map.objects.CellObject;
	import com.sigma.socialgame.controller.map.objects.MapObject;
	import com.sigma.socialgame.controller.map.objects.WallObject;

	public class ErrorGraphic
	{
		//[Embed(source="/../data/system/errorCell.swf")]
		private static var _errorCell : Class;
		
		//[Embed(source="/../data/system/errorWall_NE.swf")]
		private static var _errorWallNE : Class;
		
		//[Embed(source="/../data/system/errorWall_NW.swf")]
		private static var _errorWallNW : Class;
		
		public static function getErrorClass(mapObj_ : MapObject) : Class
		{
			if (mapObj_ is CellObject)
			{
				return _errorCell;
			}
			else if (mapObj_ is WallObject)
			{
				if ((mapObj_ as WallObject).wall == 0)
				{
					return _errorWallNW;
				}
				else
				{
					return _errorWallNE;
				}
			}
			
			return null;
		}
	}
}