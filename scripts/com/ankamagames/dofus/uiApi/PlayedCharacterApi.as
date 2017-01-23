package com.ankamagames.dofus.uiApi
{
   import com.ankamagames.berilia.interfaces.IApi;
   import com.ankamagames.dofus.datacenter.appearance.Ornament;
   import com.ankamagames.dofus.datacenter.appearance.Title;
   import com.ankamagames.dofus.datacenter.spells.Spell;
   import com.ankamagames.dofus.datacenter.spells.SpellLevel;
   import com.ankamagames.dofus.datacenter.world.SubArea;
   import com.ankamagames.dofus.internalDatacenter.items.IdolsPresetWrapper;
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import com.ankamagames.dofus.internalDatacenter.items.WeaponWrapper;
   import com.ankamagames.dofus.internalDatacenter.spells.SpellWrapper;
   import com.ankamagames.dofus.internalDatacenter.world.WorldPointWrapper;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.common.frames.MiscFrame;
   import com.ankamagames.dofus.logic.game.common.frames.AbstractEntitiesFrame;
   import com.ankamagames.dofus.logic.game.common.frames.PlayedCharacterUpdatesFrame;
   import com.ankamagames.dofus.logic.game.common.frames.TinselFrame;
   import com.ankamagames.dofus.logic.game.common.managers.EntitiesLooksManager;
   import com.ankamagames.dofus.logic.game.common.managers.InventoryManager;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.logic.game.common.misc.DofusEntities;
   import com.ankamagames.dofus.logic.game.fight.frames.FightContextFrame;
   import com.ankamagames.dofus.logic.game.fight.frames.FightEntitiesFrame;
   import com.ankamagames.dofus.logic.game.fight.frames.FightPreparationFrame;
   import com.ankamagames.dofus.logic.game.fight.managers.CurrentPlayedFighterManager;
   import com.ankamagames.dofus.logic.game.roleplay.frames.RoleplayContextFrame;
   import com.ankamagames.dofus.logic.game.roleplay.frames.RoleplayEntitiesFrame;
   import com.ankamagames.dofus.logic.game.roleplay.types.CharacterTooltipInformation;
   import com.ankamagames.dofus.misc.EntityLookAdapter;
   import com.ankamagames.dofus.network.enums.AlignmentSideEnum;
   import com.ankamagames.dofus.network.enums.PlayerLifeStatusEnum;
   import com.ankamagames.dofus.network.enums.SubEntityBindingPointCategoryEnum;
   import com.ankamagames.dofus.network.types.game.character.characteristic.CharacterCharacteristicsInformations;
   import com.ankamagames.dofus.network.types.game.character.characteristic.CharacterSpellModification;
   import com.ankamagames.dofus.network.types.game.character.choice.CharacterBaseInformations;
   import com.ankamagames.dofus.network.types.game.character.restriction.ActorRestrictionsInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayActorInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayCharacterInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayMutantInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.HumanOptionTitle;
   import com.ankamagames.dofus.network.types.game.house.AccountHouseInformations;
   import com.ankamagames.dofus.types.data.PlayerSetInfo;
   import com.ankamagames.dofus.types.entities.AnimatedCharacter;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.tiphon.types.look.TiphonEntityLook;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   
   public class PlayedCharacterApi implements IApi
   {
      
      public static var MEMORY_LOG:Dictionary = new Dictionary(true);
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(PlayedCharacterApi));
      
      private static var _instance:PlayedCharacterApi;
       
      
      public function PlayedCharacterApi()
      {
         super();
         MEMORY_LOG[this] = 1;
         _instance = this;
      }
      
      public static function getInstance() : PlayedCharacterApi
      {
         return _instance;
      }
      
      [Untrusted]
      public function characteristics() : CharacterCharacteristicsInformations
      {
         return PlayedCharacterManager.getInstance().characteristics;
      }
      
      [Untrusted]
      public function getPlayedCharacterInfo() : Object
      {
         var _loc1_:CharacterBaseInformations = PlayedCharacterManager.getInstance().infos;
         if(!_loc1_)
         {
            return null;
         }
         var _loc2_:Object = new Object();
         _loc2_.id = _loc1_.id;
         _loc2_.breed = _loc1_.breed;
         _loc2_.level = _loc1_.level;
         _loc2_.sex = _loc1_.sex;
         _loc2_.name = _loc1_.name;
         _loc2_.entityLook = EntityLookAdapter.fromNetwork(_loc1_.entityLook);
         _loc2_.realEntityLook = _loc2_.entityLook;
         if(this.isCreature() && PlayedCharacterManager.getInstance().realEntityLook)
         {
            _loc2_.entityLook = EntityLookAdapter.fromNetwork(PlayedCharacterManager.getInstance().realEntityLook);
         }
         var _loc3_:TiphonEntityLook = TiphonEntityLook(_loc2_.entityLook).getSubEntity(SubEntityBindingPointCategoryEnum.HOOK_POINT_CATEGORY_MOUNT_DRIVER,0);
         if(_loc3_)
         {
            if(_loc3_.getBone() == 2)
            {
               _loc3_.setBone(1);
            }
            _loc2_.entityLook = _loc3_;
         }
         return _loc2_;
      }
      
      [Untrusted]
      public function getCurrentEntityLook() : Object
      {
         var _loc1_:TiphonEntityLook = null;
         var _loc2_:AnimatedCharacter = DofusEntities.getEntity(PlayedCharacterManager.getInstance().id) as AnimatedCharacter;
         if(_loc2_)
         {
            _loc1_ = _loc2_.look.clone();
         }
         else
         {
            _loc1_ = EntityLookAdapter.fromNetwork(PlayedCharacterManager.getInstance().infos.entityLook);
         }
         return _loc1_;
      }
      
      [Untrusted]
      public function getInventory() : Vector.<ItemWrapper>
      {
         return InventoryManager.getInstance().realInventory;
      }
      
      [Untrusted]
      public function getEquipment() : Array
      {
         var _loc2_:* = undefined;
         var _loc1_:Array = new Array();
         for each(_loc2_ in PlayedCharacterManager.getInstance().inventory)
         {
            if(_loc2_.position <= 15)
            {
               _loc1_.push(_loc2_);
            }
         }
         return _loc1_;
      }
      
      [Untrusted]
      public function getSpellInventory() : Array
      {
         return PlayedCharacterManager.getInstance().spellsInventory;
      }
      
      [Untrusted]
      public function getJobs() : Array
      {
         return PlayedCharacterManager.getInstance().jobs;
      }
      
      [Untrusted]
      public function getMount() : Object
      {
         return PlayedCharacterManager.getInstance().mount;
      }
      
      [Untrusted]
      public function getTitle() : Title
      {
         var _loc2_:Title = null;
         var _loc3_:GameRolePlayCharacterInformations = null;
         var _loc4_:* = undefined;
         var _loc5_:Title = null;
         var _loc1_:int = (Kernel.getWorker().getFrame(TinselFrame) as TinselFrame).currentTitle;
         if(_loc1_)
         {
            _loc2_ = Title.getTitleById(_loc1_);
            return _loc2_;
         }
         _loc3_ = this.getEntityInfos();
         if(_loc3_ && _loc3_.humanoidInfo)
         {
            for each(_loc4_ in _loc3_.humanoidInfo.options)
            {
               if(_loc4_ is HumanOptionTitle)
               {
                  _loc1_ = _loc4_.titleId;
               }
            }
            _loc5_ = Title.getTitleById(_loc1_);
            return _loc5_;
         }
         return null;
      }
      
      [Untrusted]
      public function getOrnament() : Ornament
      {
         var _loc2_:Ornament = null;
         var _loc1_:int = (Kernel.getWorker().getFrame(TinselFrame) as TinselFrame).currentOrnament;
         if(_loc1_)
         {
            _loc2_ = Ornament.getOrnamentById(_loc1_);
            return _loc2_;
         }
         return null;
      }
      
      [Untrusted]
      public function getKnownTitles() : Vector.<uint>
      {
         return (Kernel.getWorker().getFrame(TinselFrame) as TinselFrame).knownTitles;
      }
      
      [Untrusted]
      public function getKnownOrnaments() : Vector.<uint>
      {
         return (Kernel.getWorker().getFrame(TinselFrame) as TinselFrame).knownOrnaments;
      }
      
      [Untrusted]
      public function titlesOrnamentsAskedBefore() : Boolean
      {
         return (Kernel.getWorker().getFrame(TinselFrame) as TinselFrame).titlesOrnamentsAskedBefore;
      }
      
      [Untrusted]
      public function getEntityInfos() : GameRolePlayCharacterInformations
      {
         var _loc1_:AbstractEntitiesFrame = null;
         if(this.isInFight())
         {
            _loc1_ = Kernel.getWorker().getFrame(FightEntitiesFrame) as AbstractEntitiesFrame;
         }
         else
         {
            _loc1_ = Kernel.getWorker().getFrame(RoleplayEntitiesFrame) as AbstractEntitiesFrame;
         }
         if(!_loc1_)
         {
            return null;
         }
         var _loc2_:GameRolePlayCharacterInformations = _loc1_.getEntityInfos(PlayedCharacterManager.getInstance().id) as GameRolePlayCharacterInformations;
         return _loc2_;
      }
      
      [Untrusted]
      public function getEntityTooltipInfos() : CharacterTooltipInformation
      {
         var _loc1_:GameRolePlayCharacterInformations = this.getEntityInfos();
         if(!_loc1_)
         {
            return null;
         }
         var _loc2_:CharacterTooltipInformation = new CharacterTooltipInformation(_loc1_,0);
         return _loc2_;
      }
      
      [Untrusted]
      public function inventoryWeight() : uint
      {
         return PlayedCharacterManager.getInstance().inventoryWeight;
      }
      
      [Untrusted]
      public function inventoryWeightMax() : uint
      {
         return PlayedCharacterManager.getInstance().inventoryWeightMax;
      }
      
      [Untrusted]
      public function isIncarnation() : Boolean
      {
         return PlayedCharacterManager.getInstance().isIncarnation;
      }
      
      [Untrusted]
      public function isMutated() : Boolean
      {
         return PlayedCharacterManager.getInstance().isMutated;
      }
      
      [Untrusted]
      public function isInHouse() : Boolean
      {
         return PlayedCharacterManager.getInstance().isInHouse;
      }
      
      [Untrusted]
      public function isInExchange() : Boolean
      {
         return PlayedCharacterManager.getInstance().isInExchange;
      }
      
      [Untrusted]
      public function isInFight() : Boolean
      {
         return Kernel.getWorker().getFrame(FightContextFrame) != null;
      }
      
      [Untrusted]
      public function isInPreFight() : Boolean
      {
         return Kernel.getWorker().contains(FightPreparationFrame) || Kernel.getWorker().isBeingAdded(FightPreparationFrame);
      }
      
      [Untrusted]
      public function isInParty() : Boolean
      {
         return PlayedCharacterManager.getInstance().isInParty;
      }
      
      [Untrusted]
      public function isPartyLeader() : Boolean
      {
         return PlayedCharacterManager.getInstance().isPartyLeader;
      }
      
      [Untrusted]
      public function isRidding() : Boolean
      {
         return PlayedCharacterManager.getInstance().isRidding;
      }
      
      [Untrusted]
      public function isPetsMounting() : Boolean
      {
         return PlayedCharacterManager.getInstance().isPetsMounting;
      }
      
      [Untrusted]
      public function hasCompanion() : Boolean
      {
         return PlayedCharacterManager.getInstance().hasCompanion;
      }
      
      [Untrusted]
      public function id() : Number
      {
         return PlayedCharacterManager.getInstance().id;
      }
      
      [Untrusted]
      public function restrictions() : ActorRestrictionsInformations
      {
         return PlayedCharacterManager.getInstance().restrictions;
      }
      
      [Untrusted]
      public function isMutant() : Boolean
      {
         var _loc1_:RoleplayContextFrame = Kernel.getWorker().getFrame(RoleplayContextFrame) as RoleplayContextFrame;
         var _loc2_:GameRolePlayActorInformations = _loc1_.entitiesFrame.getEntityInfos(PlayedCharacterManager.getInstance().id) as GameRolePlayActorInformations;
         return _loc2_ is GameRolePlayMutantInformations;
      }
      
      [Untrusted]
      public function publicMode() : Boolean
      {
         return PlayedCharacterManager.getInstance().publicMode;
      }
      
      [Untrusted]
      public function artworkId() : int
      {
         return PlayedCharacterManager.getInstance().artworkId;
      }
      
      [Untrusted]
      public function isCreature() : Boolean
      {
         return EntitiesLooksManager.getInstance().isCreature(this.id());
      }
      
      [Untrusted]
      public function getBone() : uint
      {
         var _loc1_:CharacterBaseInformations = PlayedCharacterManager.getInstance().infos;
         return EntityLookAdapter.fromNetwork(_loc1_.entityLook).getBone();
      }
      
      [Untrusted]
      public function getSkin() : uint
      {
         var _loc1_:CharacterBaseInformations = PlayedCharacterManager.getInstance().infos;
         if(EntityLookAdapter.fromNetwork(_loc1_.entityLook) && EntityLookAdapter.fromNetwork(_loc1_.entityLook).getSkins() && EntityLookAdapter.fromNetwork(_loc1_.entityLook).getSkins().length > 0)
         {
            return EntityLookAdapter.fromNetwork(_loc1_.entityLook).getSkins()[0];
         }
         return 0;
      }
      
      [Untrusted]
      public function getColors() : Object
      {
         var _loc1_:CharacterBaseInformations = PlayedCharacterManager.getInstance().infos;
         return EntityLookAdapter.fromNetwork(_loc1_.entityLook).getColors();
      }
      
      [Untrusted]
      public function getSubentityColors() : Object
      {
         var _loc1_:CharacterBaseInformations = PlayedCharacterManager.getInstance().infos;
         var _loc2_:TiphonEntityLook = EntityLookAdapter.fromNetwork(_loc1_.entityLook).getSubEntity(SubEntityBindingPointCategoryEnum.HOOK_POINT_CATEGORY_MOUNT_DRIVER,0);
         if(!_loc2_ && PlayedCharacterManager.getInstance().realEntityLook)
         {
            _loc2_ = EntityLookAdapter.fromNetwork(PlayedCharacterManager.getInstance().realEntityLook).getSubEntity(SubEntityBindingPointCategoryEnum.HOOK_POINT_CATEGORY_MOUNT_DRIVER,0);
         }
         return !!_loc2_?_loc2_.getColors():null;
      }
      
      [Untrusted]
      public function getAlignmentSide() : int
      {
         if(PlayedCharacterManager.getInstance().characteristics)
         {
            return PlayedCharacterManager.getInstance().characteristics.alignmentInfos.alignmentSide;
         }
         return AlignmentSideEnum.ALIGNMENT_NEUTRAL;
      }
      
      [Untrusted]
      public function getAlignmentValue() : uint
      {
         return PlayedCharacterManager.getInstance().characteristics.alignmentInfos.alignmentValue;
      }
      
      [Untrusted]
      public function getAlignmentAggressableStatus() : uint
      {
         return PlayedCharacterManager.getInstance().characteristics.alignmentInfos.aggressable;
      }
      
      [Untrusted]
      public function getAlignmentGrade() : uint
      {
         return PlayedCharacterManager.getInstance().characteristics.alignmentInfos.alignmentGrade;
      }
      
      [Untrusted]
      public function getMaxSummonedCreature() : uint
      {
         return CurrentPlayedFighterManager.getInstance().getMaxSummonedCreature();
      }
      
      [Untrusted]
      public function getCurrentSummonedCreature() : uint
      {
         return CurrentPlayedFighterManager.getInstance().getCurrentSummonedCreature();
      }
      
      [Untrusted]
      public function canSummon() : Boolean
      {
         return CurrentPlayedFighterManager.getInstance().canSummon();
      }
      
      [Untrusted]
      public function getSpell(param1:uint) : SpellWrapper
      {
         return CurrentPlayedFighterManager.getInstance().getSpellById(param1);
      }
      
      [Untrusted]
      public function canCastThisSpell(param1:uint, param2:uint) : Boolean
      {
         return CurrentPlayedFighterManager.getInstance().canCastThisSpell(param1,param2);
      }
      
      [Untrusted]
      public function canCastThisSpellWithResult(param1:uint, param2:uint, param3:Number = 0) : String
      {
         var _loc4_:Array = ["."];
         CurrentPlayedFighterManager.getInstance().canCastThisSpell(param1,param2,param3,_loc4_);
         return _loc4_[0];
      }
      
      [Untrusted]
      public function canCastThisSpellOnTarget(param1:uint, param2:uint, param3:Number) : Boolean
      {
         return CurrentPlayedFighterManager.getInstance().canCastThisSpell(param1,param2,param3);
      }
      
      [Untrusted]
      public function getSpellModification(param1:uint, param2:int) : int
      {
         var _loc3_:CharacterSpellModification = CurrentPlayedFighterManager.getInstance().getSpellModifications(param1,param2);
         if(_loc3_ && _loc3_.value)
         {
            return _loc3_.value.alignGiftBonus + _loc3_.value.base + _loc3_.value.additionnal + _loc3_.value.contextModif + _loc3_.value.objectsAndMountBonus;
         }
         return 0;
      }
      
      [Untrusted]
      public function isInHisHouse() : Boolean
      {
         return PlayedCharacterManager.getInstance().isInHisHouse;
      }
      
      [Untrusted]
      public function getPlayerHouses() : Vector.<AccountHouseInformations>
      {
         return (Kernel.getWorker().getFrame(MiscFrame) as MiscFrame).accountHouses;
      }
      
      [Untrusted]
      public function currentMap() : WorldPointWrapper
      {
         return PlayedCharacterManager.getInstance().currentMap;
      }
      
      [Untrusted]
      public function currentSubArea() : SubArea
      {
         return PlayedCharacterManager.getInstance().currentSubArea;
      }
      
      [Untrusted]
      public function state() : uint
      {
         return PlayedCharacterManager.getInstance().state;
      }
      
      [Untrusted]
      public function isAlive() : Boolean
      {
         return PlayedCharacterManager.getInstance().state == PlayerLifeStatusEnum.STATUS_ALIVE_AND_KICKING;
      }
      
      [Untrusted]
      public function getFollowingPlayerIds() : Vector.<Number>
      {
         return PlayedCharacterManager.getInstance().followingPlayerIds;
      }
      
      [Untrusted]
      public function getPlayerSet(param1:uint) : PlayerSetInfo
      {
         return PlayedCharacterUpdatesFrame(Kernel.getWorker().getFrame(PlayedCharacterUpdatesFrame)).getPlayerSet(param1);
      }
      
      [Untrusted]
      public function getWeapon() : WeaponWrapper
      {
         return PlayedCharacterManager.getInstance().currentWeapon;
      }
      
      [Untrusted]
      public function getExperienceBonusPercent() : int
      {
         return PlayedCharacterManager.getInstance().experiencePercent;
      }
      
      [Untrusted]
      public function getAchievementPoints() : int
      {
         return PlayedCharacterManager.getInstance().achievementPoints;
      }
      
      [Untrusted]
      public function getWaitingGifts() : Array
      {
         return PlayedCharacterManager.getInstance().waitingGifts;
      }
      
      [Untrusted]
      public function getSoloIdols() : Vector.<uint>
      {
         return PlayedCharacterManager.getInstance().soloIdols;
      }
      
      [Untrusted]
      public function getPartyIdols() : Vector.<uint>
      {
         return PlayedCharacterManager.getInstance().partyIdols;
      }
      
      [Untrusted]
      public function getIdolsPresets() : Vector.<IdolsPresetWrapper>
      {
         return PlayedCharacterManager.getInstance().idolsPresets;
      }
      
      [Untrusted]
      public function knowSpell(param1:uint) : int
      {
         var _loc4_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:SpellWrapper = null;
         var _loc8_:Boolean = false;
         var _loc9_:SpellWrapper = null;
         var _loc10_:SpellLevel = null;
         var _loc2_:Spell = Spell.getSpellById(param1);
         var _loc3_:SpellLevel = SpellLevel.getLevelById(param1);
         if(param1 == 0)
         {
            _loc4_ = 0;
         }
         else
         {
            _loc10_ = _loc2_.getSpellLevel(1);
            _loc4_ = _loc10_.minPlayerLevel;
         }
         var _loc5_:Array = this.getSpellInventory();
         for each(_loc7_ in _loc5_)
         {
            if(_loc7_.spellId == param1)
            {
               _loc6_ = _loc7_.spellLevel;
            }
         }
         _loc8_ = true;
         for each(_loc9_ in _loc5_)
         {
            if(_loc9_.spellId == param1)
            {
               _loc8_ = false;
            }
         }
         if(_loc8_)
         {
            return -1;
         }
         return _loc6_;
      }
      
      [Untrusted]
      public function isInHisHavenbag() : Boolean
      {
         return PlayedCharacterManager.getInstance().isInHisHavenbag;
      }
      
      [Untrusted]
      public function isInHavenbag() : Boolean
      {
         return PlayedCharacterManager.getInstance().isInHavenbag;
      }
   }
}
