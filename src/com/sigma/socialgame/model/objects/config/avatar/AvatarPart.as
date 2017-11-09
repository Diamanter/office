package com.sigma.socialgame.model.objects.config.avatar
{
	import com.sigma.socialgame.model.common.id.objectid.ObjectIdentifier;
	import com.sigma.socialgame.model.objects.config.condition.ConditionData;
	import com.sigma.socialgame.model.objects.config.flags.FlagData;
	import com.sigma.socialgame.model.objects.config.object.available.AvailableData;
	import com.sigma.socialgame.model.objects.sync.wallet.AmountData;

	public class AvatarPart
	{
		private var _type : String;
		private var _sex : String;
		private var _id : int;
		private var _image : String;

		private var _defaultPart : Boolean;
		
		private var _condition : ConditionData;

		private var _availables : Vector.<AvailableData>;
		
		private var _flags : Vector.<FlagData>;

		public function toString() : String
		{
			return "Type: " + type + "\nSex:" + _sex + "\nId: " + id + "\nImage: " + image;
		}

		public function get type():String
		{
			return _type;
		}

		public function set type(value:String):void
		{
			_type = value;
		}
		
		public function get sex():String
		{
			return _sex;
		}
		
		public function set sex(value:String):void
		{
			_sex = value;
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

		public function get condition():ConditionData
		{
			return _condition;
		}

		public function set condition(value:ConditionData):void
		{
			_condition = value;
		}

		public function get availables():Vector.<AvailableData>
		{
			return _availables;
		}

		public function set availables(value:Vector.<AvailableData>):void
		{
			_availables = value;
		}

		public function get defaultPart():Boolean
		{
			return _defaultPart;
		}

		public function set defaultPart(value:Boolean):void
		{
			_defaultPart = value;
		}
		
		public function get flags():Vector.<FlagData>
		{
			return _flags;
		}

		public function set flags(value:Vector.<FlagData>):void
		{
			_flags = value;
		}


	}
}