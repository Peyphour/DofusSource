package com.ankamagames.dofus.logic.common.managers
{
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.berilia.managers.TooltipManager;
   import com.ankamagames.berilia.managers.UiModuleManager;
   import com.ankamagames.berilia.types.LocationEnum;
   import com.ankamagames.dofus.misc.lists.HookList;
   import com.ankamagames.dofus.uiApi.RoleplayApi;
   import com.ankamagames.jerakine.utils.display.StageShareManager;
   import flash.geom.Rectangle;
   
   public class HyperlinkShowMonsterGroup
   {
      
      private static var roleplayApi:RoleplayApi = new RoleplayApi();
       
      
      public function HyperlinkShowMonsterGroup()
      {
         super();
      }
      
      public static function showMonsterGroup(param1:int, param2:int, param3:int, param4:String, param5:String) : void
      {
         KernelEventsManager.getInstance().processCallback(HookList.AddMapFlag,"flag_chat_" + param1 + "_" + param2 + "_" + param4 + "_" + param5.split(";")[0],unescape(param4) + " (" + param1 + "," + param2 + ")",param3,param1,param2,16737792,true,false,true,true);
      }
      
      public static function getText(param1:int, param2:int, param3:int, param4:String, param5:String) : String
      {
         return unescape(param4) + " [" + param1 + "," + param2 + "]";
      }
      
      public static function rollOver(param1:int, param2:int, param3:int, param4:int, param5:int, param6:String, param7:String) : void
      {
         showMonsterGroupTooltip(param7);
      }
      
      private static function showMonsterGroupTooltip(param1:String) : void
      {
         TooltipManager.show(roleplayApi.getMonsterGroupFromString(param1),new Rectangle(StageShareManager.stage.mouseX,StageShareManager.stage.mouseY,10,10),UiModuleManager.getInstance().getModule("Ankama_Tooltips"),false,"HyperLink",LocationEnum.POINT_BOTTOM,LocationEnum.POINT_TOP,0);
      }
   }
}
