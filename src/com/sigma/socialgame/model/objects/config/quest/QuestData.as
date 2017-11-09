package com.sigma.socialgame.model.objects.config.quest
{
	import com.sigma.socialgame.model.objects.config.condition.ConditionData;
	import com.sigma.socialgame.model.objects.config.object.task.GiveData;
	import com.sigma.socialgame.model.objects.config.object.task.ResultData;
	import com.sigma.socialgame.model.objects.sync.wallet.AmountData;

	public class QuestData
	{
		private var _id : int;
		private var _locked : ConditionData;
		
		private var _title : String;
		private var _desc : String;
		private var _success : String;

		private var _icon : String;
		private var _image : String;
		
		private var _gives : Vector.<GiveData>;
		private var _result : Vector.<ResultData>;
		
		private var _commands : Vector.<CommandTodo>;
		private var _buy : Vector.<BuyTodo>;
		
		public function QuestData()
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

		public function get locked():ConditionData
		{
			return _locked;
		}

		public function set locked(value:ConditionData):void
		{
			_locked = value;
		}

		public function get desc():String
		{
			return _desc;
		}

		public function set desc(value:String):void
		{
			_desc = value;
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

		public function get icon():String
		{
			return _icon;
		}

		public function set icon(value:String):void
		{
			_icon = value;
		}

		public function get image():String
		{
			return _image;
		}

		public function set image(value:String):void
		{
			_image = value;
		}

		public function get gives():Vector.<GiveData>
		{
			return _gives;
		}

		public function set gives(value:Vector.<GiveData>):void
		{
			_gives = value;
		}

		public function get result():Vector.<ResultData>
		{
			return _result;
		}

		public function set result(value:Vector.<ResultData>):void
		{
			_result = value;
		}

		public function get title():String
		{
			return _title;
		}

		public function set title(value:String):void
		{
			_title = value;
		}

		public function get success():String
		{
			return _success;
		}

		public function set success(value:String):void
		{
			_success = value;
		}


	}
}