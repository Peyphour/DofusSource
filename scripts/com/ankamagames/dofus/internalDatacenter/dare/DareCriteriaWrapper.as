package com.ankamagames.dofus.internalDatacenter.dare
{
   import com.ankamagames.dofus.datacenter.breeds.Breed;
   import com.ankamagames.dofus.datacenter.challenges.Challenge;
   import com.ankamagames.dofus.datacenter.dare.DareCriteria;
   import com.ankamagames.dofus.datacenter.idols.Idol;
   import com.ankamagames.dofus.datacenter.monsters.Monster;
   import com.ankamagames.dofus.internalDatacenter.fight.ChallengeWrapper;
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import com.ankamagames.dofus.network.enums.DareCriteriaTypeEnum;
   import com.ankamagames.dofus.network.types.game.data.items.effects.ObjectEffect;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.interfaces.IDataCenter;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.utils.misc.StringUtils;
   import flash.utils.getQualifiedClassName;
   
   public class DareCriteriaWrapper implements IDataCenter
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(DareCriteriaWrapper));
       
      
      public var type:uint;
      
      public var params:Vector.<int>;
      
      private var _name:String;
      
      private var _searchString:String;
      
      private var _paramsData:Array;
      
      private var _label:String;
      
      public function DareCriteriaWrapper()
      {
         this.params = new Vector.<int>();
         super();
      }
      
      public static function create(param1:uint, param2:Vector.<int>) : DareCriteriaWrapper
      {
         var _loc4_:int = 0;
         var _loc3_:DareCriteriaWrapper = new DareCriteriaWrapper();
         _loc3_.type = param1;
         _loc3_.params = new Vector.<int>();
         for each(_loc4_ in param2)
         {
            _loc3_.params.push(_loc4_);
         }
         return _loc3_;
      }
      
      public function get name() : String
      {
         var _loc1_:DareCriteria = null;
         if(!this._name)
         {
            _loc1_ = DareCriteria.getDareCriteriaById(this.type);
            if(_loc1_)
            {
               this._name = _loc1_.name;
            }
            else
            {
               return I18n.getUiText("ui.dare.criteria.unknown");
            }
         }
         return this._name;
      }
      
      public function get label() : String
      {
         var _loc1_:String = null;
         var _loc2_:Object = null;
         if(!this._label)
         {
            _loc1_ = this.name + I18n.getUiText("ui.common.colon");
            switch(this.type)
            {
               case DareCriteriaTypeEnum.MONSTER_ID:
                  _loc1_ = _loc1_ + (this.paramsData[0] as Monster).name;
                  break;
               case DareCriteriaTypeEnum.CHALLENGE_ID:
                  for each(_loc2_ in this.paramsData)
                  {
                     _loc1_ = _loc1_ + ((_loc2_ as ChallengeWrapper).name + ", ");
                  }
                  _loc1_ = _loc1_.slice(0,_loc1_.length - 2);
                  break;
               case DareCriteriaTypeEnum.FORBIDDEN_BREEDS:
               case DareCriteriaTypeEnum.MANDATORY_BREEDS:
                  for each(_loc2_ in this.paramsData)
                  {
                     _loc1_ = _loc1_ + ((_loc2_ as Breed).name + ", ");
                  }
                  _loc1_ = _loc1_.slice(0,_loc1_.length - 2);
                  break;
               case DareCriteriaTypeEnum.IDOLS:
                  for each(_loc2_ in this.paramsData)
                  {
                     _loc1_ = _loc1_ + ((_loc2_ as ItemWrapper).name + ", ");
                  }
                  _loc1_ = _loc1_.slice(0,_loc1_.length - 2);
                  break;
               case DareCriteriaTypeEnum.IDOLS_SCORE:
               case DareCriteriaTypeEnum.MAX_CHAR_LVL:
               case DareCriteriaTypeEnum.MIN_COUNT_CHAR:
               case DareCriteriaTypeEnum.MAX_COUNT_CHAR:
               case DareCriteriaTypeEnum.MAX_FIGHT_TURNS:
               case DareCriteriaTypeEnum.MIN_COUNT_MONSTERS:
                  _loc1_ = _loc1_ + this.paramsData[0];
            }
            this._label = _loc1_;
         }
         return this._label;
      }
      
      public function get paramsData() : Array
      {
         var _loc1_:int = 0;
         var _loc2_:Monster = null;
         var _loc3_:Challenge = null;
         var _loc4_:ChallengeWrapper = null;
         var _loc5_:Breed = null;
         var _loc6_:Idol = null;
         var _loc7_:ItemWrapper = null;
         if(!this._paramsData)
         {
            this._paramsData = new Array();
            switch(this.type)
            {
               case DareCriteriaTypeEnum.MONSTER_ID:
                  _loc2_ = Monster.getMonsterById(this.params[0]);
                  this._paramsData.push(_loc2_);
                  break;
               case DareCriteriaTypeEnum.CHALLENGE_ID:
                  _loc3_ = Challenge.getChallengeById(this.params[0]);
                  _loc4_ = new ChallengeWrapper();
                  _loc4_.id = _loc3_.id;
                  this._paramsData.push(_loc4_);
                  break;
               case DareCriteriaTypeEnum.FORBIDDEN_BREEDS:
               case DareCriteriaTypeEnum.MANDATORY_BREEDS:
                  for each(_loc1_ in this.params)
                  {
                     _loc5_ = Breed.getBreedById(_loc1_);
                     this._paramsData.push(_loc5_);
                  }
                  break;
               case DareCriteriaTypeEnum.IDOLS:
                  for each(_loc1_ in this.params)
                  {
                     _loc6_ = Idol.getIdolById(_loc1_);
                     _loc7_ = ItemWrapper.create(0,0,_loc6_.itemId,0,new Vector.<ObjectEffect>(),false);
                     this._paramsData.push(_loc7_);
                  }
                  break;
               case DareCriteriaTypeEnum.IDOLS_SCORE:
               case DareCriteriaTypeEnum.MAX_CHAR_LVL:
               case DareCriteriaTypeEnum.MIN_COUNT_CHAR:
               case DareCriteriaTypeEnum.MAX_COUNT_CHAR:
               case DareCriteriaTypeEnum.MAX_FIGHT_TURNS:
               case DareCriteriaTypeEnum.MIN_COUNT_MONSTERS:
                  this._paramsData.push(this.params[0]);
            }
         }
         return this._paramsData;
      }
      
      public function get searchString() : String
      {
         var _loc1_:* = null;
         var _loc2_:Breed = null;
         var _loc3_:ItemWrapper = null;
         if(!this._searchString)
         {
            _loc1_ = "";
            switch(this.type)
            {
               case DareCriteriaTypeEnum.CHALLENGE_ID:
                  _loc1_ = this.paramsData[0].name + "_";
                  break;
               case DareCriteriaTypeEnum.FORBIDDEN_BREEDS:
               case DareCriteriaTypeEnum.MANDATORY_BREEDS:
                  for each(_loc2_ in this.paramsData)
                  {
                     _loc1_ = _loc1_ + (_loc2_.shortName + "_");
                  }
                  break;
               case DareCriteriaTypeEnum.IDOLS:
                  for each(_loc3_ in this.paramsData)
                  {
                     _loc1_ = _loc1_ + (_loc3_.name + "_");
                  }
            }
            if(_loc1_ != "")
            {
               this._searchString = StringUtils.noAccent(_loc1_.toLocaleLowerCase());
            }
         }
         return this._searchString;
      }
      
      public function update(param1:uint, param2:Vector.<int>) : void
      {
         var _loc3_:int = 0;
         this.type = param1;
         this.params = new Vector.<int>();
         for each(_loc3_ in param2)
         {
            this.params.push(_loc3_);
         }
      }
      
      public function toString() : String
      {
         var _loc1_:String = null;
         var _loc2_:Breed = null;
         var _loc3_:ItemWrapper = null;
         switch(this.type)
         {
            case DareCriteriaTypeEnum.MONSTER_ID:
               _loc1_ = "monster: " + this.paramsData[0].name;
               break;
            case DareCriteriaTypeEnum.CHALLENGE_ID:
               _loc1_ = "challenge: " + this.paramsData[0].name;
               break;
            case DareCriteriaTypeEnum.FORBIDDEN_BREEDS:
               _loc1_ = "forbiddenBreeds: ";
               for each(_loc2_ in this.paramsData)
               {
                  _loc1_ = _loc1_ + (_loc2_.shortName + ", ");
               }
               _loc1_ = _loc1_.substr(0,_loc1_.length - 2);
               break;
            case DareCriteriaTypeEnum.MANDATORY_BREEDS:
               _loc1_ = "mandatoryBreeds: ";
               for each(_loc2_ in this.paramsData)
               {
                  _loc1_ = _loc1_ + (_loc2_.shortName + ", ");
               }
               _loc1_ = _loc1_.substr(0,_loc1_.length - 2);
               break;
            case DareCriteriaTypeEnum.IDOLS:
               _loc1_ = "idols: ";
               for each(_loc3_ in this.paramsData)
               {
                  _loc1_ = _loc1_ + (_loc3_.name + ", ");
               }
               _loc1_ = _loc1_.substr(0,_loc1_.length - 2);
               break;
            case DareCriteriaTypeEnum.IDOLS_SCORE:
               _loc1_ = "idolScore: " + this.paramsData[0];
               break;
            case DareCriteriaTypeEnum.MAX_CHAR_LVL:
               _loc1_ = "maxCharLevel: " + this.paramsData[0];
               break;
            case DareCriteriaTypeEnum.MIN_COUNT_CHAR:
               _loc1_ = "minCounChar: " + this.paramsData[0];
               break;
            case DareCriteriaTypeEnum.MAX_COUNT_CHAR:
               _loc1_ = "maxCounChar: " + this.paramsData[0];
               break;
            case DareCriteriaTypeEnum.MAX_FIGHT_TURNS:
               _loc1_ = "maxFightTurns: " + this.paramsData[0];
               break;
            case DareCriteriaTypeEnum.MIN_COUNT_MONSTERS:
               _loc1_ = "minCountMonsters: " + this.paramsData[0];
         }
         return _loc1_;
      }
   }
}
