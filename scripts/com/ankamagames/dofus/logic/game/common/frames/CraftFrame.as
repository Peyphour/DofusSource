package com.ankamagames.dofus.logic.game.common.frames
{
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.berilia.managers.UiModuleManager;
   import com.ankamagames.dofus.datacenter.effects.Effect;
   import com.ankamagames.dofus.datacenter.effects.EffectInstance;
   import com.ankamagames.dofus.datacenter.effects.instances.EffectInstanceDice;
   import com.ankamagames.dofus.datacenter.effects.instances.EffectInstanceInteger;
   import com.ankamagames.dofus.datacenter.effects.instances.EffectInstanceMinMax;
   import com.ankamagames.dofus.datacenter.items.Item;
   import com.ankamagames.dofus.datacenter.jobs.Skill;
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.kernel.net.ConnectionsHandler;
   import com.ankamagames.dofus.logic.common.managers.HyperlinkItemManager;
   import com.ankamagames.dofus.logic.game.common.actions.craft.ExchangeCraftPaymentModificationAction;
   import com.ankamagames.dofus.logic.game.common.actions.craft.ExchangeMultiCraftSetCrafterCanUseHisRessourcesAction;
   import com.ankamagames.dofus.logic.game.common.actions.craft.ExchangeObjectUseInWorkshopAction;
   import com.ankamagames.dofus.logic.game.common.actions.craft.ExchangePlayerMultiCraftRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.craft.ExchangeReplayAction;
   import com.ankamagames.dofus.logic.game.common.actions.craft.ExchangeReplayStopAction;
   import com.ankamagames.dofus.logic.game.common.actions.craft.ExchangeSetCraftRecipeAction;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.logic.game.common.managers.SpeakingItemManager;
   import com.ankamagames.dofus.logic.game.common.managers.TimeManager;
   import com.ankamagames.dofus.logic.game.fight.miscs.ActionIdConverter;
   import com.ankamagames.dofus.logic.game.roleplay.frames.RoleplayContextFrame;
   import com.ankamagames.dofus.misc.EntityLookAdapter;
   import com.ankamagames.dofus.misc.lists.ChatHookList;
   import com.ankamagames.dofus.misc.lists.CraftHookList;
   import com.ankamagames.dofus.misc.lists.ExchangeHookList;
   import com.ankamagames.dofus.network.enums.ChatActivableChannelsEnum;
   import com.ankamagames.dofus.network.enums.DialogTypeEnum;
   import com.ankamagames.dofus.network.enums.ExchangeReplayStopReasonEnum;
   import com.ankamagames.dofus.network.enums.ExchangeTypeEnum;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeCraftCountModifiedMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeCraftCountRequestMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeCraftPaymentModificationRequestMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeCraftPaymentModifiedMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeCraftResultMagicWithObjectDescMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeCraftResultMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeCraftResultWithObjectDescMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeCraftResultWithObjectIdMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeItemAutoCraftStopedMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeLeaveMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeObjectUseInWorkshopMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeOkMultiCraftMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangePlayerMultiCraftRequestMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeReplayStopMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeSetCraftRecipeMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeStartOkCraftMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeStartOkCraftWithInformationMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeStartOkMulticraftCrafterMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeStartOkMulticraftCustomerMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.items.ExchangeMultiCraftCrafterCanUseHisRessourcesMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.items.ExchangeMultiCraftSetCrafterCanUseHisRessourcesMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.items.ExchangeObjectModifiedInBagMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.items.ExchangeObjectPutInBagMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.items.ExchangeObjectRemovedFromBagMessage;
   import com.ankamagames.dofus.network.types.game.context.GameContextActorInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayNamedActorInformations;
   import com.ankamagames.dofus.network.types.game.data.items.ObjectItem;
   import com.ankamagames.dofus.network.types.game.data.items.effects.ObjectEffect;
   import com.ankamagames.dofus.network.types.game.data.items.effects.ObjectEffectDice;
   import com.ankamagames.dofus.network.types.game.data.items.effects.ObjectEffectInteger;
   import com.ankamagames.dofus.network.types.game.data.items.effects.ObjectEffectMinMax;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.jerakine.types.enums.Priority;
   import flash.utils.getQualifiedClassName;
   
   public class CraftFrame implements Frame
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(CraftFrame));
      
      private static const SMITHMAGIC_RUNE_ID:int = 78;
      
      private static const SMITHMAGIC_POTION_ID:int = 26;
      
      private static const SMITHMAGIC_ORB_ID:int = 189;
      
      private static const SIGNATURE_RUNE_ID:int = 7508;
       
      
      public var playerList:PlayerExchangeCraftList;
      
      public var otherPlayerList:PlayerExchangeCraftList;
      
      public var paymentCraftList:PaymentCraftList;
      
      private var _crafterInfos:PlayerInfo;
      
      private var _customerInfos:PlayerInfo;
      
      public var bagList:Array;
      
      private var _isCrafter:Boolean;
      
      private var _recipes:Array;
      
      private var _skillId:int;
      
      private var _craftType:int;
      
      private var _smithMagicOldObject:ItemWrapper;
      
      private var _success:Boolean;
      
      public function CraftFrame()
      {
         this.playerList = new PlayerExchangeCraftList();
         this.otherPlayerList = new PlayerExchangeCraftList();
         this.paymentCraftList = new PaymentCraftList();
         this._crafterInfos = new PlayerInfo();
         this._customerInfos = new PlayerInfo();
         this.bagList = new Array();
         super();
      }
      
      public function get priority() : int
      {
         return Priority.NORMAL;
      }
      
      private function get socialFrame() : SocialFrame
      {
         return Kernel.getWorker().getFrame(SocialFrame) as SocialFrame;
      }
      
      public function get crafterInfos() : PlayerInfo
      {
         return this._crafterInfos;
      }
      
      public function get customerInfos() : PlayerInfo
      {
         return this._customerInfos;
      }
      
      public function get skillId() : int
      {
         return this._skillId;
      }
      
      private function get roleplayContextFrame() : RoleplayContextFrame
      {
         return Kernel.getWorker().getFrame(RoleplayContextFrame) as RoleplayContextFrame;
      }
      
      private function get commonExchangeFrame() : CommonExchangeManagementFrame
      {
         return Kernel.getWorker().getFrame(CommonExchangeManagementFrame) as CommonExchangeManagementFrame;
      }
      
      public function processExchangeOkMultiCraftMessage(param1:ExchangeOkMultiCraftMessage) : void
      {
         PlayedCharacterManager.getInstance().isInExchange = true;
         var _loc2_:ExchangeOkMultiCraftMessage = param1 as ExchangeOkMultiCraftMessage;
         if(_loc2_.role == ExchangeTypeEnum.MULTICRAFT_CRAFTER)
         {
            this.playerList.isCrafter = true;
            this.otherPlayerList.isCrafter = false;
            this._crafterInfos.id = PlayedCharacterManager.getInstance().id;
            if(this.crafterInfos.id == _loc2_.initiatorId)
            {
               this._customerInfos.id = _loc2_.otherId;
            }
            else
            {
               this._customerInfos.id = _loc2_.initiatorId;
            }
         }
         else
         {
            this.playerList.isCrafter = false;
            this.otherPlayerList.isCrafter = true;
            this._customerInfos.id = PlayedCharacterManager.getInstance().id;
            if(this.customerInfos.id == _loc2_.initiatorId)
            {
               this._crafterInfos.id = _loc2_.otherId;
            }
            else
            {
               this._crafterInfos.id = _loc2_.initiatorId;
            }
         }
         var _loc3_:GameContextActorInformations = this.roleplayContextFrame.entitiesFrame.getEntityInfos(this.crafterInfos.id);
         if(_loc3_)
         {
            this._crafterInfos.look = EntityLookAdapter.getRiderLook(_loc3_.look);
            this._crafterInfos.name = (_loc3_ as GameRolePlayNamedActorInformations).name;
         }
         else
         {
            this._crafterInfos.look = null;
            this._crafterInfos.name = "";
         }
         var _loc4_:GameContextActorInformations = this.roleplayContextFrame.entitiesFrame.getEntityInfos(this.customerInfos.id);
         if(_loc4_)
         {
            this._customerInfos.look = EntityLookAdapter.getRiderLook(_loc4_.look);
            this._customerInfos.name = (_loc4_ as GameRolePlayNamedActorInformations).name;
         }
         else
         {
            this._customerInfos.look = null;
            this._customerInfos.name = "";
         }
         var _loc5_:String = "";
         var _loc6_:Number = _loc2_.initiatorId;
         if(_loc2_.initiatorId == PlayedCharacterManager.getInstance().id)
         {
            if(_loc2_.initiatorId == this.crafterInfos.id)
            {
               this._isCrafter = true;
               _loc5_ = this.customerInfos.name;
            }
            else
            {
               this._isCrafter = false;
               _loc5_ = this.crafterInfos.name;
            }
         }
         else if(_loc2_.otherId == this.crafterInfos.id)
         {
            this._isCrafter = false;
            _loc5_ = this.crafterInfos.name;
         }
         else
         {
            this._isCrafter = true;
            _loc5_ = this.customerInfos.name;
         }
         if(!this.socialFrame.isIgnored(_loc5_))
         {
            KernelEventsManager.getInstance().processCallback(CraftHookList.ExchangeMultiCraftRequest,_loc2_.role,_loc5_,_loc6_);
         }
      }
      
      public function processExchangeStartOkCraftWithInformationMessage(param1:ExchangeStartOkCraftWithInformationMessage) : void
      {
         var _loc2_:ExchangeStartOkCraftWithInformationMessage = param1 as ExchangeStartOkCraftWithInformationMessage;
         PlayedCharacterManager.getInstance().isInExchange = true;
         this._skillId = _loc2_.skillId;
         var _loc3_:Skill = Skill.getSkillById(this._skillId);
         this._isCrafter = true;
         if(_loc3_.isForgemagus)
         {
            this._craftType = 1;
         }
         else
         {
            this._craftType = 0;
         }
         KernelEventsManager.getInstance().processCallback(CraftHookList.ExchangeStartOkCraft,_loc2_.skillId);
      }
      
      public function pushed() : Boolean
      {
         this._success = false;
         return true;
      }
      
      public function pulled() : Boolean
      {
         if(Kernel.getWorker().contains(CommonExchangeManagementFrame))
         {
            Kernel.getWorker().removeFrame(Kernel.getWorker().getFrame(CommonExchangeManagementFrame));
         }
         KernelEventsManager.getInstance().processCallback(ExchangeHookList.ExchangeLeave,this._success);
         this.playerList = new PlayerExchangeCraftList();
         this.otherPlayerList = new PlayerExchangeCraftList();
         this.bagList = new Array();
         this._crafterInfos = new PlayerInfo();
         this._customerInfos = new PlayerInfo();
         this._smithMagicOldObject = null;
         return true;
      }
      
      public function process(param1:Message) : Boolean
      {
         var _loc2_:ExchangePlayerMultiCraftRequestAction = null;
         var _loc3_:ExchangePlayerMultiCraftRequestMessage = null;
         var _loc4_:ExchangeReplayStopAction = null;
         var _loc5_:ExchangeReplayStopMessage = null;
         var _loc6_:ExchangeSetCraftRecipeAction = null;
         var _loc7_:ExchangeSetCraftRecipeMessage = null;
         var _loc8_:ExchangeCraftResultMessage = null;
         var _loc9_:uint = 0;
         var _loc10_:String = null;
         var _loc11_:String = null;
         var _loc12_:ItemWrapper = null;
         var _loc13_:* = false;
         var _loc14_:ExchangeItemAutoCraftStopedMessage = null;
         var _loc15_:String = null;
         var _loc16_:Boolean = false;
         var _loc17_:ExchangeStartOkCraftMessage = null;
         var _loc18_:uint = 0;
         var _loc19_:ExchangeCraftPaymentModificationAction = null;
         var _loc20_:ExchangeCraftPaymentModificationRequestMessage = null;
         var _loc21_:ExchangeCraftPaymentModifiedMessage = null;
         var _loc22_:ExchangeObjectModifiedInBagMessage = null;
         var _loc23_:ItemWrapper = null;
         var _loc24_:ExchangeObjectPutInBagMessage = null;
         var _loc25_:ObjectItem = null;
         var _loc26_:ItemWrapper = null;
         var _loc27_:ExchangeObjectRemovedFromBagMessage = null;
         var _loc28_:ExchangeObjectUseInWorkshopAction = null;
         var _loc29_:ExchangeObjectUseInWorkshopMessage = null;
         var _loc30_:ExchangeMultiCraftSetCrafterCanUseHisRessourcesAction = null;
         var _loc31_:ExchangeMultiCraftSetCrafterCanUseHisRessourcesMessage = null;
         var _loc32_:ExchangeMultiCraftCrafterCanUseHisRessourcesMessage = null;
         var _loc33_:ExchangeStartOkMulticraftCrafterMessage = null;
         var _loc34_:Skill = null;
         var _loc35_:ExchangeStartOkMulticraftCustomerMessage = null;
         var _loc36_:Skill = null;
         var _loc37_:ExchangeReplayAction = null;
         var _loc38_:ExchangeCraftCountRequestMessage = null;
         var _loc39_:ExchangeCraftCountModifiedMessage = null;
         var _loc40_:ExchangeLeaveMessage = null;
         var _loc41_:ExchangeCraftResultWithObjectIdMessage = null;
         var _loc42_:ExchangeCraftResultMagicWithObjectDescMessage = null;
         var _loc43_:String = null;
         var _loc44_:Boolean = false;
         var _loc45_:Array = null;
         var _loc46_:Vector.<ObjectEffect> = null;
         var _loc47_:EffectInstance = null;
         var _loc48_:Array = null;
         var _loc49_:String = null;
         var _loc50_:String = null;
         var _loc51_:String = null;
         var _loc52_:ExchangeCraftResultWithObjectDescMessage = null;
         var _loc53_:int = 0;
         var _loc54_:ObjectEffect = null;
         var _loc55_:Boolean = false;
         var _loc56_:ObjectEffect = null;
         var _loc57_:int = 0;
         var _loc58_:int = 0;
         var _loc59_:int = 0;
         var _loc60_:EffectInstanceInteger = null;
         var _loc61_:EffectInstanceDice = null;
         var _loc62_:ObjectEffect = null;
         var _loc63_:Boolean = false;
         var _loc64_:ObjectEffect = null;
         var _loc65_:EffectInstanceMinMax = null;
         var _loc66_:Object = null;
         switch(true)
         {
            case param1 is ExchangePlayerMultiCraftRequestAction:
               _loc2_ = param1 as ExchangePlayerMultiCraftRequestAction;
               _loc3_ = new ExchangePlayerMultiCraftRequestMessage();
               _loc3_.initExchangePlayerMultiCraftRequestMessage(_loc2_.exchangeType,_loc2_.target,_loc2_.skillId);
               ConnectionsHandler.getConnection().send(_loc3_);
               return true;
            case param1 is ExchangeOkMultiCraftMessage:
               this.processExchangeOkMultiCraftMessage(param1 as ExchangeOkMultiCraftMessage);
               return true;
            case param1 is ExchangeReplayStopAction:
               _loc4_ = param1 as ExchangeReplayStopAction;
               _loc5_ = new ExchangeReplayStopMessage();
               _loc5_.initExchangeReplayStopMessage();
               ConnectionsHandler.getConnection().send(_loc5_);
               return true;
            case param1 is ExchangeSetCraftRecipeAction:
               _loc6_ = param1 as ExchangeSetCraftRecipeAction;
               _loc7_ = new ExchangeSetCraftRecipeMessage();
               _loc7_.initExchangeSetCraftRecipeMessage(_loc6_.recipeId);
               ConnectionsHandler.getConnection().send(_loc7_);
               return true;
            case param1 is ExchangeCraftResultMessage:
               _loc8_ = param1 as ExchangeCraftResultMessage;
               _loc9_ = _loc8_.getMessageId();
               _loc12_ = null;
               _loc13_ = false;
               switch(_loc9_)
               {
                  case ExchangeCraftResultMessage.protocolId:
                     _loc11_ = I18n.getUiText("ui.craft.noResult");
                     break;
                  case ExchangeCraftResultWithObjectIdMessage.protocolId:
                     _loc41_ = param1 as ExchangeCraftResultWithObjectIdMessage;
                     _loc12_ = ItemWrapper.create(63,0,_loc41_.objectGenericId,1,null,false);
                     _loc10_ = Item.getItemById(_loc41_.objectGenericId).name;
                     _loc11_ = I18n.getUiText("ui.craft.failed");
                     _loc13_ = _loc41_.craftResult == 2;
                     break;
                  case ExchangeCraftResultMagicWithObjectDescMessage.protocolId:
                     _loc42_ = param1 as ExchangeCraftResultMagicWithObjectDescMessage;
                     _loc43_ = "";
                     _loc44_ = false;
                     _loc45_ = new Array();
                     _loc46_ = _loc42_.objectInfo.effects;
                     _loc48_ = new Array();
                     if(this._smithMagicOldObject)
                     {
                        for each(_loc54_ in this._smithMagicOldObject.effectsList)
                        {
                           _loc48_.push(_loc54_);
                           if(_loc54_ is ObjectEffectInteger || _loc54_ is ObjectEffectDice)
                           {
                              _loc55_ = false;
                              for each(_loc56_ in _loc46_)
                              {
                                 if((_loc56_ is ObjectEffectInteger || _loc56_ is ObjectEffectDice) && _loc56_.actionId == _loc54_.actionId)
                                 {
                                    _loc55_ = true;
                                    _loc57_ = Effect.getEffectById(_loc54_.actionId).bonusType;
                                    _loc58_ = Effect.getEffectById(_loc56_.actionId).bonusType;
                                    if(_loc56_ is ObjectEffectInteger && _loc54_ is ObjectEffectInteger)
                                    {
                                       _loc57_ = _loc57_ * ObjectEffectInteger(_loc54_).value;
                                       _loc58_ = _loc58_ * ObjectEffectInteger(_loc56_).value;
                                       if(_loc58_ != _loc57_)
                                       {
                                          _loc59_ = _loc58_ - _loc57_;
                                          _loc60_ = new EffectInstanceInteger();
                                          _loc60_.effectId = _loc56_.actionId;
                                          if(_loc59_ > 0)
                                          {
                                             _loc44_ = true;
                                          }
                                          _loc60_.value = ObjectEffectInteger(_loc56_).value - ObjectEffectInteger(_loc54_).value;
                                          _loc43_ = _loc43_ + (_loc60_.description + ", ");
                                          _loc43_ = _loc43_.replace("+-","-");
                                          _loc43_ = _loc43_.replace("--","+");
                                          _loc45_.push({
                                             "id":_loc60_.effectId,
                                             "value":_loc59_
                                          });
                                          _loc47_ = _loc60_;
                                       }
                                    }
                                    else if(_loc56_ is ObjectEffectDice && _loc54_ is ObjectEffectDice)
                                    {
                                       _loc57_ = ObjectEffectDice(_loc54_).diceNum;
                                       _loc58_ = ObjectEffectDice(_loc56_).diceNum;
                                       if(_loc58_ != _loc57_)
                                       {
                                          _loc59_ = _loc58_ - _loc57_;
                                          if(_loc54_.actionId == ActionIdConverter.ACTION_ITEM_CHANGE_DURABILITY)
                                          {
                                             _loc43_ = _loc43_ + ("+" + _loc59_ + ", ");
                                             _loc45_.push({
                                                "id":_loc54_.actionId,
                                                "value":_loc59_
                                             });
                                             _loc59_ = _loc58_;
                                          }
                                          _loc61_ = new EffectInstanceDice();
                                          _loc61_.effectId = _loc56_.actionId;
                                          if(_loc59_ > 0)
                                          {
                                             _loc44_ = true;
                                          }
                                          _loc61_.diceNum = _loc59_;
                                          _loc61_.diceSide = _loc59_;
                                          _loc61_.value = ObjectEffectDice(_loc56_).diceConst;
                                          _loc47_ = _loc61_;
                                          _loc43_ = _loc43_ + (_loc47_.description + ", ");
                                          _loc43_ = _loc43_.replace("+-","-");
                                          _loc43_ = _loc43_.replace("--","+");
                                          _loc45_.push({
                                             "id":_loc61_.effectId,
                                             "value":_loc59_
                                          });
                                       }
                                    }
                                 }
                              }
                              if(!_loc55_ && _loc54_ is ObjectEffectInteger)
                              {
                                 _loc60_ = new EffectInstanceInteger();
                                 _loc60_.effectId = _loc54_.actionId;
                                 _loc60_.value = -ObjectEffectInteger(_loc54_).value;
                                 _loc43_ = _loc43_ + (_loc60_.description + ", ");
                                 _loc43_ = _loc43_.replace("+-","-");
                                 _loc43_ = _loc43_.replace("--","+");
                                 _loc45_.push({
                                    "id":_loc60_.effectId,
                                    "value":_loc60_.value
                                 });
                                 _loc47_ = _loc60_;
                                 if(_loc47_.description.substr(0,2) == "--")
                                 {
                                    _loc44_ = true;
                                 }
                              }
                           }
                        }
                     }
                     for each(_loc62_ in _loc46_)
                     {
                        _loc63_ = true;
                        for each(_loc64_ in _loc48_)
                        {
                           if(_loc62_ is ObjectEffectInteger || _loc62_ is ObjectEffectMinMax)
                           {
                              if(_loc62_.actionId == _loc64_.actionId)
                              {
                                 _loc63_ = false;
                                 _loc48_.splice(_loc48_.indexOf(_loc64_),1);
                                 break;
                              }
                           }
                           else
                           {
                              _loc63_ = false;
                           }
                        }
                        if(_loc63_)
                        {
                           if(_loc62_ is ObjectEffectMinMax)
                           {
                              _loc65_ = new EffectInstanceMinMax();
                              _loc65_.effectId = _loc62_.actionId;
                              _loc65_.min = ObjectEffectMinMax(_loc62_).min;
                              _loc65_.max = ObjectEffectMinMax(_loc62_).max;
                              _loc47_ = _loc65_;
                              _loc44_ = true;
                           }
                           else if(_loc62_ is ObjectEffectInteger)
                           {
                              _loc60_ = new EffectInstanceInteger();
                              _loc60_.effectId = _loc62_.actionId;
                              _loc60_.value = ObjectEffectInteger(_loc62_).value;
                              if(_loc60_.value > 0 && _loc60_.description.charAt(0) != "-")
                              {
                                 _loc44_ = true;
                              }
                              _loc43_ = _loc43_ + (_loc60_.description + ", ");
                              _loc45_.push({
                                 "id":_loc60_.effectId,
                                 "value":_loc60_.value
                              });
                              _loc47_ = _loc60_;
                           }
                        }
                     }
                     _loc49_ = "";
                     if(_loc42_.magicPoolStatus == 2)
                     {
                        _loc49_ = "+" + I18n.getUiText("ui.craft.smithResidualMagic");
                     }
                     else if(_loc42_.magicPoolStatus == 3)
                     {
                        _loc49_ = "-" + I18n.getUiText("ui.craft.smithResidualMagic");
                     }
                     _loc50_ = "";
                     _loc51_ = "";
                     if(_loc44_)
                     {
                        _loc50_ = _loc50_ + I18n.getUiText("ui.craft.success");
                     }
                     else
                     {
                        _loc50_ = _loc50_ + I18n.getUiText("ui.craft.failure");
                     }
                     if(_loc43_ != "" || _loc49_ != "")
                     {
                        _loc51_ = _loc43_;
                        if(_loc49_ != "")
                        {
                           _loc51_ = _loc51_ + _loc49_;
                        }
                        else
                        {
                           _loc51_ = _loc51_.substring(0,_loc51_.length - 2);
                        }
                        _loc50_ = _loc50_ + (I18n.getUiText("ui.common.colon") + _loc51_);
                     }
                     else
                     {
                        _loc51_ = _loc50_;
                     }
                     KernelEventsManager.getInstance().processCallback(CraftHookList.ItemMagedResult,_loc44_,_loc51_,_loc45_);
                     _loc12_ = ItemWrapper.create(63,_loc42_.objectInfo.objectUID,_loc42_.objectInfo.objectGID,1,_loc42_.objectInfo.effects,false);
                     this._smithMagicOldObject = _loc12_.clone();
                     _loc13_ = _loc42_.craftResult == 2;
                     break;
                  case ExchangeCraftResultWithObjectDescMessage.protocolId:
                     _loc52_ = param1 as ExchangeCraftResultWithObjectDescMessage;
                     if(_loc52_.objectInfo.objectGID == 0)
                     {
                        break;
                     }
                     _loc12_ = ItemWrapper.create(63,_loc52_.objectInfo.objectUID,_loc52_.objectInfo.objectGID,1,_loc52_.objectInfo.effects,false);
                     _loc10_ = HyperlinkItemManager.newChatItem(_loc12_);
                     _loc53_ = _loc52_.objectInfo.quantity;
                     switch(true)
                     {
                        case this._crafterInfos.id == PlayedCharacterManager.getInstance().id:
                           _loc11_ = I18n.getUiText("ui.craft.successTarget",[_loc53_,_loc10_,this._customerInfos.name]);
                           break;
                        case this._customerInfos.id == PlayedCharacterManager.getInstance().id:
                           _loc11_ = I18n.getUiText("ui.craft.successOther",[this._crafterInfos.name,_loc53_,_loc10_]);
                           break;
                        default:
                           _loc11_ = I18n.getUiText("ui.craft.successSelf",[_loc53_,_loc10_]);
                     }
                     _loc13_ = _loc52_.craftResult == 2;
                     break;
               }
               if(_loc13_)
               {
                  SpeakingItemManager.getInstance().triggerEvent(SpeakingItemManager.SPEAK_TRIGGER_CRAFT_OK);
               }
               else
               {
                  SpeakingItemManager.getInstance().triggerEvent(SpeakingItemManager.SPEAK_TRIGGER_CRAFT_KO);
               }
               if(_loc11_ && _loc11_ != "")
               {
                  KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,_loc11_,ChatActivableChannelsEnum.PSEUDO_CHANNEL_INFO,TimeManager.getInstance().getTimestamp());
               }
               KernelEventsManager.getInstance().processCallback(CraftHookList.ExchangeCraftResult,_loc8_.craftResult,_loc12_);
               return true;
            case param1 is ExchangeItemAutoCraftStopedMessage:
               _loc14_ = param1 as ExchangeItemAutoCraftStopedMessage;
               _loc15_ = "";
               _loc16_ = true;
               switch(_loc14_.reason)
               {
                  case ExchangeReplayStopReasonEnum.STOPPED_REASON_IMPOSSIBLE_MODIFICATION:
                     _loc15_ = I18n.getUiText("ui.craft.autoCraftStopedInvalidRecipe");
                     break;
                  case ExchangeReplayStopReasonEnum.STOPPED_REASON_MISSING_RESSOURCE:
                     _loc15_ = I18n.getUiText("ui.craft.autoCraftStopedNoRessource");
                     break;
                  case ExchangeReplayStopReasonEnum.STOPPED_REASON_OK:
                     break;
                  case ExchangeReplayStopReasonEnum.STOPPED_REASON_USER:
                     _loc15_ = I18n.getUiText("ui.craft.autoCraftStoped");
                     _loc16_ = false;
               }
               if(_loc16_ && _loc15_ != "")
               {
                  _loc66_ = UiModuleManager.getInstance().getModule("Ankama_Common").mainClass;
                  _loc66_.openPopup(I18n.getUiText("ui.popup.information"),_loc15_,[I18n.getUiText("ui.common.ok")]);
               }
               KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,_loc15_,ChatActivableChannelsEnum.PSEUDO_CHANNEL_INFO,TimeManager.getInstance().getTimestamp());
               KernelEventsManager.getInstance().processCallback(CraftHookList.ExchangeItemAutoCraftStoped,_loc14_.reason);
               return true;
            case param1 is ExchangeStartOkCraftMessage:
               _loc17_ = param1 as ExchangeStartOkCraftMessage;
               PlayedCharacterManager.getInstance().isInExchange = true;
               _loc18_ = _loc17_.getMessageId();
               switch(_loc18_)
               {
                  case ExchangeStartOkCraftMessage.protocolId:
                     KernelEventsManager.getInstance().processCallback(CraftHookList.ExchangeStartOkCraft);
                     break;
                  case ExchangeStartOkCraftWithInformationMessage.protocolId:
                     this.processExchangeStartOkCraftWithInformationMessage(param1 as ExchangeStartOkCraftWithInformationMessage);
               }
               return true;
            case param1 is ExchangeCraftPaymentModificationAction:
               _loc19_ = param1 as ExchangeCraftPaymentModificationAction;
               _loc20_ = new ExchangeCraftPaymentModificationRequestMessage();
               _loc20_.initExchangeCraftPaymentModificationRequestMessage(_loc19_.kamas);
               ConnectionsHandler.getConnection().send(_loc20_);
               return true;
            case param1 is ExchangeCraftPaymentModifiedMessage:
               _loc21_ = param1 as ExchangeCraftPaymentModifiedMessage;
               if(this.commonExchangeFrame)
               {
                  this.commonExchangeFrame.incrementEchangeSequence();
               }
               this.paymentCraftList.kamaPayment = _loc21_.goldSum;
               KernelEventsManager.getInstance().processCallback(CraftHookList.PaymentCraftList,this.paymentCraftList,true);
               return true;
            case param1 is ExchangeObjectModifiedInBagMessage:
               _loc22_ = param1 as ExchangeObjectModifiedInBagMessage;
               _loc23_ = ItemWrapper.create(63,_loc22_.object.objectUID,_loc22_.object.objectGID,_loc22_.object.quantity,_loc22_.object.effects,false);
               KernelEventsManager.getInstance().processCallback(CraftHookList.BagItemModified,_loc23_,_loc22_.remote);
               return true;
            case param1 is ExchangeObjectPutInBagMessage:
               _loc24_ = param1 as ExchangeObjectPutInBagMessage;
               _loc25_ = _loc24_.object;
               _loc26_ = ItemWrapper.create(63,_loc25_.objectUID,_loc25_.objectGID,_loc25_.quantity,_loc25_.effects,false);
               KernelEventsManager.getInstance().processCallback(CraftHookList.BagItemAdded,_loc26_,_loc24_.remote);
               return true;
            case param1 is ExchangeObjectRemovedFromBagMessage:
               _loc27_ = param1 as ExchangeObjectRemovedFromBagMessage;
               KernelEventsManager.getInstance().processCallback(CraftHookList.BagItemDeleted,_loc27_.objectUID,_loc27_.remote);
               return true;
            case param1 is ExchangeObjectUseInWorkshopAction:
               _loc28_ = param1 as ExchangeObjectUseInWorkshopAction;
               _loc29_ = new ExchangeObjectUseInWorkshopMessage();
               _loc29_.initExchangeObjectUseInWorkshopMessage(_loc28_.objectUID,_loc28_.quantity);
               ConnectionsHandler.getConnection().send(_loc29_);
               return true;
            case param1 is ExchangeMultiCraftSetCrafterCanUseHisRessourcesAction:
               _loc30_ = param1 as ExchangeMultiCraftSetCrafterCanUseHisRessourcesAction;
               _loc31_ = new ExchangeMultiCraftSetCrafterCanUseHisRessourcesMessage();
               _loc31_.initExchangeMultiCraftSetCrafterCanUseHisRessourcesMessage(_loc30_.allow);
               ConnectionsHandler.getConnection().send(_loc31_);
               return true;
            case param1 is ExchangeMultiCraftCrafterCanUseHisRessourcesMessage:
               _loc32_ = param1 as ExchangeMultiCraftCrafterCanUseHisRessourcesMessage;
               KernelEventsManager.getInstance().processCallback(CraftHookList.ExchangeMultiCraftCrafterCanUseHisRessources,_loc32_.allowed);
               return true;
            case param1 is ExchangeStartOkMulticraftCrafterMessage:
               _loc33_ = param1 as ExchangeStartOkMulticraftCrafterMessage;
               this._skillId = _loc33_.skillId;
               _loc34_ = Skill.getSkillById(this._skillId);
               if(_loc34_.isForgemagus)
               {
                  this._craftType = 1;
               }
               else
               {
                  this._craftType = 0;
               }
               KernelEventsManager.getInstance().processCallback(CraftHookList.ExchangeStartOkMultiCraft,_loc33_.skillId,this.crafterInfos,this.customerInfos);
               return true;
            case param1 is ExchangeStartOkMulticraftCustomerMessage:
               _loc35_ = param1 as ExchangeStartOkMulticraftCustomerMessage;
               this.crafterInfos.skillLevel = _loc35_.crafterJobLevel;
               this._skillId = _loc35_.skillId;
               _loc36_ = Skill.getSkillById(this._skillId);
               if(_loc36_.isForgemagus)
               {
                  this._craftType = 1;
               }
               else
               {
                  this._craftType = 0;
               }
               KernelEventsManager.getInstance().processCallback(CraftHookList.ExchangeStartOkMultiCraft,_loc35_.skillId,this.crafterInfos,this.customerInfos);
               return true;
            case param1 is ExchangeReplayAction:
               _loc37_ = param1 as ExchangeReplayAction;
               _loc38_ = new ExchangeCraftCountRequestMessage();
               _loc38_.initExchangeCraftCountRequestMessage(_loc37_.count);
               ConnectionsHandler.getConnection().send(_loc38_);
               return true;
            case param1 is ExchangeCraftCountModifiedMessage:
               _loc39_ = param1 as ExchangeCraftCountModifiedMessage;
               KernelEventsManager.getInstance().processCallback(CraftHookList.ExchangeReplayCountModified,_loc39_.count);
               return true;
            case param1 is ExchangeLeaveMessage:
               _loc40_ = param1 as ExchangeLeaveMessage;
               if(_loc40_.dialogType == DialogTypeEnum.DIALOG_EXCHANGE)
               {
                  PlayedCharacterManager.getInstance().isInExchange = false;
                  this._success = _loc40_.success;
                  Kernel.getWorker().removeFrame(this);
               }
               return true;
            default:
               return false;
         }
      }
      
      private function resetLists() : void
      {
         this.paymentCraftList.kamaPayment = 0;
         this.paymentCraftList.kamaPaymentOnlySuccess = 0;
         this.paymentCraftList.objectsPayment = new Array();
         this.paymentCraftList.objectsPaymentOnlySuccess = new Array();
      }
      
      public function addCraftComponent(param1:Boolean, param2:ItemWrapper) : void
      {
         var _loc3_:PlayerExchangeCraftList = null;
         if(param1)
         {
            _loc3_ = this.otherPlayerList;
         }
         else
         {
            _loc3_ = this.playerList;
         }
         _loc3_.componentList.push(param2);
         this.sendUpdateHook(_loc3_);
         if(this._craftType != 0 && param2.typeId != SMITHMAGIC_RUNE_ID && param2.typeId != SMITHMAGIC_POTION_ID && param2.typeId != SMITHMAGIC_ORB_ID && param2.objectGID != SIGNATURE_RUNE_ID)
         {
            this._smithMagicOldObject = param2.clone();
         }
      }
      
      public function modifyCraftComponent(param1:Boolean, param2:ItemWrapper) : void
      {
         var _loc3_:PlayerExchangeCraftList = null;
         if(param1)
         {
            _loc3_ = this.otherPlayerList;
         }
         else
         {
            _loc3_ = this.playerList;
         }
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_.componentList.length)
         {
            if(_loc3_.componentList[_loc4_].objectGID == param2.objectGID && _loc3_.componentList[_loc4_].objectUID == param2.objectUID)
            {
               _loc3_.componentList.splice(_loc4_,1,param2);
            }
            _loc4_++;
         }
         this.sendUpdateHook(_loc3_);
      }
      
      public function removeCraftComponent(param1:Boolean, param2:uint) : void
      {
         var _loc5_:ItemWrapper = null;
         var _loc6_:ItemWrapper = null;
         var _loc3_:uint = 0;
         var _loc4_:PlayerExchangeCraftList = new PlayerExchangeCraftList();
         for each(_loc5_ in this.otherPlayerList.componentList)
         {
            if(_loc5_.objectUID == param2)
            {
               this.otherPlayerList.componentList.splice(_loc3_,1);
               this.sendUpdateHook(this.otherPlayerList);
               break;
            }
            _loc3_++;
         }
         _loc3_ = 0;
         for each(_loc6_ in this.playerList.componentList)
         {
            if(_loc6_.objectUID == param2)
            {
               this.playerList.componentList.splice(_loc3_,1);
               this.sendUpdateHook(this.playerList);
               break;
            }
            _loc3_++;
         }
      }
      
      public function addObjetPayment(param1:Boolean, param2:ItemWrapper) : void
      {
         if(param1)
         {
            this.paymentCraftList.objectsPaymentOnlySuccess.push(param2);
         }
         else
         {
            this.paymentCraftList.objectsPayment.push(param2);
         }
      }
      
      public function removeObjetPayment(param1:uint, param2:Boolean) : void
      {
         var _loc4_:Array = null;
         var _loc5_:ItemWrapper = null;
         var _loc3_:uint = 0;
         if(param2)
         {
            _loc4_ = this.paymentCraftList.objectsPaymentOnlySuccess;
         }
         else
         {
            _loc4_ = this.paymentCraftList.objectsPayment;
         }
         for each(_loc5_ in _loc4_)
         {
            if(_loc5_.objectUID == param1)
            {
               _loc4_.splice(_loc3_,1);
            }
            _loc3_++;
         }
         KernelEventsManager.getInstance().processCallback(CraftHookList.PaymentCraftList,this.paymentCraftList,true);
      }
      
      private function sendUpdateHook(param1:PlayerExchangeCraftList) : void
      {
         switch(param1)
         {
            case this.otherPlayerList:
               KernelEventsManager.getInstance().processCallback(CraftHookList.OtherPlayerListUpdate,param1);
               break;
            case this.playerList:
               KernelEventsManager.getInstance().processCallback(CraftHookList.PlayerListUpdate,param1);
         }
      }
   }
}

class PaymentCraftList
{
    
   
   public var kamaPaymentOnlySuccess:uint;
   
   public var objectsPaymentOnlySuccess:Array;
   
   public var kamaPayment:uint;
   
   public var objectsPayment:Array;
   
   function PaymentCraftList()
   {
      super();
      this.kamaPaymentOnlySuccess = 0;
      this.objectsPaymentOnlySuccess = new Array();
      this.kamaPayment = 0;
      this.objectsPayment = new Array();
   }
}

class PlayerExchangeCraftList
{
    
   
   public var componentList:Array;
   
   public var isCrafter:Boolean;
   
   function PlayerExchangeCraftList()
   {
      super();
      this.componentList = new Array();
      this.isCrafter = false;
   }
}

import com.ankamagames.tiphon.types.look.TiphonEntityLook;

class PlayerInfo
{
    
   
   public var id:Number;
   
   public var name:String;
   
   public var look:TiphonEntityLook;
   
   public var skillLevel:int;
   
   function PlayerInfo()
   {
      super();
   }
}
