package com.sigma.socialgame.model.objects.config.level
{
	import com.sigma.socialgame.model.objects.sync.wallet.AmountData;

	public class LevelData
	{
		private var _id : int;
		private var _name : String;
		private var _friends : int;
		private var _rank : int;
		
		private var _until : Vector.<AmountData>;
		
		public function LevelData()
		{
		}

		public function get id():int
		{
			return _id;
		}

		public function set id(value:int):void
		{
			_id = value;
		}

		public function get name():String
		{
			return _name;
		}

		public function set name(value:String):void
		{
			_name = value;
		}

		public function get friends():int
		{
			return _friends;
		}

		public function set friends(value:int):void
		{
			_friends = value;
		}

		public function get until():Vector.<AmountData>
		{
			return _until;
		}

		public function set until(value:Vector.<AmountData>):void
		{
			_until = value;
		}

		public function toString() : String
		{
			return "Id: " + _id + "\nName: " + _name + "\nFriends: " + _friends + "\nUntils: " + (_until == null ? _until : _until.toString());
		}

		public function get rank():int
		{
			return _rank;
		}

		public function set rank(value:int):void
		{
			_rank = value;
		}

	}
}