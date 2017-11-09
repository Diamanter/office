package com.sigma.socialgame.model.common.id.socialid
{
	

	public class SocialIdentifier
	{
		private var _id : String;
		
		public function SocialIdentifier()
		{
		}
		
		public function equals(socId_:SocialIdentifier):Boolean
		{
			return _id == (socId_ as SocialIdentifier).id;
		}
		
		public function clone():SocialIdentifier
		{
			var newSocId : SocialIdentifier = new SocialIdentifier();
			
			newSocId.id = _id;
			
			return newSocId;
		}

		public function get id():String
		{
			return _id;
		}

		public function set id(value:String):void
		{
			_id = value;
		}

		public function toString() : String
		{
			return "Id: " + _id;
		}
	}
}