package com.sigma.socialgame.model.objects.sync.quest
{
	import com.sigma.socialgame.model.objects.config.quest.BuyTodo;
	import com.sigma.socialgame.model.objects.config.quest.CommandTodo;
	import com.sigma.socialgame.model.objects.config.quest.QuestData;

	public class CurrQuestData
	{
		private var _id : int;
		private var _type : int;
		private var _done : Boolean;
		
		private var _data : QuestData;
		
		private var _commands : Vector.<CommandTodo>;
		private var _buy : Vector.<BuyTodo>;
		
		public function CurrQuestData()
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

		public function get done():Boolean
		{
			return _done;
		}

		public function set done(value:Boolean):void
		{
			_done = value;
		}

		public function get data():QuestData
		{
			return _data;
		}

		public function set data(value:QuestData):void
		{
			_data = value;
		}

		public function get commands():Vector.<CommandTodo>
		{
			return _commands;
		}

		public function set commands(value:Vector.<CommandTodo>):void
		{
			_commands = value;
		}

		public function get buy():Vector.<BuyTodo>
		{
			return _buy;
		}

		public function set buy(value:Vector.<BuyTodo>):void
		{
			_buy = value;
		}

		public function get type():int
		{
			return _type;
		}

		public function set type(value:int):void
		{
			_type = value;
		}


	}
}