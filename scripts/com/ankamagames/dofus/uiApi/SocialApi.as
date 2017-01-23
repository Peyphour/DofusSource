package com.ankamagames.dofus.uiApi
{
   import com.ankamagames.berilia.interfaces.IApi;
   import com.ankamagames.berilia.types.data.UiModule;
   import com.ankamagames.dofus.internalDatacenter.communication.BasicChatSentence;
   import com.ankamagames.dofus.internalDatacenter.conquest.PrismSubAreaWrapper;
   import com.ankamagames.dofus.internalDatacenter.dare.DareWrapper;
   import com.ankamagames.dofus.internalDatacenter.guild.AllianceWrapper;
   import com.ankamagames.dofus.internalDatacenter.guild.GuildFactSheetWrapper;
   import com.ankamagames.dofus.internalDatacenter.guild.GuildWrapper;
   import com.ankamagames.dofus.internalDatacenter.guild.SocialEntityInFightWrapper;
   import com.ankamagames.dofus.internalDatacenter.guild.SocialFightersWrapper;
   import com.ankamagames.dofus.internalDatacenter.guild.TaxCollectorWrapper;
   import com.ankamagames.dofus.internalDatacenter.people.EnemyWrapper;
   import com.ankamagames.dofus.internalDatacenter.people.FriendWrapper;
   import com.ankamagames.dofus.internalDatacenter.people.IgnoredWrapper;
   import com.ankamagames.dofus.internalDatacenter.people.SpouseWrapper;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.game.common.actions.dare.DareInformationsRequestAction;
   import com.ankamagames.dofus.logic.game.common.frames.AllianceFrame;
   import com.ankamagames.dofus.logic.game.common.frames.ChatFrame;
   import com.ankamagames.dofus.logic.game.common.frames.DareFrame;
   import com.ankamagames.dofus.logic.game.common.frames.PlayedCharacterUpdatesFrame;
   import com.ankamagames.dofus.logic.game.common.frames.SocialFrame;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.logic.game.common.managers.TaxCollectorsManager;
   import com.ankamagames.dofus.network.types.game.dare.DareReward;
   import com.ankamagames.dofus.network.types.game.guild.GuildMember;
   import com.ankamagames.dofus.network.types.game.prism.AllianceInsiderPrismInformation;
   import com.ankamagames.dofus.network.types.game.prism.AlliancePrismInformation;
   import com.ankamagames.dofus.network.types.game.prism.PrismInformation;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.managers.StoreDataManager;
   import com.ankamagames.jerakine.types.DataStoreType;
   import com.ankamagames.jerakine.types.enums.DataStoreEnum;
   import com.ankamagames.jerakine.utils.misc.StringUtils;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   
   [InstanciedApi]
   public class SocialApi implements IApi
   {
      
      private static var _datastoreType:DataStoreType = new DataStoreType("Module_Ankama_Social",true,DataStoreEnum.LOCATION_LOCAL,DataStoreEnum.BIND_CHARACTER);
       
      
      protected var _log:Logger;
      
      private var _module:UiModule;
      
      public function SocialApi()
      {
         this._log = Log.getLogger(getQualifiedClassName(SocialApi));
         super();
      }
      
      public static function get dareFrame() : DareFrame
      {
         return DareFrame.getInstance();
      }
      
      [ApiData(name="module")]
      public function set module(param1:UiModule) : void
      {
         this._module = param1;
      }
      
      public function get socialFrame() : SocialFrame
      {
         return SocialFrame.getInstance();
      }
      
      public function get allianceFrame() : AllianceFrame
      {
         return AllianceFrame.getInstance();
      }
      
      [Trusted]
      public function destroy() : void
      {
         this._module = null;
      }
      
      [Untrusted]
      public function getFriendsList() : Array
      {
         var _loc3_:FriendWrapper = null;
         var _loc1_:Array = new Array();
         var _loc2_:Array = this.socialFrame.friendsList;
         for each(_loc3_ in _loc2_)
         {
            _loc1_.push(_loc3_);
         }
         _loc1_.sortOn("name",Array.CASEINSENSITIVE);
         return _loc1_;
      }
      
      [Untrusted]
      public function isFriend(param1:String) : Boolean
      {
         var _loc3_:* = undefined;
         var _loc2_:Array = this.socialFrame.friendsList;
         for each(_loc3_ in _loc2_)
         {
            if(_loc3_.playerName == param1)
            {
               return true;
            }
         }
         return false;
      }
      
      [Untrusted]
      public function getEnemiesList() : Array
      {
         var _loc2_:EnemyWrapper = null;
         var _loc1_:Array = new Array();
         for each(_loc2_ in this.socialFrame.enemiesList)
         {
            _loc1_.push(_loc2_);
         }
         _loc1_.sortOn("name",Array.CASEINSENSITIVE);
         return _loc1_;
      }
      
      [Untrusted]
      public function isEnemy(param1:String) : Boolean
      {
         var _loc2_:* = undefined;
         for each(_loc2_ in this.socialFrame.enemiesList)
         {
            if(_loc2_.playerName == param1)
            {
               return true;
            }
         }
         return false;
      }
      
      [Untrusted]
      public function getIgnoredList() : Array
      {
         var _loc2_:IgnoredWrapper = null;
         var _loc1_:Array = new Array();
         for each(_loc2_ in this.socialFrame.ignoredList)
         {
            _loc1_.push(_loc2_);
         }
         _loc1_.sortOn("name",Array.CASEINSENSITIVE);
         return _loc1_;
      }
      
      [Untrusted]
      public function isIgnored(param1:String, param2:int = 0) : Boolean
      {
         return this.socialFrame.isIgnored(param1,param2);
      }
      
      [Trusted]
      public function getAccountName(param1:String) : String
      {
         return param1;
      }
      
      [Untrusted]
      public function getWarnOnFriendConnec() : Boolean
      {
         return this.socialFrame.warnFriendConnec;
      }
      
      [Untrusted]
      public function getWarnOnMemberConnec() : Boolean
      {
         return this.socialFrame.warnMemberConnec;
      }
      
      [Untrusted]
      public function getWarnWhenFriendOrGuildMemberLvlUp() : Boolean
      {
         return this.socialFrame.warnWhenFriendOrGuildMemberLvlUp;
      }
      
      [Untrusted]
      public function getWarnWhenFriendOrGuildMemberAchieve() : Boolean
      {
         return this.socialFrame.warnWhenFriendOrGuildMemberAchieve;
      }
      
      [Untrusted]
      public function getWarnOnHardcoreDeath() : Boolean
      {
         return this.socialFrame.warnOnHardcoreDeath;
      }
      
      [Untrusted]
      public function getSpouse() : SpouseWrapper
      {
         return this.socialFrame.spouse;
      }
      
      [Untrusted]
      public function hasSpouse() : Boolean
      {
         return this.socialFrame.hasSpouse;
      }
      
      [Untrusted]
      public function getAllowedGuildEmblemSymbolCategories() : int
      {
         var _loc1_:PlayedCharacterUpdatesFrame = Kernel.getWorker().getFrame(PlayedCharacterUpdatesFrame) as PlayedCharacterUpdatesFrame;
         return _loc1_.guildEmblemSymbolCategories;
      }
      
      [Untrusted]
      public function hasGuild() : Boolean
      {
         return this.socialFrame.hasGuild;
      }
      
      [Untrusted]
      public function getGuild() : GuildWrapper
      {
         return this.socialFrame.guild;
      }
      
      [Untrusted]
      public function getGuildMembers() : Vector.<GuildMember>
      {
         return this.socialFrame.guildmembers;
      }
      
      [Untrusted]
      public function getGuildRights() : Array
      {
         return GuildWrapper.guildRights;
      }
      
      [Untrusted]
      public function getGuildByid(param1:int) : GuildFactSheetWrapper
      {
         return this.socialFrame.getGuildById(param1);
      }
      
      [Untrusted]
      public function hasGuildRight(param1:Number, param2:String) : Boolean
      {
         var _loc3_:GuildMember = null;
         var _loc4_:GuildWrapper = null;
         if(!this.socialFrame.hasGuild)
         {
            return false;
         }
         if(param1 == PlayedCharacterManager.getInstance().id)
         {
            return this.socialFrame.guild.hasRight(param2);
         }
         for each(_loc3_ in this.socialFrame.guildmembers)
         {
            if(_loc3_.id == param1)
            {
               _loc4_ = GuildWrapper.create(0,"",null,_loc3_.rights);
               return _loc4_.hasRight(param2);
            }
         }
         return false;
      }
      
      [Untrusted]
      public function hasGuildRank(param1:Number, param2:int) : Boolean
      {
         var _loc3_:GuildMember = null;
         if(!this.socialFrame.hasGuild)
         {
            return false;
         }
         for each(_loc3_ in this.socialFrame.guildmembers)
         {
            if(_loc3_.id == param1)
            {
               return _loc3_.rank == param2;
            }
         }
         return false;
      }
      
      [Untrusted]
      public function getGuildHouses() : Object
      {
         return this.socialFrame.guildHouses;
      }
      
      [Untrusted]
      public function guildHousesUpdateNeeded() : Boolean
      {
         return this.socialFrame.guildHousesUpdateNeeded;
      }
      
      [Untrusted]
      public function getGuildPaddocks() : Object
      {
         return this.socialFrame.guildPaddocks;
      }
      
      [Untrusted]
      public function getMaxGuildPaddocks() : int
      {
         return this.socialFrame.maxGuildPaddocks;
      }
      
      [Untrusted]
      public function isGuildNameInvalid() : Boolean
      {
         if(this.socialFrame.guild)
         {
            return this.socialFrame.guild.realGuildName == "#NONAME#";
         }
         return false;
      }
      
      [Untrusted]
      public function getMaxCollectorCount() : uint
      {
         return TaxCollectorsManager.getInstance().maxTaxCollectorsCount;
      }
      
      [Untrusted]
      public function getTaxCollectors() : Dictionary
      {
         return TaxCollectorsManager.getInstance().taxCollectors;
      }
      
      [Untrusted]
      public function getTaxCollector(param1:int) : TaxCollectorWrapper
      {
         return TaxCollectorsManager.getInstance().taxCollectors[param1];
      }
      
      [Untrusted]
      public function getGuildFightingTaxCollectors() : Dictionary
      {
         return TaxCollectorsManager.getInstance().guildTaxCollectorsFighters;
      }
      
      [Untrusted]
      public function getGuildFightingTaxCollector(param1:uint) : SocialEntityInFightWrapper
      {
         return TaxCollectorsManager.getInstance().guildTaxCollectorsFighters[param1];
      }
      
      [Untrusted]
      public function getAllFightingTaxCollectors() : Dictionary
      {
         return TaxCollectorsManager.getInstance().allTaxCollectorsInPreFight;
      }
      
      [Untrusted]
      public function getAllFightingTaxCollector(param1:uint) : SocialEntityInFightWrapper
      {
         return TaxCollectorsManager.getInstance().allTaxCollectorsInPreFight[param1];
      }
      
      [Untrusted]
      public function isPlayerDefender(param1:int, param2:Number, param3:int) : Boolean
      {
         var _loc4_:SocialEntityInFightWrapper = null;
         var _loc5_:SocialFightersWrapper = null;
         if(param1 == 0)
         {
            _loc4_ = TaxCollectorsManager.getInstance().guildTaxCollectorsFighters[param3];
            if(!_loc4_)
            {
               _loc4_ = TaxCollectorsManager.getInstance().allTaxCollectorsInPreFight[param3];
            }
         }
         else if(param1 == 1)
         {
            _loc4_ = TaxCollectorsManager.getInstance().prismsFighters[param3];
         }
         if(_loc4_)
         {
            for each(_loc5_ in _loc4_.allyCharactersInformations)
            {
               if(_loc5_.playerCharactersInformations.id == param2)
               {
                  return true;
               }
            }
         }
         return false;
      }
      
      [Untrusted]
      public function hasAlliance() : Boolean
      {
         return this.allianceFrame.hasAlliance;
      }
      
      [Untrusted]
      public function getAlliance() : AllianceWrapper
      {
         return this.allianceFrame.alliance;
      }
      
      [Untrusted]
      public function getAllianceById(param1:int) : AllianceWrapper
      {
         return this.allianceFrame.getAllianceById(param1);
      }
      
      [Untrusted]
      public function getAllianceGuilds() : Vector.<GuildFactSheetWrapper>
      {
         return this.allianceFrame.alliance.guilds;
      }
      
      [Untrusted]
      public function isAllianceNameInvalid() : Boolean
      {
         if(this.allianceFrame.alliance)
         {
            return this.allianceFrame.alliance.realAllianceName == "#NONAME#";
         }
         return false;
      }
      
      [Untrusted]
      public function isAllianceTagInvalid() : Boolean
      {
         if(this.allianceFrame.alliance)
         {
            return this.allianceFrame.alliance.realAllianceTag == "#TAG#";
         }
         return false;
      }
      
      [Untrusted]
      public function getAllianceNameAndTag(param1:PrismInformation) : String
      {
         var _loc2_:* = null;
         var _loc3_:AlliancePrismInformation = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:* = null;
         var _loc7_:AllianceWrapper = null;
         if(param1 is AlliancePrismInformation)
         {
            _loc3_ = param1 as AlliancePrismInformation;
            _loc4_ = _loc3_.alliance.allianceName;
            if(_loc4_ == "#NONAME#")
            {
               _loc4_ = I18n.getUiText("ui.guild.noName");
            }
            _loc5_ = _loc3_.alliance.allianceTag;
            if(_loc5_ == "#TAG#")
            {
               _loc5_ = I18n.getUiText("ui.alliance.noTag");
            }
            _loc6_ = " \\[" + _loc5_ + "]";
            _loc2_ = _loc4_ + _loc6_;
         }
         else if(param1 is AllianceInsiderPrismInformation)
         {
            _loc7_ = this.getAlliance();
            _loc2_ = _loc7_.allianceName + " \\[" + _loc7_.allianceTag + "]";
         }
         return _loc2_;
      }
      
      [Untrusted]
      public function getPrismSubAreaById(param1:int) : PrismSubAreaWrapper
      {
         return this.allianceFrame.getPrismSubAreaById(param1);
      }
      
      [Untrusted]
      public function getFightingPrisms() : Dictionary
      {
         return TaxCollectorsManager.getInstance().prismsFighters;
      }
      
      [Untrusted]
      public function getFightingPrism(param1:uint) : SocialEntityInFightWrapper
      {
         return TaxCollectorsManager.getInstance().prismsFighters[param1];
      }
      
      [Untrusted]
      public function isPlayerPrismDefender(param1:Number, param2:int) : Boolean
      {
         var _loc4_:SocialFightersWrapper = null;
         var _loc3_:SocialEntityInFightWrapper = TaxCollectorsManager.getInstance().prismsFighters[param2];
         if(_loc3_)
         {
            for each(_loc4_ in _loc3_.allyCharactersInformations)
            {
               if(_loc4_.playerCharactersInformations.id == param1)
               {
                  return true;
               }
            }
         }
         return false;
      }
      
      [Trusted]
      public function getChatSentence(param1:Number, param2:String) : BasicChatSentence
      {
         var _loc6_:Array = null;
         var _loc7_:BasicChatSentence = null;
         var _loc3_:Boolean = false;
         var _loc4_:BasicChatSentence = null;
         var _loc5_:ChatFrame = Kernel.getWorker().getFrame(ChatFrame) as ChatFrame;
         for each(_loc6_ in _loc5_.getMessages())
         {
            for each(_loc7_ in _loc6_)
            {
               if(_loc7_.fingerprint == param2 && _loc7_.timestamp == param1)
               {
                  _loc4_ = _loc7_;
                  _loc3_ = true;
                  break;
               }
            }
            if(_loc3_)
            {
               break;
            }
         }
         return _loc4_;
      }
      
      [Untrusted]
      public function getDareList() : Vector.<DareWrapper>
      {
         return dareFrame.dareList;
      }
      
      [Untrusted]
      public function getDareById(param1:Number) : DareWrapper
      {
         return dareFrame.getDareById(param1);
      }
      
      [Untrusted]
      public function getTotalGuildDares() : uint
      {
         return dareFrame.getTotalGuildDares();
      }
      
      [Untrusted]
      public function getTotalAllianceDares() : uint
      {
         return dareFrame.getTotalAllianceDares();
      }
      
      [Untrusted]
      public function getTotalDaresInSubArea(param1:uint) : uint
      {
         return dareFrame.getTotalDaresInSubArea(param1);
      }
      
      [Untrusted]
      public function getTargetedMonsterIdsInSubArea(param1:uint) : Vector.<int>
      {
         return dareFrame.getTargetedMonsterIdsInSubArea(param1);
      }
      
      [Untrusted]
      public function getFilteredDareList(param1:Boolean = true, param2:Boolean = false, param3:Boolean = false, param4:String = "", param5:Boolean = false, param6:Boolean = false, param7:Boolean = false, param8:Boolean = false, param9:Boolean = false, param10:Boolean = false, param11:Boolean = false) : Array
      {
         var _loc13_:DareWrapper = null;
         var _loc23_:String = null;
         var _loc24_:uint = 0;
         var _loc25_:uint = 0;
         var _loc26_:Boolean = false;
         var _loc27_:Number = NaN;
         var _loc28_:Date = null;
         if(param4)
         {
            param4 = StringUtils.noAccent(param4.toLocaleLowerCase());
         }
         var _loc12_:Array = new Array();
         var _loc14_:Date = new Date();
         var _loc15_:Number = _loc14_.time;
         var _loc16_:Boolean = !param2 && !param3;
         if(param4 && param5)
         {
            _loc27_ = parseInt(param4);
            if(isNaN(_loc27_) == false)
            {
               _loc13_ = dareFrame.getDareById(_loc27_);
               if(_loc13_)
               {
                  if(param2 && !_loc13_.isMyCreation)
                  {
                     return _loc12_;
                  }
                  if(param3 && !_loc13_.subscribed)
                  {
                     return _loc12_;
                  }
                  if(!_loc16_ || _loc16_ && _loc13_.isOngoing(_loc15_))
                  {
                     _loc12_.push(_loc13_);
                  }
               }
               else
               {
                  Kernel.getWorker().processImmediately(DareInformationsRequestAction.create(_loc27_));
               }
               return _loc12_;
            }
         }
         var _loc17_:Vector.<DareWrapper> = dareFrame.dareList;
         var _loc18_:PlayedCharacterManager = PlayedCharacterManager.getInstance();
         var _loc19_:Object = {
            "playerId":_loc18_.id,
            "playerBreed":_loc18_.infos.breed,
            "playerLevel":_loc18_.infos.level,
            "playerKamas":_loc18_.characteristics.kamas,
            "playerGuildId":(!!this.socialFrame.hasGuild?this.socialFrame.guild.guildId:0),
            "playerAllianceId":(!!this.allianceFrame.hasAlliance?this.allianceFrame.alliance.allianceId:0),
            "currentTime":_loc15_
         };
         var _loc20_:Boolean = false;
         if(param2)
         {
            param1 = false;
         }
         else if(param3)
         {
            _loc20_ = param1;
            param1 = false;
         }
         var _loc21_:Array = StoreDataManager.getInstance().getData(_datastoreType,"HiddenDaresIds");
         var _loc22_:Array = new Array();
         for each(_loc23_ in _loc21_)
         {
            _loc22_.push(Number(_loc23_.split("_")[0]));
         }
         _loc25_ = _loc17_.length;
         _loc24_ = 0;
         while(_loc24_ < _loc25_)
         {
            _loc13_ = _loc17_[_loc24_];
            _loc26_ = false;
            _loc28_ = new Date(_loc13_.startDate);
            DareFrame.getInstance().setDareSubscribable(_loc13_,_loc19_);
            if(!(param1 && (!_loc13_.subscribable || _loc22_ && _loc22_.indexOf(_loc13_.dareId) != -1)))
            {
               if(!(param2 && !_loc13_.isMyCreation))
               {
                  if(!(param3 && !_loc13_.subscribed))
                  {
                     if(!(_loc16_ && !_loc13_.isOngoing(_loc15_)))
                     {
                        if(!(_loc20_ && !_loc13_.isFightable(_loc15_)))
                        {
                           if(!param4)
                           {
                              _loc26_ = true;
                           }
                           else if(param5 && _loc13_.dareId.toString().indexOf(param4) != -1)
                           {
                              _loc26_ = true;
                           }
                           else if(param6 && _loc13_.undiatricalCreatorName.indexOf(param4) != -1)
                           {
                              _loc26_ = true;
                           }
                           else if(param7 && _loc13_.monster.undiatricalName.indexOf(param4) != -1)
                           {
                              _loc26_ = true;
                           }
                           else if(param8 && _loc13_.criteriaSearchString.indexOf(param4) != -1)
                           {
                              _loc26_ = true;
                           }
                           else if(param9 && _loc13_.subAreasSearchString.indexOf(param4) != -1)
                           {
                              _loc26_ = true;
                           }
                           else if(param10 && _loc13_.undiatricalGuildName && _loc13_.undiatricalGuildName.indexOf(param4) != -1)
                           {
                              _loc26_ = true;
                           }
                           else if(param11 && _loc13_.undiatricalAllianceName && _loc13_.undiatricalAllianceName.indexOf(param4) != -1)
                           {
                              _loc26_ = true;
                           }
                           if(_loc26_)
                           {
                              _loc12_.push(_loc13_);
                           }
                        }
                     }
                  }
               }
            }
            _loc24_++;
         }
         return _loc12_;
      }
      
      [Untrusted]
      public function getDareRewards() : Vector.<DareReward>
      {
         return !!this.getDareFrame()?this.getDareFrame().dareRewardsWon:null;
      }
      
      private function getDareFrame() : DareFrame
      {
         return DareFrame.getInstance();
      }
   }
}
