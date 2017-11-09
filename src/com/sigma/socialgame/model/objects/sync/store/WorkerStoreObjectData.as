package com.sigma.socialgame.model.objects.sync.store
{
	import com.sigma.socialgame.model.common.id.storeid.StoreIdentifier;
	import com.sigma.socialgame.model.objects.config.object.skill.SkillData;
	import com.sigma.socialgame.model.objects.sync.task.CurrTaskData;

	public class WorkerStoreObjectData extends StoreObjectData
	{
		private var _onTable : StoreIdentifier;
		private var _currSkill : SkillData;
		
		public function WorkerStoreObjectData()
		{
			super();
		}

		public function get onTable():StoreIdentifier
		{
			return _onTable;
		}

		public function set onTable(value:StoreIdentifier):void
		{
			_onTable = value;
		}

		public function get currSkill():SkillData
		{
			return _currSkill;
		}

		public function set currSkill(value:SkillData):void
		{
			_currSkill = value;
		}


	}
}