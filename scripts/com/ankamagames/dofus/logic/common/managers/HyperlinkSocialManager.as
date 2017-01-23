package com.ankamagames.dofus.logic.common.managers
{
   import com.ankamagames.berilia.enums.StrataEnum;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.berilia.managers.TooltipManager;
   import com.ankamagames.berilia.managers.UiModuleManager;
   import com.ankamagames.berilia.types.data.TextTooltipInfo;
   import com.ankamagames.dofus.misc.lists.SocialHookList;
   import com.ankamagames.jerakine.data.I18n;
   import flash.geom.Rectangle;
   
   public class HyperlinkSocialManager
   {
       
      
      public function HyperlinkSocialManager()
      {
         super();
      }
      
      public static function openSocial(param1:int, param2:int, ... rest) : void
      {
         KernelEventsManager.getInstance().processCallback(SocialHookList.OpenSocial,param1,param2,rest);
      }
      
      public static function rollOver(param1:int, param2:int, param3:int, param4:int, ... rest) : void
      {
         var _loc6_:Rectangle = null;
         var _loc7_:TextTooltipInfo = null;
         if(param3 == 1 && param4 == 2)
         {
            _loc6_ = new Rectangle(param1,param2,10,10);
            _loc7_ = new TextTooltipInfo(I18n.getUiText("ui.tooltip.chat.taxCollectorUnderAttack"));
            TooltipManager.show(_loc7_,_loc6_,UiModuleManager.getInstance().getModule("Ankama_GameUiCore"),false,"HyperLink",6,2,3,true,null,null,null,null,false,StrataEnum.STRATA_TOOLTIP,1);
         }
      }
   }
}
