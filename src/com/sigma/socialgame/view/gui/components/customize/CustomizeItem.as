package com.sigma.socialgame.view.gui.components.customize
{
	import com.sigma.socialgame.controller.ControllerManager;
	import com.sigma.socialgame.controller.ControllerNames;
	import com.sigma.socialgame.controller.avatar.AvatarController;
	import com.sigma.socialgame.controller.avatar.clients.AvatarPartClient;
	import com.sigma.socialgame.controller.avatar.objects.AvatarPartObject;
	import com.sigma.socialgame.events.controller.AvatarControllerEvent;
	import com.sigma.socialgame.events.view.gui.CustomizeWindowEvent;
	import com.sigma.socialgame.model.objects.config.avatar.AvatarPartType;
	import com.sigma.socialgame.model.objects.config.currency.CurrencyType;
	import com.sigma.socialgame.model.objects.config.object.available.BuyAvailableData;
	import com.sigma.socialgame.view.gui.GuiIds;
	import com.sigma.socialgame.view.gui.SkinManager;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.text.TextField;
	
	public class CustomizeItem extends Sprite
	{
		private var _skin : MovieClip;
		
		private var _client : AvatarPartClient;
		private var _grLoader : CustomizeGraphicLoader;
		
		private var _tempWidth : int;
		private var _tempHeight : int;
		
		public function CustomizeItem()
		{
			super();
			
			var clazz : Class = SkinManager.instance.getSkin(GuiIds.CustomizeItem);
			
			if (clazz != null)
			{
				_skin = new clazz();
				
				addChild(_skin);
				
				_grLoader = new CustomizeGraphicLoader();
				
				image.addChild(_grLoader);
				
				addEventListener(MouseEvent.CLICK, onMouseEvent);
				
				avatarController.addEventListener(AvatarControllerEvent.FitPartChanged, onPartChanged);
				avatarController.addEventListener(AvatarControllerEvent.StartFitting, onFittingStart);
				
				CustomizeWindow.instance.addEventListener(CustomizeWindowEvent.SetSex, onSetSex);
			}
		}
		
		protected function onSetSex(e : CustomizeWindowEvent) : void
		{
			if (e.sex == client.part.part.sex)
				if (client.part.part.defaultPart)
					_client.select();
		}
		
		protected function onPartChanged(e : AvatarControllerEvent) : void
		{
			if (e.part.part.type != _client.part.part.type)
				return;
			
			if (e.part.part.id == _client.part.part.id)
			{
				selected = true;
				
				return;
			}
			
			selected = false
			
		}
		
		protected function onMouseEvent(e : MouseEvent) : void
		{
			switch (e.type)
			{
				case MouseEvent.CLICK:
					
					_client.select();
					
					break;
			}
		}
		
		public function set selected(val_ : Boolean) : void
		{
			if (val_)
			{
				var matrix : Array = new Array();
				
				matrix = matrix.concat(new <Number>[1, 0, 0, 0, 40]);
				matrix = matrix.concat(new <Number>[0, 1, 0, 0, 40]);
				matrix = matrix.concat(new <Number>[0, 0, 1, 0, 40]);
				matrix = matrix.concat(new <Number>[0, 0, 0, 1, 0]);
				
				var filter:ColorMatrixFilter = new ColorMatrixFilter(matrix);
				
				var filters:Array = new Array();
				
				filters.push(filter);
				
				this.filters = filters;
			}
			else
			{
				this.filters = null;
			}
		}
		
		private const _gold : String = "Gold";
		private const _coins : String = "Coins";
		
		private const _cost : String = "Cost";
		private const _image : String = "image";
		
		private const _bought : String = "purchased";
		
		private const _label : String = "Label";
		
		protected function get label() : MovieClip
		{
			return _skin[_label];
		}
		
		protected function get bought() : MovieClip
		{
			return _skin[_bought];
		}
		
		protected function get coins() : MovieClip
		{
			return _skin[_coins];
		}
		
		protected function get gold() : MovieClip
		{
			return _skin[_gold];
		}
		
		protected function get costTF() : TextField
		{
			return _skin[_cost] as TextField;
		}
		
		protected function get image() : MovieClip
		{
			return _skin[_image] as MovieClip;
		}

		public function get client():AvatarPartClient
		{
			return _client;
		}

		protected function onFittingStart(e : AvatarControllerEvent) : void
		{
			updateCost();
			
			for each (var apart : AvatarPartObject in avatarController.currParts)
			{
				if (_client.part.part.id == apart.part.id)
				{
					selected = true;
					
					return;
				}
			}
			
			selected = false;
		}
		
		protected function updateCost() : void
		{
			coins.visible = false;
			gold.visible = false;
			bought.visible = false;
			
			if (_client.wasBought())
			{
				bought.visible = true;
				
				costTF.text = "";
			}
			else
			{
				if ((_client.part.part.availables[0] as BuyAvailableData).prices[0].currency.type == CurrencyType.Coin)
					coins.visible = true;
				
				if ((_client.part.part.availables[0] as BuyAvailableData).prices[0].currency.type == CurrencyType.Gold)
					gold.visible = true;
				
				costTF.text = String((_client.part.part.availables[0] as BuyAvailableData).prices[0].amount);
			}
		}
	
 		public function set client(value:AvatarPartClient):void
 		{
 			_client = value;
 			
			if (_client.saleLabel())
			{
				label.addChild(new (SkinManager.instance.getSkin(GuiIds.SaleLabel))());
			}
			
			if (_client.newLabel())
			{
				label.addChild(new (SkinManager.instance.getSkin(GuiIds.NewLabel))());
			}
			
			for each (var apart : AvatarPartObject in avatarController.currParts)
			{
				if (_client.part.part.id == apart.part.id)
				{
					selected = true;
					
					break;
				}
			}
			
			updateCost();

			_grLoader.setImage(_client.part.part.image);
		}

		private var _aCon : AvatarController;
		
		protected function get avatarController() : AvatarController
		{
			if (_aCon == null)
				_aCon = ControllerManager.instance.getController(ControllerNames.AvatarController) as AvatarController;
			
			return _aCon;
		}
	}
}