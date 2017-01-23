package
{
   public class TutorialAdvancedConstants
   {
      
      public static const QUEST_IDS:Array = [QUEST_JOB_ID,QUEST_FIGHT_ID];
      
      public static const STATUE_MAP_ID:Array = [152043521,152044545,152046593,152046595,152045571,152044547,152043523,152043525,152045573,152046597,152046599,152044551,152044549,152043527,152045575,152045569];
      
      public static const MAP_IDS:Array = merge([HUB_MAP_ID,JOB_MAP_ID,FIGHT_MAP_ID,STATUE_MAP_ID]);
      
      public static const HUB_MAP_ID:uint = 153092354;
      
      public static const JOB_MAP_ID:int = 153093380;
      
      public static const FIGHT_MAP_ID:int = 153092356;
      
      public static const EXIT_MAP_ID:int = 154010883;
      
      public static const NPC_JORIS:uint = 2897;
      
      public static const NPC_HOBOULO:uint = 2895;
      
      public static const NPC_DARM:uint = 2896;
      
      public static const NPC_MONSTER:uint = 2927;
      
      public static const QUEST_JOB_ID:uint = 1629;
      
      public static const QUEST_FIGHT_ID:uint = 1630;
      
      public static const JOB_STEP_GOTO_MAP:int = 9655;
      
      public static const JOB_STEP_FIRST_NPC_DIALOG:int = 9656;
      
      public static const JOB_STEP_HARVEST:Array = [9657,9658,9659,9660,9661];
      
      public static const JOB_STEP_CRAFT:uint = 9662;
      
      public static const JOB_STEP_CRAFT__OPEN_UI:uint = 0;
      
      public static const JOB_STEP_CRAFT__ADD_INGREDIENT:uint = 1;
      
      public static const JOB_STEP_CRAFT__FUSION:uint = 2;
      
      public static const JOB_STEP_CRAFT__QUIT:uint = 3;
      
      public static const JOB_STEP_SHOW_CRAFT:uint = 10015;
      
      public static const JOB_STEP_GO_JORIS:uint = 9663;
      
      public static const FIGHT_IDOL_ID:uint = 31;
      
      public static const FIGHT_STEP_GOTO_MAP:int = 9680;
      
      public static const FIGHT_STEP_NPC_DIALOG_1:int = 9685;
      
      public static const FIGHT_STEP_FIGHT_SIMPLE:uint = 9686;
      
      public static const FIGHT_STEP_FIGHT_SIMPLE_LAUNCH:uint = 0;
      
      public static const FIGHT_STEP_FIGHT_SIMPLE_START:uint = 1;
      
      public static const FIGHT_STEP_FIGHT_SIMPLE_FINISH:uint = 2;
      
      public static const FIGHT_STEP_NPC_DIALOG_2:uint = 9687;
      
      public static const FIGHT_STEP_FIGHT_IDOLE:uint = 9688;
      
      public static const FIGHT_STEP_FIGHT_IDOLE__OPEN_UI:uint = 0;
      
      public static const FIGHT_STEP_FIGHT_IDOLE__ACTIVE:uint = 1;
      
      public static const FIGHT_STEP_FIGHT_IDOLE__CLOSE_UI:uint = 2;
      
      public static const FIGHT_STEP_FIGHT_IDOLE__START:uint = 3;
      
      public static const FIGHT_STEP_FIGHT_IDOLE__READY:uint = 4;
      
      public static const FIGHT_STEP_FIGHT_IDOLE__FINISH:uint = 5;
      
      public static const FIGHT_STEP_NPC_DIALOG_3:uint = 9719;
      
      public static const FIGHT_STEP_FIGHT_IDOLE_2:uint = 9720;
      
      public static const FIGHT_STEP_FIGHT_IDOLE_2_BIS:uint = 10121;
      
      public static const FIGHT_STEP_NPC_DIALOG_4:uint = 10016;
      
      public static const FIGHT_STEP_GO_JORIS:uint = 9734;
      
      public static const FIGHT_STEP_WITH_IDOLE_LIST:Array = [FIGHT_STEP_FIGHT_IDOLE,FIGHT_STEP_FIGHT_IDOLE_2,FIGHT_STEP_FIGHT_IDOLE_2_BIS];
      
      public static const HARVEST_CELL_BY_OBJECTIVE:Object = {
         9657:395,
         9658:258,
         9659:297,
         9660:340,
         9661:303
      };
      
      public static const JOB_TOOL_X:uint = 830;
      
      public static const JOB_TOOL_Y:uint = 640;
       
      
      public function TutorialAdvancedConstants()
      {
         super();
      }
      
      private static function merge(param1:Array) : Array
      {
         var _loc3_:* = undefined;
         var _loc2_:Array = [];
         for each(_loc3_ in param1)
         {
            if(_loc3_ is Array)
            {
               _loc2_ = _loc2_.concat(_loc3_);
            }
            else
            {
               _loc2_.push(_loc3_);
            }
         }
         return _loc2_;
      }
   }
}
