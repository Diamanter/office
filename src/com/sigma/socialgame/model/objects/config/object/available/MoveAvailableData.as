package com.sigma.socialgame.model.objects.config.object.available
{
	public class MoveAvailableData extends AvailableData
	{
		private var _moveX : Boolean;
		private var _moveY : Boolean;
		
		public function MoveAvailableData()
		{
			super();
		}
		
		public function get moveX() : Boolean
		{
			return _moveX;
		}
		
		public function set moveX(moveX_ : Boolean) : void
		{
			_moveX = moveX_;
		}
		
		public function get moveY() : Boolean
		{
			return _moveY;
		}
		
		public function set moveY(moveY_ : Boolean) : void
		{
			_moveY = moveY_;
		}
		
		public override function toString():String
		{
			return super.toString() + "\nMoveX: " + _moveX + "\nMoveY: " + _moveY;  
		}
	}
}