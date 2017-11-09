package com.sigma.socialgame.model.objects.config.quest
{
	import com.sigma.socialgame.model.server.command.Command;

	public class CommandTodo
	{
		private var _command : Command;
		private var _amount : int;
		private var _desc : String;
		
		public function CommandTodo()
		{
		}

		public function get command(): Command
		{
			return _command;
		}

		public function set command(value:Command):void
		{
			_command = value;
		}

		public function get amount():int
		{
			return _amount;
		}

		public function set amount(value:int):void
		{
			_amount = value;
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