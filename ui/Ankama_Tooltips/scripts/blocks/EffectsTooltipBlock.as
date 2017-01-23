package blocks
{
   import blockParams.EffectsTooltipBlockParameters;
   import com.ankamagames.dofus.datacenter.monsters.Monster;
   import com.ankamagames.dofus.datacenter.monsters.MonsterGrade;
   import com.ankamagames.dofus.internalDatacenter.spells.SpellWrapper;
   
   public class EffectsTooltipBlock
   {
      
      public static const DAMAGE:uint = 0;
      
      public static const RESISTANCE:uint = 1;
      
      public static const SPELL_BOOST:uint = 3;
      
      public static const OTHER:uint = 4;
       
      
      private var _effect:Object;
      
      private var _content:String;
      
      private var _block:Object;
      
      private var _setInfo:String;
      
      private var _showDamages:Boolean;
      
      private var _showTheoreticalEffects:Boolean;
      
      private var _showSpecialEffects:Boolean;
      
      private var _isCriticalEffects:Boolean;
      
      private var _showLabel:Boolean;
      
      private var _showDuration:Boolean;
      
      private var _length:int;
      
      private var _regReplace:RegExp;
      
      public function EffectsTooltipBlock(param1:EffectsTooltipBlockParameters)
      {
         this._regReplace = /([0-9]+)/g;
         super();
         this._effect = param1.effects;
         this._showDamages = param1.showDamages;
         this._showTheoreticalEffects = param1.showTheoreticalEffects;
         this._showSpecialEffects = param1.showSpecialEffects;
         this._isCriticalEffects = param1.isCriticalEffects;
         this._length = param1.length;
         this._showLabel = param1.showLabel;
         this._showDuration = param1.showDuration;
         this._block = Api.tooltip.createTooltipBlock(this.onAllChunkLoaded,this.getContent);
         var _loc2_:Array = new Array(Api.tooltip.createChunkData("subTitle","chunks/base/subTitle.txt"),Api.tooltip.createChunkData("effect","chunks/effect/effect.txt"),Api.tooltip.createChunkData("subEffect","chunks/effect/subEffect.txt"),Api.tooltip.createChunkData("separator","chunks/base/separator.txt"));
         if(param1.setInfo)
         {
            this._setInfo = param1.setInfo;
            _loc2_.unshift(Api.tooltip.createChunkData("setInfo","chunks/text/namelessContent.txt"));
         }
         this._block.initChunk(_loc2_);
      }
      
      public function onAllChunkLoaded() : void
      {
         var _loc1_:Object = null;
         var _loc3_:Array = null;
         var _loc4_:Array = null;
         var _loc6_:String = null;
         var _loc8_:String = null;
         var _loc9_:_EffectPart = null;
         var _loc10_:int = 0;
         this._content = "";
         var _loc2_:Array = new Array();
         for each(_loc1_ in this._effect)
         {
            if(_loc1_.category == -1 || !_loc1_.visibleInTooltip)
            {
               continue;
            }
            switch(_loc1_.effectId)
            {
               case 812:
                  continue;
               default:
                  if(_loc1_.category == 2)
                  {
                     _loc10_ = 0;
                  }
                  else
                  {
                     _loc10_ = 1;
                  }
                  if(!_loc2_[_loc10_])
                  {
                     _loc2_[_loc10_] = new Array();
                  }
                  _loc2_[_loc10_].push(_loc1_);
                  continue;
            }
         }
         _loc3_ = new Array();
         if(_loc2_[0] && this._showDamages)
         {
            _loc3_.push(new _EffectPart#61(!!this._isCriticalEffects?Api.ui.getText("ui.common.criticalDamages"):Api.ui.getText("ui.stats.damagesBonus"),DAMAGE,_loc2_[0]));
         }
         if(_loc2_[1])
         {
            _loc3_.push(new _EffectPart#61(Api.ui.processText(!!this._isCriticalEffects?Api.ui.getText("ui.common.criticalEffects"):Api.ui.getText("ui.common.effects"),"",_loc2_[1].length == 1),SPELL_BOOST,_loc2_[1]));
         }
         if(this._setInfo)
         {
            this._content = this._content + this._block.getChunk("setInfo").processContent({
               "content":this._setInfo,
               "css":"[local.css]tooltip_monster.css"
            });
         }
         var _loc5_:uint = 0;
         var _loc7_:Boolean = true;
         for each(_loc9_ in _loc3_)
         {
            if(_loc7_)
            {
            }
            if(this._showLabel && _loc9_.title)
            {
               this._content = this._content + this._block.getChunk("subTitle").processContent({
                  "text":_loc9_.title + Api.ui.getText("ui.common.colon"),
                  "length":this._length
               });
            }
            for each(_loc1_ in _loc9_.effects)
            {
               this._content = this._content + this.processEffect(_loc9_,_loc1_,"effect");
               _loc5_ = _loc1_.duration;
            }
            _loc7_ = false;
         }
      }
      
      private function processEffect(param1:_EffectPart#61, param2:Object, param3:String, param4:Object = null, param5:Boolean = true) : String
      {
         var _loc7_:* = null;
         var _loc10_:SpellWrapper = null;
         var _loc11_:RegExp = null;
         var _loc12_:Object = null;
         var _loc13_:Monster = null;
         var _loc14_:int = 0;
         var _loc15_:MonsterGrade = null;
         var _loc16_:int = 0;
         var _loc17_:int = 0;
         var _loc18_:int = 0;
         var _loc19_:Object = null;
         var _loc20_:Object = null;
         var _loc21_:Object = null;
         var _loc6_:String = "";
         if(param2.effectId == 1175)
         {
            _loc10_ = Api.data.getSpellWrapper(param2.diceNum,param2.diceSide);
            _loc7_ = _loc10_.spell.description;
         }
         else if(!this._showTheoreticalEffects)
         {
            _loc7_ = param2.description;
         }
         else
         {
            _loc7_ = param2.theoreticalDescription;
         }
         if(!_loc7_)
         {
            return "";
         }
         if(!param4)
         {
            param4 = new Object();
         }
         var _loc8_:* = null;
         if(this._showDuration)
         {
            if(param2.durationString)
            {
               _loc8_ = " (" + param2.durationString + ")";
            }
         }
         var _loc9_:String = "p";
         if(param2.category != 2)
         {
            if(param1.type == SPELL_BOOST)
            {
               if(param2.bonusType == -1)
               {
                  _loc9_ = "malus";
               }
               else if(param2.bonusType == 1)
               {
                  _loc9_ = "bonus";
               }
            }
         }
         else if(param1.type == DAMAGE)
         {
            _loc9_ = "damages";
         }
         if(param2.trigger)
         {
            _loc7_ = Api.ui.getText("ui.spell.trigger",_loc7_);
         }
         if(_loc8_)
         {
            _loc7_ = "• " + _loc7_ + _loc8_;
         }
         else
         {
            _loc7_ = "• " + _loc7_;
         }
         if(param2.targetMask && param2.targetMask.length && (param2.targetMask.indexOf("i") != -1 || param2.targetMask.indexOf("s") != -1 || param2.targetMask.indexOf("I") != -1 || param2.targetMask.indexOf("S") != -1 || param2.targetMask.indexOf("j") != -1 || param2.targetMask.indexOf("J") != -1))
         {
            _loc11_ = new RegExp(/^[iIsSjJfFeE0-9,]+$/);
            _loc12_ = _loc11_.exec(param2.targetMask);
            if(_loc12_)
            {
               _loc7_ = _loc7_ + " (" + Api.ui.getText("ui.common.summon") + ")";
            }
         }
         param4.text = _loc7_;
         param4.cssClass = _loc9_;
         param4.length = this._length;
         _loc6_ = _loc6_ + this._block.getChunk(param3).processContent(param4);
         if(param5)
         {
            if(param2.effectId == 181 || param2.effectId == 405 || param2.effectId == 2796 || param2.effectId == 1011)
            {
               _loc13_ = Api.data.getMonsterFromId(int(param2.parameter0));
               if(_loc13_)
               {
                  _loc14_ = int(param2.parameter1);
                  if(_loc14_ < 1 || _loc14_ > _loc13_.grades.length)
                  {
                     _loc14_ = _loc13_.grades.length;
                  }
                  _loc15_ = _loc13_.grades[_loc14_ - 1];
                  _loc16_ = 1;
                  if(Api.player.getPlayedCharacterInfo())
                  {
                     _loc16_ = Api.player.getPlayedCharacterInfo().level;
                  }
                  _loc17_ = Math.floor(_loc15_.lifePoints + _loc15_.lifePoints * _loc16_ / 100);
                  _loc6_ = _loc6_ + this._block.getChunk("subEffect").processContent({
                     "text":"• " + Api.ui.getText("ui.stats.HP") + Api.ui.getText("ui.common.colon") + _loc17_,
                     "rightText":"• " + Api.ui.getText("ui.stats.neutralReductionPercent") + Api.ui.getText("ui.common.colon") + _loc15_.neutralResistance,
                     "rightTextVisible":true
                  });
                  _loc6_ = _loc6_ + this._block.getChunk("subEffect").processContent({
                     "text":"• " + Api.ui.getText("ui.stats.shortAP") + Api.ui.getText("ui.common.colon") + _loc15_.actionPoints,
                     "rightText":"• " + Api.ui.getText("ui.stats.earthReductionPercent") + Api.ui.getText("ui.common.colon") + _loc15_.earthResistance,
                     "rightTextVisible":true
                  });
                  _loc6_ = _loc6_ + this._block.getChunk("subEffect").processContent({
                     "text":"• " + Api.ui.getText("ui.stats.shortMP") + Api.ui.getText("ui.common.colon") + _loc15_.movementPoints,
                     "rightText":"• " + Api.ui.getText("ui.stats.fireReductionPercent") + Api.ui.getText("ui.common.colon") + _loc15_.fireResistance,
                     "rightTextVisible":true
                  });
                  _loc18_ = Math.floor((_loc15_.wisdom + _loc15_.wisdom * _loc16_ / 100) / 10);
                  _loc6_ = _loc6_ + this._block.getChunk("subEffect").processContent({
                     "text":"• " + Api.ui.getText("ui.stats.dodgeAP") + Api.ui.getText("ui.common.colon") + (_loc15_.paDodge + _loc18_),
                     "rightText":"• " + Api.ui.getText("ui.stats.waterReductionPercent") + Api.ui.getText("ui.common.colon") + _loc15_.waterResistance,
                     "rightTextVisible":true
                  });
                  _loc6_ = _loc6_ + this._block.getChunk("subEffect").processContent({
                     "text":"• " + Api.ui.getText("ui.stats.dodgeMP") + Api.ui.getText("ui.common.colon") + (_loc15_.pmDodge + _loc18_),
                     "rightText":"• " + Api.ui.getText("ui.stats.airReductionPercent") + Api.ui.getText("ui.common.colon") + _loc15_.airResistance,
                     "rightTextVisible":true
                  });
               }
            }
            if(param2.effectId == 400 || param2.effectId == 401 || param2.effectId == 1008 || param2.effectId == 402 || param2.effectId == 1091)
            {
               if(param2.effectId != 1008)
               {
                  _loc19_ = Api.data.getSpellWrapper(int(param2.parameter0),int(param2.parameter1));
               }
               else
               {
                  _loc21_ = Api.data.getBomb(int(param2.parameter0));
                  _loc19_ = Api.data.getSpellWrapper(_loc21_.explodSpellId,int(param2.parameter1));
               }
               for each(_loc20_ in _loc19_.effects)
               {
                  if(_loc20_.visibleInTooltip)
                  {
                     _loc6_ = _loc6_ + this.processEffect(param1,_loc20_,"subEffect",{"rightTextVisible":false},false);
                  }
               }
            }
         }
         return _loc6_;
      }
      
      public function getContent() : String
      {
         return this._content;
      }
      
      public function get block() : Object
      {
         return this._block;
      }
   }
}

class _EffectPart#61
{
    
   
   public var title:String;
   
   public var type:uint;
   
   public var effects:Array;
   
   function _EffectPart#61(param1:String, param2:uint, param3:Array)
   {
      super();
      this.title = param1;
      this.type = param2;
      this.effects = param3;
   }
}
