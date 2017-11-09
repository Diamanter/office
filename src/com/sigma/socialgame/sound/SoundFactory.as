package com.sigma.socialgame.sound
{
	import com.sigma.socialgame.common.Address;
	import com.sigma.socialgame.events.sound.SoundFactoryEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	public class SoundFactory extends EventDispatcher 
	{
		public var sounds : Object;
		public var back : Sound;
		
		private var _needToLoad : int = 0;
		private var _loaded : int = 0;
		
		public function SoundFactory()
		{
			
		}
		
		public function init() : void
		{
			var urlreq : URLRequest = new URLRequest(Address.Sound);
			
			var urlloader : URLLoader = new URLLoader();
			urlloader.addEventListener(Event.COMPLETE, onLoaded);
			urlloader.load(urlreq);
		}
		
		protected function onLoaded(e : Event) : void
		{
			var data : XML = XML(e.target.data);
			
			readConfig(data);
		}
		
		protected function readConfig(data_ : XML) : void
		{
			sounds = new Object();
			
			var urlreq : URLRequest;
			var soundFac : Sound;
			
			urlreq = new URLRequest(String(data_.back.@file));
			
			back = new Sound();
			
			_needToLoad++;
			
			back.addEventListener(Event.COMPLETE, onSoundLoaded);
			back.load(urlreq);
			
			for each (var sound : XML in data_.sound)
			{
				urlreq = new URLRequest(sound.@file);
				
				soundFac = new Sound();
				
				_needToLoad++;
				
				sounds[sound.@event] = soundFac;
				
				soundFac.addEventListener(Event.COMPLETE, onSoundLoaded);
				soundFac.load(urlreq);
			}
		}
		
		protected function onSoundLoaded(e : Event) : void
		{
			_loaded++;
			
			if (_loaded == _needToLoad)
			{
				dispatchEvent(new SoundFactoryEvent(SoundFactoryEvent.SoundLoaded));
			}
		}
		
		public function getSound(event : String) : SoundChannel
		{
			return sounds[event].play();
		}
	}
}