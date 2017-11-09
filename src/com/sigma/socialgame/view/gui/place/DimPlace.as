package com.sigma.socialgame.view.gui.place
{
	import flash.geom.Vector3D;

	public class DimPlace extends Place
	{
		private var _dim : Vector3D;
		
		public function DimPlace(place_ : Vector3D, fullPlace_ : Vector3D, fullAlign_ : String, dim_ : Vector3D)
		{
			super(place_, fullPlace_, fullAlign_);
			
			_dim = dim_;
		}

		public function get dim():Vector3D
		{
			return _dim;
		}

		public function set dim(value:Vector3D):void
		{
			_dim = value;
		}

	}
}