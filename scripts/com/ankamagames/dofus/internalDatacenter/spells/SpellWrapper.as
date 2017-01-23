package com.ankamagames.dofus.internalDatacenter.spells
{
   import com.ankamagames.berilia.components.Slot;
   import com.ankamagames.berilia.interfaces.IClonable;
   import com.ankamagames.berilia.managers.SecureCenter;
   import com.ankamagames.berilia.managers.SlotDataHolderManager;
   import com.ankamagames.dofus.datacenter.effects.EffectInstance;
   import com.ankamagames.dofus.datacenter.effects.instances.EffectInstanceDice;
   import com.ankamagames.dofus.datacenter.spells.Spell;
   import com.ankamagames.dofus.datacenter.spells.SpellLevel;
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.logic.game.fight.frames.FightContextFrame;
   import com.ankamagames.dofus.logic.game.fight.managers.CurrentPlayedFighterManager;
   import com.ankamagames.dofus.network.enums.CharacterSpellModificationTypeEnum;
   import com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic;
   import com.ankamagames.dofus.network.types.game.character.characteristic.CharacterCharacteristicsInformations;
   import com.ankamagames.dofus.network.types.game.character.characteristic.CharacterSpellModification;
   import com.ankamagames.dofus.uiApi.PlayedCharacterApi;
   import com.ankamagames.jerakine.data.XmlConfig;
   import com.ankamagames.jerakine.interfaces.IDataCenter;
   import com.ankamagames.jerakine.interfaces.ISlotData;
   import com.ankamagames.jerakine.interfaces.ISlotDataHolder;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.types.Uri;
   import com.ankamagames.jerakine.utils.display.spellZone.ICellZoneProvider;
   import com.ankamagames.jerakine.utils.display.spellZone.IZoneShape;
   import flash.utils.Dictionary;
   import flash.utils.Proxy;
   import flash.utils.flash_proxy;
   import flash.utils.getQualifiedClassName;
   
   public dynamic class SpellWrapper extends Proxy implements ISlotData, IClonable, ICellZoneProvider, IDataCenter
   {
      
      private static var _cache:Array = new Array();
      
      private static var _playersCache:Dictionary = new Dictionary();
      
      private static var _cac:SpellWrapper;
      
      private static var _errorIconUri:Uri;
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(SpellWrapper));
      
      public static const BASE_DAMAGE_EFFECT_IDS:Array = new Array(100,95,96,97,98,99,92,93,94,95,1012,1013,1014,1015,1016);
       
      
      private var _uri:Uri;
      
      private var _slotDataHolderManager:SlotDataHolderManager;
      
      private var _spellLevel:SpellLevel;
      
      private var _canTargetCasterOutOfZone:Object;
      
      private var _variantActivated:Boolean;
      
      public var id:uint = 0;
      
      public var spellLevel:int;
      
      public var effects:Vector.<EffectInstance>;
      
      public var criticalEffect:Vector.<EffectInstance>;
      
      public var gfxId:int;
      
      public var playerId:Number;
      
      public var versionNum:int;
      
      private var _actualCooldown:uint = 0;
      
      public function SpellWrapper()
      {
         super();
      }
      
      public static function create(param1:uint, param2:int, param3:Boolean = true, param4:Number = 0, param5:Boolean = false) : SpellWrapper
      {
         var _loc6_:SpellWrapper = null;
         var _loc8_:EffectInstance = null;
         var _loc9_:CharacterSpellModification = null;
         var _loc10_:CharacterSpellModification = null;
         var _loc11_:CharacterSpellModification = null;
         var _loc12_:int = 0;
         if(param1 == 0)
         {
            param3 = false;
         }
         if(param3)
         {
            if(_cache[param1] && !param4)
            {
               _loc6_ = _cache[param1];
            }
            else if(_playersCache[param4] && _playersCache[param4][param1])
            {
               _loc6_ = _playersCache[param4][param1];
            }
         }
         if(param1 == 0 && _cac != null)
         {
            _loc6_ = _cac;
         }
         if(!_loc6_)
         {
            _loc6_ = new SpellWrapper();
            _loc6_.id = param1;
            if(param3)
            {
               if(param4)
               {
                  if(!_playersCache[param4])
                  {
                     _playersCache[param4] = new Array();
                  }
                  if(!_playersCache[param4][param1])
                  {
                     _playersCache[param4][param1] = _loc6_;
                  }
               }
               else
               {
                  _cache[param1] = _loc6_;
               }
            }
            _loc6_._slotDataHolderManager = new SlotDataHolderManager(_loc6_);
         }
         if(param1 == 0 && !_cac)
         {
            _cac = _loc6_;
         }
         _loc6_.id = param1;
         _loc6_.gfxId = param1;
         _loc6_.spellLevel = param2;
         _loc6_.variantActivated = param5;
         _loc6_.playerId = param4;
         _loc6_.effects = new Vector.<EffectInstance>();
         _loc6_.criticalEffect = new Vector.<EffectInstance>();
         var _loc7_:Spell = Spell.getSpellById(param1);
         if(!_loc7_)
         {
            return null;
         }
         if(_loc7_.useSpellLevelScaling && !param2)
         {
            param2 = _loc6_.spellLevel = PlayedCharacterManager.getInstance().limitedLevel;
         }
         _loc6_._spellLevel = _loc7_.getSpellLevel(param2);
         for each(_loc8_ in _loc6_._spellLevel.effects)
         {
            _loc8_ = _loc8_.clone();
            if(_loc8_.category == 2 && BASE_DAMAGE_EFFECT_IDS.indexOf(_loc8_.effectId) != -1)
            {
               _loc9_ = CurrentPlayedFighterManager.getInstance().getSpellModifications(param1,CharacterSpellModificationTypeEnum.BASE_DAMAGE);
               if(_loc9_ && _loc8_ is EffectInstanceDice)
               {
                  _loc12_ = _loc9_.value.alignGiftBonus + _loc9_.value.base + _loc9_.value.contextModif + _loc9_.value.objectsAndMountBonus;
                  (_loc8_ as EffectInstanceDice).diceNum = (_loc8_ as EffectInstanceDice).diceNum + _loc12_;
                  if((_loc8_ as EffectInstanceDice).diceSide > 0)
                  {
                     (_loc8_ as EffectInstanceDice).diceSide = (_loc8_ as EffectInstanceDice).diceSide + _loc12_;
                  }
               }
               _loc10_ = CurrentPlayedFighterManager.getInstance().getSpellModifications(param1,CharacterSpellModificationTypeEnum.DAMAGE);
               _loc11_ = CurrentPlayedFighterManager.getInstance().getSpellModifications(param1,CharacterSpellModificationTypeEnum.HEAL_BONUS);
               if(_loc10_)
               {
                  _loc8_.modificator = _loc10_.value.alignGiftBonus + _loc10_.value.base + _loc10_.value.contextModif + _loc10_.value.objectsAndMountBonus;
               }
               else if(_loc11_)
               {
                  _loc8_.modificator = _loc11_.value.alignGiftBonus + _loc11_.value.base + _loc11_.value.contextModif + _loc11_.value.objectsAndMountBonus;
               }
            }
            _loc6_.effects.push(_loc8_);
         }
         for each(_loc8_ in _loc6_._spellLevel.criticalEffect)
         {
            _loc8_ = _loc8_.clone();
            if(_loc8_.category == 2 && BASE_DAMAGE_EFFECT_IDS.indexOf(_loc8_.effectId) != -1)
            {
               _loc9_ = CurrentPlayedFighterManager.getInstance().getSpellModifications(param1,CharacterSpellModificationTypeEnum.BASE_DAMAGE);
               if(_loc9_ && _loc8_ is EffectInstanceDice)
               {
                  _loc12_ = _loc9_.value.alignGiftBonus + _loc9_.value.base + _loc9_.value.contextModif + _loc9_.value.objectsAndMountBonus;
                  (_loc8_ as EffectInstanceDice).diceNum = (_loc8_ as EffectInstanceDice).diceNum + _loc12_;
                  if((_loc8_ as EffectInstanceDice).diceSide > 0)
                  {
                     (_loc8_ as EffectInstanceDice).diceSide = (_loc8_ as EffectInstanceDice).diceSide + _loc12_;
                  }
               }
               _loc10_ = CurrentPlayedFighterManager.getInstance().getSpellModifications(param1,CharacterSpellModificationTypeEnum.DAMAGE);
               _loc11_ = CurrentPlayedFighterManager.getInstance().getSpellModifications(param1,CharacterSpellModificationTypeEnum.HEAL_BONUS);
               if(_loc10_)
               {
                  _loc8_.modificator = _loc10_.value.alignGiftBonus + _loc10_.value.base + _loc10_.value.contextModif + _loc10_.value.objectsAndMountBonus;
               }
               else if(_loc11_)
               {
                  _loc8_.modificator = _loc11_.value.alignGiftBonus + _loc11_.value.base + _loc11_.value.contextModif + _loc11_.value.objectsAndMountBonus;
               }
            }
            _loc6_.criticalEffect.push(_loc8_);
         }
         return _loc6_;
      }
      
      public static function getSpellWrapperById(param1:uint, param2:Number) : SpellWrapper
      {
         if(param2 != 0)
         {
            if(!_playersCache[param2])
            {
               return null;
            }
            if(!_playersCache[param2][param1] && _cache[param1])
            {
               _playersCache[param2][param1] = _cache[param1].clone();
            }
            if(param1 == 0)
            {
               return _cac;
            }
            return _playersCache[param2][param1];
         }
         return _cache[param1];
      }
      
      public static function refreshAllPlayerSpellHolder(param1:Number) : void
      {
         var _loc2_:SpellWrapper = null;
         for each(_loc2_ in _playersCache[param1])
         {
            _loc2_._slotDataHolderManager.refreshAll();
         }
         if(_cac)
         {
            _cac._slotDataHolderManager.refreshAll();
         }
      }
      
      public static function resetAllCoolDown(param1:Number, param2:Object) : void
      {
         var _loc3_:SpellWrapper = null;
         SecureCenter.checkAccessKey(param2);
         for each(_loc3_ in _playersCache[param1])
         {
            _loc3_.actualCooldown = 0;
         }
      }
      
      public static function removeAllSpellWrapperBut(param1:Number, param2:Object) : void
      {
         var _loc4_:* = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         SecureCenter.checkAccessKey(param2);
         var _loc3_:Array = new Array();
         for(_loc4_ in _playersCache)
         {
            if(Number(_loc4_) != param1)
            {
               _loc3_.push(_loc4_);
            }
         }
         _loc5_ = _loc3_.length;
         _loc6_ = -1;
         while(++_loc6_ < _loc5_)
         {
            delete _playersCache[_loc3_[_loc6_]];
         }
      }
      
      public static function removeAllSpellWrapper() : void
      {
         _playersCache = new Dictionary();
         _cache = new Array();
      }
      
      public function set actualCooldown(param1:uint) : void
      {
         this._actualCooldown = param1;
         this._slotDataHolderManager.refreshAll();
      }
      
      public function get actualCooldown() : uint
      {
         return !!PlayedCharacterManager.getInstance().isFighting?uint(this._actualCooldown):uint(0);
      }
      
      public function get spellLevelInfos() : SpellLevel
      {
         return this._spellLevel;
      }
      
      public function get variantActivated() : Boolean
      {
         return this._variantActivated;
      }
      
      public function set variantActivated(param1:Boolean) : void
      {
         this._variantActivated = param1;
      }
      
      public function get minimalRange() : uint
      {
         return this["minRange"];
      }
      
      public function get maximalRange() : uint
      {
         return this["range"];
      }
      
      public function get castZoneInLine() : Boolean
      {
         return this["castInLine"];
      }
      
      public function get castZoneInDiagonal() : Boolean
      {
         return this["castInDiagonal"];
      }
      
      public function get spellZoneEffects() : Vector.<IZoneShape>
      {
         if(this.id != 0 || !PlayedCharacterManager.getInstance().currentWeapon)
         {
            if(this._spellLevel)
            {
               return this._spellLevel.spellZoneEffects;
            }
         }
         return null;
      }
      
      public function get hideEffects() : Boolean
      {
         if(this.id == 0 && PlayedCharacterManager.getInstance().currentWeapon != null)
         {
            return (PlayedCharacterManager.getInstance().currentWeapon as ItemWrapper).hideEffects;
         }
         if(this._spellLevel)
         {
            return this._spellLevel.hideEffects;
         }
         return false;
      }
      
      public function get backGroundIconUri() : Uri
      {
         if(this.id == 0 && PlayedCharacterManager.getInstance().currentWeapon != null)
         {
            return new Uri(XmlConfig.getInstance().getEntry("config.content.path").concat("gfx/spells/all.swf|noIcon"));
         }
         return null;
      }
      
      public function get iconUri() : Uri
      {
         return this.fullSizeIconUri;
      }
      
      public function get fullSizeIconUri() : Uri
      {
         if(!this._uri || this.id == 0)
         {
            if(this.id == 0 && PlayedCharacterManager.getInstance().currentWeapon != null)
            {
               this._uri = new Uri(XmlConfig.getInstance().getEntry("config.gfx.path.spells").concat("all.swf|weapon_").concat(PlayedCharacterManager.getInstance().currentWeapon.typeId));
            }
            else
            {
               this._uri = new Uri(XmlConfig.getInstance().getEntry("config.gfx.path.spells").concat("all.swf|sort_").concat(!!this.spell?this.spell.iconId:0));
            }
            this._uri.tag = Slot.NEED_CACHE_AS_BITMAP;
         }
         return this._uri;
      }
      
      public function get errorIconUri() : Uri
      {
         if(!_errorIconUri)
         {
            _errorIconUri = new Uri(XmlConfig.getInstance().getEntry("config.gfx.path.spells").concat("all.swf|noIcon"));
         }
         return _errorIconUri;
      }
      
      public function get info1() : String
      {
         if(this.actualCooldown == 0 || !PlayedCharacterManager.getInstance().isFighting)
         {
            return null;
         }
         if(this.actualCooldown == 63)
         {
            return "-";
         }
         return this.actualCooldown.toString();
      }
      
      public function get startTime() : int
      {
         return 0;
      }
      
      public function get endTime() : int
      {
         return 0;
      }
      
      public function set endTime(param1:int) : void
      {
      }
      
      public function get timer() : int
      {
         return 0;
      }
      
      public function get active() : Boolean
      {
         if(!PlayedCharacterManager.getInstance().isFighting)
         {
            return true;
         }
         var _loc1_:Boolean = CurrentPlayedFighterManager.getInstance().canCastThisSpell(this.spellId,this.spellLevel);
         return _loc1_;
      }
      
      public function get spell() : Spell
      {
         return Spell.getSpellById(this.id);
      }
      
      public function get spellId() : uint
      {
         if(this.spell)
         {
            return this.spell.id;
         }
         return 0;
      }
      
      public function get playerCriticalRate() : int
      {
         var _loc1_:Number = NaN;
         var _loc2_:uint = 0;
         var _loc3_:CharacterCharacteristicsInformations = null;
         var _loc4_:CharacterBaseCharacteristic = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         if(this["isSpellWeapon"] && !this["isDefaultSpellWeapon"])
         {
            _loc2_ = this.getWeaponProperty("criticalHitProbability");
            _loc1_ = _loc2_ > 0?Number(55 - _loc2_):Number(0);
         }
         else
         {
            _loc1_ = this.getCriticalHitProbability();
         }
         if(!isNaN(_loc1_) && PlayedCharacterApi.getInstance().knowSpell(this.spellId) >= 0)
         {
            if(!Kernel.getWorker().contains(FightContextFrame) || !CurrentPlayedFighterManager.getInstance() || PlayedCharacterManager.getInstance().id == CurrentPlayedFighterManager.getInstance().currentFighterId)
            {
               _loc3_ = PlayedCharacterManager.getInstance().characteristics;
               if(_loc3_)
               {
                  _loc4_ = _loc3_.criticalHit;
                  _loc5_ = _loc4_.alignGiftBonus + _loc4_.base + _loc4_.contextModif + _loc4_.objectsAndMountBonus;
                  _loc6_ = _loc1_ - _loc5_;
                  if(_loc6_ > 54)
                  {
                     _loc6_ = 54;
                  }
                  return _loc6_;
               }
            }
            else
            {
               return _loc1_;
            }
         }
         return 0;
      }
      
      public function get maximalRangeWithBoosts() : int
      {
         var _loc2_:Boolean = false;
         var _loc3_:CharacterSpellModification = null;
         var _loc4_:int = 0;
         var _loc1_:CharacterCharacteristicsInformations = PlayedCharacterManager.getInstance().characteristics;
         if(_loc1_)
         {
            _loc2_ = this._spellLevel.rangeCanBeBoosted;
            if(!_loc2_)
            {
               for each(_loc3_ in _loc1_.spellModifications)
               {
                  if(_loc3_.spellId == this.id && _loc3_.modificationType == CharacterSpellModificationTypeEnum.RANGEABLE)
                  {
                     _loc2_ = true;
                     break;
                  }
               }
            }
            if(_loc2_)
            {
               _loc4_ = _loc1_.range.base + _loc1_.range.alignGiftBonus + _loc1_.range.contextModif + _loc1_.range.objectsAndMountBonus;
               if(this.maximalRange + _loc4_ < this.minimalRange)
               {
                  return this.minimalRange;
               }
               return this.maximalRange + _loc4_;
            }
         }
         return this.maximalRange;
      }
      
      public function get canTargetCasterOutOfZone() : Boolean
      {
         var _loc1_:EffectInstance = null;
         if(this._canTargetCasterOutOfZone == null)
         {
            for each(_loc1_ in this.effects)
            {
               if(_loc1_.category == 2 && _loc1_.targetMask.indexOf("C") != -1 && _loc1_.triggers == "I")
               {
                  this._canTargetCasterOutOfZone = true;
                  break;
               }
            }
            if(!this._canTargetCasterOutOfZone)
            {
               for each(_loc1_ in this.criticalEffect)
               {
                  if(_loc1_.category == 2 && _loc1_.targetMask.indexOf("C") != -1 && _loc1_.triggers == "I")
                  {
                     this._canTargetCasterOutOfZone = true;
                     break;
                  }
               }
            }
            if(!this._canTargetCasterOutOfZone)
            {
               this._canTargetCasterOutOfZone = false;
            }
         }
         return this._canTargetCasterOutOfZone;
      }
      
      override flash_proxy function hasProperty(param1:*) : Boolean
      {
         return isAttribute(param1);
      }
      
      override flash_proxy function getProperty(param1:*) : *
      {
         var _loc2_:CurrentPlayedFighterManager = null;
         var _loc3_:CharacterSpellModification = null;
         if(isAttribute(param1))
         {
            return this[param1];
         }
         if(this.id == 0 && PlayedCharacterManager.getInstance().currentWeapon != null)
         {
            return this.getWeaponProperty(param1);
         }
         _loc2_ = CurrentPlayedFighterManager.getInstance();
         switch(param1.toString())
         {
            case "id":
            case "nameId":
            case "descriptionId":
            case "typeId":
            case "scriptParams":
            case "scriptParamsCritical":
            case "scriptId":
            case "scriptIdCritical":
            case "iconId":
            case "spellLevels":
            case "useParamCache":
            case "name":
            case "description":
            case "variants":
            case "obtentionLevel":
            case "obtentionPrestige":
            case "obtentionBaseLevel":
            case "useSpellLevelScaling":
               return Spell.getSpellById(this.id)[param1];
            case "spellBreed":
            case "needFreeCell":
            case "needTakenCell":
            case "minPlayerLevel":
            case "minRange":
            case "maxStack":
            case "globalCooldown":
               return this._spellLevel[param1.toString()];
            case "criticalHitProbability":
               return this.getCriticalHitProbability();
            case "maxCastPerTurn":
               _loc3_ = CurrentPlayedFighterManager.getInstance().getSpellModifications(this.id,CharacterSpellModificationTypeEnum.MAX_CAST_PER_TURN);
               if(_loc3_)
               {
                  return this._spellLevel["maxCastPerTurn"] + _loc3_.value.contextModif + _loc3_.value.objectsAndMountBonus;
               }
               return this._spellLevel["maxCastPerTurn"];
            case "range":
               _loc3_ = CurrentPlayedFighterManager.getInstance().getSpellModifications(this.id,CharacterSpellModificationTypeEnum.RANGE);
               if(_loc3_)
               {
                  return this._spellLevel["range"] + _loc3_.value.contextModif + _loc3_.value.objectsAndMountBonus;
               }
               return this._spellLevel["range"];
            case "maxCastPerTarget":
               _loc3_ = CurrentPlayedFighterManager.getInstance().getSpellModifications(this.id,CharacterSpellModificationTypeEnum.MAX_CAST_PER_TARGET);
               if(_loc3_)
               {
                  return this._spellLevel["maxCastPerTarget"] + _loc3_.value.contextModif + _loc3_.value.objectsAndMountBonus;
               }
               return this._spellLevel["maxCastPerTarget"];
            case "castInLine":
               _loc3_ = CurrentPlayedFighterManager.getInstance().getSpellModifications(this.id,CharacterSpellModificationTypeEnum.CAST_LINE);
               if(_loc3_)
               {
                  return this._spellLevel["castInLine"] && _loc3_.value.contextModif + _loc3_.value.objectsAndMountBonus + _loc3_.value.base + _loc3_.value.additionnal + _loc3_.value.alignGiftBonus == 0;
               }
               return this._spellLevel["castInLine"];
            case "castInDiagonal":
               return this._spellLevel["castInDiagonal"];
            case "castTestLos":
               _loc3_ = CurrentPlayedFighterManager.getInstance().getSpellModifications(this.id,CharacterSpellModificationTypeEnum.LOS);
               if(_loc3_)
               {
                  return this._spellLevel["castTestLos"] && _loc3_.value.contextModif + _loc3_.value.objectsAndMountBonus + _loc3_.value.base + _loc3_.value.additionnal + _loc3_.value.alignGiftBonus == 0;
               }
               return this._spellLevel["castTestLos"];
            case "rangeCanBeBoosted":
               _loc3_ = CurrentPlayedFighterManager.getInstance().getSpellModifications(this.id,CharacterSpellModificationTypeEnum.RANGEABLE);
               if(_loc3_)
               {
                  return this._spellLevel["rangeCanBeBoosted"] || _loc3_.value.contextModif + _loc3_.value.objectsAndMountBonus + _loc3_.value.base + _loc3_.value.additionnal + _loc3_.value.alignGiftBonus > 0;
               }
               return this._spellLevel["rangeCanBeBoosted"];
            case "apCost":
               _loc3_ = CurrentPlayedFighterManager.getInstance().getSpellModifications(this.id,CharacterSpellModificationTypeEnum.AP_COST);
               if(_loc3_)
               {
                  return this._spellLevel["apCost"] - (_loc3_.value.contextModif + _loc3_.value.objectsAndMountBonus + _loc3_.value.base + _loc3_.value.additionnal + _loc3_.value.alignGiftBonus);
               }
               return this._spellLevel["apCost"];
            case "minCastInterval":
               _loc3_ = CurrentPlayedFighterManager.getInstance().getSpellModifications(this.id,CharacterSpellModificationTypeEnum.CAST_INTERVAL);
               if(_loc3_)
               {
                  return this._spellLevel["minCastInterval"] - (_loc3_.value.contextModif + _loc3_.value.objectsAndMountBonus + _loc3_.value.base + _loc3_.value.additionnal + _loc3_.value.alignGiftBonus);
               }
               return this._spellLevel["minCastInterval"];
            case "isSpellWeapon":
               return this.id == 0;
            case "isDefaultSpellWeapon":
               return this.id == 0 && !PlayedCharacterManager.getInstance().currentWeapon;
            case "statesRequired":
               return this._spellLevel.statesRequired;
            case "statesForbidden":
               return this._spellLevel.statesForbidden;
            default:
               return;
         }
      }
      
      override flash_proxy function callProperty(param1:*, ... rest) : *
      {
         return null;
      }
      
      private function getWeaponProperty(param1:*) : *
      {
         var _loc3_:int = 0;
         var _loc2_:ItemWrapper = PlayedCharacterManager.getInstance().currentWeapon as ItemWrapper;
         if(!_loc2_)
         {
            return null;
         }
         switch(param1.toString())
         {
            case "id":
               return 0;
            case "nameId":
            case "descriptionId":
            case "iconId":
            case "name":
            case "description":
            case "criticalHitProbability":
            case "castInLine":
            case "castInDiagonal":
            case "castTestLos":
            case "apCost":
            case "minRange":
            case "range":
               return _loc2_[param1];
            case "isDefaultSpellWeapon":
            case "useParamCache":
            case "needTakenCell":
            case "rangeCanBeBoosted":
            case "useSpellLevelScaling":
               return false;
            case "isSpellWeapon":
            case "needFreeCell":
               return true;
            case "minCastInterval":
            case "minPlayerLevel":
            case "maxStack":
            case "maxCastPerTurn":
            case "maxCastPerTarget":
            case "obtentionLevel":
            case "obtentionPrestige":
            case "obtentionBaseLevel":
               return 0;
            case "typeId":
               return 24;
            case "scriptParams":
            case "scriptParamsCritical":
            case "spellLevels":
               return null;
            case "scriptId":
            case "scriptIdCritical":
            case "spellBreed":
               return 0;
            case "variants":
               return [];
            default:
               return;
         }
      }
      
      private function getCriticalHitProbability() : Number
      {
         var _loc3_:int = 0;
         var _loc1_:Number = this._spellLevel["criticalHitProbability"] > 0?Number(55 - this._spellLevel["criticalHitProbability"]):Number(NaN);
         if(isNaN(_loc1_))
         {
            return NaN;
         }
         var _loc2_:CharacterSpellModification = CurrentPlayedFighterManager.getInstance().getSpellModifications(this.id,CharacterSpellModificationTypeEnum.CRITICAL_HIT_BONUS);
         if(_loc2_)
         {
            _loc3_ = _loc2_.value.contextModif + _loc2_.value.objectsAndMountBonus + _loc2_.value.alignGiftBonus + _loc2_.value.base + _loc2_.value.additionnal;
            return _loc1_ > 0?Number(_loc1_ - _loc3_):Number(0);
         }
         return _loc1_;
      }
      
      public function clone() : *
      {
         var _loc2_:SpellWrapper = null;
         var _loc1_:Boolean = false;
         if(_cache[this.spellId] != null || _playersCache[this.playerId][this.spellId])
         {
            _loc1_ = true;
         }
         _loc2_ = SpellWrapper.create(this.id,this.spellLevel,_loc1_,this.playerId,this.variantActivated);
         return _loc2_;
      }
      
      public function addHolder(param1:ISlotDataHolder) : void
      {
         this._slotDataHolderManager.addHolder(param1);
      }
      
      public function setLinkedSlotData(param1:ISlotData) : void
      {
         this._slotDataHolderManager.setLinkedSlotData(param1);
      }
      
      public function removeHolder(param1:ISlotDataHolder) : void
      {
         this._slotDataHolderManager.removeHolder(param1);
      }
      
      public function toString() : String
      {
         return "[SpellWrapper #" + this.id + "]";
      }
   }
}
