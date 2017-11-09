package com.sigma.socialgame.view.game.map.objects.graphic
{
	import com.sigma.socialgame.model.objects.config.avatar.AvatarPart;
	import com.sigma.socialgame.model.objects.config.avatar.AvatarPartType;

	public class PlayerAvatarPartInfo
	{
		public static const NWPostfix : String = "_NW";
		public static const NEPostfix : String = "_NE";
		
		private static const HandRight_NW_X:Vector.<Number> = new <Number>[-21.8,-18.75,-17,-17,-18.75,-21.8,-21.7,-23.05,-23.05,-21.7,-21.8,-2.3,-4.3,-8.9,-12.45,-12.45,-8.25,-4.55,-1.25,-1.25];
		private static const HandRight_NW_Y:Vector.<Number> = new <Number>[-114.35,-118.95,-122.55,-122.55,-118.95,-114.35,-113.8,-114.2,-114.2,-113.8,-114.35,-107.05,-112.45,-115.5,-116.35,-116.35,-115.45,-112.7,-107.8,-107.8];
		private static const HandRight_NW_R:Vector.<Number> = new <Number>[0,0.262,0.453,0.453,0.262,0,-0.126,-0.388,-0.388,-0.126,0,1.981,1.515,1.105,0.787,0.787,1.11,1.493,1.937,1.937];
		private static const BootRight_NW_X:Vector.<Number> = new <Number>[-21,-16.15,-21.85,-21.85,-14.85,-21,-18.2,-10.75,-10.75,-17.5,-21,-21,-21,-21,-21,-21,-21,-21,-21,-21];
		private static const BootRight_NW_Y:Vector.<Number> = new <Number>[-87,-88.05,-85.85,-85.85,-88.7,-87.5,-90.2,-92.85,-92.85,-90.45,-87,-87,-87,-87,-87,-87,-87,-87,-87,-87];
		private static const BootRight_NW_R:Vector.<Number> = new <Number>[0,-0.035,-0.262,-0.262,0,0,0.14,0.436,0.436,0.157,0,0,0,0,0,0,0,0,0,0];
		private static const BootLeft_NW_X:Vector.<Number> = new <Number>[-5.15,-4.6,-1.85,-1.85,-5.75,-5.15,-4.15,-2.2,-2.2,-3.45,-5.15,-5.15,-5.15,-5.15,-5.15,-5.15,-5.15,-5.15,-5.15,-5.15];
		private static const BootLeft_NW_Y:Vector.<Number> = new <Number>[-78.6,-82.15,-85.3,-85.3,-82.2,-79.6,-83.6,-85.75,-85.75,-84.6,-78.6,-78.6,-78.6,-78.6,-78.6,-78.6,-78.6,-78.6,-78.6,-78.6];
		private static const BootLeft_NW_R:Vector.<Number> = new <Number>[0,0.17,0.349,0.349,0.14,0,-0.087,-0.052,-0.052,-0.07,0,0,0,0,0,0,0,0,0,0];
		private static const LegRight_NW_X:Vector.<Number> = new <Number>[-13.8,-13.4,-10.85,-10.85,-13.55,-13.8,-10.2,-12.9,-12.9,-10.2,-13.8,-13.8,-13.8,-13.8,-13.8,-13.8,-13.8,-13.8,-13.8,-13.8];
		private static const LegRight_NW_Y:Vector.<Number> = new <Number>[-89.7,-89.65,-90.8,-90.8,-89.5,-89.7,-91.3,-94.45,-94.45,-91.3,-89.7,-89.7,-89.7,-89.7,-89.7,-89.7,-89.7,-89.7,-89.7,-89.7];
		private static const LegRight_NW_R:Vector.<Number> = new <Number>[0,-0.157,-0.14,-0.14,-0.175,0,0.157,0.157,0.157,0.157,0,0,0,0,0,0,0,0,0,0];
		private static const LegLeft_NW_X:Vector.<Number> = new <Number>[2.1,2.55,-1.3,-1.3,2.55,2.1,1.7,2.25,2.25,1.75,2.1,2.1,2.1,2.1,2.1,2.1,2.1,2.1,2.1,2.1];
		private static const LegLeft_NW_Y:Vector.<Number> = new <Number>[-81.7,-83,-85.9,-85.9,-83,-81.7,-86.3,-88.2,-88.2,-86.3,-81.7,-81.7,-81.7,-81.7,-81.7,-81.7,-81.7,-81.7,-81.7,-81.7];
		private static const LegLeft_NW_R:Vector.<Number> = new <Number>[0,0.17,0.157,0.157,0.17,0,-0.122,-0.122,-0.122,-0.122,0,0,0,0,0,0,0,0,0,0];
		private static const Body_NW_X:Vector.<Number> = new <Number>[-16.6,-16.6,-16.6,-16.6,-16.6,-16.6,-16.6,-16.6,-16.6,-16.6,-16.6,-16.6,-16.6,-16.6,-16.6,-16.6,-16.6,-16.6,-16.6,-16.6];
		private static const Body_NW_Y:Vector.<Number> = new <Number>[-111.05,-112.05,-113.05,-113.05,-112.05,-111.05,-112.05,-113.05,-113.05,-112.05,-111.05,-111.05,-111.05,-111.05,-111.05,-111.05,-111.05,-111.05,-111.05,-111.05];
		private static const Body_NW_R:Vector.<Number> = new <Number>[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
		private static const Head_NW_X:Vector.<Number> = new <Number>[-32.95,-32.95,-32.95,-32.95,-32.95,-32.95,-32.95,-32.95,-32.95,-32.95,-32.95,-32.95,-32.95,-32.95,-32.95,-32.95,-32.95,-32.95,-32.95,-32.95];
		private static const Head_NW_Y:Vector.<Number> = new <Number>[-170.9,-171.9,-172.9,-172.9,-171.9,-170.9,-171.9,-172.9,-172.9,-171.9,-170.9,-170.9,-170.9,-170.9,-170.9,-170.9,-170.9,-170.9,-170.9,-170.9];
		private static const Head_NW_R:Vector.<Number> = new <Number>[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
		private static const HandLeft_NW_X:Vector.<Number> = new <Number>[5.45,5.2,4.25,4.25,5.2,5.45,6.8,3.3,3.3,6.8,5.45,6.6,6.95,7.65,8.65,8.65,7.5,6.25,6.1,6.1];
		private static const HandLeft_NW_Y:Vector.<Number> = new <Number>[-104.75,-103.1,-102.4,-102.4,-103.1,-104.75,-109.2,-113.4,-113.4,-109.2,-104.75,-105,-104.25,-103.6,-102.4,-102.4,-103.65,-104.15,-104.15,-104.15];
		private static const HandLeft_NW_R:Vector.<Number> = new <Number>[0,-0.293,-0.585,-0.585,-0.293,0,0.223,0.611,0.611,0.223,0,0.401,0.663,1.102,1.591,1.591,1.067,0.636,0.374,0.374];
		private static const Eye_NW_X:Vector.<Number> = new <Number>[-24.95,-24.95,-24.95,-24.95,-24.95,-24.95,-24.95,-24.95,-24.95,-24.95,-24.95,-24.95,-24.95,-24.95,-24.95,-24.95,-24.95,-24.95,-24.95,-24.95];
		private static const Eye_NW_Y:Vector.<Number> = new <Number>[-126.65,-127.65,-128.65,-128.65,-127.65,-126.65,-127.65,-128.65,-128.65,-127.65,-126.65,-126.65,-126.65,-126.65,-126.65,-126.65,-126.65,-126.65,-126.65,-126.65];
		private static const Eye_NW_R:Vector.<Number> = new <Number>[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
		private static const Hair_NW_X:Vector.<Number> = new <Number>[-33,-33,-33,-33,-33,-33,-33,-33,-33,-33,-33,-33,-33,-33,-33,-33,-33,-33,-33,-33];
		private static const Hair_NW_Y:Vector.<Number> = new <Number>[-171.1,-172.1,-173.1,-173.1,-172.1,-171.1,-172.1,-173.1,-173.1,-172.1,-171.1,-171.1,-171.1,-171.1,-171.1,-171.1,-171.1,-171.1,-171.1,-171.1];
		private static const Hair_NW_R:Vector.<Number> = new <Number>[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];

		private static const HandRight_NE_X:Vector.<Number> = new <Number>[27.2,25.9,22.85,22.85,25.9,27.2,28.4,30.15,30.15,28.4,27.2,25.75,27.3,28.25,28.25,27.3,25.75,23.8,23.8];
		private static const HandRight_NE_Y:Vector.<Number> = new <Number>[-110.45,-115.65,-118.2,-118.2,-115.65,-110.45,-110.7,-110.5,-110.5,-110.7,-110.45,-98.55,-100.55,-102.95,-102.95,-100.55,-98.55,-96.95,-96.95];
		private static const HandRight_NE_R:Vector.<Number> = new <Number>[0,-0.296,-0.557,-0.557,-0.296,0,0.152,0.414,0.414,0.152,0,1.309,1.047,0.785,0.785,1.047,1.309,1.571,1.571];
		private static const BootRight_NE_X:Vector.<Number> = new <Number>[22.7,21.35,26,26,21.35,22.7,20.4,12.45,12.45,20.45,22.7,22.7,22.7,22.7,22.7,22.7,22.7,22.7,22.7];
		private static const BootRight_NE_Y:Vector.<Number> = new <Number>[-85.55,-93,-92.95,-92.95,-93,-85.55,-85.9,-85.65,-85.65,-85.95,-85.55,-85.55,-85.55,-85.55,-85.55,-85.55,-85.55,-85.55,-85.55];
		private static const BootRight_NE_R:Vector.<Number> = new <Number>[0,0.279,0.524,0.524,0.279,0,-0.122,-0.419,-0.419,-0.122,0,0,0,0,0,0,0,0,0];
		private static const LegRight_NE_X:Vector.<Number> = new <Number>[21.95,24.45,25.4,25.4,24.45,21.95,19.1,14.65,14.65,19.1,21.95,21.95,21.95,21.95,21.95,21.95,21.95,21.95,21.95];
		private static const LegRight_NE_Y:Vector.<Number> = new <Number>[-87.95,-96.7,-91.9,-91.9,-96.7,-87.95,-85.55,-88.9,-88.9,-85.55,-87.95,-87.95,-87.95,-87.95,-87.95,-87.95,-87.95,-87.95,-87.95];
		private static const LegRight_NE_R:Vector.<Number> = new <Number>[0,0.279,0.524,0.524,0.279,0,-0.122,-0.419,-0.419,-0.122,0,0,0,0,0,0,0,0,0];
		private static const BootLeft_NE_X:Vector.<Number> = new <Number>[4.95,4.85,2.95,2.95,4.85,4.95,6.2,13.65,13.65,6.2,4.95,4.95,4.95,4.95,4.95,4.95,4.95,4.95,4.95];
		private static const BootLeft_NE_Y:Vector.<Number> = new <Number>[-80.05,-78.9,-79.4,-79.4,-78.9,-80.05,-85.75,-84.35,-84.35,-85.7,-80.05,-80.05,-80.05,-80.05,-80.05,-80.05,-80.05,-80.05,-80.05];
		private static const BootLeft_NE_R:Vector.<Number> = new <Number>[0,-0.192,-0.436,-0.436,-0.192,0,0.209,0.646,0.646,0.209,0,0,0,0,0,0,0,0,0];
		private static const LegLeft_NE_X:Vector.<Number> = new <Number>[6.1,7,4.45,4.45,7,6.1,7.5,14.6,14.6,7.5,6.1,6.1,6.1,6.1,6.1,6.1,6.1,6.1,6.1];
		private static const LegLeft_NE_Y:Vector.<Number> = new <Number>[-79.55,-80.3,-82.85,-82.85,-80.3,-79.55,-88.2,-84,-84,-88.25,-79.55,-79.55,-79.55,-79.55,-79.55,-79.55,-79.55,-79.55,-79.55];
		private static const LegLeft_NE_R:Vector.<Number> = new <Number>[0,-0.192,-0.436,-0.436,-0.192,0,0.209,0.646,0.646,0.209,0,0,0,0,0,0,0,0,0];
		private static const Body_NE_X:Vector.<Number> = new <Number>[23.6,23.6,23.6,23.6,23.6,23.6,24.6,24.6,24.6,24.6,23.6,23.6,23.6,23.6,23.6,23.6,23.6,23.6,23.6];
		private static const Body_NE_Y:Vector.<Number> = new <Number>[-112.5,-114.75,-115.5,-115.5,-114.75,-112.5,-113.55,-115.3,-115.3,-113.55,-112.5,-112.5,-112.5,-112.5,-112.5,-112.5,-112.5,-112.5,-112.5];
		private static const Body_NE_R:Vector.<Number> = new <Number>[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
		private static const Head_NE_X:Vector.<Number> = new <Number>[-4.8,-4.8,-4.8,-4.8,-4.8,-4.8,-3.8,-3.8,-3.8,-3.8,-4.8,-4.8,-4.8,-4.8,-4.8,-4.8,-4.8,-4.8,-4.8];
		private static const Head_NE_Y:Vector.<Number> = new <Number>[-133.6,-135.85,-136.6,-136.6,-135.85,-133.6,-134.65,-136.4,-136.4,-134.65,-133.6,-133.6,-133.6,-133.6,-133.6,-133.6,-133.6,-133.6,-133.6];
		private static const Head_NE_R:Vector.<Number> = new <Number>[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
		private static const Hair_NE_X:Vector.<Number> = new <Number>[40.25,40.25,40.25,40.25,40.25,40.25,41.25,41.25,41.25,41.25,40.25,40.25,40.25,40.25,40.25,40.25,40.25,40.25,40.25];
		private static const Hair_NE_Y:Vector.<Number> = new <Number>[-171.8,-174.05,-174.8,-174.8,-174.05,-171.8,-172.85,-174.6,-174.6,-172.85,-171.8,-171.8,-171.8,-171.8,-171.8,-171.8,-171.8,-171.8,-171.8];
		private static const Hair_NE_R:Vector.<Number> = new <Number>[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
		private static const HandLeft_NE_X:Vector.<Number> = new <Number>[1.55,1.7,2.4,2.4,1.7,1.55,0.8,-1.7,-1.7,0.8,1.55,0.8,-3.65,-7.4,-7.4,-3.65,0.8,1.6,1.6];
		private static const HandLeft_NE_Y:Vector.<Number> = new <Number>[-106,-106.35,-103.85,-103.85,-106.35,-106,-110.25,-114.55,-114.55,-110.25,-106,-100,-95.3,-94.3,-94.3,-95.3,-100,-102.45,-102.45];
		private static const HandLeft_NE_R:Vector.<Number> = new <Number>[0,0.179,0.44,0.44,0.179,0,-0.305,-0.567,-0.567,-0.305,0,0.624,1.309,1.833,1.833,1.309,0.624,0.362,0.362];
		
		public static const LinksNW : Array = 
		[
			{N:0, Link: "HandRight", 	Type: AvatarPartType.Body, 		Postfix: "_HandRight"	,X:HandRight_NW_X, Y:HandRight_NW_Y, R:HandRight_NW_R },
			{N:1, Link: "BootRight", 	Type: AvatarPartType.Boots,		Postfix: ""				,X:BootRight_NW_X, Y:BootRight_NW_Y, R:BootRight_NW_R },
			{N:2, Link: "BootLeft",		Type: AvatarPartType.Boots,		Postfix: ""				,X:BootLeft_NW_X,  Y:BootLeft_NW_Y,  R:BootLeft_NW_R  },
			{N:3, Link: "LegRight",		Type: AvatarPartType.Legs, 		Postfix: ""				,X:LegRight_NW_X,  Y:LegRight_NW_Y,  R:LegRight_NW_R  },
			{N:4, Link: "LegLeft", 		Type: AvatarPartType.Legs, 		Postfix: ""				,X:LegLeft_NW_X,   Y:LegLeft_NW_Y,   R:LegLeft_NW_R   },
			{N:5, Link: "Body", 		Type: AvatarPartType.Body, 		Postfix: ""				,X:Body_NW_X,      Y:Body_NW_Y,      R:Body_NW_R      },
			{N:6, Link: "Head", 		Type: AvatarPartType.Head, 		Postfix: "Head"			,X:Head_NW_X,      Y:Head_NW_Y,      R:Head_NW_R      },
			{N:7, Link: "HandLeft", 	Type: AvatarPartType.Body, 		Postfix: "_HandLeft"	,X:HandLeft_NW_X,  Y:HandLeft_NW_Y,  R:HandLeft_NW_R  },
			{N:8, Link: "Eye", 			Type: AvatarPartType.Eyes, 		Postfix: ""				,X:Eye_NW_X,       Y:Eye_NW_Y,       R:Eye_NW_R       },
			{N:9, Link: "Hair", 		Type: AvatarPartType.Hair, 		Postfix: ""				,X:Hair_NW_X,      Y:Hair_NW_Y,      R:Hair_NW_R      }
		]
			
		public static const LinksNE : Array = 
		[
			{N:0, Link: "HandRight", 	Type: AvatarPartType.Body, 		Postfix: "_HandRight"	,X:HandRight_NE_X, Y:HandRight_NE_Y, R:HandRight_NE_R },
			{N:1, Link: "BootRight", 	Type: AvatarPartType.Boots,		Postfix: ""				,X:BootRight_NE_X, Y:BootRight_NE_Y, R:BootRight_NE_R },
			{N:2, Link: "LegRight", 	Type: AvatarPartType.Legs, 		Postfix: ""				,X:LegRight_NE_X,  Y:LegRight_NE_Y,  R:LegRight_NE_R  },
			{N:3, Link: "BootLeft", 	Type: AvatarPartType.Boots,		Postfix: ""				,X:BootLeft_NE_X,  Y:BootLeft_NE_Y,  R:BootLeft_NE_R  },
			{N:4, Link: "LegLeft", 		Type: AvatarPartType.Legs, 		Postfix: ""				,X:LegLeft_NE_X,   Y:LegLeft_NE_Y,   R:LegLeft_NE_R   },
			{N:5, Link: "Body", 		Type: AvatarPartType.Body, 		Postfix: ""				,X:Body_NE_X,      Y:Body_NE_Y,      R:Body_NE_R      },
			{N:6, Link: "Head", 		Type: AvatarPartType.Head, 		Postfix: "Head"			,X:Head_NE_X,      Y:Head_NE_Y,      R:Head_NE_R      },
			{N:7, Link: "Hair", 		Type: AvatarPartType.Hair, 		Postfix: ""				,X:Hair_NE_X,      Y:Hair_NE_Y,      R:Hair_NE_R      },
			{N:8, Link: "HandLeft", 	Type: AvatarPartType.Body, 		Postfix: "_HandLeft"	,X:HandLeft_NE_X,  Y:HandLeft_NE_Y,  R:HandLeft_NE_R  }
		]
	}
}