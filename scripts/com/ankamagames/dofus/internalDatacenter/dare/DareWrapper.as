package com.ankamagames.dofus.internalDatacenter.dare
{
   import avmplus.getQualifiedClassName;
   import com.ankamagames.dofus.datacenter.monsters.Monster;
   import com.ankamagames.dofus.datacenter.world.SubArea;
   import com.ankamagames.dofus.internalDatacenter.guild.AllianceWrapper;
   import com.ankamagames.dofus.internalDatacenter.guild.GuildWrapper;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.game.common.frames.AllianceFrame;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.network.enums.DareCriteriaTypeEnum;
   import com.ankamagames.dofus.network.types.game.dare.DareCriteria;
   import com.ankamagames.dofus.network.types.game.dare.DareInformations;
   import com.ankamagames.dofus.network.types.game.dare.DareVersatileInformations;
   import com.ankamagames.jerakine.interfaces.IDataCenter;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.utils.misc.StringUtils;
   import flash.utils.Dictionary;
   
   public class DareWrapper implements IDataCenter
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(DareWrapper));
      
      private static var _ref:Dictionary = new Dictionary();
       
      
      private var _dareName:String;
      
      private var _dareTag:String;
      
      public var dareId:Number;
      
      public var creatorId:Number;
      
      public var jackpot:uint = 0;
      
      public var subscriptionFee:uint = 0;
      
      public var maxCountWinners:uint = 0;
      
      public var startDate:Number;
      
      public var endDate:Number;
      
      public var isPrivate:Boolean;
      
      public var guildId:uint = 0;
      
      public var allianceId:uint = 0;
      
      public var subscribed:Boolean;
      
      public var won:Boolean;
      
      public var countEntrants:uint = 0;
      
      public var countWinners:uint = 0;
      
      private var _guild:GuildWrapper;
      
      private var _undiatricalGuildName:String;
      
      private var _alliance:AllianceWrapper;
      
      private var _undiatricalAllianceName:String;
      
      private var _monster:Monster;
      
      private var _criteria:Vector.<DareCriteriaWrapper>;
      
      private var _jackpotString:String;
      
      private var _subFeeString:String;
      
      private var _criteriaSearchString:String;
      
      private var _subAreasSearchString:String;
      
      private var _playerId:Number = 0;
      
      private var _creatorName:String;
      
      private var _undiatricalCreatorName:String;
      
      private var _subscribable:Boolean;
      
      private var _subscribableErrorList:Array;
      
      public function DareWrapper()
      {
         this._subscribableErrorList = new Array();
         super();
      }
      
      public static function getDareById(param1:int) : DareWrapper
      {
         return _ref[param1];
      }
      
      public static function clearCache() : void
      {
         _ref = new Dictionary();
      }
      
      public static function getFromNetwork(param1:*) : DareWrapper
      {
         if(param1 is DareInformations)
         {
            return getFromBasicDareInformations(DareInformations(param1));
         }
         if(param1 is DareVersatileInformations)
         {
            return getFromDareVersatileInformations(DareVersatileInformations(param1));
         }
         return null;
      }
      
      public static function updateRef(param1:Number, param2:DareWrapper) : void
      {
         _ref[param1] = param2;
      }
      
      private static function getFromDareVersatileInformations(param1:DareVersatileInformations) : DareWrapper
      {
         var _loc2_:DareWrapper = null;
         if(_ref[param1.dareId])
         {
            _loc2_ = _ref[param1.dareId];
         }
         else
         {
            _loc2_ = new DareWrapper();
            _ref[param1.dareId] = _loc2_;
         }
         _loc2_.dareId = param1.dareId;
         _loc2_.countEntrants = param1.countEntrants;
         _loc2_.countWinners = param1.countWinners;
         return _loc2_;
      }
      
      private static function getFromBasicDareInformations(param1:DareInformations) : DareWrapper
      {
         var _loc2_:DareWrapper = null;
         var _loc3_:DareCriteria = null;
         var _loc4_:DareCriteriaWrapper = null;
         if(_ref[param1.dareId])
         {
            _loc2_ = _ref[param1.dareId];
         }
         else
         {
            _loc2_ = new DareWrapper();
            _ref[param1.dareId] = _loc2_;
         }
         _loc2_.dareId = param1.dareId;
         _loc2_.creatorId = param1.creator.id;
         _loc2_.creatorName = param1.creator.name;
         _loc2_.jackpot = param1.jackpot;
         _loc2_.subscriptionFee = param1.subscriptionFee;
         _loc2_.maxCountWinners = param1.maxCountWinners;
         _loc2_.startDate = param1.startDate;
         _loc2_.endDate = param1.endDate;
         _loc2_.isPrivate = param1.isPrivate;
         _loc2_.guildId = param1.guildId;
         _loc2_.allianceId = param1.allianceId;
         _loc2_.criteria = new Vector.<DareCriteriaWrapper>();
         for each(_loc3_ in param1.criterions)
         {
            _loc4_ = DareCriteriaWrapper.create(_loc3_.type,_loc3_.params);
            _loc2_.criteria.push(_loc4_);
         }
         return _loc2_;
      }
      
      public static function create(param1:Number, param2:uint, param3:String, param4:uint = 0, param5:uint = 0, param6:uint = 0, param7:Number = 0, param8:Number = 0, param9:Boolean = false, param10:uint = 0, param11:uint = 0, param12:Vector.<DareCriteriaWrapper> = null, param13:uint = 0, param14:uint = 0) : DareWrapper
      {
         var _loc15_:DareWrapper = new DareWrapper();
         _loc15_.dareId = param1;
         _loc15_.creatorId = param2;
         _loc15_.creatorName = param3;
         _loc15_.jackpot = param4;
         _loc15_.subscriptionFee = param5;
         _loc15_.maxCountWinners = param6;
         _loc15_.startDate = param7;
         _loc15_.endDate = param8;
         _loc15_.isPrivate = param9;
         _loc15_.guildId = param10;
         _loc15_.allianceId = param11;
         _loc15_.criteria = param12;
         _loc15_.countEntrants = param13;
         _loc15_.countWinners = param14;
         return _loc15_;
      }
      
      public function get creatorName() : String
      {
         return this._creatorName;
      }
      
      public function set creatorName(param1:String) : void
      {
         if(this._creatorName != param1)
         {
            this._undiatricalCreatorName = null;
         }
         this._creatorName = param1;
      }
      
      public function get undiatricalCreatorName() : String
      {
         if(this._undiatricalCreatorName == null)
         {
            this._undiatricalCreatorName = StringUtils.noAccent(this.creatorName).toLowerCase();
         }
         return this._undiatricalCreatorName;
      }
      
      public function get criteria() : Vector.<DareCriteriaWrapper>
      {
         return this._criteria;
      }
      
      public function set criteria(param1:Vector.<DareCriteriaWrapper>) : void
      {
         if(this._criteria != param1)
         {
            this._criteriaSearchString = null;
         }
         this._criteria = param1;
      }
      
      public function get subscribable() : Boolean
      {
         return this._subscribable;
      }
      
      public function set subscribable(param1:Boolean) : void
      {
         this._subscribable = param1;
      }
      
      public function get subscribableErrors() : Array
      {
         return this._subscribableErrorList;
      }
      
      public function set subscribableErrors(param1:Array) : void
      {
         this._subscribableErrorList = param1;
      }
      
      public function get guild() : GuildWrapper
      {
         if(this.guildId > 0 && !this._guild)
         {
            this._guild = GuildWrapper.getGuildById(this.guildId);
         }
         return this._guild;
      }
      
      public function get undiatricalGuildName() : String
      {
         if(this._undiatricalGuildName == null && this.guild)
         {
            this._undiatricalGuildName = StringUtils.noAccent(this.guild.guildName).toLowerCase();
         }
         return this._undiatricalGuildName;
      }
      
      public function get alliance() : AllianceWrapper
      {
         var _loc1_:AllianceFrame = null;
         if(this.allianceId > 0 && !this._alliance)
         {
            _loc1_ = Kernel.getWorker().getFrame(AllianceFrame) as AllianceFrame;
            this._alliance = _loc1_.getAllianceById(this.allianceId);
         }
         return this._alliance;
      }
      
      public function get undiatricalAllianceName() : String
      {
         if(this._undiatricalAllianceName == null && this.alliance)
         {
            this._undiatricalAllianceName = StringUtils.noAccent(this.alliance.allianceName).toLowerCase();
         }
         return this._undiatricalAllianceName;
      }
      
      public function get monster() : Monster
      {
         var _loc1_:DareCriteriaWrapper = null;
         if(!this._monster && this.criteria)
         {
            for each(_loc1_ in this.criteria)
            {
               if(_loc1_.type == DareCriteriaTypeEnum.MONSTER_ID)
               {
                  if(this._monster != _loc1_.paramsData[0])
                  {
                     this._subAreasSearchString = null;
                  }
                  this._monster = _loc1_.paramsData[0];
                  break;
               }
            }
         }
         return this._monster;
      }
      
      public function get monsterName() : String
      {
         return this._monster.name;
      }
      
      public function get jackpotString() : String
      {
         if(!this._jackpotString)
         {
            this._jackpotString = StringUtils.kamasToString(this.jackpot,"");
         }
         return this._jackpotString;
      }
      
      public function get subscriptionFeeString() : String
      {
         if(!this._subFeeString)
         {
            this._subFeeString = StringUtils.kamasToString(this.subscriptionFee,"");
         }
         return this._subFeeString;
      }
      
      public function get isMyCreation() : Boolean
      {
         if(this._playerId == 0)
         {
            this._playerId = PlayedCharacterManager.getInstance().id;
         }
         if(this.creatorId == this._playerId)
         {
            return true;
         }
         return false;
      }
      
      public function get criteriaSearchString() : String
      {
         var _loc1_:DareCriteriaWrapper = null;
         if(this._criteriaSearchString == null)
         {
            this._criteriaSearchString = "";
            for each(_loc1_ in this.criteria)
            {
               this._criteriaSearchString = this._criteriaSearchString + (_loc1_.searchString + "_");
            }
         }
         return this._criteriaSearchString;
      }
      
      public function get subAreasSearchString() : String
      {
         var _loc1_:SubArea = null;
         var _loc2_:uint = 0;
         if(this._subAreasSearchString == null)
         {
            this._subAreasSearchString = "";
            for each(_loc2_ in this.monster.subareas)
            {
               _loc1_ = SubArea.getSubAreaById(_loc2_);
               if(_loc1_.area)
               {
                  this._subAreasSearchString = this._subAreasSearchString + (_loc1_.area.undiatricalName + " (" + _loc1_.undiatricalName + ")_");
               }
               else
               {
                  this._subAreasSearchString = this._subAreasSearchString + _loc1_.undiatricalName;
               }
            }
         }
         return this._subAreasSearchString;
      }
      
      public function isOngoing(param1:Number) : Boolean
      {
         return this.startDate < param1 && this.endDate > param1;
      }
      
      public function isFightable(param1:Number) : Boolean
      {
         var _loc3_:DareCriteriaWrapper = null;
         if(this.won)
         {
            return false;
         }
         if(param1 < this.startDate || param1 > this.endDate)
         {
            return false;
         }
         var _loc2_:Boolean = true;
         for each(_loc3_ in this.criteria)
         {
            if(_loc3_.type == DareCriteriaTypeEnum.MAX_CHAR_LVL && PlayedCharacterManager.getInstance().infos.level > _loc3_.params[0])
            {
               return false;
            }
         }
         return true;
      }
      
      public function clone() : DareWrapper
      {
         var _loc1_:DareWrapper = create(this.dareId,this.creatorId,this.creatorName,this.jackpot,this.subscriptionFee,this.maxCountWinners,this.startDate,this.endDate,this.isPrivate,this.guildId,this.allianceId,this.criteria,this.countEntrants,this.countWinners);
         return _loc1_;
      }
      
      public function update(param1:Number, param2:uint, param3:String, param4:uint = 0, param5:uint = 0, param6:uint = 0, param7:Number = 0, param8:Number = 0, param9:Boolean = false, param10:uint = 0, param11:uint = 0, param12:Vector.<DareCriteriaWrapper> = null, param13:uint = 0, param14:uint = 0) : void
      {
         this.dareId = param1;
         this.creatorId = param2;
         this.creatorName = param3;
         this.jackpot = param4;
         this.subscriptionFee = param5;
         this.maxCountWinners = param6;
         this.startDate = param7;
         this.endDate = param8;
         this.isPrivate = param9;
         this.guildId = param10;
         this.allianceId = param11;
         this.criteria = param12;
         this.countEntrants = param13;
         this.countWinners = param14;
      }
      
      public function toString() : String
      {
         var _loc2_:DareCriteriaWrapper = null;
         var _loc1_:* = "[DareWrapper#" + this.dareId + " by " + this.creatorName + " with criteria ";
         for each(_loc2_ in this.criteria)
         {
            _loc1_ = _loc1_ + (_loc2_ + "|");
         }
         _loc1_ = _loc1_.substr(0,_loc1_.length - 1);
         _loc1_ = _loc1_ + "]";
         return _loc1_;
      }
   }
}
