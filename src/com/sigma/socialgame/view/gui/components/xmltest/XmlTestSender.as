package com.sigma.socialgame.view.gui.components.xmltest
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;

	public class XmlTestSender extends EventDispatcher
	{
		public function XmlTestSender()
		{
		}
		
		public function send(text : String) : void
		{
			var urlreq : URLRequest;
			
			urlreq = new URLRequest("http://mmo.sigma-team.net/sigma/server");
			urlreq.method = URLRequestMethod.POST;
			
			urlreq.data = text;
			
			var urlloader : URLLoader = new URLLoader();
			
			urlloader.addEventListener(Event.COMPLETE, onComplete);
			urlloader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			
			urlloader.load(urlreq);
		}
		
		protected function onComplete(e : Event) : void
		{
			var event : XmlTestSenderEvent = new XmlTestSenderEvent(XmlTestSenderEvent.Packet);
			
			event.text = XML(e.target.data).toXMLString();
			
			dispatchEvent(event);
		}
		
		protected function onIOError(e : IOErrorEvent) : void
		{
		}
	}
}