package com.sigma.socialgame.model.objects.config.object.task
{
	import com.sigma.socialgame.model.objects.sync.wallet.AmountData;

	public class FertilizerData
	{
		private var _give : Vector.<GiveData>;
		
		public function FertilizerData()
		{
		}

		public function get give():Vector.<GiveData>
		{
			return _give;
		}

		public function set give(value:Vector.<GiveData>):void
		{
			_give = value;
		}

	}
}