package com.ankamagames.dofus.logic.common.managers
{
   import com.ankamagames.berilia.enums.StrataEnum;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.berilia.managers.TooltipManager;
   import com.ankamagames.berilia.managers.UiModuleManager;
   import com.ankamagames.berilia.types.data.TextTooltipInfo;
   import com.ankamagames.dofus.misc.lists.HookList;
   import com.ankamagames.jerakine.data.I18n;
   import flash.geom.Rectangle;
   
   public class HyperlinkMapPosition
   {
       
      
      public function HyperlinkMapPosition()
      {
         super();
      }
      
      public static function showPosition(param1:int, param2:int, param3:int, param4:String = "") : void
      {
         KernelEventsManager.getInstance().processCallback(HookList.AddMapFlag,"flag_chat_" + param1 + "_" + param2 + "_" + param4,(param4 != ""?unescape(param4):I18n.getUiText("ui.cartography.chatFlag") + " ") + "(" + param1 + "," + param2 + ")",param3,param1,param2,16737792,true);
      }
      
      public static function getText(param1:int, param2:int, param3:int, param4:String = "") : String
      {
         return unescape(param4) + "[" + param1 + "," + param2 + "]";
      }
      
      public static function rollOver(param1:int, param2:int, param3:int, param4:int, param5:int, param6:String = "") : void
      {
         var _loc7_:Rectangle = new Rectangle(param1,param2,10,10);
         var _loc8_:TextTooltipInfo = new TextTooltipInfo(I18n.getUiText("ui.tooltip.chat.position"));
         TooltipManager.show(_loc8_,_loc7_,UiModuleManager.getInstance().getModule("Ankama_GameUiCore"),false,"HyperLink",6,2,3,true,null,null,null,null,false,StrataEnum.STRATA_TOOLTIP,1);
      }
   }
}
