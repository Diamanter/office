package com.sigma.socialgame.model.objects.config.quest
{
	import com.sigma.socialgame.model.objects.config.object.ObjectData;

	public class BuyTodo
	{
		private var _type : String;
		private var _object : ObjectData;
		private var _amount : int;
		private var _desc : String;
		
		public function BuyTodo()
		{
		}

		public function get object():ObjectData
		{
			return _object;
		}

		public function set object(value:ObjectData):void
		{
			_object = value;
		}

		public function get amount():int
		{
			return _amount;
		}

		public function set amount(value:int):void
		{
			_amount = value;
		}

		public function get type():String
		{
			return _type;
		}

		public function set type(value:String):void
		{
			_type = value;
		}

		public function get desc():String
		{
			return _desc;
		}

		public function set desc(value:String):void
		{
			_desc = value;
		}


	}
}