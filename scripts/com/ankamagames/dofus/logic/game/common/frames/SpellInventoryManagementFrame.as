package com.ankamagames.dofus.logic.game.common.frames
{
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.dofus.datacenter.breeds.Breed;
   import com.ankamagames.dofus.datacenter.spells.FinishMove;
   import com.ankamagames.dofus.datacenter.spells.Spell;
   import com.ankamagames.dofus.internalDatacenter.spells.SpellWrapper;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.kernel.net.ConnectionsHandler;
   import com.ankamagames.dofus.logic.game.common.managers.InventoryManager;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.logic.game.fight.frames.FightSpellCastFrame;
   import com.ankamagames.dofus.logic.game.fight.managers.CurrentPlayedFighterManager;
   import com.ankamagames.dofus.logic.game.fight.types.SpellCastInFightManager;
   import com.ankamagames.dofus.logic.game.fight.types.castSpellManager.SpellManager;
   import com.ankamagames.dofus.logic.game.roleplay.actions.FinishMoveListRequestAction;
   import com.ankamagames.dofus.logic.game.roleplay.actions.FinishMoveSetRequestAction;
   import com.ankamagames.dofus.logic.game.roleplay.actions.SpellVariantActivationRequestAction;
   import com.ankamagames.dofus.misc.lists.HookList;
   import com.ankamagames.dofus.misc.lists.InventoryHookList;
   import com.ankamagames.dofus.network.enums.ShortcutBarEnum;
   import com.ankamagames.dofus.network.messages.game.context.fight.SlaveSwitchContextMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.spell.SpellVariantActivationMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.spell.SpellVariantActivationRequestMessage;
   import com.ankamagames.dofus.network.messages.game.finishmoves.FinishMoveListMessage;
   import com.ankamagames.dofus.network.messages.game.finishmoves.FinishMoveListRequestMessage;
   import com.ankamagames.dofus.network.messages.game.finishmoves.FinishMoveSetRequestMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.spells.SpellListMessage;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightSpellCooldown;
   import com.ankamagames.dofus.network.types.game.data.items.SpellItem;
   import com.ankamagames.dofus.network.types.game.finishmoves.FinishMoveInformations;
   import com.ankamagames.dofus.uiApi.FightApi;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.jerakine.types.enums.Priority;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   
   public class SpellInventoryManagementFrame implements Frame
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(SpellInventoryManagementFrame));
       
      
      private var _fullSpellList:Array;
      
      private var _spellsGlobalCooldowns:Dictionary;
      
      public function SpellInventoryManagementFrame()
      {
         this._fullSpellList = new Array();
         this._spellsGlobalCooldowns = new Dictionary();
         super();
      }
      
      public function get priority() : int
      {
         return Priority.NORMAL;
      }
      
      public function pushed() : Boolean
      {
         return true;
      }
      
      public function process(param1:Message) : Boolean
      {
         var _loc2_:SpellListMessage = null;
         var _loc3_:Number = NaN;
         var _loc4_:Array = null;
         var _loc5_:SlaveSwitchContextMessage = null;
         var _loc6_:int = 0;
         var _loc7_:Vector.<GameFightSpellCooldown> = null;
         var _loc8_:InventoryManagementFrame = null;
         var _loc9_:SpellVariantActivationRequestAction = null;
         var _loc10_:SpellVariantActivationRequestMessage = null;
         var _loc11_:SpellVariantActivationMessage = null;
         var _loc12_:FinishMoveListRequestAction = null;
         var _loc13_:FinishMoveListRequestMessage = null;
         var _loc14_:FinishMoveSetRequestAction = null;
         var _loc15_:int = 0;
         var _loc16_:FinishMoveSetRequestMessage = null;
         var _loc17_:FinishMoveListMessage = null;
         var _loc18_:Array = null;
         var _loc19_:FinishMove = null;
         var _loc20_:FinishMoveInformations = null;
         var _loc21_:SpellItem = null;
         var _loc22_:Breed = null;
         var _loc23_:Spell = null;
         var _loc24_:SpellItem = null;
         var _loc25_:GameFightSpellCooldown = null;
         var _loc26_:SpellWrapper = null;
         var _loc27_:uint = 0;
         var _loc28_:int = 0;
         var _loc29_:SpellCastInFightManager = null;
         var _loc30_:SpellManager = null;
         var _loc31_:Boolean = false;
         switch(true)
         {
            case param1 is SpellListMessage:
               _loc2_ = param1 as SpellListMessage;
               _loc3_ = PlayedCharacterManager.getInstance().id;
               this._fullSpellList[_loc3_] = new Array();
               _loc4_ = new Array();
               for each(_loc21_ in _loc2_.spells)
               {
                  this._fullSpellList[_loc3_].push(SpellWrapper.create(_loc21_.spellId,_loc21_.spellLevel,true,PlayedCharacterManager.getInstance().id));
                  _loc4_.push(_loc21_.spellId);
               }
               if(_loc2_.spellPrevisualization)
               {
                  _loc22_ = Breed.getBreedById(PlayedCharacterManager.getInstance().infos.breed);
                  for each(_loc23_ in _loc22_.breedSpells)
                  {
                     if(_loc4_.indexOf(_loc23_.id) == -1)
                     {
                        this._fullSpellList[_loc3_].push(SpellWrapper.create(_loc23_.id,0,true,PlayedCharacterManager.getInstance().id));
                     }
                  }
               }
               PlayedCharacterManager.getInstance().spellsInventory = this._fullSpellList[_loc3_];
               PlayedCharacterManager.getInstance().playerSpellList = this._fullSpellList[_loc3_];
               KernelEventsManager.getInstance().processCallback(HookList.SpellListUpdate,this._fullSpellList[_loc3_]);
               return true;
            case param1 is SlaveSwitchContextMessage:
               _loc5_ = param1 as SlaveSwitchContextMessage;
               FightApi.slaveContext = true;
               _loc6_ = _loc5_.slaveId;
               this._fullSpellList[_loc6_] = new Array();
               for each(_loc24_ in _loc5_.slaveSpells)
               {
                  this._fullSpellList[_loc6_].push(SpellWrapper.create(_loc24_.spellId,_loc24_.spellLevel,true,_loc6_));
               }
               PlayedCharacterManager.getInstance().spellsInventory = this._fullSpellList[_loc6_];
               if(!CurrentPlayedFighterManager.getInstance().getCharacteristicsInformations(_loc6_))
               {
                  CurrentPlayedFighterManager.getInstance().setCharacteristicsInformations(_loc6_,_loc5_.slaveStats);
               }
               if(CurrentPlayedFighterManager.getInstance().getSpellCastManagerById(_loc6_).needCooldownUpdate)
               {
                  CurrentPlayedFighterManager.getInstance().getSpellCastManagerById(_loc6_).updateCooldowns();
               }
               _loc7_ = this._spellsGlobalCooldowns[_loc6_];
               if(_loc7_)
               {
                  for each(_loc25_ in _loc7_)
                  {
                     _loc29_ = CurrentPlayedFighterManager.getInstance().getSpellCastManagerById(_loc6_);
                     _loc28_ = _loc25_.cooldown;
                     _loc31_ = false;
                     for each(_loc26_ in this._fullSpellList[_loc6_])
                     {
                        if(_loc26_.spellId == _loc25_.spellId)
                        {
                           _loc31_ = true;
                           _loc27_ = _loc26_.spellLevel;
                           if(_loc28_ == -1)
                           {
                              _loc28_ = _loc26_.spellLevelInfos.minCastInterval;
                           }
                           break;
                        }
                     }
                     if(_loc31_)
                     {
                        if(!_loc29_.getSpellManagerBySpellId(_loc25_.spellId))
                        {
                           _loc29_.castSpell(_loc25_.spellId,_loc27_,[],false);
                        }
                        _loc30_ = _loc29_.getSpellManagerBySpellId(_loc25_.spellId);
                        _loc30_.forceCooldown(_loc28_);
                     }
                  }
                  _loc7_.length = 0;
                  delete this._spellsGlobalCooldowns[_loc6_];
               }
               KernelEventsManager.getInstance().processCallback(HookList.SpellListUpdate,this._fullSpellList[_loc6_]);
               if(Kernel.getWorker().contains(FightSpellCastFrame))
               {
                  Kernel.getWorker().removeFrame(Kernel.getWorker().getFrame(FightSpellCastFrame));
               }
               _loc8_ = Kernel.getWorker().getFrame(InventoryManagementFrame) as InventoryManagementFrame;
               InventoryManager.getInstance().shortcutBarSpells = _loc8_.getWrappersFromShortcuts(_loc5_.shortcuts);
               KernelEventsManager.getInstance().processCallback(InventoryHookList.ShortcutBarViewContent,ShortcutBarEnum.SPELL_SHORTCUT_BAR);
               return false;
            case param1 is SpellVariantActivationRequestAction:
               _loc9_ = param1 as SpellVariantActivationRequestAction;
               _loc10_ = new SpellVariantActivationRequestMessage();
               _loc10_.initSpellVariantActivationRequestMessage(_loc9_.spellId);
               ConnectionsHandler.getConnection().send(_loc10_);
               return true;
            case param1 is SpellVariantActivationMessage:
               _loc11_ = param1 as SpellVariantActivationMessage;
               if(_loc11_.result)
               {
                  _loc3_ = PlayedCharacterManager.getInstance().id;
                  for each(_loc26_ in this._fullSpellList[_loc3_])
                  {
                     if(_loc26_.spellId == _loc11_.deactivatedSpellId && _loc26_.variantActivated)
                     {
                        _loc26_.variantActivated = false;
                     }
                     else if(_loc26_.spellId == _loc11_.activatedSpellId && !_loc26_.variantActivated)
                     {
                        _loc26_.variantActivated = true;
                     }
                  }
                  KernelEventsManager.getInstance().processCallback(InventoryHookList.SpellVariantActivated,_loc11_.activatedSpellId,_loc11_.deactivatedSpellId);
               }
               return true;
            case param1 is FinishMoveListRequestAction:
               _loc12_ = param1 as FinishMoveListRequestAction;
               _loc13_ = new FinishMoveListRequestMessage();
               _loc13_.initFinishMoveListRequestMessage();
               ConnectionsHandler.getConnection().send(_loc13_);
               return true;
            case param1 is FinishMoveSetRequestAction:
               _loc14_ = param1 as FinishMoveSetRequestAction;
               for each(_loc15_ in _loc14_.enabledFinishedMoves)
               {
                  _loc16_ = new FinishMoveSetRequestMessage();
                  _loc16_.initFinishMoveSetRequestMessage(_loc15_,true);
                  ConnectionsHandler.getConnection().send(_loc16_);
               }
               for each(_loc15_ in _loc14_.disabledFinishedMoves)
               {
                  _loc16_ = new FinishMoveSetRequestMessage();
                  _loc16_.initFinishMoveSetRequestMessage(_loc15_,false);
                  ConnectionsHandler.getConnection().send(_loc16_);
               }
               return true;
            case param1 is FinishMoveListMessage:
               _loc17_ = param1 as FinishMoveListMessage;
               _loc18_ = new Array();
               for each(_loc20_ in _loc17_.finishMoves)
               {
                  _loc19_ = FinishMove.getFinishMoveById(_loc20_.finishMoveId);
                  _loc18_.push({
                     "id":_loc19_.id,
                     "name":Spell.getSpellById(_loc19_.getSpellLevel().spellId).name,
                     "enabled":_loc20_.finishMoveState
                  });
               }
               _loc18_.sortOn("id",Array.NUMERIC);
               KernelEventsManager.getInstance().processCallback(HookList.FinishMoveList,_loc18_);
               return true;
            default:
               return false;
         }
      }
      
      public function pulled() : Boolean
      {
         return true;
      }
      
      public function getFullSpellListByOwnerId(param1:Number) : Array
      {
         return this._fullSpellList[param1];
      }
      
      public function addSpellGlobalCoolDownInfo(param1:Number, param2:GameFightSpellCooldown) : void
      {
         if(!this._spellsGlobalCooldowns[param1])
         {
            this._spellsGlobalCooldowns[param1] = new Vector.<GameFightSpellCooldown>(0);
         }
         this._spellsGlobalCooldowns[param1].push(param2);
      }
      
      public function deleteSpellsGlobalCoolDownsData() : void
      {
         var _loc1_:* = undefined;
         for(_loc1_ in this._spellsGlobalCooldowns)
         {
            this._spellsGlobalCooldowns[_loc1_].length = 0;
            delete this._spellsGlobalCooldowns[_loc1_];
         }
      }
   }
}
