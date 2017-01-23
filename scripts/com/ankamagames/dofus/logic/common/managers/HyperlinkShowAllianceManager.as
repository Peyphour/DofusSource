package com.ankamagames.dofus.logic.common.managers
{
   import com.ankamagames.berilia.enums.StrataEnum;
   import com.ankamagames.berilia.managers.TooltipManager;
   import com.ankamagames.berilia.managers.UiModuleManager;
   import com.ankamagames.berilia.types.data.TextTooltipInfo;
   import com.ankamagames.dofus.kernel.net.ConnectionsHandler;
   import com.ankamagames.dofus.network.messages.game.alliance.AllianceFactsRequestMessage;
   import com.ankamagames.jerakine.data.I18n;
   import flash.geom.Rectangle;
   
   public class HyperlinkShowAllianceManager
   {
       
      
      public function HyperlinkShowAllianceManager()
      {
         super();
      }
      
      public static function getLink(param1:*, param2:String = null, param3:String = null, param4:String = null) : String
      {
         var _loc5_:String = !!param2?"::" + param2:"";
         var _loc6_:String = !!param3?",linkColor:" + param3:"";
         var _loc7_:String = !!param4?",hoverColor:" + param4:"";
         return "{alliance," + param1.allianceId + "," + param1.allianceTag + _loc6_ + _loc7_ + _loc5_ + "}";
      }
      
      public static function showAlliance(... rest) : void
      {
         var _loc2_:int = rest[0];
         if(_loc2_ > int.MAX_VALUE || _loc2_ < 0)
         {
            _loc2_ = 0;
         }
         var _loc3_:AllianceFactsRequestMessage = new AllianceFactsRequestMessage();
         _loc3_.initAllianceFactsRequestMessage(_loc2_);
         ConnectionsHandler.getConnection().send(_loc3_);
      }
      
      public static function getAllianceName(param1:uint, param2:String) : String
      {
         return "[" + param2 + "]";
      }
      
      public static function rollOver(param1:int, param2:int, param3:uint, param4:String = null) : void
      {
         var _loc5_:Rectangle = new Rectangle(param1,param2,10,10);
         var _loc6_:TextTooltipInfo = new TextTooltipInfo(I18n.getUiText("ui.shortcuts.openSocialAlliance"));
         TooltipManager.show(_loc6_,_loc5_,UiModuleManager.getInstance().getModule("Ankama_GameUiCore"),false,"HyperLink",6,2,3,true,null,null,null,null,false,StrataEnum.STRATA_TOOLTIP,1);
      }
   }
}
