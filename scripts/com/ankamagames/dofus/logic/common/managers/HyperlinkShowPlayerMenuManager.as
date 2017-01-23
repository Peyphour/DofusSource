package com.ankamagames.dofus.logic.common.managers
{
   import com.ankamagames.berilia.enums.StrataEnum;
   import com.ankamagames.berilia.factories.MenusFactory;
   import com.ankamagames.berilia.managers.TooltipManager;
   import com.ankamagames.berilia.managers.UiModuleManager;
   import com.ankamagames.berilia.types.data.TextTooltipInfo;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.game.common.managers.ChatAutocompleteNameManager;
   import com.ankamagames.dofus.logic.game.roleplay.frames.RoleplayEntitiesFrame;
   import com.ankamagames.dofus.network.enums.ChatActivableChannelsEnum;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayCharacterInformations;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.utils.misc.StringUtils;
   import flash.geom.Rectangle;
   import flash.utils.getQualifiedClassName;
   
   public class HyperlinkShowPlayerMenuManager
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(HyperlinkShowPlayerMenuManager));
       
      
      public function HyperlinkShowPlayerMenuManager()
      {
         super();
      }
      
      public static function showPlayerMenu(param1:String, param2:Number = 0, param3:Number = 0, param4:String = null, param5:uint = 0) : void
      {
         var _loc8_:GameRolePlayCharacterInformations = null;
         if(param1)
         {
            param1 = StringUtils.unescapeAllowedChar(param1);
         }
         var _loc6_:Object = UiModuleManager.getInstance().getModule("Ankama_ContextMenu").mainClass;
         if(param1 && param1.indexOf("★") == 0)
         {
            param1 = param1.substr(1);
         }
         var _loc7_:RoleplayEntitiesFrame = Kernel.getWorker().getFrame(RoleplayEntitiesFrame) as RoleplayEntitiesFrame;
         if(_loc7_ && param2)
         {
            _loc8_ = _loc7_.getEntityInfos(param2) as GameRolePlayCharacterInformations;
            if(!_loc8_)
            {
               _loc8_ = new GameRolePlayCharacterInformations();
               _loc8_.contextualId = param2;
               _loc8_.name = param1;
            }
            _loc6_.createContextMenu(MenusFactory.create(_loc8_,null,[{
               "id":param2,
               "fingerprint":param4,
               "timestamp":param3,
               "chan":param5
            }]));
         }
         else
         {
            _loc6_.createContextMenu(MenusFactory.create(param1));
         }
      }
      
      public static function getPlayerName(param1:String, param2:Number = 0, param3:Number = 0, param4:String = null, param5:uint = 0) : String
      {
         var _loc7_:int = 0;
         var _loc6_:String = unescape(param1);
         switch(param5)
         {
            case ChatActivableChannelsEnum.CHANNEL_TEAM:
            case ChatActivableChannelsEnum.CHANNEL_GUILD:
            case ChatActivableChannelsEnum.CHANNEL_PARTY:
            case ChatActivableChannelsEnum.CHANNEL_ARENA:
            case ChatActivableChannelsEnum.CHANNEL_ADMIN:
               _loc7_ = 3;
               break;
            case ChatActivableChannelsEnum.PSEUDO_CHANNEL_PRIVATE:
               _loc7_ = 4;
               break;
            default:
               _loc7_ = 1;
         }
         if(_loc6_ && _loc6_.indexOf("★") == 0)
         {
            _loc6_ = _loc6_.substr(1);
         }
         ChatAutocompleteNameManager.getInstance().addEntry(_loc6_,_loc7_);
         return _loc6_;
      }
      
      public static function rollOverPlayer(param1:int, param2:int, param3:String, param4:Number = 0, param5:Number = 0, param6:String = null, param7:uint = 0) : void
      {
         var _loc8_:Rectangle = new Rectangle(param1,param2,10,10);
         var _loc9_:TextTooltipInfo = new TextTooltipInfo(I18n.getUiText("ui.tooltip.chat.player"));
         TooltipManager.show(_loc9_,_loc8_,UiModuleManager.getInstance().getModule("Ankama_GameUiCore"),false,"HyperLink",6,2,3,true,null,null,null,null,false,StrataEnum.STRATA_TOOLTIP,1);
      }
   }
}
