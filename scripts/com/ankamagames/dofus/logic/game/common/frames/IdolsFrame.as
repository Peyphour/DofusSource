package com.ankamagames.dofus.logic.game.common.frames
{
   import com.ankamagames.berilia.Berilia;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.dofus.datacenter.idols.Idol;
   import com.ankamagames.dofus.internalDatacenter.items.IdolsPresetWrapper;
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import com.ankamagames.dofus.kernel.net.ConnectionsHandler;
   import com.ankamagames.dofus.logic.game.common.actions.CloseIdolsAction;
   import com.ankamagames.dofus.logic.game.common.actions.IdolSelectRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.IdolsPresetDeleteAction;
   import com.ankamagames.dofus.logic.game.common.actions.IdolsPresetSaveAction;
   import com.ankamagames.dofus.logic.game.common.actions.IdolsPresetUseAction;
   import com.ankamagames.dofus.logic.game.common.actions.OpenIdolsAction;
   import com.ankamagames.dofus.logic.game.common.managers.InventoryManager;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.logic.game.common.managers.TimeManager;
   import com.ankamagames.dofus.misc.lists.ChatHookList;
   import com.ankamagames.dofus.misc.lists.HookList;
   import com.ankamagames.dofus.network.enums.ChatActivableChannelsEnum;
   import com.ankamagames.dofus.network.enums.PresetDeleteResultEnum;
   import com.ankamagames.dofus.network.enums.PresetSaveResultEnum;
   import com.ankamagames.dofus.network.enums.PresetUseResultEnum;
   import com.ankamagames.dofus.network.messages.game.idol.IdolListMessage;
   import com.ankamagames.dofus.network.messages.game.idol.IdolPartyLostMessage;
   import com.ankamagames.dofus.network.messages.game.idol.IdolPartyRefreshMessage;
   import com.ankamagames.dofus.network.messages.game.idol.IdolPartyRegisterRequestMessage;
   import com.ankamagames.dofus.network.messages.game.idol.IdolSelectErrorMessage;
   import com.ankamagames.dofus.network.messages.game.idol.IdolSelectRequestMessage;
   import com.ankamagames.dofus.network.messages.game.idol.IdolSelectedMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.items.ObjectAddedMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.items.ObjectDeletedMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.preset.IdolsPresetDeleteMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.preset.IdolsPresetDeleteResultMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.preset.IdolsPresetSaveMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.preset.IdolsPresetSaveResultMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.preset.IdolsPresetUpdateMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.preset.IdolsPresetUseMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.preset.IdolsPresetUseResultMessage;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.jerakine.types.enums.Priority;
   import flash.utils.getQualifiedClassName;
   
   public class IdolsFrame implements Frame
   {
      
      private static const _log:Logger = Log.getLogger(getQualifiedClassName(IdolsFrame));
      
      private static const TYPE_IDOLS_PRESET_WRAPPER:int = 5;
       
      
      private var _openIdols:Boolean;
      
      private var _shortcutReplaced:Boolean;
      
      public function IdolsFrame()
      {
         super();
      }
      
      public function pushed() : Boolean
      {
         return true;
      }
      
      public function pulled() : Boolean
      {
         return true;
      }
      
      public function process(param1:Message) : Boolean
      {
         var _loc2_:IdolPartyRegisterRequestMessage = null;
         var _loc3_:Idol = null;
         var _loc5_:int = 0;
         var _loc6_:IdolsPresetWrapper = null;
         var _loc7_:IdolSelectRequestAction = null;
         var _loc8_:IdolSelectRequestMessage = null;
         var _loc9_:IdolsPresetUseAction = null;
         var _loc10_:IdolsPresetUseMessage = null;
         var _loc11_:IdolsPresetUseResultMessage = null;
         var _loc12_:IdolsPresetSaveAction = null;
         var _loc13_:IdolsPresetSaveMessage = null;
         var _loc14_:IdolsPresetSaveResultMessage = null;
         var _loc15_:IdolsPresetDeleteAction = null;
         var _loc16_:IdolsPresetDeleteMessage = null;
         var _loc17_:IdolsPresetDeleteResultMessage = null;
         var _loc18_:IdolsPresetUpdateMessage = null;
         var _loc19_:IdolListMessage = null;
         var _loc20_:int = 0;
         var _loc21_:uint = 0;
         var _loc22_:uint = 0;
         var _loc23_:Object = null;
         var _loc24_:IdolSelectErrorMessage = null;
         var _loc25_:IdolSelectedMessage = null;
         var _loc26_:IdolPartyRefreshMessage = null;
         var _loc27_:IdolPartyLostMessage = null;
         var _loc28_:ObjectAddedMessage = null;
         var _loc29_:ObjectDeletedMessage = null;
         var _loc30_:ItemWrapper = null;
         var _loc31_:String = null;
         var _loc32_:uint = 0;
         var _loc33_:int = 0;
         var _loc4_:InventoryManager = InventoryManager.getInstance();
         switch(true)
         {
            case param1 is OpenIdolsAction:
               this._openIdols = true;
               _loc2_ = new IdolPartyRegisterRequestMessage();
               _loc2_.initIdolPartyRegisterRequestMessage(true);
               ConnectionsHandler.getConnection().send(_loc2_);
               return true;
            case param1 is CloseIdolsAction:
               _loc2_ = new IdolPartyRegisterRequestMessage();
               _loc2_.initIdolPartyRegisterRequestMessage(false);
               ConnectionsHandler.getConnection().send(_loc2_);
               return true;
            case param1 is IdolSelectRequestAction:
               _loc7_ = param1 as IdolSelectRequestAction;
               _loc8_ = new IdolSelectRequestMessage();
               _loc8_.initIdolSelectRequestMessage(_loc7_.idolId,_loc7_.activate,_loc7_.party);
               ConnectionsHandler.getConnection().send(_loc8_);
               return true;
            case param1 is IdolsPresetUseAction:
               _loc9_ = param1 as IdolsPresetUseAction;
               _loc10_ = new IdolsPresetUseMessage();
               _loc10_.initIdolsPresetUseMessage(_loc9_.presetId,PlayedCharacterManager.getInstance().isPartyLeader);
               ConnectionsHandler.getConnection().send(_loc10_);
               return true;
            case param1 is IdolsPresetUseResultMessage:
               _loc11_ = param1 as IdolsPresetUseResultMessage;
               switch(_loc11_.code)
               {
                  case PresetUseResultEnum.PRESET_USE_OK:
                  case PresetUseResultEnum.PRESET_USE_OK_PARTIAL:
                     KernelEventsManager.getInstance().processCallback(HookList.IdolsPresetEquipped,_loc11_.presetId);
                     if(_loc11_.code == PresetUseResultEnum.PRESET_USE_OK_PARTIAL)
                     {
                        for each(_loc32_ in _loc11_.missingIdols)
                        {
                           KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,I18n.getUiText("ui.idol.preset.missingIdol",[Idol.getIdolById(_loc32_).item.name]),ChatActivableChannelsEnum.PSEUDO_CHANNEL_INFO,TimeManager.getInstance().getTimestamp());
                        }
                     }
                     KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,I18n.getUiText("ui.idol.preset.inUse",[_loc11_.presetId + 1]),ChatActivableChannelsEnum.PSEUDO_CHANNEL_INFO,TimeManager.getInstance().getTimestamp());
                     break;
                  case PresetUseResultEnum.PRESET_USE_ERR_UNKNOWN:
                  case PresetUseResultEnum.PRESET_USE_ERR_CRITERION:
                  case PresetUseResultEnum.PRESET_USE_ERR_BAD_PRESET_ID:
                  case PresetUseResultEnum.PRESET_USE_ERR_COOLDOWN:
                     if(_loc11_.code == PresetUseResultEnum.PRESET_USE_ERR_UNKNOWN)
                     {
                        _loc31_ = I18n.getUiText("ui.common.unknownFail");
                     }
                     else
                     {
                        _loc31_ = I18n.getUiText("ui.idol.preset.error." + _loc11_.code);
                     }
                     KernelEventsManager.getInstance().processCallback(HookList.ErrorPopup,_loc31_);
               }
               return true;
            case param1 is IdolsPresetSaveAction:
               _loc12_ = param1 as IdolsPresetSaveAction;
               _loc13_ = new IdolsPresetSaveMessage();
               _loc13_.initIdolsPresetSaveMessage(_loc12_.presetId,_loc12_.iconId);
               ConnectionsHandler.getConnection().send(_loc13_);
               return true;
            case param1 is IdolsPresetSaveResultMessage:
               _loc14_ = param1 as IdolsPresetSaveResultMessage;
               if(_loc14_.code != PresetSaveResultEnum.PRESET_SAVE_OK)
               {
               }
               return true;
            case param1 is IdolsPresetDeleteAction:
               _loc15_ = param1 as IdolsPresetDeleteAction;
               _loc16_ = new IdolsPresetDeleteMessage();
               _loc16_.initIdolsPresetDeleteMessage(_loc15_.presetId);
               ConnectionsHandler.getConnection().send(_loc16_);
               return true;
            case param1 is IdolsPresetDeleteResultMessage:
               _loc17_ = param1 as IdolsPresetDeleteResultMessage;
               if(_loc17_.code == PresetDeleteResultEnum.PRESET_DEL_OK)
               {
                  for each(_loc6_ in PlayedCharacterManager.getInstance().idolsPresets)
                  {
                     if(_loc6_.id == _loc17_.presetId)
                     {
                        _loc33_ = PlayedCharacterManager.getInstance().idolsPresets.indexOf(_loc6_);
                        break;
                     }
                  }
                  PlayedCharacterManager.getInstance().idolsPresets.splice(_loc33_,1);
                  KernelEventsManager.getInstance().processCallback(HookList.IdolsPresetDelete,_loc17_.presetId);
               }
               return true;
            case param1 is IdolsPresetUpdateMessage:
               _loc18_ = param1 as IdolsPresetUpdateMessage;
               _loc6_ = IdolsPresetWrapper.create(_loc18_.idolsPreset.presetId,_loc18_.idolsPreset.symbolId,_loc18_.idolsPreset.idolId);
               PlayedCharacterManager.getInstance().idolsPresets.push(_loc6_);
               KernelEventsManager.getInstance().processCallback(HookList.IdolsPresetSaved,_loc6_);
               return true;
            case param1 is IdolListMessage:
               _loc19_ = param1 as IdolListMessage;
               PlayedCharacterManager.getInstance().soloIdols.length = 0;
               _loc21_ = _loc19_.chosenIdols.length;
               _loc20_ = 0;
               while(_loc20_ < _loc21_)
               {
                  PlayedCharacterManager.getInstance().soloIdols.push(_loc19_.chosenIdols[_loc20_]);
                  _loc20_++;
               }
               PlayedCharacterManager.getInstance().partyIdols.length = 0;
               _loc22_ = _loc19_.partyChosenIdols.length;
               _loc20_ = 0;
               while(_loc20_ < _loc22_)
               {
                  PlayedCharacterManager.getInstance().partyIdols.push(_loc19_.partyChosenIdols[_loc20_]);
                  _loc20_++;
               }
               _loc23_ = new Object();
               _loc23_.chosenIdols = _loc19_.chosenIdols;
               _loc23_.partyChosenIdols = _loc19_.partyChosenIdols;
               _loc23_.partyIdols = _loc19_.partyIdols;
               _loc23_.presets = PlayedCharacterManager.getInstance().idolsPresets;
               if(this._openIdols && !Berilia.getInstance().getUi("idolsTab"))
               {
                  KernelEventsManager.getInstance().processCallback(HookList.OpenBook,"idolsTab",_loc23_);
               }
               else
               {
                  KernelEventsManager.getInstance().processCallback(HookList.IdolsList,_loc23_.chosenIdols,_loc23_.partyChosenIdols,_loc23_.partyIdols);
               }
               this._openIdols = false;
               return true;
            case param1 is IdolSelectErrorMessage:
               _loc24_ = param1 as IdolSelectErrorMessage;
               KernelEventsManager.getInstance().processCallback(HookList.IdolSelectError,_loc24_.reason,_loc24_.idolId,_loc24_.activate,_loc24_.party);
               return true;
            case param1 is IdolSelectedMessage:
               _loc25_ = param1 as IdolSelectedMessage;
               if(!_loc25_.party)
               {
                  if(!_loc25_.activate)
                  {
                     _loc5_ = PlayedCharacterManager.getInstance().soloIdols.indexOf(_loc25_.idolId);
                     if(_loc5_ != -1)
                     {
                        PlayedCharacterManager.getInstance().soloIdols.splice(_loc5_,1);
                     }
                  }
                  else
                  {
                     PlayedCharacterManager.getInstance().soloIdols.push(_loc25_.idolId);
                  }
               }
               else if(!_loc25_.activate)
               {
                  _loc5_ = PlayedCharacterManager.getInstance().partyIdols.indexOf(_loc25_.idolId);
                  if(_loc5_ != -1)
                  {
                     PlayedCharacterManager.getInstance().partyIdols.splice(_loc5_,1);
                  }
               }
               else
               {
                  PlayedCharacterManager.getInstance().partyIdols.push(_loc25_.idolId);
               }
               KernelEventsManager.getInstance().processCallback(HookList.IdolSelected,_loc25_.idolId,_loc25_.activate,_loc25_.party);
               return true;
            case param1 is IdolPartyRefreshMessage:
               _loc26_ = param1 as IdolPartyRefreshMessage;
               KernelEventsManager.getInstance().processCallback(HookList.IdolPartyRefresh,_loc26_.partyIdol);
               return true;
            case param1 is IdolPartyLostMessage:
               _loc27_ = param1 as IdolPartyLostMessage;
               KernelEventsManager.getInstance().processCallback(HookList.IdolPartyLost,_loc27_.idolId);
               return true;
            case param1 is ObjectAddedMessage:
               _loc28_ = param1 as ObjectAddedMessage;
               _loc3_ = Idol.getIdolByItemId(_loc28_.object.objectGID);
               if(_loc3_)
               {
                  KernelEventsManager.getInstance().processCallback(HookList.IdolAdded,_loc3_.id);
               }
               return false;
            case param1 is ObjectDeletedMessage:
               _loc29_ = param1 as ObjectDeletedMessage;
               _loc30_ = InventoryManager.getInstance().inventory.getItem(_loc29_.objectUID);
               if(_loc30_)
               {
                  _loc3_ = Idol.getIdolByItemId(_loc30_.objectGID);
               }
               if(_loc3_)
               {
                  _loc5_ = PlayedCharacterManager.getInstance().soloIdols.indexOf(_loc3_.id);
                  if(_loc5_ != -1)
                  {
                     PlayedCharacterManager.getInstance().soloIdols.splice(_loc5_,1);
                  }
                  KernelEventsManager.getInstance().processCallback(HookList.IdolRemoved,_loc3_.id);
               }
               return false;
            default:
               return false;
         }
      }
      
      public function get priority() : int
      {
         return Priority.HIGH;
      }
   }
}
