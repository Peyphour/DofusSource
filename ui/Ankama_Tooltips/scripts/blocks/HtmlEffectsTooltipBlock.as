package blocks
{
   import blockParams.EffectsTooltipBlockParameters;
   import com.ankamagames.dofus.datacenter.effects.instances.EffectInstanceDice;
   import com.ankamagames.dofus.datacenter.effects.instances.EffectInstanceMinMax;
   import com.ankamagames.dofus.datacenter.monsters.Monster;
   import com.ankamagames.dofus.datacenter.monsters.MonsterGrade;
   import com.ankamagames.dofus.internalDatacenter.spells.SpellWrapper;
   
   public class HtmlEffectsTooltipBlock
   {
      
      public static const DAMAGE:uint = 0;
      
      public static const RESISTANCE:uint = 1;
      
      public static const SPELL_BOOST:uint = 3;
      
      public static const OTHER:uint = 4;
       
      
      private var _effect:Object;
      
      private var _content:String;
      
      private var _block:Object;
      
      private var _setInfo:String;
      
      private var _splitDamageAndEffects:Boolean;
      
      private var _itemTheoreticalEffects:Array;
      
      private var _showDamages:Boolean;
      
      private var _showTheoreticalEffects:Boolean;
      
      private var _addTheoricalEffects:Boolean;
      
      private var _isCriticalEffects:Boolean;
      
      private var _showLabel:Boolean;
      
      private var _showDuration:Boolean;
      
      private var _length:int;
      
      private var _exoticEffects:Array;
      
      private var _missingEffects:Array;
      
      private var _exoticDamage:Array;
      
      private var _missingDamage:Array;
      
      private var _regReplace:RegExp;
      
      public function HtmlEffectsTooltipBlock(param1:EffectsTooltipBlockParameters)
      {
         var _loc3_:* = undefined;
         this._regReplace = /([0-9]+)/g;
         super();
         this._effect = param1.effects;
         this._showDamages = param1.showDamages;
         this._showTheoreticalEffects = param1.showTheoreticalEffects;
         this._addTheoricalEffects = param1.addTheoreticalEffects;
         this._isCriticalEffects = param1.isCriticalEffects;
         this._length = param1.length;
         this._showLabel = param1.showLabel;
         this._showDuration = param1.showDuration;
         this._splitDamageAndEffects = param1.splitDamageAndEffects;
         if(param1.itemTheoreticalEffects)
         {
            this._itemTheoreticalEffects = [];
            for each(_loc3_ in param1.itemTheoreticalEffects)
            {
               if(!this._itemTheoreticalEffects[_loc3_.effectId])
               {
                  this._itemTheoreticalEffects[_loc3_.effectId] = [];
               }
               this._itemTheoreticalEffects[_loc3_.effectId].push(_loc3_);
            }
         }
         this._block = Api.tooltip.createTooltipBlock(this.onAllChunkLoaded,this.getContent);
         var _loc2_:Array = new Array(Api.tooltip.createChunkData("separator",param1.chunkType + "/base/separator.txt"),Api.tooltip.createChunkData("subTitle",param1.chunkType + "/base/subTitle.txt"),Api.tooltip.createChunkData("effect",param1.chunkType + "/effect/effect.txt"),Api.tooltip.createChunkData("subEffect",param1.chunkType + "/effect/subEffect.txt"));
         if(param1.setInfo)
         {
            this._setInfo = param1.setInfo;
            _loc2_.unshift(Api.tooltip.createChunkData("namelessContent",param1.chunkType + "/text/namelessContent.txt"));
         }
         this._block.initChunk(_loc2_);
      }
      
      public function onAllChunkLoaded() : void
      {
         var _loc1_:* = undefined;
         var _loc5_:Array = null;
         var _loc7_:String = null;
         var _loc9_:_EffectPart = null;
         var _loc10_:int = 0;
         var _loc11_:* = false;
         var _loc12_:Array = null;
         var _loc13_:int = 0;
         var _loc14_:Array = null;
         this._content = "";
         this._exoticEffects = new Array();
         this._missingEffects = new Array();
         this._exoticDamage = new Array();
         this._missingDamage = new Array();
         var _loc2_:Array = new Array();
         var _loc3_:Array = new Array();
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
                  _loc10_ = 1;
                  if(_loc1_.category == 2)
                  {
                     _loc10_ = 0;
                  }
                  if(!_loc2_[_loc10_])
                  {
                     _loc2_[_loc10_] = new Array();
                  }
                  _loc3_[_loc1_.effectId] = _loc1_;
                  if(this._itemTheoreticalEffects)
                  {
                     _loc11_ = this._itemTheoreticalEffects[_loc1_.effectId] == null;
                     if(_loc11_ && _loc1_.showInSet)
                     {
                        if(_loc1_.category == 2)
                        {
                           this._exoticDamage.push(_loc1_);
                        }
                        else
                        {
                           this._exoticEffects.push(_loc1_);
                        }
                        continue;
                     }
                  }
                  _loc2_[_loc10_].push(_loc1_);
                  continue;
            }
         }
         if(this._itemTheoreticalEffects && this._addTheoricalEffects)
         {
            for each(_loc12_ in this._itemTheoreticalEffects)
            {
               _loc13_ = 0;
               while(_loc13_ < _loc12_.length)
               {
                  _loc1_ = _loc12_[_loc13_];
                  if(!_loc3_[_loc1_.effectId] && _loc1_.showInSet)
                  {
                     if(_loc1_.category == 2)
                     {
                        this._missingDamage.push(_loc1_);
                     }
                     else
                     {
                        this._missingEffects.push(_loc1_);
                     }
                  }
                  _loc13_++;
               }
            }
         }
         if(!_loc2_.length)
         {
            return;
         }
         var _loc4_:Array = new Array();
         if(this._splitDamageAndEffects)
         {
            if(_loc2_[0] && this._exoticDamage && this._exoticDamage.length)
            {
               _loc2_[0] = this._exoticDamage.concat(_loc2_[0]);
            }
            if(_loc2_[0] && this._missingDamage && this._missingDamage.length)
            {
               _loc2_[0] = _loc2_[0].concat(this._missingDamage);
            }
            if(_loc2_[0] && this._showDamages)
            {
               _loc4_.push(new _EffectPart#71(!!this._isCriticalEffects?Api.ui.getText("ui.common.criticalDamages"):Api.ui.getText("ui.stats.damagesBonus"),DAMAGE,_loc2_[0]));
            }
            if(_loc2_[1] && this._exoticEffects && this._exoticEffects.length)
            {
               _loc2_[1] = this._exoticEffects.concat(_loc2_[1]);
            }
            if(_loc2_[1] && this._missingEffects && this._missingEffects.length)
            {
               _loc2_[1] = _loc2_[1].concat(this._missingEffects);
            }
            if(_loc2_[1])
            {
               _loc4_.push(new _EffectPart#71(Api.ui.processText(!!this._isCriticalEffects?Api.ui.getText("ui.common.criticalEffects"):Api.ui.getText("ui.common.effects"),"",_loc2_[1].length == 1),SPELL_BOOST,_loc2_[1]));
            }
         }
         else
         {
            _loc14_ = [];
            if(_loc2_[0])
            {
               _loc14_ = _loc2_[0];
            }
            if(_loc2_[1])
            {
               _loc14_ = _loc14_.concat(_loc2_[1]);
            }
            _loc4_.push(new _EffectPart#71(Api.ui.processText(!!this._isCriticalEffects?Api.ui.getText("ui.common.criticalEffects"):Api.ui.getText("ui.common.effects"),"",_loc14_.length == 1),SPELL_BOOST,_loc14_));
         }
         if(this._setInfo)
         {
            this._content = this._content + this._block.getChunk("namelessContent").processContent({
               "content":this._setInfo,
               "css":"[local.css]tooltip_monster.css"
            });
         }
         var _loc6_:uint = 0;
         var _loc8_:Boolean = true;
         for each(_loc9_ in _loc4_)
         {
            if(this._showLabel && _loc9_.title)
            {
               if(!_loc8_)
               {
                  this._content = this._content + this._block.getChunk("separator").processContent({});
               }
               this._content = this._content + this._block.getChunk("subTitle").processContent({"text":_loc9_.title});
            }
            for each(_loc1_ in _loc9_.effects)
            {
               if(_loc1_)
               {
                  this._content = this._content + this.processEffect(_loc9_,_loc1_,"effect");
                  _loc6_ = _loc1_.duration;
               }
            }
            _loc8_ = false;
         }
         this._exoticEffects = null;
         this._missingEffects = null;
         this._exoticDamage = null;
         this._missingDamage;
         this._itemTheoreticalEffects = null;
      }
      
      private function processEffect(param1:_EffectPart#71, param2:Object, param3:String, param4:Object = null, param5:Boolean = true) : String
      {
         var _loc12_:SpellWrapper = null;
         var _loc13_:* = undefined;
         var _loc14_:String = null;
         var _loc15_:RegExp = null;
         var _loc16_:Object = null;
         var _loc17_:Monster = null;
         var _loc18_:int = 0;
         var _loc19_:MonsterGrade = null;
         var _loc20_:int = 0;
         var _loc21_:int = 0;
         var _loc22_:int = 0;
         var _loc23_:Object = null;
         var _loc24_:Object = null;
         var _loc25_:Object = null;
         if(!param2)
         {
            return "";
         }
         var _loc6_:String = "";
         var _loc7_:String = "";
         if(param2.effectId == 1175)
         {
            _loc12_ = Api.data.getSpellWrapper(param2.diceNum,param2.diceSide);
            _loc7_ = _loc7_ + _loc12_.spell.description;
         }
         else if(!this._showTheoreticalEffects)
         {
            _loc7_ = _loc7_ + (!!param2.showInSet?param2.descriptionForTooltip:param2.description);
         }
         else
         {
            _loc7_ = _loc7_ + (!!param2.showInSet?param2.theoreticalDescriptionForTooltip:param2.theoreticalDescription);
         }
         if(!_loc7_ || _loc7_ == "null")
         {
            return "";
         }
         var _loc8_:String = "bonus";
         var _loc9_:String = param2.description;
         if(param2.category != 2)
         {
            if(param1.type == SPELL_BOOST)
            {
               if(param2.bonusType == -1 || _loc9_ && _loc9_.charAt(0) == "-")
               {
                  if(_loc7_.indexOf("<span class=\'#valueCssClass\'>-") == 0)
                  {
                     _loc7_ = _loc7_.replace("<span class=\'#valueCssClass\'>-","<span class=\'#valueCssClass\'>- ");
                  }
                  _loc8_ = "malus";
               }
            }
         }
         if(this._exoticEffects && this._exoticEffects.indexOf(param2) != -1 || this._exoticDamage && this._exoticDamage.indexOf(param2) != -1)
         {
            _loc8_ = "exotic";
         }
         else if(this._missingEffects && this._missingEffects.indexOf(param2) != -1 || this._missingDamage && this._missingDamage.indexOf(param2) != -1)
         {
            _loc8_ = "theoretical";
         }
         var _loc10_:* = _loc8_ + "value";
         var _loc11_:* = null;
         if(this._showDuration)
         {
            if(param2.durationString)
            {
               _loc11_ = " (" + param2.durationString + ")";
            }
         }
         if(param2.trigger)
         {
            _loc7_ = Api.ui.getText("ui.spell.trigger",_loc7_);
         }
         if(_loc11_)
         {
            _loc7_ = _loc7_ + _loc11_;
         }
         if(this._addTheoricalEffects && param2.showInSet && (!this._missingEffects || this._missingEffects.indexOf(param2) == -1) && this._itemTheoreticalEffects && this._itemTheoreticalEffects[param2.effectId] && this._itemTheoreticalEffects[param2.effectId].length)
         {
            _loc13_ = this._itemTheoreticalEffects[param2.effectId][0];
            if(_loc13_ && (_loc13_ is EffectInstanceMinMax || _loc13_ is EffectInstanceDice))
            {
               if(param1.type != DAMAGE || param1.type == DAMAGE && _loc13_.description != param2.description)
               {
                  _loc14_ = _loc13_.theoreticalShortDescriptionForTooltip;
                  if(_loc14_)
                  {
                     _loc7_ = _loc7_ + ("  <span class=\'theoretical\'>&#91; " + _loc14_ + " &#93;</span>");
                  }
               }
            }
         }
         if(param2.targetMask && param2.targetMask.length && (param2.targetMask.indexOf("i") != -1 || param2.targetMask.indexOf("s") != -1 || param2.targetMask.indexOf("I") != -1 || param2.targetMask.indexOf("S") != -1 || param2.targetMask.indexOf("j") != -1 || param2.targetMask.indexOf("J") != -1))
         {
            _loc15_ = new RegExp(/^[iIsSjJfFeE0-9,]+$/);
            _loc16_ = _loc15_.exec(param2.targetMask);
            if(_loc16_)
            {
               _loc7_ = _loc7_ + (" (" + Api.ui.getText("ui.common.summon") + ")");
            }
         }
         if(!param4)
         {
            param4 = new Object();
         }
         param4.text = _loc7_;
         param4.cssClass = _loc8_;
         param4.li = "";
         _loc6_ = _loc6_ + this._block.getChunk(param3).processContent(param4,{"valueCssClass":_loc10_});
         if(param5)
         {
            if(param2.effectId == 181 || param2.effectId == 405 || param2.effectId == 2796 || param2.effectId == 1011)
            {
               _loc17_ = Api.data.getMonsterFromId(int(param2.parameter0));
               if(_loc17_)
               {
                  _loc18_ = int(param2.parameter1);
                  if(_loc18_ < 1 || _loc18_ > _loc17_.grades.length)
                  {
                     _loc18_ = _loc17_.grades.length;
                  }
                  _loc19_ = _loc17_.grades[_loc18_ - 1];
                  _loc20_ = 1;
                  if(Api.player.getPlayedCharacterInfo())
                  {
                     _loc20_ = Api.player.getPlayedCharacterInfo().level;
                  }
                  _loc21_ = Math.floor(_loc19_.lifePoints + _loc19_.lifePoints * _loc20_ / 100);
                  _loc6_ = _loc6_ + this._block.getChunk("subEffect").processContent({
                     "text":Api.ui.getText("ui.stats.HP") + Api.ui.getText("ui.common.colon") + "<span class=\'#valueCssClass\'>" + _loc21_ + "</span>",
                     "rightText":Api.ui.getText("ui.stats.neutralReductionPercent") + Api.ui.getText("ui.common.colon") + "<span class=\'#valueCssClass\'>" + _loc19_.neutralResistance + "</span>"
                  },{"valueCssClass":"value"});
                  _loc6_ = _loc6_ + this._block.getChunk("subEffect").processContent({
                     "text":Api.ui.getText("ui.stats.shortAP") + Api.ui.getText("ui.common.colon") + "<span class=\'#valueCssClass\'>" + _loc19_.actionPoints + "</span>",
                     "rightText":Api.ui.getText("ui.stats.earthReductionPercent") + Api.ui.getText("ui.common.colon") + "<span class=\'#valueCssClass\'>" + _loc19_.earthResistance + "</span>"
                  },{"valueCssClass":"value"});
                  _loc6_ = _loc6_ + this._block.getChunk("subEffect").processContent({
                     "text":Api.ui.getText("ui.stats.shortMP") + Api.ui.getText("ui.common.colon") + "<span class=\'#valueCssClass\'>" + _loc19_.movementPoints + "</span>",
                     "rightText":Api.ui.getText("ui.stats.fireReductionPercent") + Api.ui.getText("ui.common.colon") + "<span class=\'#valueCssClass\'>" + _loc19_.fireResistance + "</span>"
                  },{"valueCssClass":"value"});
                  _loc22_ = Math.floor((_loc19_.wisdom + _loc19_.wisdom * _loc20_ / 100) / 10);
                  _loc6_ = _loc6_ + this._block.getChunk("subEffect").processContent({
                     "text":Api.ui.getText("ui.stats.dodgeAP") + Api.ui.getText("ui.common.colon") + "<span class=\'#valueCssClass\'>" + (_loc19_.paDodge + _loc22_) + "</span>",
                     "rightText":Api.ui.getText("ui.stats.waterReductionPercent") + Api.ui.getText("ui.common.colon") + "<span class=\'#valueCssClass\'>" + _loc19_.waterResistance + "</span>"
                  },{"valueCssClass":"value"});
                  _loc6_ = _loc6_ + this._block.getChunk("subEffect").processContent({
                     "text":Api.ui.getText("ui.stats.dodgeMP") + Api.ui.getText("ui.common.colon") + "<span class=\'#valueCssClass\'>" + (_loc19_.pmDodge + _loc22_) + "</span>",
                     "rightText":Api.ui.getText("ui.stats.airReductionPercent") + Api.ui.getText("ui.common.colon") + "<span class=\'#valueCssClass\'>" + _loc19_.airResistance + "</span>"
                  },{"valueCssClass":"value"});
               }
            }
            if(param2.effectId == 400 || param2.effectId == 401 || param2.effectId == 1008 || param2.effectId == 402 || param2.effectId == 1091)
            {
               if(param2.effectId != 1008)
               {
                  _loc23_ = Api.data.getSpellWrapper(int(param2.parameter0),int(param2.parameter1));
               }
               else
               {
                  _loc25_ = Api.data.getBomb(int(param2.parameter0));
                  _loc23_ = Api.data.getSpellWrapper(_loc25_.explodSpellId,int(param2.parameter1));
               }
               for each(_loc24_ in _loc23_.effects)
               {
                  if(_loc24_.visibleInTooltip)
                  {
                     _loc6_ = _loc6_ + this.processEffect(param1,_loc24_,"subEffect",{"rightText":""},false);
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

class _EffectPart#71
{
    
   
   public var title:String;
   
   public var type:uint;
   
   public var effects:Array;
   
   function _EffectPart#71(param1:String, param2:uint, param3:Array)
   {
      super();
      this.title = param1;
      this.type = param2;
      this.effects = param3;
   }
}
