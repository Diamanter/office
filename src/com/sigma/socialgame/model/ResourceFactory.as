package com.sigma.socialgame.model
{
	import com.sigma.socialgame.common.logger.LogLevel;
	import com.sigma.socialgame.common.logger.LogModule;
	import com.sigma.socialgame.common.logger.Logger;
	import com.sigma.socialgame.common.map.MapRotation;
	import com.sigma.socialgame.model.common.id.objectid.ObjectIdFactory;
	import com.sigma.socialgame.model.common.id.objectid.ObjectIdentifier;
	import com.sigma.socialgame.model.common.id.objectid.ObjectPlaces;
	import com.sigma.socialgame.model.common.id.objectid.ObjectTypes;
	import com.sigma.socialgame.model.common.id.socialid.SocialIdFactory;
	import com.sigma.socialgame.model.common.id.storeid.StoreIdFactory;
	import com.sigma.socialgame.model.common.id.storeid.StoreIdentifier;
	import com.sigma.socialgame.model.objects.config.flags.FlagData;
	import com.sigma.socialgame.model.objects.config.avatar.AvatarPart;
	import com.sigma.socialgame.model.objects.config.condition.ConditionData;
	import com.sigma.socialgame.model.objects.config.convert.ConvertData;
	import com.sigma.socialgame.model.objects.config.currency.CurrencyData;
	import com.sigma.socialgame.model.objects.config.expand.ExpandData;
	import com.sigma.socialgame.model.objects.config.graphic.ImageData;
	import com.sigma.socialgame.model.objects.config.graphic.SkinData;
	import com.sigma.socialgame.model.objects.config.level.LevelData;
	import com.sigma.socialgame.model.objects.config.money.MoneyData;
	import com.sigma.socialgame.model.objects.config.object.CellObjectData;
	import com.sigma.socialgame.model.objects.config.object.ObjectData;
	import com.sigma.socialgame.model.objects.config.object.WallObjectData;
	import com.sigma.socialgame.model.objects.config.object.WorkerObjectData;
	import com.sigma.socialgame.model.objects.config.object.available.GiftAvailableData;
	import com.sigma.socialgame.model.objects.config.object.available.AvailableData;
	import com.sigma.socialgame.model.objects.config.object.available.AvailableTypes;
	import com.sigma.socialgame.model.objects.config.object.available.BuyAvailableData;
	import com.sigma.socialgame.model.objects.config.object.available.MoveAvailableData;
	import com.sigma.socialgame.model.objects.config.object.available.SellAvailableData;
	import com.sigma.socialgame.model.objects.config.object.available.WorkerBuyAvailableData;
	import com.sigma.socialgame.model.objects.config.object.available.WorkerSellAvailableData;
	import com.sigma.socialgame.model.objects.config.object.lock.ILockable;
	import com.sigma.socialgame.model.objects.config.object.skill.SkillData;
	import com.sigma.socialgame.model.objects.config.object.task.FertilizerData;
	import com.sigma.socialgame.model.objects.config.object.task.GiveData;
	import com.sigma.socialgame.model.objects.config.object.task.JobData;
	import com.sigma.socialgame.model.objects.config.object.task.LockedJobData;
	import com.sigma.socialgame.model.objects.config.object.task.ManuredData;
	import com.sigma.socialgame.model.objects.config.object.task.NeedData;
	import com.sigma.socialgame.model.objects.config.object.task.RequireData;
	import com.sigma.socialgame.model.objects.config.object.task.RequireTypes;
	import com.sigma.socialgame.model.objects.config.object.task.ResultData;
	import com.sigma.socialgame.model.objects.config.object.task.ResultTypes;
	import com.sigma.socialgame.model.objects.config.object.task.TaskData;
	import com.sigma.socialgame.model.objects.config.quest.BuyTodo;
	import com.sigma.socialgame.model.objects.config.quest.CommandTodo;
	import com.sigma.socialgame.model.objects.config.quest.QuestData;
	import com.sigma.socialgame.model.objects.sync.avatar.CurrAvatarPart;
	import com.sigma.socialgame.model.objects.sync.friend.FriendData;
	import com.sigma.socialgame.model.objects.sync.gift.GiftData;
	import com.sigma.socialgame.model.objects.sync.id.ReservedIdObject;
	import com.sigma.socialgame.model.objects.sync.id.ReservedIdType;
	import com.sigma.socialgame.model.objects.sync.map.CellMapObjectData;
	import com.sigma.socialgame.model.objects.sync.map.WallMapObjectData;
	import com.sigma.socialgame.model.objects.sync.map.WorkerMapObjectData;
	import com.sigma.socialgame.model.objects.sync.quest.CurrQuestData;
	import com.sigma.socialgame.model.objects.sync.store.StoreObjectData;
	import com.sigma.socialgame.model.objects.sync.store.WorkerStoreObjectData;
	import com.sigma.socialgame.model.objects.sync.task.CurrTaskData;
	import com.sigma.socialgame.model.objects.sync.unlock.JobUnlockedData;
	import com.sigma.socialgame.model.objects.sync.unlock.PriceUnlockedData;
	import com.sigma.socialgame.model.objects.sync.unlock.UnlockedData;
	import com.sigma.socialgame.model.objects.sync.wallet.AmountData;
	import com.sigma.socialgame.model.objects.sync.wallet.LockedAmountData;
	import com.sigma.socialgame.model.objects.sync.wallet.WorkerAmountData;
	import com.sigma.socialgame.model.objects.sync.wallet.WorkerLockedAmountData;
	import com.sigma.socialgame.model.server.command.Command;
	import com.sigma.socialgame.model.server.packet.Packet;
	import com.sigma.socialgame.view.gui.components.GiftAlert;

	public class ResourceFactory
	{
		public static const TAG : String = "ResourceFactory";
		
		private static function parseIdString(str_ : String) : Vector.<String>
		{
			str_ += ",";
			
			var strings : Vector.<String> = new Vector.<String>();
			var string : String = "";
			
			for (var i : int = 0; i < str_.length; i++)
			{
				if (str_.charAt(i) == ",")
				{
					strings.push(string);
					
					string = "";
				}
				else
				{
					string += str_.charAt(i);
				}
			}
			
			return strings;
		}
		
		public static function readStoreIds(packet_ : Packet) : Vector.<ReservedIdObject>
		{
			var storeIds : Vector.<ReservedIdObject> = new Vector.<ReservedIdObject>();
			var storeId : ReservedIdObject;
			
			var ids : Vector.<String> = parseIdString(packet_.data.sync_data.store.@reserved);
			
			for each (var string : String in ids)
			{
				storeId = new ReservedIdObject();
				
				storeId.idType = ReservedIdType.StoreId;
				storeId.id = string;
				
				storeIds.push(storeId);
			}
			
			return storeIds;
		}
		
		public static function readTaskIds(packet_ : Packet) : Vector.<ReservedIdObject>
		{
			var taskIds : Vector.<ReservedIdObject> = new Vector.<ReservedIdObject>();
			var taskId : ReservedIdObject;
			
			var ids : Vector.<String> = parseIdString(packet_.data.sync_data.tasks.@reserved);
			
			for each (var string : String in ids)
			{
				taskId = new ReservedIdObject();
				
				taskId.idType = ReservedIdType.TaskId;
				taskId.id = string;
				
				taskIds.push(taskId);
			}
			
			return taskIds;
		}
		
		public static function readConfigParam(packet_ : Packet, paramType_ : String) : Object
		{
			var param : XML;
			
			for each (param in packet_.data.config_data.config.param)
			{
				if (String(param.@name) == paramType_)
					return String(param);
			}
			
			for each (param in packet_.data.config_data.params.param)
			{
				if (String(param.@name) == paramType_)
					return String(param);
			}
			
			return null;
		}
		
		public static function readSyncParam(packet_ : Packet, paramType_ : String) : Object
		{
			var param : XML;
			
			for each (param in packet_.data.sync_data.params.param)
			{
				if (String(param.@name) == paramType_)
					return String(param);
			}
			
			return null;
		}
		
		public static function readMoney(packet_ : Packet, curr_ : Vector.<CurrencyData>) : Vector.<MoneyData>
		{
			var moneys : Vector.<MoneyData> = new Vector.<MoneyData>();
			
			var newMoney : MoneyData;
			
			var money : XML;
			var curr : CurrencyData;
			
			var foundCurr : Boolean;
			
			for each (money in PacketParser.getMoney(packet_.data))
			{
				newMoney = new MoneyData();
				
				newMoney.id = money.@id;
				newMoney.gold = money.@value;
				newMoney.desc = money.@description;
				
				newMoney.amount = new AmountData();
				
				foundCurr = false;
				
				for each (curr in curr_)
				{
					if (curr.type == String(money.@currency))
					{
						newMoney.amount.currency = curr;
						newMoney.amount.amount = money.@amount;
						
						foundCurr = true;
						
						break;
					}
				}
				
				if (!foundCurr)
				{
					
				}
				
				moneys.push(newMoney);
			}
			
			return moneys;
		}
		
		public static function readConverts(packet_ : Packet, curr_ : Vector.<CurrencyData>) : Vector.<ConvertData>
		{
			var converts : Vector.<ConvertData> = new Vector.<ConvertData>();
			
			var newConvert : ConvertData;
			var newAmount : AmountData;
			var convert : XML;
			
			var curr : CurrencyData;
			var found : Boolean;
			
			for each (convert in PacketParser.getConverts(packet_.data))
			{
				newConvert = new ConvertData();
				
				newConvert.id = convert.@id;
				
				newAmount = new AmountData();
				
				newAmount.amount = convert.@fromval;
				
				for each (curr in curr_)
				{
					if (curr.type == String(convert.@fromcurr))
					{
						newAmount.currency = curr;
						
						found = true;
						
						break;
					}
				}
				
				if (!found)
				{
					
				}
				
				newConvert.fromCurr = newAmount;
				
				newAmount = new AmountData();
				newAmount.amount = convert.@toval;
				
				found = false;
				
				for each (curr in curr_)
				{
					if (curr.type == String(convert.@tocurr))
					{
						newAmount.currency = curr;
						
						found = true;
						
						break;
					}
				}
				
				if (!found)
				{
					
				}
				
				newConvert.toCurr = newAmount;
				
				converts.push(newConvert);
			}
			
			return converts;
		}
		
		public static function readObjects(packet_ : Packet, curr_ : Vector.<CurrencyData>, cond_ : Vector.<ConditionData>) : Vector.<ObjectData>
		{
			if (packet_ == null)
			{
				Logger.message("Packet must be non null.", TAG, LogLevel.Error, LogModule.Model);
				
				return null;
			}
			
			Logger.message("Reading objects.", TAG, LogLevel.Info, LogModule.Model);
			
			var pack : Packet = packet_ as Packet;
			
			var objects : Vector.<ObjectData> = new Vector.<ObjectData>();
			
			var obj : XML;
			
			for each (obj in PacketParser.getObjects(pack.data))
			{
				objects.push(readObject(obj, curr_, cond_));
			}
			
			return objects;
		}
		
		protected static function readObject(obj_ : XML, curr_ : Vector.<CurrencyData>, cond_ : Vector.<ConditionData>) : ObjectData
		{
			var newOD : ObjectData;
			
			switch (String(obj_.@type))
			{
				case ObjectTypes.Door:
				case ObjectTypes.Decor:
					switch (String(obj_.@place))
					{
						case ObjectPlaces.Cell:

							Logger.message("Creating decor cell data object.", TAG, LogLevel.Debug, LogModule.Model);

							newOD = new CellObjectData();
							
							newOD.name = String(obj_.@name);
							newOD.objectId = ObjectIdFactory.createObjectId(String(obj_.@id));
							newOD.type = String(obj_.@type);
							newOD.place = String(obj_.@place);
							(newOD as CellObjectData).sides = obj_.@sides;
							(newOD as CellObjectData).width = obj_.@width;
							(newOD as CellObjectData).height = obj_.@height;
							
							newOD.available = readAvailables(obj_, curr_, cond_);
							//newOD.giftable = readGiftable(obj_, cond_);
							
							Logger.message(newOD.toString(), "", LogLevel.Debug, LogModule.Model);
							
							return newOD;
						break;
						
						case ObjectPlaces.Wall:
							
							Logger.message("Creating decor wall data object.", TAG, LogLevel.Debug, LogModule.Model);
							
							newOD = new WallObjectData();
							
							newOD.name = String(obj_.@name);
							newOD.objectId = ObjectIdFactory.createObjectId(String(obj_.@id));
							newOD.type = ObjectTypes.Decor;
							newOD.place = String(obj_.@place);
							(newOD as WallObjectData).width = obj_.@width;
							(newOD as WallObjectData).sides = obj_.@sides;
							(newOD as WallObjectData).isDoor = (String(obj_.@type) == ObjectTypes.Door); 
							
							newOD.available = readAvailables(obj_, curr_, cond_);
							//newOD.giftable = readGiftable(obj_, cond_);
							
							Logger.message(newOD.toString(), "", LogLevel.Debug, LogModule.Model);
							
							return newOD;
						break;
					}
					
					Logger.message("Unknown object place: " + String(obj_.@place), TAG, LogLevel.Error, LogModule.Model);
					
					return newOD;
					
				break;
				
				case ObjectTypes.Trim:
					
					switch (String(obj_.@place))
					{
						case ObjectPlaces.Cell:
							Logger.message("Creating trim cell data object.", TAG, LogLevel.Debug, LogModule.Model);
							
							newOD = new CellObjectData();
							
							newOD.name = String(obj_.@name);
							newOD.objectId = ObjectIdFactory.createObjectId(String(obj_.@id));
							newOD.type = String(obj_.@type);
							newOD.place = String(obj_.@place);
							(newOD as CellObjectData).sides = obj_.@sides;
							(newOD as CellObjectData).width = obj_.@width;
							(newOD as CellObjectData).height = obj_.@height;
							
							newOD.available = readAvailables(obj_, curr_, cond_);
							//newOD.giftable = readGiftable(obj_, cond_);
							
							Logger.message(newOD.toString(), "", LogLevel.Debug, LogModule.Model);
							
							return newOD;
						break;
						
						case ObjectPlaces.Wall:
							Logger.message("Creating trim wall data object.", TAG, LogLevel.Debug, LogModule.Model);
							
							newOD = new WallObjectData();
							
							newOD.name = String(obj_.@name);
							newOD.objectId = ObjectIdFactory.createObjectId(String(obj_.@id));
							newOD.type = String(obj_.@type);
							newOD.place = String(obj_.@place);
							(newOD as WallObjectData).width = obj_.@width;
							(newOD as WallObjectData).sides = obj_.@sides;
							
							newOD.available = readAvailables(obj_, curr_, cond_);
							//newOD.giftable = readGiftable(obj_, cond_);
							
							Logger.message(newOD.toString(), "", LogLevel.Debug, LogModule.Model);
							
							return newOD;
						break;
					}
					
					break;
				
				case ObjectTypes.Worker:
					
					Logger.message("Creating worker object data.", TAG, LogLevel.Debug, LogModule.Model);
					
					newOD = new WorkerObjectData();
					
					newOD.name = String(obj_.@name);
					newOD.objectId = ObjectIdFactory.createObjectId(String(obj_.@id));
					newOD.type = String(obj_.@type);
					newOD.place = String(obj_.@place);
					(newOD as CellObjectData).sides = obj_.@sides;
					(newOD as CellObjectData).width = obj_.@width;
					(newOD as CellObjectData).height = obj_.@height;
					
					(newOD as WorkerObjectData).skills = readSkills(obj_, curr_);
					
					newOD.available = readAvailables(obj_, curr_, cond_, (newOD as WorkerObjectData).skills);
					//newOD.giftable = readGiftable(obj_, cond_);
					
					(newOD as WorkerObjectData).tasks = readObjectTasks(obj_, curr_, (newOD as WorkerObjectData).skills, cond_);

					Logger.message(newOD.toString(), "", LogLevel.Debug, LogModule.Model);

					return newOD;
					
				break;
				
				case ObjectTypes.Workspace:
					
					Logger.message("Creating workspace data object.", TAG, LogLevel.Debug, LogModule.Model);
					
					newOD = new CellObjectData();
					
					newOD.name = String(obj_.@name);
					newOD.objectId = ObjectIdFactory.createObjectId(String(obj_.@id));
					newOD.type = String(obj_.@type);
					newOD.place = String(obj_.@place);
					(newOD as CellObjectData).width = obj_.@width;
					(newOD as CellObjectData).height = obj_.@height;
					(newOD as CellObjectData).sides = obj_.@sides;
					
					newOD.available = readAvailables(obj_, curr_, cond_);
					//newOD.giftable = readGiftable(obj_, cond_);
					
					Logger.message(newOD.toString(), "", LogLevel.Debug, LogModule.Model);
					
					return newOD;
				break;
				
				case ObjectTypes.Product:
					
					Logger.message("Creating product data object.", TAG, LogLevel.Debug, LogModule.Model);
					
					newOD = new ObjectData();
					
					newOD.name = String(obj_.@name);
					newOD.objectId = ObjectIdFactory.createObjectId(String(obj_.@id));
					newOD.type = String(obj_.@type);
					newOD.place = String(obj_.@place);
					newOD.available = readAvailables(obj_, curr_, cond_);
					//newOD.giftable = readGiftable(obj_, cond_);
					
					Logger.message(newOD.toString(), "", LogLevel.Debug, LogModule.Model);
					
					break;
			}
			
			Logger.message("Unknown object type: " + String(obj_.@type), TAG, LogLevel.Error, LogModule.Model);
			
			return newOD;
		}
		
		public static function readGifts(packet_ : Packet, objects_ : Vector.<ObjectData>) : Vector.<GiftData>
		{
			var gifts : Vector.<GiftData> = new Vector.<GiftData>();
			
			var newGift : GiftData;
			
			var foundObject : Boolean;
			
			for each (var gift : XML in PacketParser.getGifts(packet_.data))
			{
				newGift = new GiftData();
				
				newGift.id = gift.@id;
				
				var time : Date = new Date();
				time.setTime(gift.@time);
				
				newGift.time = time;
				
				foundObject = false;
				
				for each (var obj : ObjectData in objects_)
				{
					if (obj.objectId.id == gift.@type)
					{
						foundObject = true;
						
						newGift.obejct = obj;
						
						break;
					}
				}
				
				if (!foundObject)
				{
				}
				
				gifts.push(newGift);
			}
			
			return gifts;
		}
		
		/*protected static function readGiftable(obj_ : XML, cond_ : Vector.<ConditionData>) : ConditionData
		{
			if (obj_.gift.length() > 0)
			{
				for each (var cond : ConditionData in cond_)
				{
//					if (cond.id == int(obj_.gift.@condtition))
					if (cond.id == int(obj_.gift.@locked))
						return cond;
				}
			}
			
			return null;
		}*/
		
		protected static function readObjectTasks(obj_ : XML, curr_ : Vector.<CurrencyData>, skills_ : Vector.<SkillData>, cond_ : Vector.<ConditionData>) : Vector.<TaskData>
		{
			var tasks : Vector.<TaskData> = new Vector.<TaskData>();
			var newTask : TaskData;
			
			var jobs : Vector.<JobData>;
			var newJob : JobData;
			
			var requires : Vector.<RequireData>;
			var newReqiare : RequireData;
			
			var needs : Vector.<NeedData>;
			var newNeed : NeedData;
			
			var gives : Vector.<GiveData>;
			var newGive : GiveData;
			
			var results : Vector.<ResultData>;
			var newResult : ResultData;
			
			var found : Boolean;
			
			var curr : CurrencyData;
			var skill : SkillData;
			
			var manured : ManuredData;
			var fert : FertilizerData;
			
			var cond : ConditionData;
			
			for each (var task : XML in obj_.tasks.task)
			{
				newTask = new TaskData();
				
				newTask.id = task.@id;
				newTask.name = task.@name;
				newTask.image = task.@image;
				
				jobs = new Vector.<JobData>();
				
				for each (var job : XML in task.job)
				{
					if (job.@locked.length() > 0)
					{
						newJob = new LockedJobData();
				
						var foundCond : Boolean = false;
						
						for each (cond in cond_)
						{
							if (cond.id == job.@locked)
							{
								foundCond = true;
								
								(newJob as LockedJobData).condition = cond;
								
								break;
							}
						}
						
						if (!foundCond)
						{
							Logger.message("Condition: " + job.@locked + " not found.", TAG, LogLevel.Error, LogModule.Model);
						}
					}
					else
						newJob = new JobData();
					
					newJob.period = job.@period;
					newJob.id = job.@id;
					
					found = false;
					
					for each (skill in skills_)
					{
						if (skill.id == job.@skill)
						{
							newJob.skill = skill;
							
							found = true;
							
							break;
						}
					}
					
					if (!found)
					{
						Logger.message("Skill: " + job.@skill + " not found.", TAG, LogLevel.Error, LogModule.Model);
					}
					
					requires = new Vector.<RequireData>();

					for each (var require : XML in job.require)
					{
						newReqiare = new RequireData();
						
						if (require.@type.length() > 0)
						{
							newReqiare.type = RequireTypes.Object;
							
							newReqiare.object = ObjectIdFactory.createObjectId(require.@type);
							newReqiare.amount = require.@amount;
						}
						
						requires.push(newReqiare);
					}
					
					needs = new Vector.<NeedData>();
					
					for each (var need : XML in job.need)
					{
						newNeed = new NeedData();
						
						newNeed.amount = int(need);
						
						found = false;
						
						for each (curr in curr_)
						{
							if (curr.type == need.@currency)
							{
								newNeed.currency = curr;
								
								found = true;
								
								break;
							}
						}
						
						if (!found)
						{
							Logger.message("Currency: " + String(need.@currency) + "not found in currencies.", TAG, LogLevel.Error, LogModule.Model);
						}
						
						needs.push(newNeed);
					}
					
					manured = new ManuredData();
					gives = new Vector.<GiveData>();
					
					for each (give in job.manured.give)
					{
						newGive = new GiveData();
						
						if (give.@currency.length() > 0)
						{
							newGive.amount = int(give);
							
							found = false;
							
							for each (curr in curr_)
							{
								if (curr.type == give.@currency)
								{
									newGive.currency = curr;
									
									found = true;
									
									break;
								}
							}
							
							if (!found)
							{
								Logger.message("Currency: " + String(give.@currency) + "not found in currencies.", TAG, LogLevel.Error, LogModule.Model);
							}
						}
						
						gives.push(newGive);
					}
					
					manured.give = gives;
					
					fert = new FertilizerData();
					gives = new Vector.<GiveData>();
					
					for each (give in job.fertilizer.give)
					{
						newGive = new GiveData();
						
						if (give.@currency.length() > 0)
						{
							newGive.amount = int(give);
							
							found = false;
							
							for each (curr in curr_)
							{
								if (curr.type == give.@currency)
								{
									newGive.currency = curr;
									
									found = true;
									
									break;
								}
							}
							
							if (!found)
							{
								Logger.message("Currency: " + String(give.@currency) + "not found in currencies.", TAG, LogLevel.Error, LogModule.Model);
							}
						}
						
						gives.push(newGive);
					}
					
					fert.give = gives;
					
					gives = new Vector.<GiveData>();
					
					for each (var give : XML in job.give)
					{
						newGive = new GiveData();
						
						if (give.@currency.length() > 0)
						{
							newGive.amount = int(give);
							
							found = false;
							
							for each (curr in curr_)
							{
								if (curr.type == give.@currency)
								{
									newGive.currency = curr;
									
									found = true;
									
									break;
								}
							}
							
							if (!found)
							{
								Logger.message("Currency: " + String(give.@currency) + "not found in currencies.", TAG, LogLevel.Error, LogModule.Model);
							}
						}
						
						gives.push(newGive);
					}
					
					results = new Vector.<ResultData>();
					
					for each (var result : XML in job.result)
					{
						newResult = new ResultData();
						
						if (result.@type.length() > 0)
						{
							newResult.object = ObjectIdFactory.createObjectId(result.@type);
							newResult.amount = result.@amount;
						}
						else if (result.@skill.length() > 0)
						{
							found = false;
							
							newResult.type = ResultTypes.Skill;
							
							for each (skill in skills_)
							{
								if (skill.id == result.@skill)
								{
									newResult.skill = skill;
									
									found = true;
									
									break;
								}
							}
							
							if (!found)
							{
								Logger.message("Skill: " + String(result.@skill) + "not found in skills.", TAG, LogLevel.Error, LogModule.Model);
							}
						}
						
						results.push(newResult);
					}
					
					newJob.gives = gives;
					newJob.require = requires;
					newJob.result = results;
					newJob.need = needs;
					newJob.manured = manured;
					newJob.ferilizer = fert;
					
					jobs.push(newJob);
				}
				
				newTask.jobs = jobs;
				
				tasks.push(newTask);
			}
			
			return tasks;
		}
		
		protected static function readSkills(obj_ : XML, curr_ : Vector.<CurrencyData>) : Vector.<SkillData>
		{
			var skills : Vector.<SkillData> = new Vector.<SkillData>();
			var newSkill : SkillData;
			var amounts : Vector.<AmountData>;
			var newAmount : AmountData;
			
			for each (var skill : XML in obj_.skills.skill)
			{
				Logger.message("Creating skill data object.", TAG, LogLevel.Debug, LogModule.Model);
				
				newSkill = new SkillData();
				
				newSkill.id = skill.@id;
				newSkill.name = skill.@name;
				newSkill.rank = skill.@rank;
				
				Logger.message(newSkill.toString(), "", LogLevel.Debug, LogModule.Model);
				
				skills.push(newSkill);
			}
			
			return skills;
		}
		
		protected static function parseFlags(str_ : String) : Vector.<String>
		{
			str_ += ",";
			
			var strings : Vector.<String> = new Vector.<String>();
			var string : String = "";
			
			for (var i : int = 0; i < str_.length; i++)
			{
				if (str_.charAt(i) == ",")
				{
					strings.push(string);
					
					string = "";
				}
				else
				{
					string += str_.charAt(i);
				}
			}
			
			return strings;
		}
		
		protected static function readFlags(flags_ : String) : Vector.<FlagData>
		{
			var flags : Vector.<FlagData> = new Vector.<FlagData>();
			var newFlag : FlagData;
			
			var flagsstr : Vector.<String> = parseFlags(flags_);
			
			for each (var str : String in flagsstr)
			{
				newFlag = new FlagData();
				newFlag.type = str;
				
				flags.push(newFlag);
			}
			
			return flags;
		}
		
		protected static function readAvailables(obj_ : XML, curr_ : Vector.<CurrencyData>, cond_ : Vector.<ConditionData>, skills_ : Vector.<SkillData> = null) : Vector.<AvailableData>
		{
			var avails : Vector.<AvailableData> = new Vector.<AvailableData>();
			var newAvail : AvailableData;
			var newPrice : AmountData;
			var foundCurr : Boolean;
			var foundSkill : Boolean;
			var curr : CurrencyData;
			var foundCond : Boolean;
			var cond : ConditionData;
			
			var prices : Vector.<AmountData>;
			
			for each (var child : XML in obj_.*)
			{
				switch (String(child.name()))
				{
					case AvailableTypes.Gift:
						
						newAvail = new GiftAvailableData();
						newAvail.type = AvailableTypes.Gift;

						if (child.@locked.length() > 0)
						{
							for each (cond in cond_)
							{
								if (cond.id == int(child.@locked))
								{
									(newAvail as GiftAvailableData).condition = cond;
									
									break;
								}
							}
						}
						
						if (child.price.length() > 0)
						{
							newPrice = new AmountData();
							
							newPrice.amount = int(child.price);
							
							for each (curr in curr_)
							{
								if (curr.type == String(child.price.@currency))
								{
									newPrice.currency = curr;
								}
							}
							
							(newAvail as GiftAvailableData).price = newPrice;
						}
						
						if (child.@flags.length() > 0)
						{
							(newAvail as GiftAvailableData).flags = readFlags(String(child.@flags));
						}
						
						avails.push(newAvail);
						
						break;
					
					case AvailableTypes.Buy:
						
						Logger.message("Creating buy available data object.", TAG, LogLevel.Debug, LogModule.Model);
						
						var price : XML;
					
						prices = new Vector.<AmountData>();
						
						switch (String(obj_.@type))
						{
							case ObjectTypes.Worker:
								
								newAvail = new WorkerBuyAvailableData();
								newAvail.type = AvailableTypes.Buy;
								
								if (child.@flags.length() > 0)
								{
									(newAvail as BuyAvailableData).flags = readFlags(String(child.@flags));
								}

								for each (price in child.price)
								{
									foundCond = false;
									
									if (price.@locked.length() > 0)
									{
										newPrice = new WorkerLockedAmountData();
										
										for each (cond in cond_)
										{
											if (cond.id == price.@locked)
											{
												foundCond = true;
												
												(newPrice as ILockable).condition = cond;
												
												break;
											}
										}
										
										if (!foundCond)
										{
											Logger.message("Condition: " + child.@locked + " not found.", TAG, LogLevel.Error, LogModule.Model);
										}
									}
									else
										newPrice = new WorkerAmountData();
									
									foundCurr = false;
									
									for each (curr in curr_)
									{
										if (curr.type == String(price.@currency))
										{
											newPrice.currency = curr;
											newPrice.amount = int(price);
											
											foundCurr = true;
											
											break;
										}
									}
									
									if (!foundCurr)
									{
										Logger.message("Currency: " + String(price.@currency) + " not found in currencies.", TAG, LogLevel.Error, LogModule.Model); 
									}
									
									foundSkill = false;
									
									for each (var skill : SkillData in skills_)
									{
										if (skill.id == price.@skill)
										{
											(newPrice as WorkerAmountData).skill = skill;
											
											foundSkill = true;
											
											break;
										}
									}
									
									if (!foundSkill)
									{
										Logger.message("Skill: " + price.@skill + " not found.", TAG, LogLevel.Error, LogModule.Model);
									}
									
									prices.push(newPrice);
									
									(newAvail as WorkerBuyAvailableData).addSkillPrice(price.@skill, newPrice); 
								}
									
								(newAvail as BuyAvailableData).prices = prices;
								
								avails.push(newAvail);
								
								break;
							
							default:
								
								newAvail = new BuyAvailableData();
								newAvail.type = AvailableTypes.Buy;
								
								if (child.@flags.length() > 0)
								{
									(newAvail as BuyAvailableData).flags = readFlags(String(child.@flags));
								}

								for each (price in child.price)
								{
									foundCond = false;
									
									if (price.@locked.length() > 0)
									{
										newPrice = new LockedAmountData();
										
										for each (cond in cond_)
										{
											if (cond.id == int(price.@locked))
											{
												foundCond = true;
												
												(newPrice as LockedAmountData).condition = cond;
												
												break;
											}
										}
										
										if (!foundCond)
										{
											Logger.message("Condition: " + child.@locked + " not found.", TAG, LogLevel.Error, LogModule.Model);
										}
									}
									else
										newPrice = new AmountData();
									
									foundCurr = false;
									
									for each (curr in curr_)
									{
										if (curr.type == String(price.@currency))
										{
											newPrice.currency = curr;
											newPrice.amount = int(price);
											
											foundCurr = true;
											
											break;
										}
									}
									
									if (!foundCurr)
									{
										Logger.message("Currency: " + String(price.@currency) + " not found in currencies.", TAG, LogLevel.Error, LogModule.Model); 
									}
									
									prices.push(newPrice);
								}
								
								(newAvail as BuyAvailableData).prices = prices;
								
								avails.push(newAvail);
								
								break;
						}
						
						break;
					
					case AvailableTypes.Sell:
						
						Logger.message("Creating sell available data object.", TAG, LogLevel.Debug, LogModule.Model);
						
						prices = new Vector.<AmountData>();
						
						switch (String(obj_.@type))
						{
							case ObjectTypes.Worker:
								
								newAvail = new WorkerSellAvailableData();
								newAvail.type = AvailableTypes.Sell;
								
								for each (price in child.price)
								{
									newPrice = new AmountData();

									foundCurr = false;
									
									for each (curr in curr_)
									{
										if (curr.type == String(price.@currency))
										{
											newPrice.currency = curr;
											newPrice.amount = int(price);
											
											foundCurr = true;
											
											break;
										}
									}
									
									(newAvail as WorkerSellAvailableData).addSkillPrice(price.@skill, newPrice);
								
									if (!foundCurr)
									{
										Logger.message("Currency: " + String(price.@currency) + " not found in currencies.", TAG, LogLevel.Error, LogModule.Model); 
									}
									
									prices.push(newPrice);
								}
								
								(newAvail as SellAvailableData).prices = prices;
								
								avails.push(newAvail);
								
								break;
								
							default:
								
								newAvail = new SellAvailableData();
								newAvail.type = AvailableTypes.Sell;
								
								for each (price in child.price)
								{
									
									newPrice = new AmountData();
									
									foundCurr = false;
									
									for each (curr in curr_)
									{
										if (curr.type == String(price.@currency))
										{
											newPrice.currency = curr;
											newPrice.amount = child.price;
											
											foundCurr = true;
											
											break;
										}
									}
									
									if (!foundCurr)
									{
										Logger.message("Currency: " + String(price.@currency) + " not found in currencies.", TAG, LogLevel.Error, LogModule.Model); 
									}
									
									prices.push(newPrice);
								}
								
								(newAvail as SellAvailableData).prices = prices;
								
								avails.push(newAvail);
								break;
						}
						
						break;
					
					case AvailableTypes.Move:
						
						Logger.message("Creating move available data object.", TAG, LogLevel.Debug, LogModule.Model);
						
						newAvail = new MoveAvailableData();
						newAvail.type = AvailableTypes.Move;
						
						(newAvail as MoveAvailableData).moveX = (child.@x == "yes");
						(newAvail as MoveAvailableData).moveY = (child.@y == "yes");
						
						avails.push(newAvail);
						
						break;
					
					case AvailableTypes.Rotate:
						
						Logger.message("Creating rotate available data object.", TAG, LogLevel.Debug, LogModule.Model);
						
						newAvail = new AvailableData();
						newAvail.type = AvailableTypes.Rotate;
						
						avails.push(newAvail);
						
						break;
					
				}
				
				if (newAvail != null)
					Logger.message(newAvail.toString(), "", LogLevel.Debug, LogModule.Model);
				
				newAvail = null;
			}
			
			return avails;
		}
		
		public static function readFriends(packet_ : Packet) : Vector.<FriendData>
		{
			var friends : Vector.<FriendData> = new Vector.<FriendData>();
			
			var newFriend : FriendData;
			
			for each (var friend : XML in PacketParser.getFriends(packet_.data))
			{
				newFriend = new FriendData();
				
				newFriend.sociId = SocialIdFactory.createSocialId(friend.@social);
				newFriend.level = int(friend.@level);
				newFriend.gifts = int(friend.@gifts);
				newFriend.manured = int(friend.@fertilized);
				
				friends.push(newFriend);
			}
			
			return friends;
		}
		
		public static function readCurrQuests(packet_ : Packet, objects_ : Vector.<ObjectData>, currencies_ : Vector.<CurrencyData>, condition_ : Vector.<ConditionData>) : Vector.<CurrQuestData>
		{
			var quests : Vector.<CurrQuestData> = new Vector.<CurrQuestData>();
			var newQuest : CurrQuestData;
			var quest : XML;
			
			var newCommand : CommandTodo;
			var newComm : Command;
			var command : XML;
			
			var newBuy : BuyTodo;
			var buy : XML;
			
			var commands : Vector.<CommandTodo>;
			var buys : Vector.<BuyTodo>;
			
			var object : ObjectData;
			
			for each (quest in PacketParser.getCurrQuests(packet_.data))
			{
				newQuest = new CurrQuestData();
				
				newQuest.id = quest.@id;
				newQuest.type = quest.@type;
				newQuest.done = String(quest.@done) == "true";
				
				commands = new Vector.<CommandTodo>();
				
				for each (command in quest.done.commands.command)
				{
					newCommand = new CommandTodo();
					
					newComm = new Command();
					newComm.type = command.@type;
					
					newCommand.command = newComm;
					newCommand.amount = command.@count;
					
					commands.push(newCommand);
				}
				
				buys = new Vector.<BuyTodo>();
				
				for each (buy in quest.done.buys.goods)
				{
					newBuy = new BuyTodo();
					
					newBuy.amount = buy.@count;
					newBuy.type = String(buy.@type);
					
					var foundObj : Boolean = false;
					
					for each (object in objects_)
					{
						if (object.objectId.id == String(buy.@type))
						{
							foundObj = true;
							
							newBuy.object = object;
							
							break;
						}
					}
					
					if (!foundObj)
					{
						
					}
					
					buys.push(newBuy);
				}

				newQuest.data = readQuest(quest.data, objects_, currencies_, condition_);
				
				newQuest.commands = commands;
				newQuest.buy = buys;
				
				quests.push(newQuest);
			}
			
			return quests;
		}
		
		public static function readQuest(data : XMLList, objects_ : Vector.<ObjectData>, currencies_ : Vector.<CurrencyData>, condition_ : Vector.<ConditionData>) : QuestData
		{
			var newQuest : QuestData = new QuestData();

			var newCommand : CommandTodo;
			var newComm : Command;
			var command : XML;
			
			var newBuy : BuyTodo;
			var buy : XML;
			
			var gives : Vector.<GiveData>;
			var give : XML;
			var newGive : GiveData;
			
			var results : Vector.<ResultData>;
			var result : XML;
			var newResult : ResultData;
			
			var commands : Vector.<CommandTodo>;
			var buys : Vector.<BuyTodo>;
			
			var object : ObjectData;
			
			newQuest.id = data.@id;
			newQuest.desc = data.description;
			newQuest.title = data.title;
			newQuest.success = data.success;
			newQuest.icon = data.@icon;
			newQuest.image = data.@image;
			
			if (data.@locked.length() > 0)
			{
				var foundCond : Boolean = false;
				
				for each (var cond : ConditionData in condition_)
				{
					if (cond.id == data.@locked)
					{
						newQuest.locked = cond;
						
						foundCond = true;
						
						break;
					}
				}
				
				if (!foundCond)
				{
					
				}
			}
			
			gives = new Vector.<GiveData>();
			
			for each (give in data.rewards.profit)
			{
				newGive = new GiveData();
				
				newGive.amount = int(give);
				
				var foundCurr : Boolean = false;
				
				for each (var curr : CurrencyData in currencies_)
				{
					if (curr.type == give.@currency)
					{
						newGive.currency = curr;
						
						foundCurr = true;
						
						break;
					}
				}
				
				if (!foundCurr)
				{
					
				}
				
				gives.push(newGive);
			}
			
			newQuest.gives = gives;
			
			var foundObj : Boolean;
			
			results = new Vector.<ResultData>();
			
			for each (result in data.rewards.gives)
			{
				newResult = new ResultData();
				
				newResult.type = ResultTypes.Object;
				
				newResult.amount = int(result);
				
				foundObj = false;
				
				for each (var obj : ObjectData in objects_)
				{
					if (obj.objectId.id == result.@thing)
					{
						newResult.object = obj.objectId;
						
						foundObj = true;
						
						break;
					}
				}
				
				results.push(newResult);
			}
			
			newQuest.result = results;
			
			commands = new Vector.<CommandTodo>();
			
			for each (command in data.todo.commands.command)
			{
				newCommand = new CommandTodo();
				
				newComm = new Command();
				newComm.type = command.@type;
				
				newCommand.command = newComm;
				newCommand.amount = command.@count;
				newCommand.desc = command.@description;
				
				commands.push(newCommand);
			}
			
			buys = new Vector.<BuyTodo>();
			
			for each (buy in data.todo.buy.goods)
			{
				newBuy = new BuyTodo();
				
				newBuy.amount = buy.@count;
				newBuy.desc = buy.@description;
				
				foundObj = false;
				
				newBuy.type = buy.@type;
				
				for each (object in objects_)
				{
					if (object.objectId.id == String(buy.@type))
					{
						foundObj = true;
						
						newBuy.object = object;
						
						break;
					}
				}
				
				if (!foundObj)
				{
					
				}
				
				buys.push(newBuy);
			}
			
			newQuest.commands = commands;
			newQuest.buy = buys;
			
			return newQuest;
		}
		
		public static function readUnlocked(packet_ : Packet, objects_ : Vector.<ObjectData>) : Vector.<UnlockedData>
		{
			Logger.message("Reading unlocked objects.", TAG, LogLevel.Info, LogModule.Model);
			
			var unlockeds : Vector.<UnlockedData> = new Vector.<UnlockedData>();
			
			var newUnlocked : UnlockedData;
			
			var found : Boolean;
			
			var obj : ObjectData;
			
			var breakLoop : Boolean;
			
			for each (var unlocked : XML in PacketParser.getUnlock(packet_.data))
			{
				Logger.message("Creating new unlocked data.", TAG, LogLevel.Debug, LogModule.Model);
	
				if (unlocked.@price.length() > 0)
				{
					newUnlocked = new PriceUnlockedData();
					
					found = false;
					
					for each (obj in objects_)
					{
						if (obj.objectId.id == unlocked.@price)
						{
							(newUnlocked as PriceUnlockedData).object = obj;
							
							found = true;
							
							break;
						}
					}
					
					if (!found)
					{
						Logger.message("Object: " + unlocked.@price + " not found in objects.", TAG, LogLevel.Error, LogModule.Model);
					}
					
					if (unlocked.@skill.length() > 0)
					{
						breakLoop = false;
						
//						objLoop1: for each (obj in objects_)
						for each (obj in objects_)
						{
							if (obj.type == ObjectTypes.Worker)
							{
								for each (var skill : SkillData in (obj as WorkerObjectData).skills)
								{
									if (skill.id == unlocked.@skill)
									{
										found = true;
										
										(newUnlocked as PriceUnlockedData).skill = skill;
										
//										break objLoop1;
										breakLoop = true;
										break;
									}
								}
							}
							
							if (breakLoop)
								break;
						}
					}
					
					if (!found)
					{
						Logger.message("Skill: " + unlocked.@skill + " not found.", TAG, LogLevel.Error, LogModule.Model);
					}
					
				}
				else if (unlocked.@job.length() > 0)
				{
					newUnlocked = new JobUnlockedData();
					
					found = false;
					
					breakLoop = false;
					
//					objLoop2: for each (obj in objects_)
					for each (obj in objects_)
					{
						if (obj.type == ObjectTypes.Worker)
						{
							for each (var task : TaskData in (obj as WorkerObjectData).tasks)
							{
								for each (var job : JobData in task.jobs)
								{
									if (job.id == unlocked.@job)
									{
										found = true;
										
										(newUnlocked as JobUnlockedData).job = job;
										
//										break objLoop2;
										
										breakLoop = true;
										break;
									}
								}
								
								if (breakLoop)
									break;
							}
						}
						
						if (breakLoop)
							break;
					}
					
					if (!found)
					{
						Logger.message("Job: " + unlocked.@job + " not found in jobs.", TAG, LogLevel.Error, LogModule.Model);
					}
				}

				Logger.message(newUnlocked.toString(), "", LogLevel.Debug, LogModule.Model);
				
				unlockeds.push(newUnlocked);
			}
			
			return unlockeds;
		}
		
		public static function readTasks(packet_ : Packet, store_ : Vector.<StoreObjectData>, objects_ : Vector.<ObjectData>) : Vector.<CurrTaskData>
		{
			Logger.message("Reading current tasks.", TAG, LogLevel.Info, LogModule.Model);
			
			var tasks : Vector.<CurrTaskData> = new Vector.<CurrTaskData>;
			
			var newTask : CurrTaskData;
			
			var found : Boolean;
			
			for each (var task : XML in PacketParser.getTasks(packet_.data))
			{
				Logger.message("Creating new current task.", TAG, LogLevel.Debug, LogModule.Model);
				
				newTask = new CurrTaskData();
				
				newTask.complete = String(task.@complete) == "true";
				newTask.id = int(task.@id);
				newTask.backId = int(task.@back);
				newTask.time = Number(task.@time);
				newTask.manured = String(task.@manured) == "true";
				
				var storeId : StoreIdentifier = StoreIdFactory.createStoreId(task.@instance);
				var objId : ObjectIdentifier;
					
				found = false;
				
				for each (var thing : StoreObjectData in store_)
				{
					if (storeId.equals(thing.storeId))
					{
						newTask.storeObject = thing;
						
						var foundTask : Boolean = false;
						
						for each (var objTask : TaskData in (thing.object as WorkerObjectData).tasks)
						{
							if (objTask.id == task.@task)
							{
								newTask.task = objTask;
								
								var foundJob : Boolean = false;
								
								for each (var taskJob : JobData in objTask.jobs)
								{
									if (taskJob.skill.id == (thing as WorkerStoreObjectData).currSkill.id)
									{
										newTask.job = taskJob;
										
										foundJob = true;
										
										break;
									}
								}
								
								if (!foundJob)
								{
									Logger.message("Job with level: " + task.@level + " not found in task: " + objTask, TAG, LogLevel.Error, LogModule.Model);
								}
							
								foundTask = true;
								
								break;
							}
						}
						
						if (!foundTask)
						{
							Logger.message("Task: " + task.@type + " not found in Object: " + thing.object, TAG, LogLevel.Error, LogModule.Model); 
						}
						
						found = true;
						
						break;
					}
				}
				
				if (!found)
				{
					Logger.message("Thing with id: " + task.@id + " not found in store.", TAG, LogLevel.Error, LogModule.Model);
				}
				
/*				found = false;
				
				for each (var object : ObjectData in objects_)
				{
					if (newTask.object.equals(object.objectId))
					{
						var foundTask : Boolean = false;
						
						for each (var objTask : TaskData in (object as WorkerObjectData).tasks)
						{
							if (objTask.id == task.@type)
							{
								newTask.task = objTask;
					
								var foundJob : Boolean = false;
								
								for each (var taskJob : JobData in objTask.jobs)
								{
									if (task.@level == taskJob.level)
									{
										newTask.job = taskJob;
										
										foundJob = true;
										
										break;
									}
								}
								
								if (!foundJob)
								{
									Logger.message("Job with level: " + task.@level + " not found in task: " + objTask, TAG, LogLevel.Error, LogModule.Model);
								}
								
								foundTask = true;
								
								break;
							}
						}
						
						if (!foundTask)
						{
							Logger.message("Task: " + task.@type + " not found in Object: " + object, TAG, LogLevel.Error, LogModule.Model); 
						}
						
						found = true;
						
						break;
					}
				}
				
				if (!found)
				{
					Logger.message("Object: " + newTask.object + " not found in objects.", TAG, LogLevel.Error, LogModule.Model);
				}
*/				
				Logger.message(newTask.toString(), "", LogLevel.Debug, LogModule.Model);
				
				tasks.push(newTask);
			}
			
			return tasks;
		}
		
		public static function readConditions(packet_ : Packet, currencies_ : Vector.<CurrencyData>) : Vector.<ConditionData>
		{
			if (packet_ == null)
			{
				return null;
			}
			
			var conditions : Vector.<ConditionData> = new Vector.<ConditionData>();
			
			var newCondition : ConditionData;
			var amount : AmountData;
			
			for each (var condition : XML in PacketParser.getConditions(packet_.data))
			{
				newCondition = new ConditionData();
				
				newCondition.id = condition.@id;
				
				if (condition.@level.length() > 0)
					newCondition.level = condition.@level;
				
				if (condition.@friends.length() > 0)
					newCondition.friends = condition.@friends;
				
				amount = new AmountData();
				
				amount.amount = condition.unlock;
				
				var foundCurr : Boolean = false;

				if (condition.unlock.length() > 0)
				{
					for each (var curr : CurrencyData in currencies_)
					{
						if (curr.type == String(condition.unlock.@currency))
						{
							foundCurr = true;
							
							amount.currency = curr;
							
							break;
						}
					}
	
					if (!foundCurr)
					{
						Logger.message("Currency: " + condition.unlock.@currency + " not found.", TAG, LogLevel.Error, LogModule.Model);
					}
				}
				newCondition.price = amount;
				
				conditions.push(newCondition);
			}
			
			return conditions;
		}
		
		public static function readExpands(packet_ : Packet, curr_ : Vector.<CurrencyData>, cond_ : Vector.<ConditionData>) : Vector.<ExpandData>
		{
			var expands : Vector.<ExpandData> = new Vector.<ExpandData>();
			var prices : Vector.<AmountData>;
			
			var newExpand : ExpandData;
			var newPrice : AmountData;
			
			for each (var expand : XML in PacketParser.getExpands(packet_.data))
			{
				newExpand = new ExpandData();
				
				newExpand.width = expand.@x;
				newExpand.height = expand.@y;
				
				newExpand.id = expand.@id;
				newExpand.image = expand.@image;
				
				var foundCond : Boolean = false;
				
				if (expand.@locked.length() > 0)
				{
					for each (var cond : ConditionData in cond_)
					{
						if (cond.id == expand.@locked)
						{
							newExpand.condition = cond;
							
							foundCond = true;
							
							break;
						}
					}
					
					if (!foundCond)
					{
						Logger.message("Condition: " + expand.@locked + " not found.", TAG, LogLevel.Error, LogModule.Model);
					}
				}
				
				prices = new Vector.<AmountData>();
				
				for each (var price : XML in expand.price)
				{
					newPrice = new AmountData();
					
					newPrice.amount = int(price);
					
					var foundCurr : Boolean = false;
					
					for each (var curr : CurrencyData in curr_)
					{
						if (curr.type == String(price.@currency))
						{
							newPrice.currency = curr;
							
							foundCurr = true;
							
							break;
						}
					}
					
					if (!foundCurr)
					{
						Logger.message("Currency: " + price.@currency + " not found.", TAG, LogLevel.Error, LogModule.Model);
					}
					
					prices.push(newPrice);
				}
				
				newExpand.prices = prices;
				expands.push(newExpand);
			}
			
			return expands;
		}
		
		public static function readAvatarParts(packet_ : Packet, conditions_ : Vector.<ConditionData>, currencies_ : Vector.<CurrencyData>) : Vector.<AvatarPart>
		{
			if (packet_ == null)
			{
				Logger.message("Packet must be non null.", TAG, LogLevel.Error, LogModule.Model);
				
				return null;				
			}
			
			Logger.message("Reading avatar parts.", TAG, LogLevel.Info, LogModule.Model);
			
			var pack : Packet = packet_ as Packet;
			
			var parts : Vector.<AvatarPart> = new Vector.<AvatarPart>();
			var newPart : AvatarPart;
			
			var cond : ConditionData;
			
			var avails : Vector.<AvailableData> = new Vector.<AvailableData>();
			
			var newBuyAvail : BuyAvailableData;
			
			var prices : Vector.<AmountData>;
			var newPrice : AmountData;
			var curr : CurrencyData;
			var price : XML;
			
			for each (var part : XML in PacketParser.getParts(pack.data))
			{
				Logger.message("Creating skin data object.", TAG, LogLevel.Debug, LogModule.Model)
				
				newPart = new AvatarPart();
				
				newPart.defaultPart = part.@default == true;
				
				newPart.id = part.@id;
				newPart.sex = part.@sex;
				newPart.type = part.@type;
				newPart.image = part.@image;
				
				if (part.@flags.length() > 0)
				{
					newPart.flags = readFlags(String(part.@flags));
				}

				var foundCond : Boolean = false;
				
				if (part.@locked.length() > 0)
				{
					for each (cond in conditions_)
					{
						if (cond.id == part.@locked)
						{
							newPart.condition = cond;
							
							foundCond = true;
							
							break;
						}
					}
					
					if (!foundCond)
					{
						
					}
				}
				
				newBuyAvail = new BuyAvailableData();
				newBuyAvail.type = AvailableTypes.Buy;
				
				prices = new Vector.<AmountData>();

				var foundCurr : Boolean = false;
				
				newPrice = new AmountData();
				
				newPrice.amount = int(part.@price);
				
				for each (curr in currencies_)
				{
					if (curr.type == String(part.@currency))
					{
						newPrice.currency = curr;
						
						foundCurr = true;
						
						break;
					}
				}
				
				if (!foundCurr)
				{
					
				}
				
				prices.push(newPrice);
				
				newBuyAvail.prices = prices;
				
				avails = new Vector.<AvailableData>();
				
				avails.push(newBuyAvail);
				
				newPart.availables = avails;
				
				Logger.message(newPart.toString(), "", LogLevel.Debug, LogModule.Model);
				
				parts.push(newPart);
			}
			
			return parts;
		}
		
		public static function readSkins(packet_ : Packet) : Vector.<SkinData>
		{
			if (packet_ == null)
			{
				Logger.message("Packet must be non null.", TAG, LogLevel.Error, LogModule.Model);
				
				return null;
			}
			
			Logger.message("Reading skins.", TAG, LogLevel.Info, LogModule.Model);
			
			var pack : Packet = packet_ as Packet;
			
			var skins : Vector.<SkinData> = new Vector.<SkinData>();
			var newSkin : SkinData;
			
			for each (var skin : XML in PacketParser.getSkins(pack.data))
			{
				Logger.message("Creating skin data object.", TAG, LogLevel.Debug, LogModule.Model)
				
				newSkin = new SkinData();
				
				newSkin.id = skin.@id;
				newSkin.url = skin.@url;
			
				Logger.message(newSkin.toString(), "", LogLevel.Debug, LogModule.Model);
				
				skins.push(newSkin);
			}
			
			return skins;
		}
		
		public static function readImages(packet_ : Packet, skins_ : Vector.<SkinData>) : Vector.<ImageData>
		{
			if (packet_ == null)
			{
				Logger.message("Packet must be non null.", TAG, LogLevel.Error, LogModule.Model);
				
				return null;
			}
			
			if (skins_ == null)
			{
				Logger.message("Skins must be non null.", TAG, LogLevel.Error, LogModule.Model);
				
				return null;
			}
			
			Logger.message("Reading images.", TAG, LogLevel.Info, LogModule.Model);
			
			var pack : Packet = packet_ as Packet;
			
			var images : Vector.<ImageData> = new Vector.<ImageData>();
			var newImage : ImageData;
			
			for each (var image : XML in PacketParser.getImages(pack.data))
			{
				Logger.message("Creating image data object.", TAG, LogLevel.Debug, LogModule.Model);
				
				newImage = new ImageData();
				
				newImage.name = image.@name;
				
				var foundSkin : Boolean = false;
				
				for each (var skin : SkinData in skins_)
				{
					if (skin.id == String(image.@skin))
					{
						newImage.skin = skin;

						foundSkin = true;
						
						break;
					}
				}
				
				if (!foundSkin)
				{
					Logger.message("Skin: " + String(image.@skin) + " not found in skins.", TAG, LogLevel.Error, LogModule.Model);
				}
				
				Logger.message(newImage.toString(), "", LogLevel.Debug, LogModule.Model);
				
				images.push(newImage);
			}
			
			return images;
		}
		
		public static function readCurrencies(packet_ : Packet) : Vector.<CurrencyData>
		{
			if (packet_ == null)
			{
				Logger.message("Packet must be non null.", TAG, LogLevel.Error, LogModule.Model);
				
				return null;
			}

			Logger.message("Reading currencies.", TAG, LogLevel.Info, LogModule.Model);
			
			var pack : Packet = packet_ as Packet;
			
			var currs : Vector.<CurrencyData> = new Vector.<CurrencyData>();
			var newCurr : CurrencyData;
			
			for each (var curr : XML in PacketParser.getCurrencies(pack.data))
			{
				Logger.message("Creating currency data object.", TAG, LogLevel.Debug, LogModule.Model);
				
				newCurr = new CurrencyData();
				
				newCurr.type = curr.@type;
				newCurr.spendable = (String(curr.@spendable) == "true");
				
				Logger.message(newCurr.toString(), "", LogLevel.Debug, LogModule.Model);
				
				currs.push(newCurr);
			}
			
			return currs;
		}
		
		public static function readLevels(packet_ : Packet, currs_ : Vector.<CurrencyData>) : Vector.<LevelData>
		{
			if (packet_ == null)
			{
				Logger.message("Packet must be non null.", TAG, LogLevel.Error, LogModule.Model);
				
				return null;
			}
			
			Logger.message("Reading levels.", TAG, LogLevel.Debug, LogModule.Model);
			
			var pack : Packet = packet_ as Packet;
			
			var levels : Vector.<LevelData> = new Vector.<LevelData>;
			var newLevel : LevelData;
			
			for each (var level : XML in PacketParser.getLevels(pack.data))
			{
				Logger.message("Creating level data object.", TAG, LogLevel.Debug, LogModule.Model);
				
				newLevel = new LevelData();
				
				newLevel.id = level.@id;
				newLevel.name = level.@name;
				newLevel.friends = level.@friends;
				newLevel.rank = level.@rank;
				
				var newUntils : Vector.<AmountData> = new Vector.<AmountData>();
				var newAmount : AmountData;
				var foundCurr : Boolean;
				
				for each (var until : XML in level.until)
				{
					foundCurr = false;
					
					for each (var curr : CurrencyData in currs_)
					{
						if (curr.type == String(until.@currency))
						{
							newAmount = new AmountData();
							newAmount.currency = curr;
							newAmount.amount = int(until);
							
							newUntils.push(newAmount);
					
							foundCurr = true;
							
							break;
						}
					}
					
					if (!foundCurr)
					{
						Logger.message("Currency: " + until.@currency + " not found in currencies.", TAG, LogLevel.Error, LogModule.Model);
					}
				}
				
				newLevel.until = newUntils;
				
				levels.push(newLevel);
				
				Logger.message(newLevel.toString(), "", LogLevel.Debug, LogModule.Model);
			}
			
			return levels;
		}
		
		public static function readStore(packet_ : Packet, objects_ : Vector.<ObjectData>) : Vector.<StoreObjectData>
		{
			if (packet_ == null)
			{
				Logger.message("Packet must be non null.", TAG, LogLevel.Error, LogModule.Model);
				
				return null;
			}

			Logger.message("Reading store.", TAG, LogLevel.Info, LogModule.Model);
			
			var pack : Packet = packet_ as Packet;
			
			var things : Vector.<StoreObjectData> = new Vector.<StoreObjectData>();
			var newThing : StoreObjectData;
			
			for each (var thing : XML in PacketParser.getStore(pack.data))
			{
				Logger.message("Creating thing data object.", TAG, LogLevel.Debug, LogModule.Model);
				var objId : ObjectIdentifier = ObjectIdFactory.createObjectId(thing.@type);
				
				var found : Boolean = false;
				
				for each (var object : ObjectData in objects_)
				{
					if (objId.equals(object.objectId))
					{
						found = true;
						
						switch (object.type)
						{
							case ObjectTypes.Worker:
								
								newThing = new WorkerStoreObjectData();
								
								newThing.object = object;
								newThing.storeId = StoreIdFactory.createStoreId(thing.@id);
								newThing.backId = StoreIdFactory.createStoreId(thing.@back);

								(newThing as WorkerStoreObjectData).onTable = StoreIdFactory.createStoreId(thing.@on);

								var foundSkill : Boolean = false;
								
								for each (var skill : SkillData in (object as WorkerObjectData).skills)
								{
									if (thing.@skill.length() == 0)
									{			
										(newThing as WorkerStoreObjectData).currSkill = skill;
									
										foundSkill = true;
										
										break;
									}
									
									if (skill.id == thing.@skill)
									{
										(newThing as WorkerStoreObjectData).currSkill = skill;
										
/*										for each (var task : TaskData in (object as WorkerObjectData).tasks)
										{
											for each (var job : JobData in task.jobs)
											{
												for each (var req : RequireData in job.require)
												{
													if (req.type == RequireTypes.Skill)
														if (req.skill.id == skill.id)
														{
															task.currSkillJob = job;
															
															break;
														}
												}
											}
										}
*/									
										foundSkill = true;
										
										break;
									}
								}
									
								if (!foundSkill)
								{
									Logger.message("Skill with id: " + thing.@skill + " not found in skill of object: " + object.toString(), TAG, LogLevel.Error, LogModule.Model);
								}
								
								break;
							
							default:
								
								newThing = new StoreObjectData();
								
								newThing.object = object;
								newThing.storeId = StoreIdFactory.createStoreId(thing.@id);
								newThing.backId = StoreIdFactory.createStoreId(thing.@back);

								break;
						}
						
						break;
					}
				}
				
				if (!found)
				{
					Logger.message("Object with objectId: '" + objId.id + "' not found in objects.", TAG, LogLevel.Error, LogModule.Model);
				}
				
				Logger.message(newThing.toString(), "", LogLevel.Debug, LogModule.Model);
				
				things.push(newThing);
			}
			
			return things;
		}
		
		public static function readWallet(packet_ : Packet, currs_ : Vector.<CurrencyData>) : Vector.<AmountData>
		{
			if (packet_ == null)
			{
				Logger.message("Packet must be non null.", TAG, LogLevel.Error, LogModule.Model);
				
				return null;
			}

			if (currs_ == null)
			{
				Logger.message("Currencies must be non null.", TAG, LogLevel.Error, LogModule.Model);
				
				return null;
			}
			
			Logger.message("Reading wallet.", TAG, LogLevel.Info, LogModule.Model);
			
			var pack : Packet = packet_ as Packet;
			
			var amounts : Vector.<AmountData> = new Vector.<AmountData>();
			var newAmount : AmountData;
			
			for each (var amount : XML in PacketParser.getWallet(pack.data))
			{
				Logger.message("Creating amount data object.", TAG, LogLevel.Debug, LogModule.Model);
				
				newAmount = new AmountData();
				
				newAmount.amount = int(amount);
				
				var foundCurr : Boolean = false;
				
				for each (var curr : CurrencyData in currs_)
				{
					if (curr.type == String(amount.@currency))
					{
						newAmount.currency = curr;
						
						foundCurr = true;
						
						break;
					}
				}
				
				if (!foundCurr)
				{
					Logger.message("Currency: " + String(amount.@currency) + " not found in currencies.", TAG, LogLevel.Error, LogModule.Model);
				}
				
				Logger.message(newAmount.toString(), "", LogLevel.Debug, LogModule.Model);
				
				amounts.push(newAmount);
			}
			
			return amounts;
		}
		
		public static function readWalls(packet_ : Packet, objects_ : Vector.<ObjectData>, store_ : Vector.<StoreObjectData>) : Vector.<WallMapObjectData>
		{
			if (packet_ == null)
			{
				Logger.message("Packet must be non null.", TAG, LogLevel.Error, LogModule.Model);
				
				return null;
			}

			if (objects_ == null)
			{
				Logger.message("Objects must be non null.", TAG, LogLevel.Error, LogModule.Model);
				
				return null;
			}
			
			Logger.message("Reading walls.", TAG, LogLevel.Info, LogModule.Model);
			
			var pack : Packet = packet_ as Packet;
			
			var walls : Vector.<WallMapObjectData> = new Vector.<WallMapObjectData>();
			var newWall : WallMapObjectData;
			
			for each (var wall : XML in PacketParser.getMapWalls(pack.data))
			{
				Logger.message("Creating wall map data object.", TAG, LogLevel.Debug, LogModule.Model);
				
				newWall = new WallMapObjectData();
				
				newWall.x = wall.@x;
				newWall.wall = (String(wall.@orient) == "NW" ? 0 : 1);
				
				var objId : ObjectIdentifier = ObjectIdFactory.createObjectId(String(wall.@type));
				var storeId : StoreIdentifier = StoreIdFactory.createStoreId(int(wall.@id));
				
				var foundStore : Boolean = false;
				
				for each (var thing : StoreObjectData in store_)
				{
					if (storeId.equals(thing.storeId))
					{
						newWall.storeObject = thing;
						
						foundStore = true;
						
						break;
					}
				}
				
				if (!foundStore)
				{
					Logger.message("Store object: " + storeId.toString() + "not found in store.", TAG, LogLevel.Error, LogModule.Model);
				}
				
				Logger.message(newWall.toString(), "", LogLevel.Debug, LogModule.Model);
				
				walls.push(newWall);
			}
			
			return walls;
		}
		
		public static function readCells(packet_ : Packet, objects_ : Vector.<ObjectData>, store_ : Vector.<StoreObjectData>, tasks_ : Vector.<CurrTaskData>) : Vector.<CellMapObjectData>
		{
			if (packet_ == null)
			{
				Logger.message("Packet must be non null.", TAG, LogLevel.Error, LogModule.Model);
				
				return null;
			}

			if (objects_ == null)
			{
				Logger.message("Objects must be non null.", TAG, LogLevel.Error, LogModule.Model);
				
				return null;
			}
			
			Logger.message("Reading cells.", TAG, LogLevel.Info, LogModule.Model);
			
			var pack : Packet = packet_ as Packet;
			//trace(pack)
			
			var cells : Vector.<CellMapObjectData> = new Vector.<CellMapObjectData>();
			var newCell : CellMapObjectData;
			
			for each (var cell : XML in PacketParser.getMapCells(pack.data))
			{
				Logger.message("Creating cell map data object.", TAG, LogLevel.Debug, LogModule.Model);
				
				var storeId : StoreIdentifier = StoreIdFactory.createStoreId(int(cell.@id));
				//trace(cell.@id,storeId)
				
				var foundStore : Boolean = false;
				
				newCell = null;
				
				for each (var thing : StoreObjectData in store_)
				{
					if (storeId.equals(thing.storeId))
					{
						switch (thing.object.type)
						{
							case ObjectTypes.Worker:
								
								newCell = new WorkerMapObjectData();

								for each (var currTask : CurrTaskData in tasks_)
								{
									if (currTask.storeObject.storeId.equals(storeId))
									{
										(newCell as WorkerMapObjectData).currTask = currTask;
									}
								}
								
								newCell.storeObject = thing;
								
							default:
								
								if (newCell == null)
									newCell = new CellMapObjectData();
								
								newCell.x = cell.@x;
								newCell.y = cell.@y;
								newCell.rotation = processRotation(String(cell.@rotation));
								
								newCell.storeObject = thing;
								
								foundStore = true;
								
								break;
						}
					}
				}
			
				if (!foundStore)
				{
					Logger.message("Store object: " + storeId.toString() + "not found in store.", TAG, LogLevel.Error, LogModule.Model);
				}
				
				//Logger.message(newCell.toString(), "", LogLevel.Debug, LogModule.Model);
				
				cells.push(newCell);
			}
			
			return cells;
		}
		
		public static function readMapWidth(packet_ :  Packet) : int
		{
			if (packet_ == null)
			{
				Logger.message("Packet must be non null.", TAG, LogLevel.Error, LogModule.Model);
				
				return 0;
			}

			var width : int = PacketParser.getMap(packet_.data).@width; 
			
			Logger.message("Reading map width.", TAG, LogLevel.Info, LogModule.Model);
			Logger.message("Width: " + width, "", LogLevel.Debug, LogModule.Model);
			
			return width;
		}
		
		public static function readMapHeigth(packet_ :  Packet) : int
		{
			if (packet_ == null)
			{
				Logger.message("Packet must be non null.", TAG, LogLevel.Error, LogModule.Model);
				
				return 0;
			}

			var height : int = PacketParser.getMap(packet_.data).@length; 
			
			Logger.message("Reading map height.", TAG, LogLevel.Info, LogModule.Model);
			Logger.message("Height: " + height, "", LogLevel.Debug, LogModule.Model);
			
			return height;
		}
		
		public static function readBoughtAvatarParts(packet_ : Packet, parts_ : Vector.<AvatarPart>) : Vector.<CurrAvatarPart>
		{
			var currParts : Vector.<CurrAvatarPart> = new Vector.<CurrAvatarPart>();
			
			var newCurrPart : CurrAvatarPart;
			
			for each (var currpart : XML in PacketParser.getCurrAvatarParts(packet_.data))
			{
				newCurrPart = new CurrAvatarPart();
				
				var foundPart : Boolean = false;
				
				for each (var part : AvatarPart in parts_)
				{
					if (part.id == int(currpart.@id))
					{
						newCurrPart.part = part;
						
						foundPart = true;
						
						break;
					}
				}
				
				if (!foundPart)
				{
					trace("not found");
				}
				
				currParts.push(newCurrPart);
			}
			
			return currParts;
		}
	

		public static function readCurrAvatarParts(packet_ : Packet, parts_ : Vector.<AvatarPart>) : Vector.<CurrAvatarPart>
		{
			var currParts : Vector.<CurrAvatarPart> = new Vector.<CurrAvatarPart>();
			
			var newCurrPart : CurrAvatarPart;
			
			for each (var currpart : XML in PacketParser.getCurrAvatarParts(packet_.data))
			{
				if (String(currpart.@current) == "false")
					continue;
				
				newCurrPart = new CurrAvatarPart();
				
				var foundPart : Boolean = false;
				
				for each (var part : AvatarPart in parts_)
				{
					if (part.id == int(currpart.@id))
					{
						newCurrPart.part = part;
						
						foundPart = true;
						
						break;
					}
				}
				
				if (!foundPart)
				{
					
				}
				
				currParts.push(newCurrPart);
			}
			
			return currParts;
		}
		
/*		public static function readAvatarState(packet_ : Packet) : AvatarState
		{
			if (packet_ == null)
			{
				Logger.message("Packet must be non null.", TAG, LogLevel.Error, LogModule.Model);
				
				return null;
			}
			
			var data : XMLList = PacketParser.getAvatarState(packet_.data);
			var state : AvatarState = new AvatarState();
			
			for each (var part : XML in data.part)
			{
				state.addPart(part.@id);
			}
			
			Logger.message("Reading avatar state.", TAG, LogLevel.Info, LogModule.Model);
			Logger.message(state.toString(), "", LogLevel.Debug, LogModule.Model);
			
			return state;			
		}
*/		
		protected static function processRotation(rot_ : String) : int
		{
			var rot : int;
			
			switch (rot_)
			{
				case "NW":
					rot = MapRotation.NorthWest;
					break;
				
				case "NE":
					rot = MapRotation.NorthEast;
					break;
				
				case "SE":
					rot = MapRotation.SouthEast;
					break;
				
				case "SW":
					rot = MapRotation.SouthWest;
					break;
			}
			
			return rot;
		}
		
		public static function createCellMapObjectData(storeObj_ : StoreObjectData) : CellMapObjectData
		{
			var newcmod : CellMapObjectData;// = new CellMapObjectData();
			
			if (storeObj_.object.type == ObjectTypes.Worker)
			{
				newcmod = new WorkerMapObjectData();
				newcmod.storeObject = storeObj_;
			}
			else
			{
				newcmod = new CellMapObjectData();
				newcmod.storeObject = storeObj_;
			}
			
			return newcmod;
		}
		
		public static function createWallMapObjectData(storeObj_ : StoreObjectData) : WallMapObjectData
		{
			var newwmod : WallMapObjectData = new WallMapObjectData();
			
			newwmod.storeObject = storeObj_;
			
			return newwmod;
		}
		
		public static function readOfficeId(pack_ : Packet) : String
		{
			return pack_.data.sync_data.@social;
		}
		
		public static function isMyOffice(pack_ : Packet) : Boolean
		{
			if (pack_.data.sync_data.@social.length() > 0)
				return false;
			
			return true;
		}
		
		public static function readTime(pack_ : Packet) : Date
		{
			return new Date(Number(PacketParser.getTime(pack_.data)));
		}
	}
}

class PacketParser
{
	protected static function getConfigData(data_ : XML) : XMLList
	{
		return data_.config_data;
	}
	
	protected static function getSyncData(data_ : XML) : XMLList
	{
		return data_.sync_data;
	}
	
	public static function getConverts(data_ : XML) : XMLList
	{
		return getConfigData(data_).converts.convert;
	}
	
	public static function getCurrQuests(data_ : XML) : XMLList
	{
		return getSyncData(data_).quests.quest;
	}
	
	public static function getFriends(data_ : XML) : XMLList
	{
		return getSyncData(data_).friends.friend;
	}
	
	public static function getExpands(data_ : XML) : XMLList
	{
		return getConfigData(data_).expands.expand;
	}
	
	public static function getConditions(data_ : XML) : XMLList
	{
		return getConfigData(data_).conditions.condition;
	}
	
	public static function getCurrencies(data_ : XML) : XMLList
	{
		return getConfigData(data_).currencies.currency;
	}
	
	public static function getLevels(data_ : XML) : XMLList
	{
		return getConfigData(data_).levels.level;
	}
	
	public static function getSkins(data_ : XML) : XMLList
	{
		return getConfigData(data_).skins.skin;
	}
	
	public static function getParts(data_ : XML) : XMLList
	{
		return getConfigData(data_).avatar.part;
	}
		
	public static function getImages(data_ : XML) : XMLList
	{
		return getConfigData(data_).images.image;
	}
	
	public static function getMoney(data_ : XML) : XMLList
	{
		return getConfigData(data_).money.price;
	}
	
	public static function getObjects(data_ : XML) : XMLList
	{
		return getConfigData(data_).objects.object;
	}
	
	public static function getCurrAvatarParts(data_ : XML) : XMLList
	{
		return getSyncData(data_).avatar.part;
	}	
	
	public static function getMap(data_ : XML) : XMLList
	{
		return getSyncData(data_).map;
	}
	
	public static function getMapCells(data_ : XML) : XMLList
	{
		return getSyncData(data_).map.cells.cell;
	}
	
	public static function getMapWalls(data_ : XML) : XMLList
	{
		return getSyncData(data_).map.walls.wall;
	}
	
	public static function getStore(data_ : XML) : XMLList
	{
		return getSyncData(data_).store.have;
	}
	
	public static function getTasks(data_ : XML) : XMLList
	{
		return getSyncData(data_).tasks.task;
	}
	
	public static function getWallet(data_ : XML) : XMLList
	{
		return getSyncData(data_).wallet.amount;
	}
	
	public static function getGifts(data_ : XML) : XMLList
	{
		return getSyncData(data_).gifts.gift;
	}
	
	public static function getTime(data_ : XML) : XMLList
	{
		return getSyncData(data_).time;
	}
	
	public static function getUnlock(data_ : XML) : XMLList
	{
		return getSyncData(data_).unlocked.item;
	}
}