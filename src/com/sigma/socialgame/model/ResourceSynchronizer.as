package com.sigma.socialgame.model
{
	import com.sigma.socialgame.events.model.ResourceSynchronizerEvent;
	import com.sigma.socialgame.model.objects.config.quest.BuyTodo;
	import com.sigma.socialgame.model.objects.config.quest.CommandTodo;
	import com.sigma.socialgame.model.objects.sync.avatar.CurrAvatarPart;
	import com.sigma.socialgame.model.objects.sync.map.CellMapObjectData;
	import com.sigma.socialgame.model.objects.sync.map.WallMapObjectData;
	import com.sigma.socialgame.model.objects.sync.quest.CurrQuestData;
	import com.sigma.socialgame.model.objects.sync.store.StoreObjectData;
	import com.sigma.socialgame.model.objects.sync.store.WorkerStoreObjectData;
	import com.sigma.socialgame.model.objects.sync.task.CurrTaskData;
	import com.sigma.socialgame.model.objects.sync.unlock.ExpandUnlockedData;
	import com.sigma.socialgame.model.objects.sync.unlock.JobUnlockedData;
	import com.sigma.socialgame.model.objects.sync.unlock.PriceUnlockedData;
	import com.sigma.socialgame.model.objects.sync.unlock.UnlockedData;
	import com.sigma.socialgame.model.objects.sync.unlock.UnlockedType;
	import com.sigma.socialgame.model.objects.sync.wallet.AmountData;
	import com.sigma.socialgame.model.server.command.CommandFactory;
	import com.sigma.socialgame.view.game.map.Map;
	
	import flash.net.URLLoader;

	public class ResourceSynchronizer
	{
		public static function syncQuests(questsOld_ : Vector.<CurrQuestData>, questsNew_ : Vector.<CurrQuestData>) : void
		{
			var rsEvent : ResourceSynchronizerEvent;
			
			var newQuest : CurrQuestData;
			var oldQuest : CurrQuestData;
			
			var found : Boolean;
			
			for each (newQuest in questsNew_)
			{
				found = false;
				
				for each (oldQuest in questsOld_)
				{
					if (newQuest.id == oldQuest.id)
					{
						found = true;
						
						if (updateQuest(oldQuest, newQuest))
						{
							rsEvent = new ResourceSynchronizerEvent(ResourceSynchronizerEvent.QuestChanged);
							rsEvent.quest = oldQuest;
							ResourceManager.instance.dispatchEvent(rsEvent);
						}
						
						break;
					}
				}
				
				if (!found)
				{
					questsOld_.push(newQuest);
					
					rsEvent = new ResourceSynchronizerEvent(ResourceSynchronizerEvent.QuestAdded);
					rsEvent.quest = newQuest;
					ResourceManager.instance.dispatchEvent(rsEvent);
				}
			}
		}
		
		protected static function updateQuest(oldQuest_ : CurrQuestData, newQuest_ : CurrQuestData) : Boolean
		{
			var diff : Boolean = false;
			
			if (oldQuest_.done != newQuest_.done)
			{
				oldQuest_.done = newQuest_.done;
				
				diff = true;
			}
			
			for each (var btold : BuyTodo in oldQuest_.buy)
			{
				for each (var btnew : BuyTodo in newQuest_.buy)
				{
					if (btold.type == btnew.type)
					{
						if (btold.amount != btnew.amount)
						{
							btold.amount = btnew.amount;
							
							diff = true;
							
							break;
						}
					}
				}
			}
			
			for each (var ctold : CommandTodo in oldQuest_.commands)
			{
				for each (var ctnew : CommandTodo in newQuest_.commands)
				{
					if (ctold.command.type == ctnew.command.type)
					{
						if (ctold.amount != ctnew.amount)
						{
							ctold.amount = ctnew.amount;
							
							diff = true;
							
							break;
						}
					}
				}
			}
			
			return diff;
		}
		
		public static function syncData(mapWidthOld_ : int, mapWidthNew_ : int,
										mapHeightOld_ : int, mapHeightNew_ : int,
										storeOld_ : Vector.<StoreObjectData>, storeNew_ : Vector.<StoreObjectData>,
									    tasksOld_ : Vector.<CurrTaskData>, tasksNew_ : Vector.<CurrTaskData>,
										walletOld_ : Vector.<AmountData>, walletNew_ : Vector.<AmountData>,
										mapCellsOld_ : Vector.<CellMapObjectData>, mapCellsNew_ : Vector.<CellMapObjectData>,
										mapWallsOld_ : Vector.<WallMapObjectData>, mapWallsNew_ : Vector.<WallMapObjectData>,
										unlockedOld_ : Vector.<UnlockedData>, unlockedNew_ : Vector.<UnlockedData>,
										avatarOld_ : Vector.<CurrAvatarPart>, avatarNew_ : Vector.<CurrAvatarPart>
										) : void
		{
			var rsEvent : ResourceSynchronizerEvent;
		
			if (mapWidthOld_ != mapWidthNew_ || mapHeightOld_ != mapHeightNew_)
			{
				rsEvent = new ResourceSynchronizerEvent(ResourceSynchronizerEvent.MapDimChanged);
				rsEvent.width = mapWidthNew_;
				rsEvent.height = mapHeightNew_;
				
				ResourceManager.instance.dispatchEvent(rsEvent);
			}
			
			var newthing : StoreObjectData;
			var oldthing : StoreObjectData;
			
			var foundThing : Boolean;
			
			var changeStorePairs : Vector.<ChangePair> = new Vector.<ChangePair>();
			var changeTaskPairs : Vector.<ChangePair> = new Vector.<ChangePair>();
			
			var pair : ChangePair;
			
			for each (oldthing in storeOld_)
			{
				if (oldthing.storeId.storeId < 0)
				{
					for each (newthing in storeNew_)
					{
						if (newthing.backId.equals(oldthing.storeId))
						{
							oldthing.storeId = newthing.storeId.clone();
							
							changeStorePairs.push(new ChangePair(newthing.backId.storeId, newthing.storeId.storeId)); 
							
							break;
						}
					}
				}
			}
			
			var newtask : CurrTaskData;
			var oldtask : CurrTaskData;
			
			var foundTask : Boolean;
			
			for each (oldtask in tasksOld_)
			{
				if (oldtask.id < 0)
				{
					for each (newtask in tasksNew_)
					{
						if (newtask.backId == oldtask.id)
						{
							oldtask.id = newtask.id;
							
							changeTaskPairs.push(new ChangePair(newtask.backId, newtask.id)); 
							
							break;
						}
					}
				}
			}
			
			for each (newthing in storeNew_)
			{
				foundThing = false;
				
				for each (oldthing in storeOld_)
				{
					if (newthing.storeId.equals(oldthing.storeId))
					{
						if (updateStoreObject(newthing, oldthing))
						{
							rsEvent = new ResourceSynchronizerEvent(ResourceSynchronizerEvent.StoreObjectChanged);
							rsEvent.storeObject = oldthing;
							ResourceManager.instance.dispatchEvent(rsEvent);
						}
						
						foundThing = true;
						
						break;
					}
				}
				
				if (!foundThing)
				{
					storeOld_.push(newthing);
					
					rsEvent = new ResourceSynchronizerEvent(ResourceSynchronizerEvent.StoreObjectAdded);
					rsEvent.storeObject = newthing;
					ResourceManager.instance.dispatchEvent(rsEvent);
				}
			}
			
			for each (oldthing in storeOld_)
			{
				foundThing = false;
				
				for each (newthing in storeNew_)
				{
					if (oldthing.storeId.storeId < 0)
					{
						foundThing = true;
						
						break;
					}
					
					if (newthing.storeId.equals(oldthing.storeId))
					{
						if (updateStoreObject(newthing, oldthing))
						{
							rsEvent = new ResourceSynchronizerEvent(ResourceSynchronizerEvent.StoreObjectChanged);
							rsEvent.storeObject = oldthing;
							ResourceManager.instance.dispatchEvent(rsEvent);
						}
						
						foundThing = true;
						
						break;
					}
				}
				
				if (!foundThing)
				{
					storeOld_.splice(storeOld_.indexOf(oldthing), 1);
					
					rsEvent = new ResourceSynchronizerEvent(ResourceSynchronizerEvent.StoreObjectRemoved);
					rsEvent.storeObject = oldthing;
					ResourceManager.instance.dispatchEvent(rsEvent);
				}
			}
			
			for each (newtask in tasksNew_)
			{
				foundTask = false;
				
				for each (oldtask in tasksOld_)
				{
					if (oldtask.id < 0)
					{
						for each (pair in changeTaskPairs)
						{
							if (pair._back == oldtask.id)
							{
								oldtask.id = pair._store;
							}
						}
					}
	
					if (oldtask.id == newtask.id)
					{
//						if (updateTask(oldtask, newtask))
						{
							foundTask = true;
							
							break;
						}
					}
				}
				
				if (!foundTask)
				{
					tasksOld_.push(newtask);
					
					rsEvent = new ResourceSynchronizerEvent(ResourceSynchronizerEvent.TaskAdded);
					rsEvent.task = newtask;
					ResourceManager.instance.dispatchEvent(rsEvent);
				}
			}
			
			for each (oldtask in tasksOld_)
			{
				foundTask = false;
				
				if (oldtask.id < 0)
				{
					foundTask = true;
					
					break;
				}
				
				for each (newtask in tasksNew_)
				{
					if (newtask.id == oldtask.id)
					{
						if (updateTask(oldtask, newtask))
						{
							rsEvent = new ResourceSynchronizerEvent(ResourceSynchronizerEvent.TaskChanged);
							rsEvent.task = oldtask;
							ResourceManager.instance.dispatchEvent(rsEvent);
							
							foundTask = true;
							
							break;
						}
					}
				}
				
				if (!foundTask)
				{
					tasksOld_.splice(tasksOld_.indexOf(oldtask), 1);
					
					rsEvent = new ResourceSynchronizerEvent(ResourceSynchronizerEvent.TaskRemoved);
					rsEvent.task = oldtask;
					ResourceManager.instance.dispatchEvent(rsEvent);
				}
			}
			
			var newamount : AmountData;
			var oldamount : AmountData;
			
			var foundAmount : Boolean;
			
			for each (newamount in walletNew_)
			{
				foundAmount = false;
				
				for each (oldamount in walletOld_)
				{
					if (newamount.currency.type == oldamount.currency.type)
					{
						if (updateAmount(newamount, oldamount))
						{
							rsEvent = new ResourceSynchronizerEvent(ResourceSynchronizerEvent.AmountChanged);
							rsEvent.amount = oldamount;
							ResourceManager.instance.dispatchEvent(rsEvent);
						}
						
						foundAmount = true;
						
						break;
					}
				}
				
				if (!foundAmount)
				{
					walletOld_.push(newamount);
					
					rsEvent = new ResourceSynchronizerEvent(ResourceSynchronizerEvent.AmountAdded);
					rsEvent.amount = newamount;
					ResourceManager.instance.dispatchEvent(rsEvent);
				}
			}
			
			for each (oldamount in walletOld_)
			{
				foundAmount = false;
				
				for each (newamount in walletNew_)
				{
					if (oldamount.currency.type == newamount.currency.type)
					{
						foundAmount = true;
						
						break;
					}
				}
				
				if (!foundAmount)
				{
					walletOld_.splice(walletOld_.indexOf(oldamount), 1);
					
					rsEvent = new ResourceSynchronizerEvent(ResourceSynchronizerEvent.AmountRemoved);
					rsEvent.amount = oldamount;
					ResourceManager.instance.dispatchEvent(rsEvent);
				}
			}
			
			var newmapcell : CellMapObjectData;
			var oldmapcell : CellMapObjectData;
			
			var foundCell : Boolean;
			
			for each (newmapcell in mapCellsNew_)
			{
				foundCell = false;
				
				for each (oldmapcell in mapCellsOld_)
				{
					if (oldmapcell.storeObject.storeId.storeId < 0)
					{
						for each (pair in changeStorePairs)
						{
							if (pair._back == oldmapcell.storeObject.storeId.storeId)
							{
								oldmapcell.storeObject.storeId.storeId = pair._store;
							}
						}
					}
					
/*					if (oldmapcell.storeObject.storeId.storeId < 0)
					{
						foundCell = true;
						
						break;
					}
*/					
					if (newmapcell.storeObject.storeId.equals(oldmapcell.storeObject.storeId))
					{
						if (updateMapCell(newmapcell, oldmapcell))
						{
							rsEvent = new ResourceSynchronizerEvent(ResourceSynchronizerEvent.CellObjectChanged);
							rsEvent.cellObject = oldmapcell;
							ResourceManager.instance.dispatchEvent(rsEvent);
						}
						
						foundCell = true;
						
						break;
					}
				}
				
				if (!foundCell)
				{
					mapCellsOld_.push(newmapcell);
					
					rsEvent = new ResourceSynchronizerEvent(ResourceSynchronizerEvent.CellObjectAdded);
					rsEvent.cellObject = newmapcell;
					ResourceManager.instance.dispatchEvent(rsEvent);
				}
			}
			
			for each (oldmapcell in mapCellsOld_)
			{
				foundCell = false;
				
				if (oldmapcell.storeObject.storeId.storeId < 0)
				{
					foundCell = true;
				
					break;
				}

				for each (newmapcell in mapCellsNew_)
				{
					if (oldmapcell.storeObject.storeId.equals(newmapcell.storeObject.storeId))
					{
						foundCell = true;
						
						break;
					}
				}
				
				if (!foundCell)
				{
					mapCellsOld_.splice(mapCellsOld_.indexOf(oldmapcell), 1);
					
					rsEvent = new ResourceSynchronizerEvent(ResourceSynchronizerEvent.CellObjectRemoved);
					rsEvent.cellObject = oldmapcell;
					ResourceManager.instance.dispatchEvent(rsEvent);
				}
			}
			
			var newmapwall : WallMapObjectData;
			var oldmapwall : WallMapObjectData;
			
			var foundWall : Boolean;
			
			for each (newmapwall in mapWallsNew_)
			{
				foundWall = false;
				
				for each (oldmapwall in mapWallsOld_)
				{
					if (oldmapwall.storeObject.storeId.storeId < 0)
					{
						for each (pair in changeStorePairs)
						{
							if (pair._back == oldmapwall.storeObject.storeId.storeId)
							{
								oldmapwall.storeObject.storeId.storeId = pair._store;
							}
						}
					}
					
					if (newmapwall.storeObject.storeId.equals(oldmapwall.storeObject.storeId))
					{
						if (updateMapWall(newmapwall, oldmapwall))
						{
							rsEvent = new ResourceSynchronizerEvent(ResourceSynchronizerEvent.WallObjectChanged);
							rsEvent.wallObject = oldmapwall;
							ResourceManager.instance.dispatchEvent(rsEvent);
						}
						
						foundWall = true;
						
						break;
					}
				}
				
				if (!foundWall)
				{
					mapWallsOld_.push(newmapwall);
					
					rsEvent = new ResourceSynchronizerEvent(ResourceSynchronizerEvent.WallObjectAdded);
					rsEvent.wallObject = newmapwall;
					ResourceManager.instance.dispatchEvent(rsEvent);
				}
			}
			
			for each (oldmapwall in mapWallsOld_)
			{
				foundWall = false;
				
				if (oldmapwall.storeObject.storeId.storeId < 0)
				{
					foundWall = true;
					
					break;
				}
				
				for each (newmapwall in mapWallsNew_)
				{
					if (oldmapwall.storeObject.storeId.equals(newmapwall.storeObject.storeId))
					{
						foundWall = true;
						
						break;
					}
				}
				
				if (!foundWall)
				{
					mapWallsOld_.splice(mapWallsOld_.indexOf(oldmapwall), 1);
					
					rsEvent = new ResourceSynchronizerEvent(ResourceSynchronizerEvent.WallObjectRemoved);
					rsEvent.wallObject = oldmapwall;
					ResourceManager.instance.dispatchEvent(rsEvent);
				}
			}
			
			var newunlocked : UnlockedData;
			var oldunlocked : UnlockedData;
			
			var foundUnlocked : Boolean;
			
			for each (newunlocked in unlockedNew_)
			{
				foundUnlocked = false;
				
				for each (oldunlocked in unlockedOld_)
				{
					switch (newunlocked.type)
					{
						case UnlockedType.Expand:

							if (oldunlocked.type == UnlockedType.Expand)
								if ((newunlocked as ExpandUnlockedData).expand.id == (oldunlocked as ExpandUnlockedData).expand.id)
								{
									foundUnlocked = true;
									
									break;
								}
							
							break;
						
						case UnlockedType.Job:
							
							if (oldunlocked.type == UnlockedType.Job)
								if ((newunlocked as JobUnlockedData).job.id == (oldunlocked as JobUnlockedData).job.id)
								{
									foundUnlocked = true;
									
									break;
								}
							
							break;
						
						case UnlockedType.Price:
							
							if (oldunlocked.type == UnlockedType.Price)
								if ((newunlocked as PriceUnlockedData).object.objectId.id == (oldunlocked as PriceUnlockedData).object.objectId.id)
								{
									if ((newunlocked as PriceUnlockedData).skill != null)
									{
										if ((oldunlocked as  PriceUnlockedData).skill != null)
										{
											if ((oldunlocked as PriceUnlockedData).skill.id == (newunlocked as PriceUnlockedData).skill.id)
											{
												foundUnlocked = true;
												
												break;
											}
											else
											{
												//changed
											}
										}
										else
										{
											//changed
										}
									}
									
									foundUnlocked = true;
									
									break;
								}
							
							break;
					}
				}
				
				if (!foundUnlocked)
				{
					//added
				}
			}
			
			for each (oldunlocked in unlockedOld_)
			{
				foundUnlocked = false;
				
				for each (newunlocked in unlockedNew_)
				{
					switch (oldunlocked.type)
					{
						case UnlockedType.Expand:
							
							if (newunlocked.type == UnlockedType.Expand)
								if ((newunlocked as ExpandUnlockedData).expand.id == (oldunlocked as ExpandUnlockedData).expand.id)
								{
									foundUnlocked = true;
									
									break;
								}
							
							break;
						
						case UnlockedType.Job:
							
							if (newunlocked.type == UnlockedType.Job)
								if ((newunlocked as JobUnlockedData).job.id == (oldunlocked as JobUnlockedData).job.id)
								{
									foundUnlocked = true;
									
									break;
								}
							
							break;
						
						case UnlockedType.Price:
							
							if (newunlocked.type == UnlockedType.Price)
								if ((newunlocked as PriceUnlockedData).object.objectId.id == (oldunlocked as PriceUnlockedData).object.objectId.id)
								{
									foundUnlocked = true;
									
									break;
								}
							
							break;
					}
				}
				
				if (!foundUnlocked)
				{
					//removed
				}
			}
			
			var oldpart : CurrAvatarPart;
			var newpart : CurrAvatarPart;
			
			var foundPart : Boolean;
			
			for each (oldpart in avatarOld_)
			{
				foundPart = false;
				
				for each (newpart in avatarNew_)
				{
					if (newpart.part.id == oldpart.part.id)
					{
						foundPart = true;
						
						break;
					}
				}
				
				if (!foundPart)
				{
					ResourceManager.instance.dispatchEvent(new ResourceSynchronizerEvent(ResourceSynchronizerEvent.AvatarChanged));
					
					break;
				}
			}
			Map.instance.renderScene(); //todo use event instead direct call
		}
		
		protected static function updateMapWall(newMapWall_ : WallMapObjectData, oldMapWall_ : WallMapObjectData) : Boolean
		{
			var diff : Boolean = false;
			
			if (newMapWall_.x != oldMapWall_.x)
			{
				oldMapWall_.x = newMapWall_.x;
				
				diff = true;
			}
			
			if (newMapWall_.wall != oldMapWall_.wall)
			{
				oldMapWall_.wall = newMapWall_.wall;
				
				diff = true;
			}
			
			return diff;
		}
		
		protected static function updateMapCell(newMapCell_ : CellMapObjectData, oldMapCell_ : CellMapObjectData) : Boolean
		{
			var diff : Boolean = false;
			
			if (newMapCell_.x != oldMapCell_.x)
			{
				oldMapCell_.x = newMapCell_.x;
				
				diff = true;
			}
			
			if (newMapCell_.y != oldMapCell_.y)
			{
				oldMapCell_.y = newMapCell_.y;
				
				diff = true;
			}
			
			if (newMapCell_.rotation != oldMapCell_.rotation)
			{
				oldMapCell_.rotation = newMapCell_.rotation;
				
				diff = true;
			}

/*			if (oldMapCell_ is WorkerMapObjectData)
			{
				var oldmapcell : WorkerMapObjectData = oldMapCell_ as WorkerMapObjectData;
				var newmapcell : WorkerMapObjectData = newMapCell_ as WorkerMapObjectData;
				
				if (oldmapcell.currSkill != newmapcell.currSkill)
				{
					oldmapcell.currSkill = newmapcell.currSkill;
					
					diff = true;
				}

				if (oldmapcell.currTask != null && newmapcell.currTask != null)
				{
					if (!updateTask(newmapcell.currTask, oldmapcell.currTask))
					{
						oldmapcell.currTask = newmapcell.currTask;
						
						diff = true;
					}
				}
				else if ((oldmapcell.currTask == null && newmapcell.currTask != null) || 
						 (oldmapcell.currTask != null && newmapcell.currTask == null))
				{
					diff = true;
					
					oldmapcell.currTask = newmapcell.currTask;
				}
			}
*/			
			return diff;
		}
		
		protected static function updateAmount(newAmount_ : AmountData, oldAmount_ : AmountData) : Boolean
		{
			var diff : Boolean = false;
			
			if (newAmount_.amount != oldAmount_.amount)
			{
				oldAmount_.amount = newAmount_.amount;
				
				diff = true;
			}
			
			return diff;
		}
		
		protected static function updateTask(newtask_ : CurrTaskData, oldtask_ : CurrTaskData) : Boolean
		{
			var diff : Boolean = false;
			
			if (newtask_.complete != oldtask_.complete)
			{
				oldtask_.complete = newtask_.complete;
				
				diff = true;
			}
			
			if (newtask_.time != oldtask_.time)
			{
				oldtask_.time = newtask_.time;
				
				diff = true;
			}
			
			return diff;
		}
		
		protected static function updateStoreObject(newStoreObj_ : StoreObjectData, oldStoreObj_ : StoreObjectData) : Boolean
		{
			var diff : Boolean = false;
			
			if (oldStoreObj_ is WorkerStoreObjectData)
			{
				var newStore : WorkerStoreObjectData = newStoreObj_ as WorkerStoreObjectData;
				var oldStore : WorkerStoreObjectData = oldStoreObj_ as WorkerStoreObjectData;
				
				if (newStore.currSkill.id != oldStore.currSkill.id)
				{
					oldStore.currSkill = newStore.currSkill;
					
					diff = true;
				}
				
/*				if (!newStore.onTable.equals(oldStore.onTable))
				{
					oldStore.onTable = newStore.onTable;
					
					diff = true;
				}
*/			}
			
			return diff;
		}
	}
}

class ChangePair
{
	public var _back : int;
	public var _store : int;
	
	public function ChangePair(back_ : int, store_ : int)
	{
		_back = back_;
		_store = store_;
	}
}