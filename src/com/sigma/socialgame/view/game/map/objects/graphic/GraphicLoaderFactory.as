package com.sigma.socialgame.view.game.map.objects.graphic
{
	import com.sigma.socialgame.model.ResourceManager;
	import com.sigma.socialgame.model.common.id.objectid.ObjectIdentifier;
	import com.sigma.socialgame.model.common.id.objectid.ObjectTypes;
	import com.sigma.socialgame.model.objects.config.object.CellObjectData;
	import com.sigma.socialgame.model.objects.config.object.ObjectData;
	import com.sigma.socialgame.model.objects.config.object.WallObjectData;
	import com.sigma.socialgame.model.objects.config.object.skill.SkillData;
	import com.sigma.socialgame.view.game.common.GraphicStates;

	public class GraphicLoaderFactory
	{
		public static function createStates(obj : ObjectData) : Array
		{
			var id : String = obj.objectId.id;
			
			var needStates : Array = new Array();
			
			switch (obj.type)
			{
				case ObjectTypes.Decor:
					if (obj is CellObjectData)
					{
						switch ((obj as CellObjectData).sides)
						{
							case 4:
								needStates.push(GraphicStates.SW);
								needStates.push(GraphicStates.SE);

							case 2:
								needStates.push(GraphicStates.NE);

							case 1:
								needStates.push(GraphicStates.NW);
							break;
						}
					}
					else if (obj is WallObjectData)
					{
						switch ((obj as WallObjectData).sides)
						{
							case 2:
								needStates.push(GraphicStates.NE);

							case 1:
								needStates.push(GraphicStates.NW);
								break;
						}
					}
					break;
				
				case ObjectTypes.Trim:
					if (obj is CellObjectData)
					{
						switch ((obj as CellObjectData).sides)
						{
							case 4:
								needStates.push(GraphicStates.SW);
								needStates.push(GraphicStates.SE);
								
							case 2:
								needStates.push(GraphicStates.NE);
								
							case 1:
								needStates.push(GraphicStates.NW);
								break;
						}
					}
					else if (obj is WallObjectData)
					{
						switch ((obj as WallObjectData).sides)
						{
							case 2:
								needStates.push(GraphicStates.NE);
								
							case 1:
								needStates.push(GraphicStates.NW);
								break;
						}
					}
					break;
				
				case ObjectTypes.Workspace:
					
					switch ((obj as CellObjectData).sides)
					{
						case 4:
							needStates.push(GraphicStates.ChairSE);
							needStates.push(GraphicStates.ChairSW);
							
							needStates.push(GraphicStates.TopChairSE);
							needStates.push(GraphicStates.TopChairSW);
							
							needStates.push(GraphicStates.BottomChairSE);
							needStates.push(GraphicStates.BottomChairSW);
							
							needStates.push(GraphicStates.TableSE);
							needStates.push(GraphicStates.TableSW);
							
						case 2:
							needStates.push(GraphicStates.ChairNE);
							needStates.push(GraphicStates.TopChairNE);
							needStates.push(GraphicStates.BottomChairNE);
							needStates.push(GraphicStates.TableNE);
							
						case 1:
							needStates.push(GraphicStates.ChairNW);
							needStates.push(GraphicStates.TopChairNW);
							needStates.push(GraphicStates.BottomChairNW);
							needStates.push(GraphicStates.TableNW);
					}
					
					break;
				
				case ObjectTypes.Worker:
						switch ((obj as CellObjectData).sides)
						{
							case 4:
								needStates.push(GraphicStates.SW);
								needStates.push(GraphicStates.SE);
								
							case 2:
								needStates.push(GraphicStates.NE);
								
							case 1:
								needStates.push(GraphicStates.NW);
								break;
						}
					break;
			}
			
			return needStates;
		}
		
		public static function createClasses(obj : ObjectData, states_ : Array, skill_ : SkillData = null) : Array
		{
			var type : String = obj.type;
			var id : String = obj.objectId.id;
			
			var needClasses : Array = new Array();
			var state : String;
			
			if (obj.type != ObjectTypes.Worker)
			{
				for each (state in states_)
				{
					needClasses.push(id + "_" + state);
				}
			}
			else
			{
				for each (state in states_)
				{
					needClasses.push(id + "" + skill_.rank + "_" + state);
				}
			}
			
/*			switch (type)
			{
				case ObjectTypes.Decor:
					
					for each (state in states_)
					{
						needClasses.push(id + "_" + state);
					}
					
				break;
				
				case ObjectTypes.Trim:
					
					for each (state in states_)
					{
						needClasses.push(id + "_" + state);
					}
					
					break;
				
				case I
			}
*/			
			return needClasses;
		}
	}
}