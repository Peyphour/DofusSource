package com.ankamagames.dofus.logic.game.fight.managers
{
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.dofus.datacenter.items.Item;
   import com.ankamagames.dofus.datacenter.items.Weapon;
   import com.ankamagames.dofus.datacenter.spells.Spell;
   import com.ankamagames.dofus.datacenter.spells.SpellLevel;
   import com.ankamagames.dofus.datacenter.spells.SpellState;
   import com.ankamagames.dofus.internalDatacenter.spells.SpellWrapper;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.game.common.managers.InventoryManager;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.logic.game.common.misc.DofusEntities;
   import com.ankamagames.dofus.logic.game.common.misc.SpellModificator;
   import com.ankamagames.dofus.logic.game.fight.frames.FightEntitiesFrame;
   import com.ankamagames.dofus.logic.game.fight.frames.FightSpellCastFrame;
   import com.ankamagames.dofus.logic.game.fight.miscs.FightReachableCellsMaker;
   import com.ankamagames.dofus.logic.game.fight.types.SpellCastInFightManager;
   import com.ankamagames.dofus.logic.game.fight.types.castSpellManager.SpellManager;
   import com.ankamagames.dofus.misc.lists.FightHookList;
   import com.ankamagames.dofus.misc.lists.HookList;
   import com.ankamagames.dofus.misc.lists.InventoryHookList;
   import com.ankamagames.dofus.network.ProtocolConstantsEnum;
   import com.ankamagames.dofus.network.enums.CharacterSpellModificationTypeEnum;
   import com.ankamagames.dofus.network.enums.ShortcutBarEnum;
   import com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic;
   import com.ankamagames.dofus.network.types.game.character.characteristic.CharacterCharacteristicsInformations;
   import com.ankamagames.dofus.network.types.game.character.characteristic.CharacterSpellModification;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightFighterInformations;
   import com.ankamagames.dofus.types.entities.AnimatedCharacter;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   
   public final class CurrentPlayedFighterManager
   {
      
      private static const _log:Logger = Log.getLogger(getQualifiedClassName(CurrentPlayedFighterManager));
      
      private static var _self:CurrentPlayedFighterManager;
       
      
      private var _currentFighterId:Number = 0;
      
      private var _currentFighterIsRealPlayer:Boolean = true;
      
      private var _characteristicsInformationsList:Dictionary;
      
      private var _spellCastInFightManagerList:Dictionary;
      
      private var _currentSummonedCreature:Dictionary;
      
      private var _currentSummonedBomb:Dictionary;
      
      public function CurrentPlayedFighterManager()
      {
         this._characteristicsInformationsList = new Dictionary();
         this._spellCastInFightManagerList = new Dictionary();
         this._currentSummonedCreature = new Dictionary();
         this._currentSummonedBomb = new Dictionary();
         super();
      }
      
      public static function getInstance() : CurrentPlayedFighterManager
      {
         if(_self == null)
         {
            _self = new CurrentPlayedFighterManager();
            _self.currentFighterId = PlayedCharacterManager.getInstance().id;
         }
         return _self;
      }
      
      public function get currentFighterId() : Number
      {
         return this._currentFighterId;
      }
      
      public function set currentFighterId(param1:Number) : void
      {
         if(param1 == this._currentFighterId)
         {
            return;
         }
         var _loc2_:Number = this._currentFighterId;
         this._currentFighterId = param1;
         var _loc3_:PlayedCharacterManager = PlayedCharacterManager.getInstance();
         this._currentFighterIsRealPlayer = this._currentFighterId == _loc3_.id;
         var _loc4_:AnimatedCharacter = DofusEntities.getEntity(_loc2_) as AnimatedCharacter;
         if(_loc4_)
         {
            _loc4_.setCanSeeThrough(false);
         }
         var _loc5_:AnimatedCharacter = DofusEntities.getEntity(this._currentFighterId) as AnimatedCharacter;
         if(_loc5_)
         {
            _loc5_.setCanSeeThrough(true);
         }
         if(_loc3_.isFighting)
         {
            this.updatePortrait(_loc5_);
            if(_loc3_.id != param1 || _loc2_)
            {
               KernelEventsManager.getInstance().processCallback(FightHookList.SlaveStatsList,this.getCharacteristicsInformations());
            }
         }
      }
      
      public function checkPlayableEntity(param1:Number) : Boolean
      {
         if(param1 == PlayedCharacterManager.getInstance().id)
         {
            return true;
         }
         return this._characteristicsInformationsList[param1] != null;
      }
      
      public function isRealPlayer() : Boolean
      {
         return this._currentFighterIsRealPlayer;
      }
      
      public function resetPlayerSpellList() : void
      {
         var _loc1_:PlayedCharacterManager = PlayedCharacterManager.getInstance();
         var _loc2_:InventoryManager = InventoryManager.getInstance();
         if(_loc1_.spellsInventory != _loc1_.playerSpellList)
         {
            _loc1_.spellsInventory = _loc1_.playerSpellList;
            KernelEventsManager.getInstance().processCallback(HookList.SpellListUpdate,_loc1_.playerSpellList);
            if(Kernel.getWorker().contains(FightSpellCastFrame))
            {
               Kernel.getWorker().removeFrame(Kernel.getWorker().getFrame(FightSpellCastFrame));
            }
         }
         if(_loc2_.shortcutBarSpells != _loc1_.playerShortcutList)
         {
            _loc2_.shortcutBarSpells = _loc1_.playerShortcutList;
            KernelEventsManager.getInstance().processCallback(InventoryHookList.ShortcutBarViewContent,ShortcutBarEnum.SPELL_SHORTCUT_BAR);
         }
      }
      
      public function setCharacteristicsInformations(param1:Number, param2:CharacterCharacteristicsInformations) : void
      {
         this._characteristicsInformationsList[param1] = param2;
      }
      
      public function getCharacteristicsInformations(param1:Number = 0) : CharacterCharacteristicsInformations
      {
         var _loc2_:PlayedCharacterManager = PlayedCharacterManager.getInstance();
         if(param1)
         {
            if(param1 == _loc2_.id)
            {
               return _loc2_.characteristics;
            }
            return this._characteristicsInformationsList[param1];
         }
         if(this._currentFighterIsRealPlayer || !_loc2_.isFighting)
         {
            return _loc2_.characteristics;
         }
         return this._characteristicsInformationsList[this._currentFighterId];
      }
      
      public function getBasicTurnDuration() : int
      {
         var _loc2_:CharacterCharacteristicsInformations = null;
         var _loc3_:CharacterBaseCharacteristic = null;
         var _loc4_:CharacterBaseCharacteristic = null;
         var _loc1_:int = 15;
         if(this._characteristicsInformationsList)
         {
            _loc2_ = this._characteristicsInformationsList[this._currentFighterId];
            if(_loc2_)
            {
               _loc3_ = _loc2_.actionPoints;
               _loc4_ = _loc2_.movementPoints;
               _loc1_ = _loc1_ + (_loc3_.base + _loc3_.additionnal + _loc3_.objectsAndMountBonus + _loc4_.base + _loc4_.additionnal + _loc4_.objectsAndMountBonus);
            }
         }
         return _loc1_;
      }
      
      public function getSpellById(param1:uint) : SpellWrapper
      {
         var _loc2_:SpellWrapper = null;
         var _loc4_:SpellWrapper = null;
         var _loc3_:PlayedCharacterManager = PlayedCharacterManager.getInstance();
         for each(_loc4_ in _loc3_.spellsInventory)
         {
            if(_loc4_.id == param1)
            {
               return _loc4_;
            }
         }
         return null;
      }
      
      public function getSpellCastManager() : SpellCastInFightManager
      {
         var _loc1_:SpellCastInFightManager = this._spellCastInFightManagerList[this._currentFighterId];
         if(!_loc1_)
         {
            _loc1_ = new SpellCastInFightManager(this._currentFighterId);
            this._spellCastInFightManagerList[this._currentFighterId] = _loc1_;
         }
         return _loc1_;
      }
      
      public function getSpellCastManagerById(param1:Number) : SpellCastInFightManager
      {
         var _loc2_:SpellCastInFightManager = this._spellCastInFightManagerList[param1];
         if(!_loc2_)
         {
            _loc2_ = new SpellCastInFightManager(param1);
            this._spellCastInFightManagerList[param1] = _loc2_;
         }
         return _loc2_;
      }
      
      public function canCastThisSpell(param1:uint, param2:uint, param3:Number = 0, param4:Array = null) : Boolean
      {
         var _loc7_:SpellWrapper = null;
         var _loc8_:* = null;
         var _loc10_:SpellWrapper = null;
         var _loc13_:uint = 0;
         var _loc14_:uint = 0;
         var _loc16_:CharacterSpellModification = null;
         var _loc18_:int = 0;
         var _loc19_:int = 0;
         var _loc22_:Weapon = null;
         var _loc23_:SpellState = null;
         var _loc24_:Weapon = null;
         var _loc25_:SpellState = null;
         var _loc26_:int = 0;
         var _loc27_:uint = 0;
         var _loc5_:Spell = Spell.getSpellById(param1);
         var _loc6_:SpellLevel = _loc5_.getSpellLevel(param2);
         if(_loc6_ == null)
         {
            if(param4)
            {
               param4[0] = I18n.getUiText("ui.fightAutomsg.spellcast.noSpell",[_loc8_]);
            }
            return false;
         }
         var _loc9_:PlayedCharacterManager = PlayedCharacterManager.getInstance();
         if(param1 == 0)
         {
            if(this._currentFighterIsRealPlayer && _loc9_.currentWeapon)
            {
               _loc8_ = _loc9_.currentWeapon.name;
            }
            else
            {
               _loc8_ = _loc5_.name;
            }
         }
         else
         {
            _loc8_ = "{spell," + param1 + "," + param2 + "}";
         }
         if(_loc6_.minPlayerLevel > _loc9_.infos.level)
         {
            if(param4)
            {
               if(_loc9_.infos.level > ProtocolConstantsEnum.MAX_LEVEL)
               {
                  param4[0] = I18n.getUiText("ui.fightAutomsg.spellcast.prestigeTooLow",[_loc8_,_loc9_.infos.level - ProtocolConstantsEnum.MAX_LEVEL]);
               }
               else
               {
                  param4[0] = I18n.getUiText("ui.fightAutomsg.spellcast.levelTooLow",[_loc8_,_loc9_.infos.level]);
               }
            }
            return false;
         }
         for each(_loc10_ in _loc9_.spellsInventory)
         {
            if(_loc10_ && _loc10_.id == param1)
            {
               _loc7_ = _loc10_;
            }
         }
         if(!_loc7_)
         {
            if(param4)
            {
               param4[0] = I18n.getUiText("ui.fightAutomsg.spellcast.notAvailable",[_loc8_]);
            }
            return false;
         }
         var _loc11_:CharacterCharacteristicsInformations = this.getCharacteristicsInformations();
         if(!_loc11_)
         {
            if(param4)
            {
               param4[0] = I18n.getUiText("ui.fightAutomsg.spellcast.notAvailableWithoutStats",[_loc8_]);
            }
            return false;
         }
         var _loc12_:int = _loc11_.actionPointsCurrent;
         if(param1 == 0 && _loc9_.currentWeapon != null)
         {
            _loc22_ = Item.getItemById(_loc9_.currentWeapon.objectGID) as Weapon;
            if(!_loc22_)
            {
               if(param4)
               {
                  param4[0] = I18n.getUiText("ui.fightAutomsg.spellcast.notAWeapon",[_loc8_]);
               }
               return false;
            }
            _loc13_ = _loc22_.apCost;
            _loc14_ = _loc22_.maxCastPerTurn;
         }
         else
         {
            _loc13_ = _loc7_.apCost;
            _loc14_ = _loc7_.maxCastPerTurn;
         }
         var _loc15_:SpellModificator = new SpellModificator();
         for each(_loc16_ in _loc11_.spellModifications)
         {
            if(_loc16_.spellId == param1)
            {
               switch(_loc16_.modificationType)
               {
                  case CharacterSpellModificationTypeEnum.AP_COST:
                     _loc15_.apCost = _loc16_.value;
                     continue;
                  case CharacterSpellModificationTypeEnum.CAST_INTERVAL:
                     _loc15_.castInterval = _loc16_.value;
                     continue;
                  case CharacterSpellModificationTypeEnum.CAST_INTERVAL_SET:
                     _loc15_.castIntervalSet = _loc16_.value;
                     continue;
                  case CharacterSpellModificationTypeEnum.MAX_CAST_PER_TARGET:
                     _loc15_.maxCastPerTarget = _loc16_.value;
                     continue;
                  case CharacterSpellModificationTypeEnum.MAX_CAST_PER_TURN:
                     _loc15_.maxCastPerTurn = _loc16_.value;
                     continue;
                  default:
                     continue;
               }
            }
            else
            {
               continue;
            }
         }
         if(_loc13_ > _loc12_)
         {
            if(param4)
            {
               param4[0] = I18n.getUiText("ui.fightAutomsg.spellcast.needAP",[_loc8_,_loc13_]);
            }
            return false;
         }
         var _loc17_:Array = FightersStateManager.getInstance().getStates(this._currentFighterId);
         if(!_loc17_)
         {
            _loc17_ = new Array();
         }
         for each(_loc18_ in _loc17_)
         {
            _loc23_ = SpellState.getSpellStateById(_loc18_);
            if(_loc23_.preventsFight && param1 == 0)
            {
               if(param4)
               {
                  param4[0] = I18n.getUiText("ui.fightAutomsg.spellcast.stateForbidden",[_loc8_,_loc23_.name]);
               }
               return false;
            }
            if(_loc23_.id == 101 && param1 == 0)
            {
               _loc24_ = Item.getItemById(_loc9_.currentWeapon.objectGID) as Weapon;
               if(_loc24_.typeId != 2)
               {
                  if(param4)
                  {
                     param4[0] = I18n.getUiText("ui.fightAutomsg.spellcast.stateForbidden",[_loc8_,_loc23_.name]);
                  }
                  return false;
               }
            }
            if(_loc6_.statesForbidden && _loc6_.statesForbidden.indexOf(_loc18_) != -1)
            {
               if(param4)
               {
                  param4[0] = I18n.getUiText("ui.fightAutomsg.spellcast.stateForbidden",[_loc8_,_loc23_.name]);
               }
               return false;
            }
            if(_loc23_.preventsSpellCast)
            {
               if(_loc6_.statesRequired)
               {
                  if(_loc6_.statesRequired.indexOf(_loc18_) == -1)
                  {
                     if(param4)
                     {
                        param4[0] = I18n.getUiText("ui.fightAutomsg.spellcast.stateForbidden",[_loc8_,_loc23_.name]);
                     }
                     return false;
                  }
                  continue;
               }
               if(param4)
               {
                  param4[0] = I18n.getUiText("ui.fightAutomsg.spellcast.stateForbidden",[_loc8_,_loc23_.name]);
               }
               return false;
            }
         }
         for each(_loc19_ in _loc6_.statesRequired)
         {
            if(_loc17_.indexOf(_loc19_) == -1)
            {
               _loc25_ = SpellState.getSpellStateById(_loc19_);
               if(param4)
               {
                  param4[0] = I18n.getUiText("ui.fightAutomsg.spellcast.stateRequired",[_loc8_,_loc25_.name]);
               }
               return false;
            }
         }
         if(_loc6_.canSummon && !this.canSummon())
         {
            if(param4)
            {
               param4[0] = I18n.getUiText("ui.fightAutomsg.spellcast.tooManySummon",[_loc8_]);
            }
            return false;
         }
         if(_loc6_.canBomb && !this.canBomb())
         {
            if(param4)
            {
               param4[0] = I18n.getUiText("ui.fightAutomsg.spellcast.tooManyBomb",[_loc8_]);
            }
            return false;
         }
         if(!_loc9_.isFighting)
         {
            if(param4)
            {
               param4[0] = I18n.getUiText("ui.fightAutomsg.spellcast.available",[_loc8_]);
            }
            return true;
         }
         var _loc20_:SpellCastInFightManager = this.getSpellCastManager();
         var _loc21_:SpellManager = _loc20_.getSpellManagerBySpellId(param1);
         if(_loc21_ == null)
         {
            if(param4)
            {
               param4[0] = I18n.getUiText("ui.fightAutomsg.spellcast.available",[_loc8_]);
            }
            return true;
         }
         if(_loc14_ <= _loc21_.numberCastThisTurn && _loc14_ > 0)
         {
            if(param4)
            {
               param4[0] = I18n.getUiText("ui.fightAutomsg.spellcast.castPerTurn",[_loc8_,_loc14_]);
            }
            return false;
         }
         if(_loc21_.cooldown > 0 || _loc7_.actualCooldown > 0)
         {
            _loc26_ = Math.max(_loc21_.cooldown,_loc7_.actualCooldown);
            if(param4)
            {
               if(_loc26_ == 63)
               {
                  param4[0] = I18n.getUiText("ui.fightAutomsg.spellcast.noCast",[_loc8_]);
               }
               else
               {
                  param4[0] = I18n.getUiText("ui.fightAutomsg.spellcast.cooldown",[_loc8_,_loc26_]);
               }
            }
            return false;
         }
         if(param3 != 0)
         {
            _loc27_ = _loc21_.getCastOnEntity(param3);
            if(_loc6_.maxCastPerTarget + _loc15_.getTotalBonus(_loc15_.maxCastPerTarget) <= _loc27_ && _loc6_.maxCastPerTarget > 0)
            {
               if(param4)
               {
                  param4[0] = I18n.getUiText("ui.fightAutomsg.spellcast.castPerTarget",[_loc8_]);
               }
               return false;
            }
         }
         if(param4)
         {
            param4[0] = I18n.getUiText("ui.fightAutomsg.spellcast.available",[_loc8_]);
         }
         return true;
      }
      
      public function endFight() : void
      {
         if(PlayedCharacterManager.getInstance().id != this._currentFighterId)
         {
            this.currentFighterId = PlayedCharacterManager.getInstance().id;
            this.resetPlayerSpellList();
            this.updatePortrait(DofusEntities.getEntity(this._currentFighterId) as AnimatedCharacter);
         }
         this._currentFighterId = 0;
         this._characteristicsInformationsList = new Dictionary();
         this._spellCastInFightManagerList = new Dictionary();
         this._currentSummonedCreature = new Dictionary();
         this._currentSummonedBomb = new Dictionary();
      }
      
      public function getSpellModifications(param1:int, param2:int) : CharacterSpellModification
      {
         var _loc4_:CharacterSpellModification = null;
         var _loc3_:CharacterCharacteristicsInformations = this.getCharacteristicsInformations();
         if(_loc3_)
         {
            for each(_loc4_ in _loc3_.spellModifications)
            {
               if(_loc4_.spellId == param1 && _loc4_.modificationType == param2)
               {
                  return _loc4_;
               }
            }
         }
         return null;
      }
      
      public function canPlay() : Boolean
      {
         var _loc5_:FightEntitiesFrame = null;
         var _loc6_:GameFightFighterInformations = null;
         var _loc7_:FightReachableCellsMaker = null;
         var _loc8_:PlayedCharacterManager = null;
         var _loc9_:SpellWrapper = null;
         var _loc10_:Weapon = null;
         return true;
      }
      
      public function getCurrentSummonedCreature(param1:Number = 0) : uint
      {
         if(!param1)
         {
            param1 = this._currentFighterId;
         }
         return this._currentSummonedCreature[param1];
      }
      
      public function setCurrentSummonedCreature(param1:uint, param2:Number = 0) : void
      {
         if(!param2)
         {
            param2 = this._currentFighterId;
         }
         this._currentSummonedCreature[param2] = param1;
      }
      
      public function getCurrentSummonedBomb(param1:Number = 0) : uint
      {
         if(!param1)
         {
            param1 = this._currentFighterId;
         }
         return this._currentSummonedBomb[param1];
      }
      
      public function setCurrentSummonedBomb(param1:uint, param2:Number = 0) : void
      {
         if(!param2)
         {
            param2 = this._currentFighterId;
         }
         this._currentSummonedBomb[param2] = param1;
      }
      
      public function resetSummonedCreature(param1:Number = 0) : void
      {
         this.setCurrentSummonedCreature(0,param1);
      }
      
      public function addSummonedCreature(param1:Number = 0) : void
      {
         this.setCurrentSummonedCreature(this.getCurrentSummonedCreature(param1) + 1,param1);
      }
      
      public function removeSummonedCreature(param1:Number = 0) : void
      {
         if(this.getCurrentSummonedCreature(param1) > 0)
         {
            this.setCurrentSummonedCreature(this.getCurrentSummonedCreature(param1) - 1,param1);
         }
      }
      
      public function getMaxSummonedCreature(param1:Number = 0) : uint
      {
         var _loc2_:CharacterCharacteristicsInformations = this.getCharacteristicsInformations(param1);
         return _loc2_.summonableCreaturesBoost.base + _loc2_.summonableCreaturesBoost.objectsAndMountBonus + _loc2_.summonableCreaturesBoost.alignGiftBonus + _loc2_.summonableCreaturesBoost.contextModif;
      }
      
      public function canSummon(param1:Number = 0) : Boolean
      {
         return this.getMaxSummonedCreature(param1) > this.getCurrentSummonedCreature(param1);
      }
      
      public function resetSummonedBomb(param1:Number = 0) : void
      {
         this.setCurrentSummonedBomb(0,param1);
      }
      
      public function addSummonedBomb(param1:Number = 0) : void
      {
         this.setCurrentSummonedBomb(this.getCurrentSummonedBomb(param1) + 1,param1);
      }
      
      public function removeSummonedBomb(param1:Number = 0) : void
      {
         if(this.getCurrentSummonedBomb(param1) > 0)
         {
            this.setCurrentSummonedBomb(this.getCurrentSummonedBomb(param1) - 1,param1);
         }
      }
      
      public function canBomb(param1:Number = 0) : Boolean
      {
         return this.getMaxSummonedBomb() > this.getCurrentSummonedBomb(param1);
      }
      
      private function getMaxSummonedBomb() : uint
      {
         return 3;
      }
      
      private function updatePortrait(param1:AnimatedCharacter) : void
      {
         if(this._currentFighterIsRealPlayer)
         {
            KernelEventsManager.getInstance().processCallback(FightHookList.ShowMonsterArtwork,0);
         }
         else if(param1)
         {
            KernelEventsManager.getInstance().processCallback(FightHookList.ShowMonsterArtwork,param1.look.getBone());
         }
      }
   }
}
