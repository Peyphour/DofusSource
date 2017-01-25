package com.ankamagames.dofus.misc.stats.ui
{
   import com.ankamagames.berilia.types.data.Hook;
   import com.ankamagames.berilia.types.graphic.UiRootContainer;
   import com.ankamagames.dofus.misc.stats.StatsAction;
   import com.ankamagames.dofus.network.enums.StatisticTypeEnum;
   import com.ankamagames.jerakine.handlers.messages.mouse.MouseClickMessage;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.messages.Message;
   import flash.utils.getQualifiedClassName;
   
   public class NicknameRegistrationStats implements IUiStats
   {
      
      private static const _log:Logger = Log.getLogger(getQualifiedClassName(NicknameRegistrationStats));
       
      
      private var _action:StatsAction;
      
      public function NicknameRegistrationStats(param1:UiRootContainer)
      {
         super();
         this._action = StatsAction.get(StatisticTypeEnum.STEP0000_CHOSE_NICKNAME);
         this._action.start();
      }
      
      public function process(param1:Message) : void
      {
         var _loc2_:MouseClickMessage = null;
         switch(true)
         {
            case param1 is MouseClickMessage:
               _loc2_ = param1 as MouseClickMessage;
               if(_loc2_.target.name == "btn_validate")
               {
                  this._action.send();
               }
         }
      }
      
      public function onHook(param1:Hook, param2:Array) : void
      {
      }
      
      public function remove() : void
      {
      }
   }
}
