package com.sigma.socialgame.view.gui.components.quest
{
	import com.sigma.socialgame.controller.ControllerManager;
	import com.sigma.socialgame.controller.ControllerNames;
	import com.sigma.socialgame.controller.quest.QuestController;
	import com.sigma.socialgame.controller.quest.objects.QuestObject;
	import com.sigma.socialgame.events.controller.QuestControllerEvent;
	import com.sigma.socialgame.view.gui.place.GuiPlaces;
	
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.display.Sprite;
	import starling.display.Image;
	import starling.display.Button;
	import starling.display.MovieClip;
	
	public class QuestBar extends Sprite
	{
		private var _dimY : int;
		
		private var _icons : Vector.<QuestIcon>;
		
		public function QuestBar()
		{
			super();
			
			_instance = this;
			
			_dimY = GuiPlaces.QuestBarPlace.dim.y;
			
			_icons = new Vector.<QuestIcon>();
			
			(ControllerManager.instance.getController(ControllerNames.QuestController) as QuestController).addEventListener(QuestControllerEvent.QuestConfirmed, onQuestConfirmed);
			(ControllerManager.instance.getController(ControllerNames.QuestController) as QuestController).addEventListener(QuestControllerEvent.QuestAdded, onQuestAdded);
			
			init();
		}
		
		protected function init() : void
		{
			var i : int = 0;
			
			var newQi : QuestIcon;
			
			var qiy : int = 0;
			
			for each (var qo : QuestObject in questController.quests)
			{
				if (i++ >= _dimY)
					break;
				
				newQi = new QuestIcon(qo.questData.data.icon);
				newQi.questObject = qo;
				
				addChild(newQi);
	
				_icons.push(newQi);
				
				newQi.y = qiy;
				
				qiy += newQi.width;
			}
		}
		
		public function showFirstWindow() : void
		{
			_icons[0].dispatchEvent(new Event(Event.TRIGGERED));
		}
		
		public function showWindow(qo_ : QuestObject) : void
		{
			for each (var qi : QuestIcon in _icons)
			{
				if (qi.questObject.questData.id == qo_.questData.id)
				{
					qi.dispatchEvent(new Event(Event.TRIGGERED));
				}
			}
		}
		
		protected function onQuestAdded(e : QuestControllerEvent) : void
		{
			var newQi : QuestIcon = new QuestIcon(e.quest.questData.data.icon);
			
			newQi.questObject = e.quest;
			
			var qiy : int = 0;
			
			for each (var qi : QuestIcon in _icons)
			{
				qiy += qi.height;
			}
				
			_icons.push(newQi);
			
			addChild(newQi);
			
			newQi.y = qiy;
		}
		
		protected function placeIcons() : void
		{
			var qiy : int = 0;
			
			for each (var qi : QuestIcon in _icons)
			{
				qi.y = qiy;
				
				qiy += qi.height;
			}
		}
		
		protected function onQuestConfirmed(e : QuestControllerEvent) : void
		{
			for each (var qi : QuestIcon in _icons)
			{
				if (qi.questObject.questData.id == e.quest.questData.id)
				{
					removeChild(qi);
					
					_icons.splice(_icons.indexOf(qi), 1);
					
					placeIcons();
				}
			}
		}
		
		private static var _instance : QuestBar;
		
		public static function get instance() : QuestBar
		{
			return _instance;
		}
		
		protected function get questController() : QuestController
		{
			return ControllerManager.instance.getController(ControllerNames.QuestController) as QuestController;
		}
	}
}