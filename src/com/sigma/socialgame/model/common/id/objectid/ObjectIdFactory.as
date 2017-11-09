package com.sigma.socialgame.model.common.id.objectid
{
	import com.sigma.socialgame.common.logger.LogLevel;
	import com.sigma.socialgame.common.logger.LogModule;
	import com.sigma.socialgame.common.logger.Logger;

	public class ObjectIdFactory
	{
		public static function createObjectId(id_ : String) : ObjectIdentifier
		{
			Logger.message("Creating object identifier", "ObjectIdFactory", LogLevel.Debug, LogModule.Model);

			var objId : ObjectIdentifier = new ObjectIdentifier();
			
			objId.id = id_;
			
			Logger.message(objId.toString(), "", LogLevel.Debug, LogModule.Model);
			
			return objId;
		}
	}
}