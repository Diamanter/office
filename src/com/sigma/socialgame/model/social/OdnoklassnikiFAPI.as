package com.sigma.socialgame.model.social
{
	import flash.external.ExternalInterface;

	public class OdnoklassnikiFAPI
	{
		public static function showInvite() : void
		{
			ExternalInterface.call("FAPI.UI.showInvite");
		}
		
		public static function showPayment(name : String, description : String, code : String, price : int = -1, options : String = null, attributes : String = null, currency: String = null, callback : String = 'false') : void
		{
			ExternalInterface.call("FAPI.UI.showPayment", name, description, code, price, options, attributes, currency, callback);
		}
		
		public static function showConfirmation(method : String, userText : String, signature : String) : void
		{
			ExternalInterface.call("FAPI.UI.showConfirmation", method, userText, signature);
		}
	}
}