package com.sigma.socialgame.controller.wallet
{
	import com.sigma.socialgame.common.logger.LogLevel;
	import com.sigma.socialgame.common.logger.LogModule;
	import com.sigma.socialgame.common.logger.Logger;
	import com.sigma.socialgame.controller.wallet.objects.ConvertObject;
	import com.sigma.socialgame.controller.wallet.objects.MoneyObject;
	import com.sigma.socialgame.controller.wallet.objects.WalletObject;
	import com.sigma.socialgame.model.objects.config.convert.ConvertData;
	import com.sigma.socialgame.model.objects.config.money.MoneyData;
	import com.sigma.socialgame.model.objects.sync.wallet.AmountData;

	public class WalletFactory
	{
		public static const TAG : String = "WalletFactory";
		
		public static function createConvertObject(convert_ : ConvertData) : ConvertObject
		{
			var newCO : ConvertObject = new ConvertObject();
			
			newCO.convertData = convert_;
			
			return newCO;
		}
		
		public static function createMoneyObject(money_ : MoneyData) : MoneyObject
		{
			var newMO : MoneyObject = new MoneyObject(); 
			
			newMO.moneyData = money_;
			
			return newMO;
		}
		
		public static function createWalletObject(amount_ : AmountData) : WalletObject
		{
			Logger.message("Creating wallet object.", TAG, LogLevel.Debug, LogModule.Controller);
			
			var newWO : WalletObject = new WalletObject();
			
			newWO.amountData = amount_;
			
			Logger.message(newWO.toString(), "", LogLevel.Debug, LogModule.Controller);
			
			return newWO;
		}
		
		public static function updateWalletObject(walletObject_ : WalletObject, amount_ : AmountData) : Boolean
		{
			Logger.message("Updateing wallet obejct.", TAG, LogLevel.Debug, LogModule.Controller);
			
			if (walletObject_.amountData.amount != amount_.amount)
			{
				walletObject_.amountData.amount = amount_.amount;
				
				return true;
			}
			
			return false;
		}
	}
}