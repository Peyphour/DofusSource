package com.ankamagames.dofus.logic.game.common.frames
{
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.berilia.managers.TooltipManager;
   import com.ankamagames.dofus.datacenter.communication.Emoticon;
   import com.ankamagames.dofus.internalDatacenter.mount.MountData;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.kernel.net.ConnectionsHandler;
   import com.ankamagames.dofus.logic.game.common.actions.mount.ExchangeHandleMountStableAction;
   import com.ankamagames.dofus.logic.game.common.actions.mount.ExchangeRequestOnMountStockAction;
   import com.ankamagames.dofus.logic.game.common.actions.mount.MountFeedRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.mount.MountHarnessColorsUpdateRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.mount.MountHarnessDissociateRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.mount.MountInfoRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.mount.MountInformationInPaddockRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.mount.MountReleaseRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.mount.MountRenameRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.mount.MountSetXpRatioRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.mount.MountSterilizeRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.mount.MountToggleRidingRequestAction;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.logic.game.common.managers.TimeManager;
   import com.ankamagames.dofus.logic.game.common.misc.DofusEntities;
   import com.ankamagames.dofus.logic.game.fight.frames.FightBattleFrame;
   import com.ankamagames.dofus.logic.game.roleplay.frames.RoleplayEntitiesFrame;
   import com.ankamagames.dofus.misc.lists.ChatHookList;
   import com.ankamagames.dofus.misc.lists.ExchangeHookList;
   import com.ankamagames.dofus.misc.lists.MountHookList;
   import com.ankamagames.dofus.network.ProtocolConstantsEnum;
   import com.ankamagames.dofus.network.enums.ChatActivableChannelsEnum;
   import com.ankamagames.dofus.network.enums.MountEquipedErrorEnum;
   import com.ankamagames.dofus.network.enums.UpdatableMountBoostEnum;
   import com.ankamagames.dofus.network.messages.game.context.mount.MountDataMessage;
   import com.ankamagames.dofus.network.messages.game.context.mount.MountEmoteIconUsedOkMessage;
   import com.ankamagames.dofus.network.messages.game.context.mount.MountEquipedErrorMessage;
   import com.ankamagames.dofus.network.messages.game.context.mount.MountFeedRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.mount.MountHarnessColorsUpdateRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.mount.MountHarnessDissociateRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.mount.MountInformationInPaddockRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.mount.MountInformationRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.mount.MountReleaseRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.mount.MountReleasedMessage;
   import com.ankamagames.dofus.network.messages.game.context.mount.MountRenameRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.mount.MountRenamedMessage;
   import com.ankamagames.dofus.network.messages.game.context.mount.MountRidingMessage;
   import com.ankamagames.dofus.network.messages.game.context.mount.MountSetMessage;
   import com.ankamagames.dofus.network.messages.game.context.mount.MountSetXpRatioRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.mount.MountSterilizeRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.mount.MountSterilizedMessage;
   import com.ankamagames.dofus.network.messages.game.context.mount.MountToggleRidingRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.mount.MountUnSetMessage;
   import com.ankamagames.dofus.network.messages.game.context.mount.MountXpRatioMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeHandleMountsStableMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeMountsPaddockAddMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeMountsPaddockRemoveMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeMountsStableAddMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeMountsStableBornAddMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeMountsStableRemoveMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeMountsTakenFromPaddockMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeRequestOnMountStockMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeStartOkMountMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeStartOkMountWithOutPaddockMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeWeightMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.UpdateMountBoostMessage;
   import com.ankamagames.dofus.network.types.game.mount.MountClientData;
   import com.ankamagames.dofus.network.types.game.mount.UpdateMountBoost;
   import com.ankamagames.dofus.network.types.game.mount.UpdateMountIntBoost;
   import com.ankamagames.dofus.types.entities.AnimatedCharacter;
   import com.ankamagames.dofus.types.enums.AnimationEnum;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.entities.interfaces.IMovable;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.jerakine.sequencer.SerialSequencer;
   import com.ankamagames.tiphon.display.TiphonSprite;
   import com.ankamagames.tiphon.sequence.PlayAnimationStep;
   import com.ankamagames.tiphon.sequence.SetAnimationStep;
   import flash.utils.getQualifiedClassName;
   
   public class MountFrame implements Frame
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(MountFrame));
      
      public static const MAX_XP_RATIO:uint = 90;
       
      
      private var _mountDialogFrame:MountDialogFrame;
      
      private var _mountXpRatio:uint;
      
      private var _stableList:Array;
      
      private var _paddockList:Array;
      
      private var _inventoryWeight:uint;
      
      private var _inventoryMaxWeight:uint;
      
      public function MountFrame()
      {
         super();
      }
      
      public function get priority() : int
      {
         return 0;
      }
      
      public function get mountXpRatio() : uint
      {
         return this._mountXpRatio;
      }
      
      public function get stableList() : Array
      {
         return this._stableList;
      }
      
      public function get paddockList() : Array
      {
         return this._paddockList;
      }
      
      public function pushed() : Boolean
      {
         this._mountDialogFrame = new MountDialogFrame();
         return true;
      }
      
      public function initializeMountLists(param1:Vector.<MountClientData>, param2:Vector.<MountClientData>) : void
      {
         var _loc3_:MountClientData = null;
         this._stableList = new Array();
         if(param1)
         {
            for each(_loc3_ in param1)
            {
               this._stableList.push(MountData.makeMountData(_loc3_,true,this._mountXpRatio));
            }
         }
         this._paddockList = new Array();
         if(param2)
         {
            for each(_loc3_ in param2)
            {
               this._paddockList.push(MountData.makeMountData(_loc3_,true,this._mountXpRatio));
            }
         }
      }
      
      public function process(param1:Message) : Boolean
      {
         var _loc2_:MountData = null;
         var _loc3_:MountClientData = null;
         var _loc4_:uint = 0;
         var _loc5_:MountInformationInPaddockRequestAction = null;
         var _loc6_:MountInformationInPaddockRequestMessage = null;
         var _loc7_:IMovable = null;
         var _loc8_:MountFeedRequestAction = null;
         var _loc9_:MountReleaseRequestMessage = null;
         var _loc10_:MountSterilizeRequestMessage = null;
         var _loc11_:MountRenameRequestAction = null;
         var _loc12_:MountRenameRequestMessage = null;
         var _loc13_:MountSetXpRatioRequestAction = null;
         var _loc14_:MountSetXpRatioRequestMessage = null;
         var _loc15_:MountInfoRequestAction = null;
         var _loc16_:MountInformationRequestMessage = null;
         var _loc17_:ExchangeRequestOnMountStockMessage = null;
         var _loc18_:MountRenamedMessage = null;
         var _loc19_:Number = NaN;
         var _loc20_:String = null;
         var _loc21_:ExchangeHandleMountStableAction = null;
         var _loc22_:Vector.<uint> = null;
         var _loc23_:* = undefined;
         var _loc24_:Vector.<uint> = null;
         var _loc25_:ExchangeMountsStableBornAddMessage = null;
         var _loc26_:ExchangeMountsStableAddMessage = null;
         var _loc27_:ExchangeMountsStableRemoveMessage = null;
         var _loc28_:ExchangeMountsPaddockAddMessage = null;
         var _loc29_:ExchangeMountsPaddockRemoveMessage = null;
         var _loc30_:MountDataMessage = null;
         var _loc31_:Boolean = false;
         var _loc32_:AnimatedCharacter = null;
         var _loc33_:RoleplayEntitiesFrame = null;
         var _loc34_:MountEquipedErrorMessage = null;
         var _loc35_:String = null;
         var _loc36_:ExchangeWeightMessage = null;
         var _loc37_:ExchangeStartOkMountMessage = null;
         var _loc38_:ExchangeStartOkMountWithOutPaddockMessage = null;
         var _loc39_:UpdateMountBoostMessage = null;
         var _loc40_:Object = null;
         var _loc41_:MountEmoteIconUsedOkMessage = null;
         var _loc42_:TiphonSprite = null;
         var _loc43_:ExchangeMountsTakenFromPaddockMessage = null;
         var _loc44_:String = null;
         var _loc45_:MountReleasedMessage = null;
         var _loc46_:MountHarnessDissociateRequestAction = null;
         var _loc47_:MountHarnessDissociateRequestMessage = null;
         var _loc48_:MountHarnessColorsUpdateRequestAction = null;
         var _loc49_:MountHarnessColorsUpdateRequestMessage = null;
         var _loc50_:MountToggleRidingRequestMessage = null;
         var _loc51_:MountFeedRequestMessage = null;
         var _loc52_:ExchangeHandleMountsStableMessage = null;
         var _loc53_:int = 0;
         var _loc54_:Emoticon = null;
         var _loc55_:String = null;
         var _loc56_:Object = null;
         var _loc57_:UpdateMountBoost = null;
         var _loc58_:UpdateMountIntBoost = null;
         var _loc59_:String = null;
         var _loc60_:SerialSequencer = null;
         switch(true)
         {
            case param1 is MountInformationInPaddockRequestAction:
               _loc5_ = param1 as MountInformationInPaddockRequestAction;
               _loc6_ = new MountInformationInPaddockRequestMessage();
               _loc6_.initMountInformationInPaddockRequestMessage(_loc5_.mountId);
               ConnectionsHandler.getConnection().send(_loc6_);
               return true;
            case param1 is MountToggleRidingRequestAction:
               _loc7_ = DofusEntities.getEntity(PlayedCharacterManager.getInstance().id) as IMovable;
               if(_loc7_ && !_loc7_.isMoving)
               {
                  _loc50_ = new MountToggleRidingRequestMessage();
                  _loc50_.initMountToggleRidingRequestMessage();
                  ConnectionsHandler.getConnection().send(_loc50_);
               }
               return true;
            case param1 is MountFeedRequestAction:
               _loc8_ = param1 as MountFeedRequestAction;
               if(Kernel.getWorker().getFrame(FightBattleFrame) == null)
               {
                  _loc51_ = new MountFeedRequestMessage();
                  _loc51_.initMountFeedRequestMessage(_loc8_.mountId,_loc8_.mountLocation,_loc8_.mountFoodUid,_loc8_.quantity);
                  ConnectionsHandler.getConnection().send(_loc51_);
               }
               return true;
            case param1 is MountReleaseRequestAction:
               _loc9_ = new MountReleaseRequestMessage();
               _loc9_.initMountReleaseRequestMessage();
               ConnectionsHandler.getConnection().send(_loc9_);
               return true;
            case param1 is MountSterilizeRequestAction:
               _loc10_ = new MountSterilizeRequestMessage();
               _loc10_.initMountSterilizeRequestMessage();
               ConnectionsHandler.getConnection().send(_loc10_);
               return true;
            case param1 is MountRenameRequestAction:
               _loc11_ = param1 as MountRenameRequestAction;
               _loc12_ = new MountRenameRequestMessage();
               _loc12_.initMountRenameRequestMessage(!!_loc11_.newName?_loc11_.newName:"",_loc11_.mountId);
               ConnectionsHandler.getConnection().send(_loc12_);
               return true;
            case param1 is MountSetXpRatioRequestAction:
               _loc13_ = param1 as MountSetXpRatioRequestAction;
               _loc14_ = new MountSetXpRatioRequestMessage();
               _loc14_.initMountSetXpRatioRequestMessage(_loc13_.xpRatio > MAX_XP_RATIO?uint(MAX_XP_RATIO):uint(_loc13_.xpRatio));
               ConnectionsHandler.getConnection().send(_loc14_);
               return true;
            case param1 is MountInfoRequestAction:
               _loc15_ = param1 as MountInfoRequestAction;
               _loc16_ = new MountInformationRequestMessage();
               _loc16_.initMountInformationRequestMessage(_loc15_.mountId,_loc15_.time);
               ConnectionsHandler.getConnection().send(_loc16_);
               return true;
            case param1 is ExchangeRequestOnMountStockAction:
               _loc17_ = new ExchangeRequestOnMountStockMessage();
               _loc17_.initExchangeRequestOnMountStockMessage();
               ConnectionsHandler.getConnection().send(_loc17_);
               return true;
            case param1 is MountSterilizedMessage:
               _loc19_ = MountSterilizedMessage(param1).mountId;
               _loc2_ = MountData.getMountFromCache(_loc19_);
               if(_loc2_)
               {
                  _loc2_.reproductionCount = -1;
               }
               KernelEventsManager.getInstance().processCallback(MountHookList.MountSterilized,_loc19_);
               return true;
            case param1 is MountRenamedMessage:
               _loc18_ = param1 as MountRenamedMessage;
               _loc19_ = _loc18_.mountId;
               _loc20_ = _loc18_.name;
               _loc2_ = MountData.getMountFromCache(_loc19_);
               if(_loc2_)
               {
                  _loc2_.name = _loc20_;
               }
               if(this._mountDialogFrame.inStable)
               {
                  KernelEventsManager.getInstance().processCallback(MountHookList.MountStableUpdate,this._stableList,null,null);
               }
               KernelEventsManager.getInstance().processCallback(MountHookList.MountRenamed,_loc19_,_loc20_);
               return true;
            case param1 is ExchangeHandleMountStableAction:
               _loc21_ = param1 as ExchangeHandleMountStableAction;
               _loc22_ = Vector.<uint>(_loc21_.ridesId);
               _loc23_ = _loc22_.length;
               while(_loc23_ > 0)
               {
                  if(_loc23_ > ProtocolConstantsEnum.MAX_OBJ_COUNT_BY_XFERT)
                  {
                     _loc24_ = _loc22_.splice(0,ProtocolConstantsEnum.MAX_OBJ_COUNT_BY_XFERT);
                     _loc23_ = _loc22_.length;
                  }
                  else
                  {
                     _loc24_ = _loc22_;
                     _loc23_ = 0;
                  }
                  _loc52_ = new ExchangeHandleMountsStableMessage();
                  _loc52_.initExchangeHandleMountsStableMessage(_loc21_.actionType,_loc22_);
                  ConnectionsHandler.getConnection().send(_loc52_);
               }
               return true;
            case param1 is ExchangeMountsStableBornAddMessage:
               _loc25_ = param1 as ExchangeMountsStableBornAddMessage;
               for each(_loc3_ in _loc25_.mountDescription)
               {
                  _loc2_ = MountData.makeMountData(_loc3_,true,this._mountXpRatio);
                  _loc2_.borning = true;
                  if(this._stableList)
                  {
                     this._stableList.push(_loc2_);
                  }
               }
               KernelEventsManager.getInstance().processCallback(MountHookList.MountStableUpdate,this._stableList,null,null);
               return true;
            case param1 is ExchangeMountsStableAddMessage:
               _loc26_ = param1 as ExchangeMountsStableAddMessage;
               if(this._stableList)
               {
                  for each(_loc3_ in _loc26_.mountDescription)
                  {
                     this._stableList.push(MountData.makeMountData(_loc3_,true,this._mountXpRatio));
                  }
               }
               KernelEventsManager.getInstance().processCallback(MountHookList.MountStableUpdate,this._stableList,null,null);
               return true;
            case param1 is ExchangeMountsStableRemoveMessage:
               _loc27_ = param1 as ExchangeMountsStableRemoveMessage;
               for each(_loc4_ in _loc27_.mountsId)
               {
                  _loc53_ = 0;
                  while(_loc53_ < this._stableList.length)
                  {
                     if(this._stableList[_loc53_].id == _loc4_)
                     {
                        this._stableList.splice(_loc53_,1);
                        break;
                     }
                     _loc53_++;
                  }
               }
               KernelEventsManager.getInstance().processCallback(MountHookList.MountStableUpdate,this._stableList,null,null);
               return true;
            case param1 is ExchangeMountsPaddockAddMessage:
               _loc28_ = param1 as ExchangeMountsPaddockAddMessage;
               for each(_loc3_ in _loc28_.mountDescription)
               {
                  this._paddockList.push(MountData.makeMountData(_loc3_,true,this._mountXpRatio));
               }
               KernelEventsManager.getInstance().processCallback(MountHookList.MountStableUpdate,null,this._paddockList,null);
               return true;
            case param1 is ExchangeMountsPaddockRemoveMessage:
               _loc29_ = param1 as ExchangeMountsPaddockRemoveMessage;
               for each(_loc4_ in _loc29_.mountsId)
               {
                  _loc53_ = 0;
                  while(_loc53_ < this._paddockList.length)
                  {
                     if(this._paddockList[_loc53_].id == _loc4_)
                     {
                        this._paddockList.splice(_loc53_,1);
                        break;
                     }
                     _loc53_++;
                  }
               }
               KernelEventsManager.getInstance().processCallback(MountHookList.MountStableUpdate,null,this._paddockList,null);
               return true;
            case param1 is MountXpRatioMessage:
               this._mountXpRatio = MountXpRatioMessage(param1).ratio;
               _loc2_ = PlayedCharacterManager.getInstance().mount;
               if(_loc2_)
               {
                  _loc2_.xpRatio = this._mountXpRatio;
               }
               KernelEventsManager.getInstance().processCallback(MountHookList.MountXpRatio,this._mountXpRatio);
               return true;
            case param1 is MountDataMessage:
               _loc30_ = param1 as MountDataMessage;
               if(this._mountDialogFrame.inStable)
               {
                  KernelEventsManager.getInstance().processCallback(MountHookList.CertificateMountData,MountData.makeMountData(_loc30_.mountData,false,this.mountXpRatio));
               }
               else
               {
                  KernelEventsManager.getInstance().processCallback(MountHookList.PaddockedMountData,MountData.makeMountData(_loc30_.mountData,false,this.mountXpRatio));
               }
               return true;
            case param1 is MountRidingMessage:
               _loc31_ = MountRidingMessage(param1).isRiding;
               _loc32_ = DofusEntities.getEntity(PlayedCharacterManager.getInstance().id) as AnimatedCharacter;
               _loc33_ = Kernel.getWorker().getFrame(RoleplayEntitiesFrame) as RoleplayEntitiesFrame;
               if(_loc32_ && _loc33_)
               {
                  _loc54_ = Emoticon.getEmoticonById(_loc33_.currentEmoticon);
                  if(_loc32_.getAnimation().indexOf("_Statique_") != -1)
                  {
                     _loc55_ = _loc32_.getAnimation();
                  }
                  else if(_loc54_ && _loc54_.persistancy)
                  {
                     _loc55_ = _loc32_.getAnimation().replace("_","_Statique_");
                  }
                  if(_loc55_)
                  {
                     (Kernel.getWorker().getFrame(RoleplayEntitiesFrame) as RoleplayEntitiesFrame).lastStaticAnimations[_loc32_.id] = {"anim":_loc55_};
                  }
                  _loc32_.setAnimation(AnimationEnum.ANIM_STATIQUE);
               }
               PlayedCharacterManager.getInstance().isRidding = _loc31_;
               KernelEventsManager.getInstance().processCallback(MountHookList.MountRiding,_loc31_);
               return true;
            case param1 is MountEquipedErrorMessage:
               _loc34_ = MountEquipedErrorMessage(param1);
               switch(_loc34_.errorType)
               {
                  case MountEquipedErrorEnum.UNSET:
                     _loc35_ = "UNSET";
                     break;
                  case MountEquipedErrorEnum.SET:
                     _loc35_ = "SET";
                     break;
                  case MountEquipedErrorEnum.RIDING:
                     _loc35_ = "RIDING";
                     KernelEventsManager.getInstance().processCallback(MountHookList.MountRiding,false);
               }
               KernelEventsManager.getInstance().processCallback(MountHookList.MountEquipedError,_loc35_);
               return true;
            case param1 is ExchangeWeightMessage:
               _loc36_ = param1 as ExchangeWeightMessage;
               this._inventoryWeight = _loc36_.currentWeight;
               this._inventoryMaxWeight = _loc36_.maxWeight;
               KernelEventsManager.getInstance().processCallback(ExchangeHookList.ExchangeWeight,_loc36_.currentWeight,_loc36_.maxWeight);
               return true;
            case param1 is ExchangeStartOkMountMessage:
               _loc37_ = param1 as ExchangeStartOkMountMessage;
               TooltipManager.hideAll();
               this.initializeMountLists(_loc37_.stabledMountsDescription,_loc37_.paddockedMountsDescription);
               Kernel.getWorker().addFrame(this._mountDialogFrame);
               return true;
            case param1 is MountSetMessage:
               PlayedCharacterManager.getInstance().mount = MountData.makeMountData(MountSetMessage(param1).mountData,false,this.mountXpRatio);
               KernelEventsManager.getInstance().processCallback(MountHookList.MountSet);
               return true;
            case param1 is MountUnSetMessage:
               PlayedCharacterManager.getInstance().mount = null;
               KernelEventsManager.getInstance().processCallback(MountHookList.MountUnSet);
               return true;
            case param1 is ExchangeStartOkMountWithOutPaddockMessage:
               _loc38_ = param1 as ExchangeStartOkMountWithOutPaddockMessage;
               this.initializeMountLists(_loc38_.stabledMountsDescription,null);
               Kernel.getWorker().addFrame(this._mountDialogFrame);
               return true;
            case param1 is UpdateMountBoostMessage:
               _loc39_ = param1 as UpdateMountBoostMessage;
               _loc40_ = null;
               for each(_loc56_ in this._paddockList)
               {
                  if(_loc56_.id == _loc39_.rideId)
                  {
                     _loc40_ = _loc56_;
                     break;
                  }
               }
               if(!_loc40_)
               {
                  _log.error("Can\'t find " + _loc39_.rideId + " ride ID for update mount boost");
                  return true;
               }
               for each(_loc57_ in _loc39_.boostToUpdateList)
               {
                  if(_loc57_ is UpdateMountIntBoost)
                  {
                     _loc58_ = _loc57_ as UpdateMountIntBoost;
                     switch(_loc58_.type)
                     {
                        case UpdatableMountBoostEnum.ENERGY:
                           _loc40_.energy = _loc58_.value;
                           continue;
                        case UpdatableMountBoostEnum.LOVE:
                           _loc40_.love = _loc58_.value;
                           continue;
                        case UpdatableMountBoostEnum.MATURITY:
                           _loc40_.maturity = _loc58_.value;
                           continue;
                        case UpdatableMountBoostEnum.SERENITY:
                           _loc40_.serenity = _loc58_.value;
                           continue;
                        case UpdatableMountBoostEnum.STAMINA:
                           _loc40_.stamina = _loc58_.value;
                           continue;
                        case UpdatableMountBoostEnum.TIREDNESS:
                           _loc40_.boostLimiter = _loc58_.value;
                        case UpdatableMountBoostEnum.RIDEABLE:
                           _loc40_.isRideable = _loc58_.value;
                        default:
                           continue;
                     }
                  }
                  else
                  {
                     continue;
                  }
               }
               KernelEventsManager.getInstance().processCallback(MountHookList.MountStableUpdate,null,this._paddockList,null);
               return true;
            case param1 is MountEmoteIconUsedOkMessage:
               _loc41_ = param1 as MountEmoteIconUsedOkMessage;
               _loc42_ = DofusEntities.getEntity(_loc41_.mountId) as TiphonSprite;
               if(_loc42_)
               {
                  _loc59_ = null;
                  switch(_loc41_.reactionType)
                  {
                     case 1:
                        _loc59_ = "AnimEmoteRest_Statique";
                        break;
                     case 2:
                        _loc59_ = "AnimAttaque0";
                        break;
                     case 3:
                        _loc59_ = "AnimEmoteCaresse";
                        break;
                     case 4:
                        _loc59_ = "AnimEmoteReproductionF";
                        break;
                     case 5:
                        _loc59_ = "AnimEmoteReproductionM";
                  }
                  if(_loc59_)
                  {
                     _loc60_ = new SerialSequencer();
                     _loc60_.addStep(new PlayAnimationStep(_loc42_,_loc59_,false));
                     _loc60_.addStep(new SetAnimationStep(_loc42_,AnimationEnum.ANIM_STATIQUE));
                     _loc60_.start();
                  }
               }
               return true;
            case param1 is ExchangeMountsTakenFromPaddockMessage:
               _loc43_ = param1 as ExchangeMountsTakenFromPaddockMessage;
               _loc44_ = I18n.getUiText("ui.mount.takenFromPaddock",[_loc43_.name,"[" + _loc43_.worldX + "," + _loc43_.worldY + "]",_loc43_.ownername]);
               KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,_loc44_,ChatActivableChannelsEnum.PSEUDO_CHANNEL_INFO,TimeManager.getInstance().getTimestamp());
               return true;
            case param1 is MountReleasedMessage:
               _loc45_ = param1 as MountReleasedMessage;
               KernelEventsManager.getInstance().processCallback(MountHookList.MountReleased,_loc45_.mountId);
               return true;
            case param1 is MountHarnessDissociateRequestAction:
               _loc46_ = param1 as MountHarnessDissociateRequestAction;
               _loc47_ = new MountHarnessDissociateRequestMessage();
               _loc47_.initMountHarnessDissociateRequestMessage();
               ConnectionsHandler.getConnection().send(_loc47_);
               return true;
            case param1 is MountHarnessColorsUpdateRequestAction:
               _loc48_ = param1 as MountHarnessColorsUpdateRequestAction;
               _loc49_ = new MountHarnessColorsUpdateRequestMessage();
               _loc49_.initMountHarnessColorsUpdateRequestMessage(_loc48_.useHarnessColors);
               ConnectionsHandler.getConnection().send(_loc49_);
               return true;
            default:
               return false;
         }
      }
      
      public function pulled() : Boolean
      {
         return true;
      }
      
      public function get inventoryWeight() : uint
      {
         return this._inventoryWeight;
      }
      
      public function get inventoryMaxWeight() : uint
      {
         return this._inventoryMaxWeight;
      }
   }
}
