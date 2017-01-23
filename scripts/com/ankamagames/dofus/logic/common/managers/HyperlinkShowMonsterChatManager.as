package com.ankamagames.dofus.logic.common.managers
{
   import com.ankamagames.berilia.enums.StrataEnum;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.berilia.managers.TooltipManager;
   import com.ankamagames.berilia.managers.UiModuleManager;
   import com.ankamagames.berilia.types.data.TextTooltipInfo;
   import com.ankamagames.dofus.datacenter.monsters.Monster;
   import com.ankamagames.dofus.misc.lists.HookList;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import flash.geom.Rectangle;
   import flash.utils.getQualifiedClassName;
   
   public class HyperlinkShowMonsterChatManager
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(HyperlinkShowMonsterChatManager));
      
      private static var _monsterList:Array = new Array();
      
      private static var _monsterId:uint = 0;
       
      
      public function HyperlinkShowMonsterChatManager()
      {
         super();
      }
      
      public static function showMonster(param1:uint) : void
      {
         var _loc2_:Object = new Object();
         _loc2_.monsterId = param1;
         _loc2_.forceOpen = true;
         TooltipManager.hideAll();
         KernelEventsManager.getInstance().processCallback(HookList.OpenBook,"bestiaryTab",_loc2_);
      }
      
      public static function addMonster(param1:uint) : String
      {
         var _loc3_:* = null;
         var _loc2_:Monster = Monster.getMonsterById(param1);
         if(_loc2_)
         {
            _monsterList[_monsterId] = _loc2_;
            _loc3_ = "{chatmonster," + param1 + "::[" + _loc2_.name + "]}";
            _monsterId++;
            return _loc3_;
         }
         return "[null]";
      }
      
      public static function getMonsterName(param1:uint) : String
      {
         var _loc2_:Monster = Monster.getMonsterById(param1);
         if(_loc2_)
         {
            return "[" + _loc2_.name + "]";
         }
         return "[null]";
      }
      
      public static function rollOver(param1:int, param2:int, param3:uint, param4:uint = 0) : void
      {
         var _loc5_:Rectangle = new Rectangle(param1,param2,10,10);
         var _loc6_:TextTooltipInfo = new TextTooltipInfo(I18n.getUiText("ui.tooltip.chat.monster"));
         TooltipManager.show(_loc6_,_loc5_,UiModuleManager.getInstance().getModule("Ankama_GameUiCore"),false,"HyperLink",6,2,3,true,null,null,null,null,false,StrataEnum.STRATA_TOOLTIP,1);
      }
   }
}
