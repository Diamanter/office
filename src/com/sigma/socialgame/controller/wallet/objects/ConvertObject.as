package com.sigma.socialgame.controller.wallet.objects
{
	import com.sigma.socialgame.model.objects.config.convert.ConvertData;

	public class ConvertObject
	{
		private var _convertData : ConvertData;
		
		public function ConvertObject()
		{
		}

		public function get convertData():ConvertData
		{
			return _convertData;
		}

		public function set convertData(value:ConvertData):void
		{
			_convertData = value;
		}

	}
}