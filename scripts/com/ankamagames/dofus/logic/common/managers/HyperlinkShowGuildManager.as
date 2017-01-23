package com.ankamagames.dofus.logic.common.managers
{
   import com.ankamagames.berilia.enums.StrataEnum;
   import com.ankamagames.berilia.managers.TooltipManager;
   import com.ankamagames.berilia.managers.UiModuleManager;
   import com.ankamagames.berilia.types.data.TextTooltipInfo;
   import com.ankamagames.dofus.kernel.net.ConnectionsHandler;
   import com.ankamagames.dofus.network.messages.game.guild.GuildFactsRequestMessage;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.utils.misc.StringUtils;
   import flash.geom.Rectangle;
   
   public class HyperlinkShowGuildManager
   {
       
      
      public function HyperlinkShowGuildManager()
      {
         super();
      }
      
      public static function getLink(param1:*, param2:String = null) : String
      {
         var _loc3_:String = !!param2?"::" + param2:"";
         return "{guild," + param1.guildId + "," + escape(param1.guildName) + _loc3_ + "}";
      }
      
      public static function showGuild(param1:uint, param2:String) : void
      {
         if(param1 > int.MAX_VALUE)
         {
            param1 = 0;
         }
         var _loc3_:GuildFactsRequestMessage = new GuildFactsRequestMessage();
         _loc3_.initGuildFactsRequestMessage(param1);
         ConnectionsHandler.getConnection().send(_loc3_);
      }
      
      public static function getGuildName(param1:uint, param2:String) : String
      {
         return "[" + StringUtils.unescapeAllowedChar(param2) + "]";
      }
      
      public static function rollOver(param1:int, param2:int, param3:uint, param4:String) : void
      {
         var _loc5_:Rectangle = new Rectangle(param1,param2,10,10);
         var _loc6_:TextTooltipInfo = new TextTooltipInfo(I18n.getUiText("ui.shortcuts.openSocialGuild"));
         TooltipManager.show(_loc6_,_loc5_,UiModuleManager.getInstance().getModule("Ankama_GameUiCore"),false,"HyperLink",6,2,3,true,null,null,null,null,false,StrataEnum.STRATA_TOOLTIP,1);
      }
   }
}
