package com.sigma.socialgame.model.objects.config.expand
{
	import com.sigma.socialgame.model.objects.config.condition.ConditionData;
	import com.sigma.socialgame.model.objects.sync.wallet.AmountData;

	public class ExpandData
	{
		private var _id : int;
		
		private var _width : int;
		private var _height : int;
		
		private var _condition : ConditionData;
		
		private var _prices : Vector.<AmountData>;
		
		private var _image : String;
		
		public function ExpandData()
		{
		}

		public function get width():int
		{
			return _width;
		}

		public function set width(value:int):void
		{
			_width = value;
		}

		public function get height():int
		{
			return _height;
		}

		public function set height(value:int):void
		{
			_height = value;
		}

		public function get condition():ConditionData
		{
			return _condition;
		}

		public function set condition(value:ConditionData):void
		{
			_condition = value;
		}

		public function get prices():Vector.<AmountData>
		{
			return _prices;
		}

		public function set prices(value:Vector.<AmountData>):void
		{
			_prices = value;
		}

		public function get id():int
		{
			return _id;
		}

		public function set id(value:int):void
		{
			_id = value;
		}

		public function get image():String
		{
			return _image;
		}

		public function set image(value:String):void
		{
			_image = value;
		}


	}
}