package com.sigma.socialgame.view.game.map.objects.avatar
{
	public class SexChooser
	{
		public static function chooseSex(id_ : int) : String
		{
			var seed_1 : int = id_;
			
			seed_1 = 36969 * (seed_1 & 65535) + (seed_1 >> 16);
			
			return (seed_1 % 2 == 0 ? Sex.Man : Sex.Woman);
		}
	}
}