package com.sigma.socialgame.view.gui.components.friends
{
	import com.sigma.socialgame.controller.ControllerManager;
	import com.sigma.socialgame.controller.ControllerNames;
	import com.sigma.socialgame.controller.friends.FriendsContoller;
	import com.sigma.socialgame.controller.friends.objects.FriendObject;
	import com.sigma.socialgame.controller.gift.GiftController;
	import com.sigma.socialgame.events.controller.FriendsControllerEvent;
	import com.sigma.socialgame.view.gui.GuiIds;
	import com.sigma.socialgame.view.gui.GuiManager;
	import com.sigma.socialgame.view.gui.SkinManager;
	import com.sigma.socialgame.view.gui.string.StringCase;
	import com.sigma.socialgame.view.gui.string.StringManager;
	import com.sigma.socialgame.view.gui.string.StringTypes;
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.net.URLRequest;
	import flash.text.TextField;

	public class FriendItem extends Sprite
	{
		private var _skin : MovieClip;
		
		private var _appFriend : FriendObject;
		
		private var _graphic : FriendGraphicLoader;
		private var _selected : Boolean;
		
		public function FriendItem()
		{
			super();
			
			var clazz : Class = SkinManager.instance.getSkin(GuiIds.FriendItem);
			
			if (clazz != null)
			{
				_skin = new clazz();
				
				addChild(_skin);
				
				_graphic = new FriendGraphicLoader();
				image.addChild(_graphic);
				
				addEventListener(MouseEvent.CLICK, onClicked);
				friendsController.addEventListener(FriendsControllerEvent.Unselected, onItemUnselected);
			}
		}

		protected function onItemUnselected(e : FriendsControllerEvent) : void
		{
			if ((e.object == null) || (e.object == _appFriend))
			{
				selected = false;
			}
		}
		
		protected function onClicked(e : MouseEvent) : void
		{
			if (selected)
			{
				friendsController.unselect(_appFriend);
				selected = false;
				return;
			}
			
			friendsController.select(_appFriend);
			selected = true;
			
			giftController.sendGift();
			giftController.unselect();
			friendsController.clearSelected();
			
			FriendsWindow.instance.visible = false;
			
			var sCase : StringCase = StringManager.instance.getCase(StringTypes.GiftAlert);
			
			GuiManager.instance.giftWindow(sCase.title, sCase.message);
		}
		
		protected function get giftController() : GiftController
		{
			return ControllerManager.instance.getController(ControllerNames.GiftController) as GiftController;
		}				
		
		private const _name : String = "Name";
		private const _image : String = "image";
		
		protected function get friendsController() : FriendsContoller
		{
			return ControllerManager.instance.getController(ControllerNames.FriendsController) as FriendsContoller;
		}
		
		protected function get nameTF() : TextField
		{
			return _skin[_name] as TextField;
		}
		
		protected function get image() : MovieClip
		{
			return _skin[_image] as MovieClip;
		}
		
		private var loader : Loader;
		
		public function set appFriend(appFriend_ : FriendObject) : void
		{
			_appFriend = appFriend_;
			_graphic.setImage(_appFriend.socFriend.name);
			nameTF.text = appFriend_.socFriend.name;
			
			loader = new Loader();
			
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoaderComplete);
			
			//if (_appFriend.socFriend.pic != null)
				//loader.load(new URLRequest(_appFriend.socFriend.pic));
		}
		
		public function onLoaderComplete(e : Event) : void
		{
			var wsc : Number = loader.width / image.width;
			var hsc : Number = loader.height / image.height;
			
			var resK : Number = wsc > hsc ? wsc : hsc;
			
			if (wsc > 1.0 || hsc > 1.0)
			{
				resK = 1 / resK;
			}
			
			image.addChild(loader);
			
			loader.scaleX = resK;
			loader.scaleY = resK;
			
			loader.x = -loader.width / 2;
			loader.y = -loader.height / 2;
		}
		
		public function get selected() : Boolean
		{
			return _selected;
		}
		
		public function set selected(val_ : Boolean) : void
		{
			_selected = val_;
			if (val_)
			{
				var matrix : Array = new Array();
				
				matrix = matrix.concat(new <Number>[1, 0, 0, 0, 40]);
				matrix = matrix.concat(new <Number>[0, 1, 0, 0, 40]);
				matrix = matrix.concat(new <Number>[0, 0, 1, 0, 40]);
				matrix = matrix.concat(new <Number>[0, 0, 0, 1, 0]);
				
				var filter : ColorMatrixFilter = new ColorMatrixFilter(matrix);
				
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