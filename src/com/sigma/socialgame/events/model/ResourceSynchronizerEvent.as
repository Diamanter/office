package com.sigma.socialgame.events.model
{
	import com.sigma.socialgame.model.objects.sync.map.CellMapObjectData;
	import com.sigma.socialgame.model.objects.sync.map.WallMapObjectData;
	import com.sigma.socialgame.model.objects.sync.quest.CurrQuestData;
	import com.sigma.socialgame.model.objects.sync.store.StoreObjectData;
	import com.sigma.socialgame.model.objects.sync.task.CurrTaskData;
	import com.sigma.socialgame.model.objects.sync.wallet.AmountData;
	
	import flash.events.Event;
	
	public class ResourceSynchronizerEvent extends Event
	{
		public static const QuestChanged : String = "rsQuestChanged";
		public static const QuestAdded : String = "rsQuestAdded";
		
		public static const MapDimChanged : String = "rsMapDimChanged";
		
		public static const StoreObjectChanged : String = "rsStoreObjectChanged";
		public static const StoreObjectAdded : String = "rsStoreObjectAdded";
		public static const StoreObjectRemoved : String = "rsStoreObjectRemoved";
		
		public static const TaskAdded : String = "rsTaskAdded";
		public static const TaskChanged : String = "rsTaskChanged";
		public static const TaskRemoved : String = "rsTaskRemoved";
		
		public static const AmountChanged : String = "rsAmountChanged";
		public static const AmountRemoved : String = "rsAmountRemoved";
		public static const AmountAdded : String = "rsAmountAdded";
		
		public static const CellObjectChanged : String = "rsCellObjectChanged";
		public static const CellObjectRemoved : String = "rsCellObjectRemoved";
		public static const CellObjectAdded : String = "rsCellObjectAdded";
		
		public static const WallObjectChanged : String = "rsWallObjectChanged";
		public static const WallObjectRemoved : String = "rsWallObjectRemoved";
		public static const WallObjectAdded : String = "rsWallObjectAdded";
		
		public static const AvatarChanged : String = "rsAvatarChanged";
		
		private var _quest : CurrQuestData;
		
		private var _width : int;
		private var _height : int;
		
		private var _storeObject : StoreObjectData;
		private var _task : CurrTaskData;
		private var _amount : AmountData;
		private var _cellObject : CellMapObjectData;
		private var _wallObject : WallMapObjectData;
		
		public function ResourceSynchronizerEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		public function get wallObject():WallMapObjectData
		{
			return _wallObject;
		}

		public function set wallObject(value:WallMapObjectData):void
		{
			_wallObject = value;
		}

		public function get cellObject():CellMapObjectData
		{
			return _cellObject;
		}

		public function set cellObject(value:CellMapObjectData):void
		{
			_cellObject = value;
		}

		public function get amount():AmountData
		{
			return _amount;
		}

		public function set amount(value:AmountData):void
		{
			_amount = value;
		}

		public function get task():CurrTaskData
		{
			return _task;
		}

		public function set task(value:CurrTaskData):void
		{
			_task = value;
		}

		public function get storeObject():StoreObjectData
		{
			return _storeObject;
		}
		
		public function set storeObject(value:StoreObjectData):void
		{
			_storeObject = value;
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

		public function get quest():CurrQuestData
		{
			return _quest;
		}

		public function set quest(value:CurrQuestData):void
		{
			_quest = value;
		}


	}
}