package com.sigma.socialgame.events.model.common
{
	import com.sigma.socialgame.model.server.packet.Packet;
	
	import flash.events.Event;
	
	public class SenderEvent extends Event
	{
		public static const PacketRecieved : String = "sPacketRecieved";
		
		private var _packet : Packet;
		
		public function SenderEvent(type:String)
		{
			super(type);
		}

		public function get packet():Packet
		{
			return _packet;
		}

		public function set packet(value:Packet):void
		{
			_packet = value;
		}

	}
}