package utils
{
   public class FormulaHandler
   {
      
      private static var _self:FormulaHandler;
      
      private static const XP_GROUP:Array = [1,1.1,1.5,2.3,3.1,3.6,4.2,4.7];
      
      private static const MAX_LEVEL_MALUS:Number = 4;
       
      
      private var _xpSolo:Number;
      
      private var _xpGroup:Number;
      
      public function FormulaHandler()
      {
         super();
         this.clearData();
      }
      
      public static function getInstance() : FormulaHandler
      {
         if(_self == null)
         {
            _self = new FormulaHandler();
         }
         return _self;
      }
      
      public static function createMonsterData(param1:int, param2:int, param3:uint) : MonsterData
      {
         return new MonsterData(param1,param2,param3);
      }
      
      public static function createGroupMember(param1:int, param2:Boolean = false) : GroupMemberData
      {
         return new GroupMemberData(param1,param2);
      }
      
      public static function createPlayerData(param1:int, param2:int = 0, param3:Number = 0, param4:Number = 0, param5:Number = 0, param6:Number = 0) : PlayerData
      {
         return new PlayerData(param1,param2,param3,param4,param5,param6);
      }
      
      public static function getArenaMalusDrop(param1:int, param2:int) : int
      {
         var _loc3_:int = Math.round(100 - param1 / param2 * 100);
         return _loc3_ < 0?0:int(_loc3_);
      }
      
      private function clearData() : void
      {
         this._xpSolo = 0;
         this._xpGroup = 0;
      }
      
      public function initXpFormula(param1:PlayerData, param2:Array, param3:Array, param4:int = 0, param5:int = 0, param6:int = 0) : void
      {
         var _loc11_:MonsterData = null;
         var _loc12_:uint = 0;
         var _loc13_:uint = 0;
         var _loc14_:uint = 0;
         var _loc15_:GroupMemberData = null;
         var _loc16_:Number = NaN;
         var _loc37_:Number = NaN;
         var _loc38_:Number = NaN;
         var _loc39_:Number = NaN;
         var _loc40_:Number = NaN;
         var _loc41_:Number = NaN;
         this.clearData();
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         var _loc10_:uint = 0;
         for each(_loc11_ in param2)
         {
            _loc7_ = _loc7_ + _loc11_.xp;
            _loc9_ = _loc9_ + _loc11_.level;
            _loc10_ = _loc10_ + (_loc11_.hiddenLevel > 0?_loc11_.hiddenLevel:_loc11_.level);
            if(_loc11_.level > _loc8_)
            {
               _loc8_ = _loc11_.level;
            }
         }
         _loc12_ = 0;
         _loc13_ = 0;
         _loc14_ = 0;
         for each(_loc15_ in param3)
         {
            _loc12_ = _loc12_ + _loc15_.level;
            if(_loc15_.level > _loc13_)
            {
               _loc13_ = _loc15_.level;
            }
         }
         for each(_loc15_ in param3)
         {
            if(!_loc15_.companion && _loc15_.level >= _loc13_ / 3)
            {
               _loc14_++;
            }
         }
         _loc16_ = 1;
         if(_loc12_ - 5 > _loc9_)
         {
            _loc16_ = _loc9_ / _loc12_;
         }
         else if(_loc12_ + 10 < _loc9_)
         {
            _loc16_ = (_loc12_ + 10) / _loc9_;
         }
         var _loc17_:Number = 1;
         if(param1.level - 5 > _loc9_)
         {
            _loc17_ = _loc9_ / param1.level;
         }
         else if(param1.level + 10 < _loc9_)
         {
            _loc17_ = (param1.level + 10) / _loc9_;
         }
         var _loc18_:uint = Math.min(param1.level,this.truncate(2.5 * _loc8_));
         var _loc19_:Number = _loc18_ / param1.level * 100;
         var _loc20_:Number = _loc18_ / _loc12_ * 100;
         var _loc21_:uint = this.truncate(_loc7_ * XP_GROUP[0] * _loc17_);
         if(_loc14_ == 0)
         {
            _loc14_ = 1;
         }
         var _loc22_:uint = this.truncate(_loc7_ * XP_GROUP[_loc14_ - 1] * _loc16_);
         var _loc23_:uint = this.truncate(_loc19_ / 100 * _loc21_);
         var _loc24_:uint = this.truncate(_loc20_ / 100 * _loc22_);
         var _loc25_:Number = param4 <= 0?Number(1):Number(1 + param4 / 100);
         var _loc26_:Number = Math.min(MAX_LEVEL_MALUS,_loc10_ / param2.length / param1.level);
         _loc26_ = _loc26_ * _loc26_;
         var _loc27_:Number = Math.min(MAX_LEVEL_MALUS,_loc10_ / param2.length / _loc13_);
         _loc27_ = _loc27_ * _loc27_;
         var _loc28_:int = this.truncate((100 + param1.level * 2.5) * this.truncate(param5 * _loc26_) / 100);
         var _loc29_:int = this.truncate((100 + param1.level * 2.5) * this.truncate(param6 * _loc27_) / 100);
         var _loc30_:uint = Math.max(param1.wisdom + _loc28_,0);
         var _loc31_:uint = Math.max(param1.wisdom + _loc29_,0);
         var _loc32_:uint = this.truncate(this.truncate(_loc23_ * (100 + _loc30_) / 100) * _loc25_);
         var _loc33_:uint = this.truncate(this.truncate(_loc24_ * (100 + _loc31_) / 100) * _loc25_);
         var _loc34_:Number = 1 + param1.xpBonusPercent / 100;
         var _loc35_:Number = _loc32_;
         var _loc36_:Number = _loc33_;
         if(param1.xpRatioMount > 0)
         {
            _loc37_ = _loc35_ * param1.xpRatioMount / 100;
            _loc38_ = _loc36_ * param1.xpRatioMount / 100;
            _loc35_ = this.truncate(_loc35_ - _loc37_);
            _loc36_ = this.truncate(_loc36_ - _loc38_);
         }
         _loc35_ = _loc35_ * _loc34_;
         _loc36_ = _loc36_ * _loc34_;
         if(param1.xpGuildGivenPercent > 0)
         {
            _loc39_ = _loc35_ * param1.xpGuildGivenPercent / 100;
            _loc40_ = _loc36_ * param1.xpGuildGivenPercent / 100;
            _loc35_ = _loc35_ - _loc39_;
            _loc36_ = _loc36_ - _loc40_;
         }
         if(param1.xpAlliancePrismBonusPercent > 0)
         {
            _loc41_ = 1 + param1.xpAlliancePrismBonusPercent / 100;
            _loc35_ = _loc35_ * _loc41_;
            _loc36_ = _loc36_ * _loc41_;
         }
         _loc32_ = this.truncate(_loc35_);
         _loc33_ = this.truncate(_loc36_);
         this._xpSolo = _loc7_ > 0?Number(Math.max(_loc32_,1)):Number(0);
         this._xpGroup = _loc7_ > 0?Number(Math.max(_loc33_,1)):Number(0);
      }
      
      private function truncate(param1:Number) : int
      {
         var _loc2_:uint = Math.pow(10,0);
         var _loc3_:Number = param1 * _loc2_;
         return int(_loc3_) / _loc2_;
      }
      
      public function get xpSolo() : Number
      {
         return this._xpSolo;
      }
      
      public function get xpGroup() : Number
      {
         return this._xpGroup;
      }
   }
}

class MonsterData
{
    
   
   public var xp:int;
   
   public var level:int;
   
   public var hiddenLevel:uint;
   
   function MonsterData(param1:int, param2:int, param3:uint)
   {
      super();
      this.xp = param2;
      this.level = param1;
      this.hiddenLevel = param3;
   }
}

class GroupMemberData
{
    
   
   public var level:int;
   
   public var companion:Boolean;
   
   function GroupMemberData(param1:int, param2:Boolean)
   {
      super();
      this.level = param1;
      this.companion = param2;
   }
}

class PlayerData
{
    
   
   public var level:int;
   
   public var wisdom:int;
   
   public var xpBonusPercent:Number;
   
   public var xpRatioMount:Number;
   
   public var xpGuildGivenPercent:Number;
   
   public var xpAlliancePrismBonusPercent:Number;
   
   function PlayerData(param1:int, param2:int = 0, param3:Number = 0, param4:Number = 0, param5:Number = 0, param6:Number = 0)
   {
      super();
      this.level = param1;
      this.wisdom = param2;
      this.xpBonusPercent = param3;
      this.xpRatioMount = param4;
      this.xpGuildGivenPercent = param5;
      this.xpAlliancePrismBonusPercent = param6;
   }
}
