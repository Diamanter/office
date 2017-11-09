package com.sigma.socialgame.common.map
{
	public class MapRotation
	{
		public static const NorthWest : int = 0; //не менять значения. на это сильно завязаны стены.
		public static const NorthEast : int = 1;
		public static const SouthEast : int = 2; 
		public static const SouthWest : int = 3; 
		
		public static function next(rot_ : int) : int
		{
			return (rot_ + 1) % 4;	//0->1, 1->2, 2->3, 3->0, CW rotation
		}
		
		public static function prev(rot_  : int) : int
		{
			return (rot_ + 3) % 4; //3->2, 2->1, 1->0, 0->3, CCW rotation
		}
	}
}