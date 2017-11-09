package com.sigma.socialgame.model.param
{
	public class ParamManager
	{
		private var _configParams : Object;
		private var _syncParams : Object;
		
		public function ParamManager()
		{
			_instance = this;
			
			_configParams = new Object();
			_syncParams = new Object();
		}
		
		public function addConfigParam(param : Object, paramType : String) : void
		{
			_configParams[paramType] = param;
		}
		
		public function getConfigParam(paramType : String) : Object
		{
			return _configParams[paramType];
		}
		
		public function addSyncParam(param : Object, paramType : String) : void
		{
			_syncParams[paramType] = param;
		}
		
		public function getSyncParam(paramType : String) : Object
		{
			return _syncParams[paramType];
		}
		
		private static var _instance : ParamManager;
		
		public static function get instance() : ParamManager
		{
			return _instance;
		}
	}
}