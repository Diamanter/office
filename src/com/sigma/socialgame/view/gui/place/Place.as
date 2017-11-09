package com.sigma.socialgame.view.gui.place
{
	import flash.geom.Vector3D;

	public class Place
	{
		private var _place : Vector3D;
		
		private var _fullScreenPlace : Vector3D;
		private var _fullScrrenAlign : String;
		
		public function Place(place_ : Vector3D, fullPlace_ : Vector3D, fullAlign_ : String)
		{
			_place = place_;
			
			_fullScreenPlace = fullPlace_;
			_fullScrrenAlign = fullAlign_;
		}

		public function get place():Vector3D
		{
			return _place;
		}

		public function set place(value:Vector3D):void
		{
			_place = value;
		}

		public function get fullScreenPlace():Vector3D
		{
			return _fullScreenPlace;
		}

		public function set fullScreenPlace(value:Vector3D):void
		{
			_fullScreenPlace = value;
		}

		public function get fullScrrenAlign():String
		{
			return _fullScrrenAlign;
		}

		public function set fullScrrenAlign(value:String):void
		{
			_fullScrrenAlign = value;
		}


	}
}