package com.sigma.socialgame.model.objects.config.object
{
	import com.sigma.socialgame.model.common.id.objectid.ObjectIdentifier;
	import com.sigma.socialgame.model.objects.config.condition.ConditionData;
	import com.sigma.socialgame.model.objects.config.object.available.AvailableData;

	public class ObjectData
	{
		private var _objectId : ObjectIdentifier;
		
		private var _type : String;
		
		private var _available : Vector.<AvailableData>;
		
		private var _place : String;
		
		private var _name : String;
		
		//private var _giftable : ConditionData;
		
		public function ObjectData()
		{
		}

		public function get objectId():ObjectIdentifier
		{
			return _objectId;
		}

		public function set objectId(value:ObjectIdentifier):void
		{
			_objectId = value;
		}

		public function get type():String
		{
			return _type;
		}

		public function set type(value:String):void
		{
			_type = value;
		}

		public function get available():Vector.<AvailableData>
		{
			return _available;
		}

		public function set available(value:Vector.<AvailableData>):void
		{
			_available = value;
		}
		
		public function toString() : String
		{
			return "Type: " + _type + "\nObjId: " + _objectId.toString() + "\nAvail: " + _available;
		}

		public function get place():String
		{
			return _place;
		}

		public function set place(value:String):void
		{
			_place = value;
		}

		public function get name():String
		{
			return _name;
		}

		public function set name(value:String):void
		{
			_name = value;
		}

		/*public function get giftable():ConditionData
		{
			return _giftable;
		}

		public function set giftable(value:ConditionData):void
		{
			_giftable = value;
		}*/


	}
}