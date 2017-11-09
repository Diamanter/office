package com.sigma.socialgame.model.common.id.storeid
{
	import com.sigma.socialgame.common.logger.LogLevel;
	import com.sigma.socialgame.common.logger.LogModule;
	import com.sigma.socialgame.common.logger.Logger;

	public class StoreIdFactory
	{
		public static function createStoreId(storeId_ : int) : StoreIdentifier
		{
			Logger.message("Creating store identifier", "MapIdFactory", LogLevel.Debug, LogModule.Model);
			
			var newStoreId : StoreIdentifier = new StoreIdentifier();
			
			newStoreId.storeId = storeId_;
			
			Logger.message(newStoreId.toString(), "", LogLevel.Debug, LogModule.Model);
			
			return newStoreId;
		}
	}
}