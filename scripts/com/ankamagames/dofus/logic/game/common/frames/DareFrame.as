package com.ankamagames.dofus.logic.game.common.frames
{
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.dofus.BuildInfos;
   import com.ankamagames.dofus.internalDatacenter.dare.DareCriteriaWrapper;
   import com.ankamagames.dofus.internalDatacenter.dare.DareWrapper;
   import com.ankamagames.dofus.kernel.net.ConnectionsHandler;
   import com.ankamagames.dofus.logic.common.managers.PlayerManager;
   import com.ankamagames.dofus.logic.game.common.actions.dare.DareCancelRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.dare.DareCreationRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.dare.DareInformationsRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.dare.DareListRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.dare.DareRewardRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.dare.DareSubscribeRequestAction;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.logic.game.common.managers.TimeManager;
   import com.ankamagames.dofus.misc.lists.ChatHookList;
   import com.ankamagames.dofus.misc.lists.SocialHookList;
   import com.ankamagames.dofus.network.enums.BuildTypeEnum;
   import com.ankamagames.dofus.network.enums.ChatActivableChannelsEnum;
   import com.ankamagames.dofus.network.enums.DareCriteriaTypeEnum;
   import com.ankamagames.dofus.network.enums.DareErrorEnum;
   import com.ankamagames.dofus.network.messages.game.dare.DareCancelRequestMessage;
   import com.ankamagames.dofus.network.messages.game.dare.DareCanceledMessage;
   import com.ankamagames.dofus.network.messages.game.dare.DareCreatedListMessage;
   import com.ankamagames.dofus.network.messages.game.dare.DareCreatedMessage;
   import com.ankamagames.dofus.network.messages.game.dare.DareCreationRequestMessage;
   import com.ankamagames.dofus.network.messages.game.dare.DareErrorMessage;
   import com.ankamagames.dofus.network.messages.game.dare.DareInformationsMessage;
   import com.ankamagames.dofus.network.messages.game.dare.DareInformationsRequestMessage;
   import com.ankamagames.dofus.network.messages.game.dare.DareListMessage;
   import com.ankamagames.dofus.network.messages.game.dare.DareRewardConsumeRequestMessage;
   import com.ankamagames.dofus.network.messages.game.dare.DareRewardConsumeValidationMessage;
   import com.ankamagames.dofus.network.messages.game.dare.DareRewardWonMessage;
   import com.ankamagames.dofus.network.messages.game.dare.DareRewardsListMessage;
   import com.ankamagames.dofus.network.messages.game.dare.DareSubscribeRequestMessage;
   import com.ankamagames.dofus.network.messages.game.dare.DareSubscribedListMessage;
   import com.ankamagames.dofus.network.messages.game.dare.DareSubscribedMessage;
   import com.ankamagames.dofus.network.messages.game.dare.DareVersatileListMessage;
   import com.ankamagames.dofus.network.messages.game.dare.DareWonListMessage;
   import com.ankamagames.dofus.network.messages.game.dare.DareWonMessage;
   import com.ankamagames.dofus.network.types.game.dare.DareCriteria;
   import com.ankamagames.dofus.network.types.game.dare.DareInformations;
   import com.ankamagames.dofus.network.types.game.dare.DareReward;
   import com.ankamagames.dofus.network.types.game.dare.DareVersatileInformations;
   import com.ankamagames.dofus.types.enums.DareSubscribeErrorEnum;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.data.XmlConfig;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.managers.StoreDataManager;
   import com.ankamagames.jerakine.messages.RegisteringFrame;
   import com.ankamagames.jerakine.resources.adapters.impl.SignedFileAdapter;
   import com.ankamagames.jerakine.types.DataStoreType;
   import com.ankamagames.jerakine.types.Uri;
   import com.ankamagames.jerakine.types.enums.DataStoreEnum;
   import com.ankamagames.jerakine.types.enums.Priority;
   import com.ankamagames.jerakine.utils.crypto.Base64;
   import com.ankamagames.jerakine.utils.crypto.Signature;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   import flash.utils.getTimer;
   
   public class DareFrame extends RegisteringFrame
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(DareFrame));
      
      private static const LOCAL_URL:String = "http://gameservers-www-exports.dofus2.lan/";
      
      private static const ONLINE_URL:String = "http://dl.ak.ankama.com/games/dofus2/game-export/";
      
      private static var _instance:DareFrame;
      
      private static var _datastoreType:DataStoreType = new DataStoreType("Module_Ankama_Social",true,DataStoreEnum.LOCATION_LOCAL,DataStoreEnum.BIND_CHARACTER);
       
      
      private var _urlDareList:Uri;
      
      private var _urlDareVersatileList:Uri;
      
      private var _dareList:Vector.<DareWrapper>;
      
      private var _dareListById:Dictionary;
      
      private var _dareIdsBySubAreaId:Dictionary;
      
      private var _monsterIdsBySubAreaId:Dictionary;
      
      private var _monsterTotalDaresBySubAreaId:Dictionary;
      
      private var _dareRewardsWon:Vector.<DareReward>;
      
      private var _totalGuildDares:int = 0;
      
      private var _totalAllianceDares:int = 0;
      
      private var _waitStaticDareInfo:Boolean;
      
      private var _waitVersatileDareInfo:Boolean;
      
      public var versatileDataLifetime:uint = 300000.0;
      
      public var staticDataLifetime:uint = 900000.0;
      
      public function DareFrame()
      {
         var output:ByteArray = null;
         var signedData:ByteArray = null;
         var signature:Signature = null;
         var signatureIsValid:Boolean = false;
         super();
         _instance = this;
         DareWrapper.clearCache();
         this._dareList = new Vector.<DareWrapper>();
         this._dareListById = new Dictionary(true);
         this._dareIdsBySubAreaId = new Dictionary(true);
         this._monsterIdsBySubAreaId = new Dictionary(true);
         this._monsterTotalDaresBySubAreaId = new Dictionary(true);
         this._dareRewardsWon = new Vector.<DareReward>();
         var serverId:int = PlayerManager.getInstance().server.id;
         var base_url:String = BuildInfos.BUILD_TYPE >= BuildTypeEnum.TESTING?LOCAL_URL:ONLINE_URL;
         var configGameExport:String = XmlConfig.getInstance().getEntry("config.gameExport");
         if(configGameExport)
         {
            if(BuildInfos.BUILD_TYPE <= BuildTypeEnum.TESTING)
            {
               if(XmlConfig.getInstance().getEntry("config.gameExport.signature"))
               {
                  output = new ByteArray();
                  try
                  {
                     signedData = Base64.decodeToByteArray(XmlConfig.getInstance().getEntry("config.gameExport.signature"));
                     signedData.position = signedData.length;
                     signedData.writeUTFBytes(configGameExport);
                     signedData.position = 0;
                     signature = new Signature(SignedFileAdapter.defaultSignatureKey);
                     signatureIsValid = signature.verify(signedData,output);
                  }
                  catch(error:Error)
                  {
                     _log.error("gameExport signature has not been properly encoded in Base64.");
                  }
                  if(signatureIsValid)
                  {
                     base_url = configGameExport;
                  }
               }
               else
               {
                  _log.error("gameExport needs to be signed!");
               }
            }
            else
            {
               base_url = configGameExport;
            }
         }
         this._urlDareList = new Uri(base_url + "DareListMessage." + serverId + ".data");
         this._urlDareVersatileList = new Uri(base_url + "DareVersatileListMessage." + serverId + ".data");
         ConnectionsHandler.getHttpConnection().addToWhiteList(DareVersatileListMessage);
         ConnectionsHandler.getHttpConnection().addToWhiteList(DareListMessage);
         ConnectionsHandler.getHttpConnection().resetTime(this._urlDareList);
         ConnectionsHandler.getHttpConnection().resetTime(this._urlDareVersatileList);
         this.onDareListRequest(null);
      }
      
      public static function getInstance() : DareFrame
      {
         return _instance;
      }
      
      override public function get priority() : int
      {
         return Priority.NORMAL;
      }
      
      public function get dareList() : Vector.<DareWrapper>
      {
         return this._dareList;
      }
      
      public function getDareById(param1:Number) : DareWrapper
      {
         return this._dareListById[param1];
      }
      
      public function getTotalDaresInSubArea(param1:uint) : uint
      {
         if(this._dareIdsBySubAreaId[param1])
         {
            return this._dareIdsBySubAreaId[param1].length;
         }
         return 0;
      }
      
      public function getTotalGuildDares() : uint
      {
         return this._totalGuildDares;
      }
      
      public function getTotalAllianceDares() : uint
      {
         return this._totalAllianceDares;
      }
      
      public function getTargetedMonsterIdsInSubArea(param1:uint) : Vector.<int>
      {
         if(this._monsterIdsBySubAreaId[param1])
         {
            return this._monsterIdsBySubAreaId[param1];
         }
         return null;
      }
      
      public function get dareRewardsWon() : Vector.<DareReward>
      {
         return this._dareRewardsWon;
      }
      
      override protected function registerMessages() : void
      {
         register(DareListRequestAction,this.onDareListRequest);
         register(DareListMessage,this.onDareListMessage);
         register(DareVersatileListMessage,this.onDareVersatileListMessage);
         register(DareSubscribedListMessage,this.onDareSubscribedListMessage);
         register(DareCreatedListMessage,this.onDareCreatedListMessage);
         register(DareWonListMessage,this.onDareWonListMessage);
         register(DareWonMessage,this.onDareWonMessage);
         register(DareInformationsRequestAction,this.onDareInformationsRequest);
         register(DareInformationsMessage,this.onDareInformationsMessage);
         register(DareErrorMessage,this.onDareErrorMessage);
         register(DareSubscribeRequestAction,this.onDareSubscribeRequest);
         register(DareSubscribedMessage,this.onDareSubscribedMessage);
         register(DareCreationRequestAction,this.onDareCreationRequest);
         register(DareCreatedMessage,this.onDareCreatedMessage);
         register(DareCancelRequestAction,this.onDareCancelRequest);
         register(DareCanceledMessage,this.onDareCanceledMessage);
         register(DareRewardRequestAction,this.onDareRewardRequestAction);
         register(DareRewardsListMessage,this.onRewardListMessage);
         register(DareRewardWonMessage,this.onRewardWonMessage);
         register(DareRewardConsumeValidationMessage,this.onDareRewardConsumeValidationMessage);
      }
      
      private function onDareListRequest(param1:DareListRequestAction) : Boolean
      {
         var _loc2_:Boolean = ConnectionsHandler.getHttpConnection().request(this._urlDareList,this.onDareIoError,this.staticDataLifetime);
         if(_loc2_)
         {
            this._waitStaticDareInfo = true;
         }
         var _loc3_:Boolean = ConnectionsHandler.getHttpConnection().request(this._urlDareVersatileList,this.onDareVersatileIoError,this.versatileDataLifetime);
         if(_loc3_)
         {
            this._waitVersatileDareInfo = true;
         }
         if(!this._waitVersatileDareInfo && !this._waitStaticDareInfo)
         {
            this.dispatchDareList();
         }
         return true;
      }
      
      private function onDareListMessage(param1:DareListMessage) : Boolean
      {
         var _loc4_:DareWrapper = null;
         var _loc5_:Number = NaN;
         var _loc6_:Array = null;
         var _loc7_:Array = null;
         var _loc8_:String = null;
         var _loc9_:uint = 0;
         var _loc10_:Vector.<DareInformations> = null;
         var _loc11_:uint = 0;
         var _loc12_:DareWrapper = null;
         var _loc13_:Number = NaN;
         var _loc14_:DareWrapper = null;
         var _loc2_:uint = getTimer();
         var _loc3_:Dictionary = new Dictionary(true);
         for each(_loc4_ in this._dareList)
         {
            if(_loc4_.subscribed || _loc4_.isMyCreation)
            {
               _loc3_[_loc4_.dareId] = _loc4_;
            }
         }
         this._dareList = new Vector.<DareWrapper>();
         this._dareListById = new Dictionary(true);
         this._dareIdsBySubAreaId = new Dictionary(true);
         this._monsterIdsBySubAreaId = new Dictionary(true);
         this._monsterTotalDaresBySubAreaId = new Dictionary(true);
         this._totalGuildDares = 0;
         this._totalAllianceDares = 0;
         _loc5_ = new Date().time;
         _loc6_ = StoreDataManager.getInstance().getData(_datastoreType,"HiddenDaresIds");
         _loc7_ = new Array();
         for each(_loc8_ in _loc6_)
         {
            _loc13_ = Number(_loc8_.split("_")[1]);
            if(_loc13_ >= _loc5_)
            {
               _loc7_.push(_loc8_);
            }
         }
         StoreDataManager.getInstance().setData(_datastoreType,"HiddenDaresIds",_loc7_);
         _loc9_ = param1.dares.length;
         _loc10_ = param1.dares;
         _loc11_ = 0;
         while(_loc11_ < _loc9_)
         {
            this._dareList[_loc11_] = DareWrapper.getFromNetwork(_loc10_[_loc11_]);
            _loc14_ = _loc3_[this._dareList[_loc11_].dareId];
            if(_loc14_)
            {
               this._dareList[_loc11_].subscribed = _loc14_.subscribed;
               _loc3_[this._dareList[_loc11_].dareId] = null;
            }
            this.updateDictionnariesWithDareInfo(this._dareList[_loc11_],_loc5_);
            _loc11_++;
         }
         for each(_loc12_ in _loc3_)
         {
            if(_loc12_)
            {
               this._dareList.push(_loc12_);
               this.updateDictionnariesWithDareInfo(_loc12_,_loc5_);
            }
         }
         this._waitStaticDareInfo = false;
         _log.warn("Liste des " + _loc9_ + " défis traitée en " + (getTimer() - _loc2_) + " ms");
         this.dispatchDareList(true);
         return true;
      }
      
      private function onDareVersatileListMessage(param1:DareVersatileListMessage) : Boolean
      {
         var _loc5_:DareWrapper = null;
         var _loc6_:int = 0;
         var _loc9_:DareWrapper = null;
         var _loc2_:uint = getTimer();
         var _loc3_:uint = param1.dares.length;
         var _loc4_:Vector.<DareVersatileInformations> = param1.dares;
         var _loc7_:Number = new Date().time;
         var _loc8_:uint = 0;
         while(_loc8_ < _loc3_)
         {
            _loc6_ = -1;
            for each(_loc5_ in this._dareList)
            {
               if(_loc5_.dareId == _loc4_[_loc8_].dareId)
               {
                  _loc6_ = this._dareList.indexOf(_loc5_);
                  break;
               }
            }
            if(_loc6_ != -1)
            {
               this._dareList[_loc6_] = DareWrapper.getFromNetwork(_loc4_[_loc8_]);
               this._dareListById[this._dareList[_loc6_].dareId] = this._dareList[_loc6_];
            }
            else
            {
               _loc9_ = DareWrapper.getFromNetwork(_loc4_[_loc8_]);
               this._dareList.push(_loc9_);
               this.updateDictionnariesWithDareInfo(_loc9_,_loc7_);
            }
            _loc8_++;
         }
         this._waitVersatileDareInfo = false;
         _log.warn("Liste des infos versatiles de " + _loc3_ + " défis traitée en " + (getTimer() - _loc2_) + " ms");
         this.dispatchDareList(true);
         return true;
      }
      
      private function onDareSubscribedListMessage(param1:DareSubscribedListMessage) : Boolean
      {
         var _loc6_:DareWrapper = null;
         var _loc7_:int = 0;
         var _loc2_:uint = getTimer();
         var _loc3_:uint = param1.daresFixedInfos.length;
         var _loc4_:Vector.<DareInformations> = param1.daresFixedInfos;
         var _loc5_:Vector.<DareVersatileInformations> = param1.daresVersatilesInfos;
         var _loc8_:Number = new Date().time;
         var _loc9_:uint = 0;
         while(_loc9_ < _loc3_)
         {
            _loc7_ = -1;
            for each(_loc6_ in this._dareList)
            {
               if(_loc6_.dareId == _loc4_[_loc9_].dareId)
               {
                  _loc7_ = this._dareList.indexOf(_loc6_);
                  break;
               }
            }
            if(_loc7_ != -1)
            {
               this._dareList[_loc7_] = DareWrapper.getFromNetwork(_loc4_[_loc9_]);
               this._dareList[_loc7_] = DareWrapper.getFromNetwork(_loc5_[_loc9_]);
               this._dareList[_loc7_].subscribed = true;
               this._dareListById[this._dareList[_loc7_].dareId] = this._dareList[_loc7_];
            }
            else
            {
               _loc6_ = DareWrapper.getFromNetwork(_loc4_[_loc9_]);
               _loc6_ = DareWrapper.getFromNetwork(_loc5_[_loc9_]);
               _loc6_.subscribed = true;
               this._dareList.push(_loc6_);
               this.updateDictionnariesWithDareInfo(_loc6_,_loc8_);
            }
            _loc9_++;
         }
         _log.warn("Liste des " + _loc3_ + " défis auxquels on est inscrit traitée en " + (getTimer() - _loc2_) + " ms");
         this.dispatchDareList(true);
         return true;
      }
      
      private function onDareCreatedListMessage(param1:DareCreatedListMessage) : Boolean
      {
         var _loc6_:DareWrapper = null;
         var _loc7_:int = 0;
         var _loc2_:uint = getTimer();
         var _loc3_:uint = param1.daresFixedInfos.length;
         var _loc4_:Vector.<DareInformations> = param1.daresFixedInfos;
         var _loc5_:Vector.<DareVersatileInformations> = param1.daresVersatilesInfos;
         var _loc8_:Number = new Date().time;
         var _loc9_:uint = 0;
         while(_loc9_ < _loc3_)
         {
            _loc7_ = -1;
            for each(_loc6_ in this._dareList)
            {
               if(_loc6_.dareId == _loc4_[_loc9_].dareId)
               {
                  _loc7_ = this._dareList.indexOf(_loc6_);
                  break;
               }
            }
            if(_loc7_ != -1)
            {
               this._dareList[_loc7_] = DareWrapper.getFromNetwork(_loc4_[_loc9_]);
               this._dareList[_loc7_] = DareWrapper.getFromNetwork(_loc5_[_loc9_]);
               this._dareListById[this._dareList[_loc7_].dareId] = this._dareList[_loc7_];
            }
            else
            {
               _loc6_ = DareWrapper.getFromNetwork(_loc4_[_loc9_]);
               _loc6_ = DareWrapper.getFromNetwork(_loc5_[_loc9_]);
               this._dareList.push(_loc6_);
               this.updateDictionnariesWithDareInfo(_loc6_,_loc8_);
            }
            _loc9_++;
         }
         _log.warn("Liste des " + _loc3_ + " défis créés pas nous traitée en " + (getTimer() - _loc2_) + " ms");
         this.dispatchDareList(true);
         return true;
      }
      
      private function onDareWonListMessage(param1:DareWonListMessage) : Boolean
      {
         var _loc5_:DareWrapper = null;
         var _loc6_:int = 0;
         var _loc2_:uint = getTimer();
         var _loc3_:Vector.<Number> = param1.dareId;
         var _loc4_:uint = param1.dareId.length;
         var _loc7_:uint = 0;
         while(_loc7_ < _loc4_)
         {
            _loc5_ = this._dareListById[_loc3_[_loc7_]];
            if(_loc5_)
            {
               _loc5_.won = true;
            }
            else
            {
               _log.error("Failed to update \'hasBeenWon\' property for dareId " + _loc3_[_loc7_] + ", DareWrapper instance doesn\'t exist!");
            }
            _loc7_++;
         }
         _log.warn("Liste des " + _loc4_ + " défis gagnés traitée en " + (getTimer() - _loc2_) + " ms");
         return true;
      }
      
      private function onDareWonMessage(param1:DareWonMessage) : Boolean
      {
         var _loc2_:DareWrapper = this._dareListById[param1.dareId];
         if(_loc2_)
         {
            _loc2_.won = true;
            KernelEventsManager.getInstance().processCallback(SocialHookList.DareWon,_loc2_.dareId);
            KernelEventsManager.getInstance().processCallback(SocialHookList.DareUpdated,_loc2_.dareId);
         }
         else
         {
            _log.error("Failed to update \'won\' property for dareId " + param1.dareId + ", DareWrapper instance doesn\'t exist!");
         }
         return true;
      }
      
      private function onDareInformationsRequest(param1:DareInformationsRequestAction) : Boolean
      {
         var _loc2_:DareInformationsRequestMessage = new DareInformationsRequestMessage();
         _loc2_.initDareInformationsRequestMessage(param1.dareId);
         ConnectionsHandler.getConnection().send(_loc2_);
         return true;
      }
      
      private function onDareInformationsMessage(param1:DareInformationsMessage) : Boolean
      {
         var _loc2_:DareWrapper = null;
         var _loc3_:int = -1;
         for each(_loc2_ in this._dareList)
         {
            if(_loc2_.dareId == param1.dareFixedInfos.dareId)
            {
               _loc3_ = this._dareList.indexOf(_loc2_);
               break;
            }
         }
         if(_loc3_ != -1)
         {
            this._dareList[_loc3_] = DareWrapper.getFromNetwork(param1.dareFixedInfos);
            this._dareList[_loc3_] = DareWrapper.getFromNetwork(param1.dareVersatilesInfos);
            this._dareListById[this._dareList[_loc3_].dareId] = this._dareList[_loc3_];
         }
         else
         {
            _loc2_ = DareWrapper.getFromNetwork(param1.dareFixedInfos);
            _loc2_ = DareWrapper.getFromNetwork(param1.dareVersatilesInfos);
            this._dareList.push(_loc2_);
            this.updateDictionnariesWithDareInfo(_loc2_);
         }
         var _loc4_:Date = new Date();
         var _loc5_:PlayedCharacterManager = PlayedCharacterManager.getInstance();
         var _loc6_:Object = {
            "playerId":_loc5_.id,
            "playerBreed":_loc5_.infos.breed,
            "playerLevel":_loc5_.limitedLevel,
            "playerKamas":_loc5_.characteristics.kamas,
            "playerGuildId":(!!SocialFrame.getInstance().hasGuild?SocialFrame.getInstance().guild.guildId:0),
            "playerAllianceId":(!!AllianceFrame.getInstance().hasAlliance?AllianceFrame.getInstance().alliance.allianceId:0),
            "currentTime":_loc4_.time
         };
         this.setDareSubscribable(_loc2_,_loc6_);
         KernelEventsManager.getInstance().processCallback(SocialHookList.DareUpdated,param1.dareFixedInfos.dareId);
         return true;
      }
      
      private function onDareSubscribeRequest(param1:DareSubscribeRequestAction) : Boolean
      {
         var _loc2_:DareSubscribeRequestMessage = new DareSubscribeRequestMessage();
         _loc2_.initDareSubscribeRequestMessage(param1.dareId,param1.subscribe);
         ConnectionsHandler.getConnection().send(_loc2_);
         return true;
      }
      
      private function onDareSubscribedMessage(param1:DareSubscribedMessage) : Boolean
      {
         var _loc2_:DareWrapper = null;
         var _loc4_:* = null;
         var _loc5_:* = null;
         var _loc6_:String = null;
         var _loc7_:Date = null;
         var _loc8_:PlayedCharacterManager = null;
         var _loc9_:Object = null;
         var _loc3_:int = -1;
         for each(_loc2_ in this._dareList)
         {
            if(_loc2_.dareId == param1.dareVersatilesInfos.dareId)
            {
               _loc3_ = this._dareList.indexOf(_loc2_);
               break;
            }
         }
         if(_loc3_ != -1)
         {
            this._dareList[_loc3_] = DareWrapper.getFromNetwork(param1.dareVersatilesInfos);
            if(param1.success)
            {
               this._dareList[_loc3_].subscribed = param1.subscribe;
            }
            this._dareListById[this._dareList[_loc3_].dareId] = this._dareList[_loc3_];
         }
         else
         {
            _loc2_ = DareWrapper.getFromNetwork(param1.dareVersatilesInfos);
            if(param1.success)
            {
               _loc2_.subscribed = param1.subscribe;
            }
            this._dareList.push(_loc2_);
            this.updateDictionnariesWithDareInfo(_loc2_);
         }
         if(param1.success)
         {
            _loc2_ = this.getDareById(param1.dareId);
            if(!_loc2_)
            {
               _log.error("Le défi " + param1.dareId + " accepté ne semble pas exister !");
               return true;
            }
            if(!param1.subscribe)
            {
               _loc7_ = new Date();
               _loc8_ = PlayedCharacterManager.getInstance();
               _loc9_ = {
                  "playerId":_loc8_.id,
                  "playerBreed":_loc8_.infos.breed,
                  "playerLevel":_loc8_.limitedLevel,
                  "playerKamas":_loc8_.characteristics.kamas,
                  "playerGuildId":(!!SocialFrame.getInstance().hasGuild?SocialFrame.getInstance().guild.guildId:0),
                  "playerAllianceId":(!!AllianceFrame.getInstance().hasAlliance?AllianceFrame.getInstance().alliance.allianceId:0),
                  "currentTime":_loc7_.time
               };
               this.setDareSubscribable(_loc2_,_loc9_);
            }
            _loc4_ = "{chatmonster," + _loc2_.monster.id + "}";
            _loc5_ = "{chatdare," + _loc2_.dareId + "}";
            if(param1.subscribe)
            {
               _loc6_ = I18n.getUiText("ui.dare.chat.subscribed",[_loc5_,_loc4_]);
            }
            else
            {
               _loc6_ = I18n.getUiText("ui.dare.chat.unsubscribed",[_loc5_,_loc4_]);
            }
            KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,_loc6_,ChatActivableChannelsEnum.PSEUDO_CHANNEL_INFO,TimeManager.getInstance().getTimestamp());
         }
         KernelEventsManager.getInstance().processCallback(SocialHookList.DareUpdated,param1.dareId);
         return true;
      }
      
      private function onDareCreationRequest(param1:DareCreationRequestAction) : Boolean
      {
         var _loc4_:int = 0;
         var _loc7_:DareCriteria = null;
         var _loc2_:Vector.<DareCriteria> = new Vector.<DareCriteria>();
         var _loc3_:int = param1.criteria.length;
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_)
         {
            _loc7_ = new DareCriteria();
            _loc4_ = param1.criteria[_loc5_].shift();
            if(param1.criteria[_loc5_] && param1.criteria[_loc5_].length && param1.criteria[_loc5_][0])
            {
               _loc7_.initDareCriteria(_loc4_,param1.criteria[_loc5_]);
               _loc2_.push(_loc7_);
            }
            _loc5_++;
         }
         var _loc6_:DareCreationRequestMessage = new DareCreationRequestMessage();
         _loc6_.initDareCreationRequestMessage(param1.subscriptionFee,param1.jackpot,param1.maxCountWinners,param1.delayBeforeStart,param1.duration,param1.isPrivate,param1.isForGuild,param1.isForAlliance,param1.needNotifications,_loc2_);
         ConnectionsHandler.getConnection().send(_loc6_);
         return true;
      }
      
      private function onDareCreatedMessage(param1:DareCreatedMessage) : Boolean
      {
         var _loc3_:* = null;
         var _loc4_:DareCriteria = null;
         var _loc5_:* = null;
         var _loc6_:String = null;
         var _loc2_:DareWrapper = DareWrapper.getFromNetwork(param1.dareInfos);
         this._dareList.push(_loc2_);
         this.updateDictionnariesWithDareInfo(_loc2_);
         _log.debug(" - Enregistrement d\'un nouveau défi créé " + _loc2_);
         KernelEventsManager.getInstance().processCallback(SocialHookList.DareCreated,true,param1.dareInfos.dareId);
         for each(_loc4_ in param1.dareInfos.criterions)
         {
            if(_loc4_.type == DareCriteriaTypeEnum.MONSTER_ID)
            {
               _loc3_ = "{chatmonster," + _loc4_.params[0] + "}";
               break;
            }
         }
         _loc5_ = "{chatdare," + _loc2_.dareId + "}";
         _loc6_ = I18n.getUiText("ui.dare.chat.created",[_loc5_,_loc3_]);
         KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,_loc6_,ChatActivableChannelsEnum.PSEUDO_CHANNEL_INFO,TimeManager.getInstance().getTimestamp());
         return true;
      }
      
      private function onDareCancelRequest(param1:DareCancelRequestAction) : Boolean
      {
         var _loc2_:DareCancelRequestMessage = new DareCancelRequestMessage();
         _loc2_.initDareCancelRequestMessage(param1.dareId);
         ConnectionsHandler.getConnection().send(_loc2_);
         return true;
      }
      
      private function onDareCanceledMessage(param1:DareCanceledMessage) : Boolean
      {
         var _loc6_:Vector.<int> = null;
         var _loc7_:Vector.<Number> = null;
         var _loc8_:String = null;
         var _loc9_:uint = 0;
         var _loc2_:DareWrapper = this._dareListById[param1.dareId];
         var _loc3_:int = this._dareList.indexOf(_loc2_);
         _log.debug("Suppression du défi " + param1.dareId + " à l\'index " + _loc3_);
         var _loc4_:* = "{chatmonster," + _loc2_.monster.id + "}";
         this._dareListById[_loc2_.dareId] = null;
         this._dareList.splice(_loc3_,1);
         var _loc5_:Vector.<uint> = _loc2_.monster.subareas;
         for each(_loc9_ in _loc5_)
         {
            _loc7_ = this._dareIdsBySubAreaId[_loc9_];
            _loc3_ = _loc7_.indexOf(_loc2_.dareId);
            if(_loc3_ != -1)
            {
               _loc7_.splice(_loc3_,1);
            }
            _loc8_ = _loc9_ + "_" + _loc2_.monster.id;
            if(this._monsterTotalDaresBySubAreaId[_loc8_])
            {
               this._monsterTotalDaresBySubAreaId[_loc8_]--;
               if(this._monsterTotalDaresBySubAreaId[_loc8_] == 0)
               {
                  _loc6_ = this._monsterIdsBySubAreaId[_loc9_];
                  _loc3_ = _loc6_.indexOf(_loc2_.monster.id);
                  if(_loc3_ != -1)
                  {
                     _loc6_.splice(_loc3_,1);
                  }
               }
            }
         }
         if(SocialFrame.getInstance().hasGuild)
         {
            if(_loc2_.guildId && _loc2_.guildId == SocialFrame.getInstance().guild.guildId)
            {
               this._totalGuildDares--;
            }
         }
         else
         {
            this._totalGuildDares = 0;
         }
         if(AllianceFrame.getInstance().hasAlliance)
         {
            if(_loc2_.allianceId && _loc2_.allianceId == AllianceFrame.getInstance().alliance.allianceId)
            {
               this._totalAllianceDares--;
            }
         }
         else
         {
            this._totalAllianceDares = 0;
         }
         this.dispatchDareList(true);
         _loc2_ = null;
         KernelEventsManager.getInstance().processCallback(SocialHookList.DareUpdated,param1.dareId);
         var _loc10_:String = I18n.getUiText("ui.dare.chat.cancelled",[param1.dareId,_loc4_]);
         KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,_loc10_,ChatActivableChannelsEnum.PSEUDO_CHANNEL_INFO,TimeManager.getInstance().getTimestamp());
         return true;
      }
      
      private function onDareErrorMessage(param1:DareErrorMessage) : Boolean
      {
         if(param1.error == DareErrorEnum.DARE_CREATION_FAILED)
         {
            KernelEventsManager.getInstance().processCallback(SocialHookList.DareCreated,false);
         }
         return true;
      }
      
      private function onRewardListMessage(param1:DareRewardsListMessage) : Boolean
      {
         this._dareRewardsWon = this._dareRewardsWon.concat(param1.rewards);
         if(this._dareRewardsWon.length > 0)
         {
            KernelEventsManager.getInstance().processCallback(SocialHookList.DareRewardVisible,true);
         }
         return true;
      }
      
      private function onRewardWonMessage(param1:DareRewardWonMessage) : Boolean
      {
         this._dareRewardsWon.push(param1.reward);
         if(this._dareRewardsWon.length > 0)
         {
            KernelEventsManager.getInstance().processCallback(SocialHookList.DareRewardVisible,true);
         }
         return true;
      }
      
      private function onDareRewardRequestAction(param1:DareRewardRequestAction) : Boolean
      {
         var _loc2_:DareRewardRequestAction = param1 as DareRewardRequestAction;
         var _loc3_:DareRewardConsumeRequestMessage = new DareRewardConsumeRequestMessage();
         _loc3_.initDareRewardConsumeRequestMessage(_loc2_.dareId,_loc2_.dareRewardType);
         ConnectionsHandler.getConnection().send(_loc3_);
         return true;
      }
      
      private function onDareRewardConsumeValidationMessage(param1:DareRewardConsumeValidationMessage) : Boolean
      {
         var _loc3_:int = 0;
         var _loc5_:DareReward = null;
         var _loc2_:DareRewardConsumeValidationMessage = param1 as DareRewardConsumeValidationMessage;
         var _loc4_:Boolean = false;
         for each(_loc5_ in this._dareRewardsWon)
         {
            if(_loc5_.dareId == _loc2_.dareId && _loc5_.type == _loc2_.type)
            {
               _loc3_ = this._dareRewardsWon.indexOf(_loc5_);
               _loc4_ = true;
               break;
            }
         }
         if(_loc4_)
         {
            this._dareRewardsWon.splice(_loc3_,1);
         }
         if(this._dareRewardsWon.length <= 0)
         {
            KernelEventsManager.getInstance().processCallback(SocialHookList.DareRewardVisible,false);
         }
         KernelEventsManager.getInstance().processCallback(SocialHookList.DareRewardSuccess);
         return true;
      }
      
      private function dispatchDareList(param1:Boolean = false, param2:Boolean = false) : void
      {
         var _loc3_:DareWrapper = null;
         if(this._waitStaticDareInfo || this._waitVersatileDareInfo)
         {
            return;
         }
         for each(_loc3_ in this._dareList)
         {
            DareWrapper.updateRef(_loc3_.dareId,_loc3_);
         }
         KernelEventsManager.getInstance().processCallback(SocialHookList.DareListUpdated);
      }
      
      private function updateDictionnariesWithDareInfo(param1:DareWrapper, param2:Number = 0) : void
      {
         var _loc5_:uint = 0;
         var _loc6_:String = null;
         var _loc7_:int = 0;
         this._dareListById[param1.dareId] = param1;
         if(!param1.monster)
         {
            return;
         }
         if(!param2)
         {
            param2 = new Date().time;
         }
         if(SocialFrame.getInstance().hasGuild)
         {
            if(param1.guildId && param1.guildId == SocialFrame.getInstance().guild.guildId)
            {
               this._totalGuildDares++;
            }
         }
         else
         {
            this._totalGuildDares = 0;
         }
         if(AllianceFrame.getInstance().hasAlliance)
         {
            if(param1.allianceId && param1.allianceId == AllianceFrame.getInstance().alliance.allianceId)
            {
               this._totalAllianceDares++;
            }
         }
         else
         {
            this._totalAllianceDares = 0;
         }
         var _loc3_:int = param1.monster.id;
         var _loc4_:Vector.<uint> = param1.monster.subareas;
         var _loc8_:int = 0;
         while(_loc8_ < _loc4_.length)
         {
            _loc5_ = _loc4_[_loc8_];
            _loc6_ = _loc5_ + "_" + _loc3_;
            if(param1.isOngoing(param2))
            {
               if(!this._dareIdsBySubAreaId[_loc5_])
               {
                  this._dareIdsBySubAreaId[_loc5_] = new Vector.<Number>();
               }
               if(this._dareIdsBySubAreaId[_loc5_].indexOf(param1.dareId) == -1)
               {
                  this._dareIdsBySubAreaId[_loc5_].push(param1.dareId);
               }
               if(!this._monsterIdsBySubAreaId[_loc5_])
               {
                  this._monsterIdsBySubAreaId[_loc5_] = new Vector.<int>();
               }
               if(this._monsterIdsBySubAreaId[_loc5_].indexOf(_loc3_) == -1)
               {
                  this._monsterIdsBySubAreaId[_loc5_].push(_loc3_);
               }
               if(!this._monsterTotalDaresBySubAreaId[_loc6_])
               {
                  this._monsterTotalDaresBySubAreaId[_loc6_] = 1;
               }
               else
               {
                  this._monsterTotalDaresBySubAreaId[_loc6_]++;
               }
            }
            else
            {
               if(this._dareIdsBySubAreaId[_loc5_])
               {
                  _loc7_ = this._dareIdsBySubAreaId[_loc5_].indexOf(param1.dareId);
                  if(_loc7_ != -1)
                  {
                     (this._dareIdsBySubAreaId[_loc5_] as Vector.<Number>).splice(_loc7_,1);
                  }
               }
               if(this._monsterIdsBySubAreaId[_loc5_])
               {
                  _loc7_ = this._monsterIdsBySubAreaId[_loc5_].indexOf(_loc3_);
                  if(_loc7_ != -1)
                  {
                     (this._monsterIdsBySubAreaId[_loc5_] as Vector.<int>).splice(_loc7_,1);
                  }
               }
               if(this._monsterTotalDaresBySubAreaId[_loc6_])
               {
                  this._monsterTotalDaresBySubAreaId[_loc6_]--;
               }
            }
            _loc8_++;
         }
      }
      
      public function setDareSubscribable(param1:DareWrapper, param2:Object) : void
      {
         var _loc5_:DareCriteriaWrapper = null;
         var _loc3_:Boolean = true;
         var _loc4_:Array = new Array();
         if(param1.subscribed)
         {
            _loc3_ = false;
         }
         if(param1.endDate < param2.currentTime)
         {
            _loc3_ = false;
            _loc4_.push(DareSubscribeErrorEnum.TIME_OVER);
         }
         if(param1.maxCountWinners && param1.countWinners >= param1.maxCountWinners)
         {
            _loc3_ = false;
            _loc4_.push(DareSubscribeErrorEnum.NO_MORE_WINNERS);
         }
         if(param2.playerKamas < param1.subscriptionFee)
         {
            _loc3_ = false;
            _loc4_.push(DareSubscribeErrorEnum.NOT_ENOUGH_MONEY);
         }
         if(param1.guildId > 0 && param1.guildId != param2.playerGuildId)
         {
            _loc3_ = false;
            _loc4_.push(DareSubscribeErrorEnum.GUILD_LIMITED);
         }
         if(param1.allianceId > 0 && param1.allianceId != param2.playerAllianceId)
         {
            _loc3_ = false;
            _loc4_.push(DareSubscribeErrorEnum.ALLIANCE_LIMITED);
         }
         if(param1.creatorId == param2.playerId)
         {
            _loc3_ = false;
         }
         for each(_loc5_ in param1.criteria)
         {
            if(_loc5_.type == DareCriteriaTypeEnum.FORBIDDEN_BREEDS && _loc5_.params.indexOf(param2.playerBreed) != -1)
            {
               _loc3_ = false;
               _loc4_.push(DareSubscribeErrorEnum.BREED_LIMITED);
            }
            if(_loc5_.type == DareCriteriaTypeEnum.MAX_CHAR_LVL && param2.playerLevel > _loc5_.params[0])
            {
               _loc3_ = false;
               _loc4_.push(DareSubscribeErrorEnum.LEVEL_TOO_HIGH);
            }
         }
         param1.subscribable = _loc3_;
         param1.subscribableErrors = _loc4_;
      }
      
      private function onDareIoError() : void
      {
         _log.error("Impossible d\'accéder aux données static de liste de défis communautaires");
         this._waitStaticDareInfo = false;
         this.dispatchDareList(false,true);
      }
      
      private function onDareVersatileIoError() : void
      {
         _log.error("Impossible d\'accéder aux données versatile de liste de défis communautaires");
         this._waitVersatileDareInfo = false;
         this.dispatchDareList(false,true);
      }
   }
}
