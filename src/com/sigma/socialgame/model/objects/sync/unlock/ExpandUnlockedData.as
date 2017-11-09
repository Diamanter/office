package com.sigma.socialgame.model.objects.sync.unlock
{
	import com.sigma.socialgame.model.objects.config.expand.ExpandData;

	public class ExpandUnlockedData extends UnlockedData
	{
		private var _expand : ExpandData;
		
		public function ExpandUnlockedData()
		{
			super(UnlockedType.Expand);
		}

		public function get expand():ExpandData
		{
			return _expand;
		}

		public function set expand(value:ExpandData):void
		{
			_expand = value;
		}

	}
}