package com.sigma.socialgame.common
{
	import com.sigma.socialgame.view.game.MyOfficeGame;
	public class Address
	{
		public static var InitPacket : String = 	"init_packet.xml";
		public static var Skin : String = 		"C:/Users/Denis/Drive/work/office/data/gui/skins.swf";
		public static var QuestSkin : String = 	"C:/Users/Denis/Drive/work/office/data/gui/images.swf";
		public static var Places : String = 		"C:/Users/Denis/Drive/work/office/data/gui/places.xml";
		public static var Sound : String = 		"C:/Users/Denis/Drive/work/office/data/sound/sound.xml";
		public static var Help : String = 		"C:/Users/Denis/Drive/work/office/data/gui/help.xml";
		public static var Strings : String = 		"C:/Users/Denis/Drive/work/office/data/gui/strings.xml";
		public static var Limits : String = 		"C:/Users/Denis/Drive/work/office/data/system/workerlimit.xml";
		
		if (MyOfficeGame.instance.isLocal && !MyOfficeGame.instance.isMobile) 
		{
			InitPacket = 	"init_packet.xml";
//			Skin = 		"http://officelife.yamsonline.ru/static/officelife/data/gui/skins.swf";
			Skin = 		"C:/Users/Denis/Drive/work/office/data/gui/skins.swf";
			QuestSkin = 	"C:/Users/Denis/Drive/work/office/data/gui/images.swf";
			Places = 		"C:/Users/Denis/Drive/work/office/data/gui/places.xml";
			Sound = 		"C:/Users/Denis/Drive/work/office/data/sound/sound.xml";
			Help = 		"C:/Users/Denis/Drive/work/office/data/gui/help.xml";
			Strings = 		"C:/Users/Denis/Drive/work/office/data/gui/strings.xml";
			Limits = 		"C:/Users/Denis/Drive/work/office/data/system/workerlimit.xml";
			
/*			InitPacket = "../data/init_packet.xml";
			Skin = "../data/gui/skins.swf";
			QuestSkin = "../data/gui/images.swf";
			Places = "../data/gui/places.xml";
			Help = "../data/gui/help.xml";
			Sound = "../data/sound/sound.xml";
			Strings = "../data/gui/strings.xml"; 
			Limits = "../data/system/workerlimit.xml"; 
*/		}
		
		else
		{
/*			InitPacket = "http://officelife.yamsonline.ru/static/officelife/data/init_packet.xml";
			Skin = "http://officelife.yamsonline.ru/static/officelife/data/gui/skins.swf";
			QuestSkin = "http://officelife.yamsonline.ru/static/officelife/data/gui/images.swf";
			Places = "http://officelife.yamsonline.ru/static/officelife/data/gui/places.xml";
			Sound = "http://officelife.yamsonline.ru/static/officelife/data/sound/sound.xml";
			Help = "http://officelife.yamsonline.ru/static/officelife/data/gui/help.xml";
			Strings = "http://officelife.yamsonline.ru/static/officelife/data/gui/strings.xml";
			Limits = "http://officelife.yamsonline.ru/static/officelife/data/system/workerlimit.xml";
*/			
			InitPacket = 	"//officelife.yamsonline.ru/static/officelife/data/init_packet.xml?"+Math.random();
			Skin = 		"//officelife.yamsonline.ru/static/officelife/data/gui/skins.swf?1";
			QuestSkin = 	"//officelife.yamsonline.ru/static/officelife/data/gui/images.swf";
			Places = 		"//officelife.yamsonline.ru/static/officelife/data/gui/places.xml";
			Sound = 		"//officelife.yamsonline.ru/static/officelife/data/sound/sound.xml";
			Help = 		"//officelife.yamsonline.ru/static/officelife/data/gui/help.xml";
			Strings = 		"//officelife.yamsonline.ru/static/officelife/data/gui/strings.xml";
			Limits = 		"//officelife.yamsonline.ru/static/officelife/data/system/workerlimit.xml"; 
		}
	}
}
