package com.ankamagames.dofus.misc.stats.ui
{
   import com.ankamagames.berilia.types.data.Hook;
   import com.ankamagames.berilia.types.graphic.UiRootContainer;
   import com.ankamagames.dofus.logic.connection.actions.AcquaintanceSearchAction;
   import com.ankamagames.dofus.logic.connection.actions.ServerSelectionAction;
   import com.ankamagames.dofus.misc.stats.StatisticDataTypeEnum;
   import com.ankamagames.dofus.misc.stats.StatsAction;
   import com.ankamagames.dofus.network.enums.StatisticTypeEnum;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.messages.Message;
   import flash.utils.getQualifiedClassName;
   
   public class ServerListSelectionStats implements IUiStats
   {
      
      private static const _log:Logger = Log.getLogger(getQualifiedClassName(ServerListSelectionStats));
       
      
      private var _action:StatsAction;
      
      public function ServerListSelectionStats(param1:UiRootContainer)
      {
         super();
         this._action = StatsAction.get(StatisticTypeEnum.STEP0100_CHOSE_SERVER);
         this._action.addParam("Chosen_Server_ID",StatisticDataTypeEnum.SHORT);
         this._action.addParam("Automatic_Choice",StatisticDataTypeEnum.BOOLEAN);
         this._action.setParam("Automatic_Choice",true);
         this._action.addParam("Seek_A_Friend",StatisticDataTypeEnum.BOOLEAN);
         this._action.start();
      }
      
      public function process(param1:Message) : void
      {
         var _loc2_:ServerSelectionAction = null;
         switch(true)
         {
            case param1 is AcquaintanceSearchAction:
               this._action.setParam("Seek_A_Friend",true);
               break;
            case param1 is ServerSelectionAction:
               _loc2_ = param1 as ServerSelectionAction;
               this._action.setParam("Chosen_Server_ID",_loc2_.serverId);
               this._action.setParam("Automatic_Choice",false);
               this._action.setParam("Seek_A_Friend",false);
               this._action.send();
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
