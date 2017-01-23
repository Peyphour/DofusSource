package com.ankamagames.dofus.logic.game.roleplay.frames
{
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.dofus.datacenter.world.Hint;
   import com.ankamagames.dofus.internalDatacenter.taxi.TeleportDestinationWrapper;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.kernel.net.ConnectionsHandler;
   import com.ankamagames.dofus.logic.common.actions.ChangeWorldInteractionAction;
   import com.ankamagames.dofus.logic.game.common.frames.ChatFrame;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.logic.game.common.managers.TimeManager;
   import com.ankamagames.dofus.logic.game.roleplay.actions.LeaveDialogRequestAction;
   import com.ankamagames.dofus.logic.game.roleplay.actions.TeleportRequestAction;
   import com.ankamagames.dofus.logic.game.roleplay.actions.ZaapRespawnSaveRequestAction;
   import com.ankamagames.dofus.misc.lists.ChatHookList;
   import com.ankamagames.dofus.misc.lists.HookList;
   import com.ankamagames.dofus.misc.lists.RoleplayHookList;
   import com.ankamagames.dofus.network.enums.DialogTypeEnum;
   import com.ankamagames.dofus.network.enums.TeleporterTypeEnum;
   import com.ankamagames.dofus.network.messages.game.dialog.LeaveDialogMessage;
   import com.ankamagames.dofus.network.messages.game.dialog.LeaveDialogRequestMessage;
   import com.ankamagames.dofus.network.messages.game.interactive.zaap.TeleportDestinationsListMessage;
   import com.ankamagames.dofus.network.messages.game.interactive.zaap.TeleportRequestMessage;
   import com.ankamagames.dofus.network.messages.game.interactive.zaap.ZaapListMessage;
   import com.ankamagames.dofus.network.messages.game.interactive.zaap.ZaapRespawnSaveRequestMessage;
   import com.ankamagames.dofus.network.messages.game.interactive.zaap.ZaapRespawnUpdatedMessage;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.messages.Message;
   import flash.utils.getQualifiedClassName;
   
   public class ZaapFrame implements Frame
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(NpcDialogFrame));
       
      
      private var _priority:int = 0;
      
      private var _spawnMapId:uint;
      
      private var _zaapsList:Array;
      
      public function ZaapFrame()
      {
         super();
      }
      
      public function get spawnMapId() : uint
      {
         return this._spawnMapId;
      }
      
      public function get priority() : int
      {
         return this._priority;
      }
      
      public function set priority(param1:int) : void
      {
         this._priority = param1;
      }
      
      public function pushed() : Boolean
      {
         this._zaapsList = new Array();
         return true;
      }
      
      public function process(param1:Message) : Boolean
      {
         var _loc2_:ZaapListMessage = null;
         var _loc3_:TeleportDestinationsListMessage = null;
         var _loc4_:Array = null;
         var _loc5_:Vector.<Hint> = null;
         var _loc6_:Hint = null;
         var _loc7_:TeleportRequestAction = null;
         var _loc8_:ZaapRespawnSaveRequestAction = null;
         var _loc9_:ZaapRespawnSaveRequestMessage = null;
         var _loc10_:ZaapRespawnUpdatedMessage = null;
         var _loc11_:LeaveDialogMessage = null;
         var _loc12_:int = 0;
         var _loc13_:TeleportRequestMessage = null;
         var _loc14_:TeleportDestinationWrapper = null;
         switch(true)
         {
            case param1 is ZaapListMessage:
               _loc2_ = param1 as ZaapListMessage;
               this._zaapsList = new Array();
               _loc12_ = 0;
               while(_loc12_ < _loc2_.mapIds.length)
               {
                  this._zaapsList.push(new TeleportDestinationWrapper(_loc2_.teleporterType,_loc2_.mapIds[_loc12_],_loc2_.subAreaIds[_loc12_],_loc2_.destTeleporterType[_loc12_],_loc2_.costs[_loc12_],_loc2_.spawnMapId == _loc2_.mapIds[_loc12_]));
                  _loc12_++;
               }
               this._spawnMapId = _loc2_.spawnMapId;
               KernelEventsManager.getInstance().processCallback(RoleplayHookList.TeleportDestinationList,this._zaapsList,_loc2_.teleporterType == TeleporterTypeEnum.TELEPORTER_HAVENBAG?TeleporterTypeEnum.TELEPORTER_HAVENBAG:TeleporterTypeEnum.TELEPORTER_ZAAP);
               return true;
            case param1 is TeleportDestinationsListMessage:
               _loc3_ = param1 as TeleportDestinationsListMessage;
               _loc4_ = new Array();
               _loc12_ = 0;
               while(_loc12_ < _loc3_.mapIds.length)
               {
                  if(_loc3_.teleporterType == TeleporterTypeEnum.TELEPORTER_SUBWAY)
                  {
                     _loc5_ = TeleportDestinationWrapper.getHintsFromMapId(_loc3_.mapIds[_loc12_]);
                     for each(_loc6_ in _loc5_)
                     {
                        _loc4_.push(new TeleportDestinationWrapper(_loc3_.teleporterType,_loc3_.mapIds[_loc12_],_loc3_.subAreaIds[_loc12_],TeleporterTypeEnum.TELEPORTER_SUBWAY,_loc3_.costs[_loc12_],false,_loc6_));
                     }
                  }
                  else
                  {
                     _loc4_.push(new TeleportDestinationWrapper(_loc3_.teleporterType,_loc3_.mapIds[_loc12_],_loc3_.subAreaIds[_loc12_],_loc3_.destTeleporterType[_loc12_],_loc3_.costs[_loc12_]));
                  }
                  _loc12_++;
               }
               KernelEventsManager.getInstance().processCallback(RoleplayHookList.TeleportDestinationList,_loc4_,_loc3_.teleporterType);
               return true;
            case param1 is TeleportRequestAction:
               _loc7_ = param1 as TeleportRequestAction;
               if(_loc7_.cost <= PlayedCharacterManager.getInstance().characteristics.kamas)
               {
                  _loc13_ = new TeleportRequestMessage();
                  _loc13_.initTeleportRequestMessage(_loc7_.teleportType,_loc7_.mapId);
                  ConnectionsHandler.getConnection().send(_loc13_);
               }
               else
               {
                  KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,I18n.getUiText("ui.popup.not_enough_rich"),ChatFrame.RED_CHANNEL_ID,TimeManager.getInstance().getTimestamp());
               }
               return true;
            case param1 is ZaapRespawnSaveRequestAction:
               _loc8_ = param1 as ZaapRespawnSaveRequestAction;
               _loc9_ = new ZaapRespawnSaveRequestMessage();
               _loc9_.initZaapRespawnSaveRequestMessage();
               ConnectionsHandler.getConnection().send(_loc9_);
               return true;
            case param1 is ZaapRespawnUpdatedMessage:
               _loc10_ = param1 as ZaapRespawnUpdatedMessage;
               for each(_loc14_ in this._zaapsList)
               {
                  if(_loc14_.mapId == _loc10_.mapId)
                  {
                     _loc14_.spawn = true;
                  }
                  else
                  {
                     _loc14_.spawn = false;
                  }
               }
               this._spawnMapId = _loc10_.mapId;
               KernelEventsManager.getInstance().processCallback(RoleplayHookList.TeleportDestinationList,this._zaapsList,TeleporterTypeEnum.TELEPORTER_ZAAP);
               return true;
            case param1 is LeaveDialogRequestAction:
               ConnectionsHandler.getConnection().send(new LeaveDialogRequestMessage());
               return true;
            case param1 is LeaveDialogMessage:
               _loc11_ = param1 as LeaveDialogMessage;
               if(_loc11_.dialogType == DialogTypeEnum.DIALOG_TELEPORTER)
               {
                  Kernel.getWorker().process(ChangeWorldInteractionAction.create(true));
                  Kernel.getWorker().removeFrame(this);
               }
               return true;
            default:
               return false;
         }
      }
      
      public function pulled() : Boolean
      {
         KernelEventsManager.getInstance().processCallback(HookList.LeaveDialog);
         return true;
      }
   }
}
