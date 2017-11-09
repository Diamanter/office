package com.sigma.socialgame.view.gui.components.gifts
{
	import com.sigma.socialgame.controller.ControllerManager;
	import com.sigma.socialgame.controller.ControllerNames;
	import com.sigma.socialgame.controller.gift.GiftController;
	import com.sigma.socialgame.controller.gift.clients.GiftClient;
	import com.sigma.socialgame.events.controller.GiftControllerEvent;
	import com.sigma.socialgame.model.objects.config.currency.CurrencyType;
	import com.sigma.socialgame.view.gui.GuiIds;
	import com.sigma.socialgame.view.gui.SkinManager;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.text.TextField;

	public class GiftItem extends Sprite
	{
		protected  var _skin : MovieClip;
		
		private var _client : GiftClient;
		
		protected  var _graphic : GiftGraphicLoader;
		
		public function GiftItem()
		{
			super();
			
			var clazz : Class = SkinManager.instance.getSkin(GuiIds.GiftItem);
			
			if (clazz != null)
			{
				_skin = new clazz();
				
				//addChild(_skin);
				
				gold.visible = false;
				coins.visible = false;
				bought.visible = false;
				
				_graphic = new GiftGraphicLoader();
				image.addChild(_graphic);
				
				_graphic.scaleX = 0.6;
				_graphic.scaleY = 0.6;
				
				addEventListener(MouseEvent.CLICK, onClicked);
				
				giftController.addEventListener(GiftControllerEvent.Selected, onItemSelected);
				giftController.addEventListener(GiftControllerEvent.Unselected, onItemUnselected);
			}
		}

		protected function onItemSelected(e : GiftControllerEvent) : void
		{
			selected = (e.selected.object.objectId.id == _client.gift.object.objectId.id); 	
		}
		
		protected function onItemUnselected(e : GiftControllerEvent) : void
		{
			selected = false; 	
		}		
		
		protected function onClicked(e : MouseEvent) : void
		{
			_client.select();
		}
		
		private const _cost : String = "Cost";
		private const _image : String = "image";
		
		private const _gold : String = "Gold";
		private const _coins : String = "Coins";
		
		private const _bought : String = "purchased";
		
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
		
		protected function get giftController() : GiftController
		{
			return ControllerManager.instance.getController(ControllerNames.GiftController) as GiftController;
		}
		
		protected function get costTF() : TextField
		{
			return _skin[_cost] as TextField;
		}
		
		protected function get image() : MovieClip
		{
			return _skin[_image] as MovieClip;
		}
		
		public function get client() : GiftClient
		{
			return _client;
		}
		
		public function set client(client_ : GiftClient) : void
		{
			_client = client_;
			_graphic.setImage(_client.gift.object.objectId.id);
			
			if (_client.price != null)
			{
				if (_client.price.currency.type == CurrencyType.Coin)
					coins.visible = true;
				
				if (_client.price.currency.type == CurrencyType.Gold)
					gold.visible = true;
				
				costTF.text = String(_client.price.amount);
			}
		}
		
		public function set selected(val_ : Boolean) : void
		{
			if (val_)
			{
				var matrix : Array = new Array();
				
				matrix = matrix.concat([1, 0, 0, 0, 40]);
				matrix = matrix.concat([0, 1, 0, 0, 40]);
				matrix = matrix.concat([0, 0, 1, 0, 40]);
				matrix = matrix.concat([0, 0, 0, 1, 0]);
				
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
	}
}