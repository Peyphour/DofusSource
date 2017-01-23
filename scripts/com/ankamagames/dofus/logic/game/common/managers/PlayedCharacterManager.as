package com.ankamagames.dofus.logic.game.common.managers
{
   import com.ankamagames.dofus.datacenter.breeds.Breed;
   import com.ankamagames.dofus.datacenter.world.SubArea;
   import com.ankamagames.dofus.datacenter.world.WorldMap;
   import com.ankamagames.dofus.internalDatacenter.items.IdolsPresetWrapper;
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import com.ankamagames.dofus.internalDatacenter.items.WeaponWrapper;
   import com.ankamagames.dofus.internalDatacenter.mount.MountData;
   import com.ankamagames.dofus.internalDatacenter.world.WorldPointWrapper;
   import com.ankamagames.dofus.misc.EntityLookAdapter;
   import com.ankamagames.dofus.network.ProtocolConstantsEnum;
   import com.ankamagames.dofus.network.enums.CharacterInventoryPositionEnum;
   import com.ankamagames.dofus.network.enums.SubEntityBindingPointCategoryEnum;
   import com.ankamagames.dofus.network.types.game.character.characteristic.CharacterCharacteristicsInformations;
   import com.ankamagames.dofus.network.types.game.character.choice.CharacterBaseInformations;
   import com.ankamagames.dofus.network.types.game.character.restriction.ActorRestrictionsInformations;
   import com.ankamagames.dofus.network.types.game.look.EntityLook;
   import com.ankamagames.jerakine.interfaces.IDestroyable;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.utils.errors.SingletonError;
   import com.ankamagames.tiphon.types.look.TiphonEntityLook;
   import flash.geom.Point;
   import flash.utils.getQualifiedClassName;
   
   public class PlayedCharacterManager implements IDestroyable
   {
      
      private static var _self:PlayedCharacterManager;
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(PlayedCharacterManager));
       
      
      private var _isPartyLeader:Boolean = false;
      
      private var _followingPlayerIds:Vector.<Number>;
      
      private var _soloIdols:Vector.<uint>;
      
      private var _partyIdols:Vector.<uint>;
      
      private var _idolsPresets:Vector.<IdolsPresetWrapper>;
      
      public var infos:CharacterBaseInformations;
      
      public var restrictions:ActorRestrictionsInformations;
      
      public var realEntityLook:EntityLook;
      
      public var characteristics:CharacterCharacteristicsInformations;
      
      public var spellsInventory:Array;
      
      public var playerSpellList:Array;
      
      public var playerShortcutList:Array;
      
      public var inventory:Vector.<ItemWrapper>;
      
      public var currentWeapon:WeaponWrapper;
      
      public var inventoryWeight:uint;
      
      public var inventoryWeightMax:uint;
      
      public var currentMap:WorldPointWrapper;
      
      public var currentSubArea:SubArea;
      
      public var jobs:Array;
      
      public var isInExchange:Boolean = false;
      
      public var isInHisHouse:Boolean = false;
      
      public var isInHouse:Boolean = false;
      
      public var isInHisHavenbag:Boolean = false;
      
      public var isInHavenbag:Boolean = false;
      
      public var currentHavenbagTotalRooms:uint;
      
      public var lastCoord:Point;
      
      public var isInParty:Boolean = false;
      
      public var state:uint;
      
      public var publicMode:Boolean = false;
      
      public var isRidding:Boolean = false;
      
      public var isPetsMounting:Boolean = false;
      
      public var hasCompanion:Boolean = false;
      
      public var mount:MountData;
      
      public var isFighting:Boolean = false;
      
      public var teamId:int = 0;
      
      public var isSpectator:Boolean = false;
      
      public var experiencePercent:int = 0;
      
      public var achievementPoints:int = 0;
      
      public var achievementPercent:int = 0;
      
      public var waitingGifts:Array;
      
      public function PlayedCharacterManager()
      {
         this._followingPlayerIds = new Vector.<Number>();
         this._soloIdols = new Vector.<uint>();
         this._partyIdols = new Vector.<uint>();
         this._idolsPresets = new Vector.<IdolsPresetWrapper>(0);
         this.lastCoord = new Point(0,0);
         this.waitingGifts = new Array();
         super();
         if(_self != null)
         {
            throw new SingletonError("PlayedCharacterManager is a singleton and should not be instanciated directly.");
         }
      }
      
      public static function getInstance() : PlayedCharacterManager
      {
         if(_self == null)
         {
            _self = new PlayedCharacterManager();
         }
         return _self;
      }
      
      public function get id() : Number
      {
         if(this.infos)
         {
            return this.infos.id;
         }
         return 0;
      }
      
      public function set id(param1:Number) : void
      {
         if(this.infos)
         {
            this.infos.id = param1;
         }
      }
      
      public function get cantMinimize() : Boolean
      {
         return this.restrictions.cantMinimize;
      }
      
      public function get forceSlowWalk() : Boolean
      {
         return this.restrictions.forceSlowWalk;
      }
      
      public function get cantUseTaxCollector() : Boolean
      {
         return this.restrictions.cantUseTaxCollector;
      }
      
      public function get cantTrade() : Boolean
      {
         return this.restrictions.cantTrade;
      }
      
      public function get cantRun() : Boolean
      {
         return this.restrictions.cantRun;
      }
      
      public function get cantMove() : Boolean
      {
         return this.restrictions.cantMove;
      }
      
      public function get cantBeChallenged() : Boolean
      {
         return this.restrictions.cantBeChallenged;
      }
      
      public function get cantBeAttackedByMutant() : Boolean
      {
         return this.restrictions.cantBeAttackedByMutant;
      }
      
      public function get cantBeAggressed() : Boolean
      {
         return this.restrictions.cantBeAggressed;
      }
      
      public function get cantAttack() : Boolean
      {
         return this.restrictions.cantAttack;
      }
      
      public function get cantAgress() : Boolean
      {
         return this.restrictions.cantAggress;
      }
      
      public function get cantChallenge() : Boolean
      {
         return this.restrictions.cantChallenge;
      }
      
      public function get cantExchange() : Boolean
      {
         return this.restrictions.cantExchange;
      }
      
      public function get cantChat() : Boolean
      {
         return this.restrictions.cantChat;
      }
      
      public function get cantBeMerchant() : Boolean
      {
         return this.restrictions.cantBeMerchant;
      }
      
      public function get cantUseObject() : Boolean
      {
         return this.restrictions.cantUseObject;
      }
      
      public function get cantUseInteractiveObject() : Boolean
      {
         return this.restrictions.cantUseInteractive;
      }
      
      public function get cantSpeakToNpc() : Boolean
      {
         return this.restrictions.cantSpeakToNPC;
      }
      
      public function get cantChangeZone() : Boolean
      {
         return this.restrictions.cantChangeZone;
      }
      
      public function get cantAttackMonster() : Boolean
      {
         return this.restrictions.cantAttackMonster;
      }
      
      public function get cantWalkInEightDirections() : Boolean
      {
         return this.restrictions.cantWalk8Directions;
      }
      
      public function get limitedLevel() : uint
      {
         if(this.infos)
         {
            if(this.infos.level > ProtocolConstantsEnum.MAX_LEVEL)
            {
               return ProtocolConstantsEnum.MAX_LEVEL;
            }
            return this.infos.level;
         }
         return 0;
      }
      
      public function get currentWorldMap() : WorldMap
      {
         if(this.currentSubArea)
         {
            return this.currentSubArea.worldmap;
         }
         return null;
      }
      
      public function get isIncarnation() : Boolean
      {
         return EntitiesLooksManager.getInstance().isIncarnation(this.id);
      }
      
      public function get isMutated() : Boolean
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc1_:Vector.<ItemWrapper> = InventoryManager.getInstance().inventory.getView("roleplayBuff").content;
         if(_loc1_)
         {
            _loc2_ = _loc1_.length;
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               if(_loc1_[_loc3_] && _loc1_[_loc3_].typeId == 27 && _loc1_[_loc3_].position == CharacterInventoryPositionEnum.INVENTORY_POSITION_MUTATION)
               {
                  return true;
               }
               _loc3_++;
            }
         }
         return false;
      }
      
      public function set isPartyLeader(param1:Boolean) : void
      {
         if(!this.isInParty)
         {
            this._isPartyLeader = false;
         }
         else
         {
            this._isPartyLeader = param1;
         }
      }
      
      public function get isPartyLeader() : Boolean
      {
         return this._isPartyLeader;
      }
      
      public function get isGhost() : Boolean
      {
         var _loc1_:Boolean = false;
         var _loc5_:Breed = null;
         var _loc2_:TiphonEntityLook = EntityLookAdapter.fromNetwork(this.infos.entityLook);
         var _loc3_:Boolean = false;
         var _loc4_:Array = Breed.getBreeds();
         for each(_loc5_ in _loc4_)
         {
            if(_loc5_.creatureBonesId == _loc2_.getBone())
            {
               _loc3_ = true;
               break;
            }
         }
         return !_loc2_.getSubEntity(SubEntityBindingPointCategoryEnum.HOOK_POINT_CATEGORY_MOUNT_DRIVER,0) && !_loc3_ && _loc2_.getBone() != 1 && !this.isIncarnation;
      }
      
      public function get artworkId() : uint
      {
         return this.infos.entityLook.bonesId == 1?uint(this.infos.entityLook.skins[0]):uint(this.infos.entityLook.bonesId);
      }
      
      public function get followingPlayerIds() : Vector.<Number>
      {
         return this._followingPlayerIds;
      }
      
      public function set followingPlayerIds(param1:Vector.<Number>) : void
      {
         this._followingPlayerIds = param1;
      }
      
      public function get soloIdols() : Vector.<uint>
      {
         return this._soloIdols;
      }
      
      public function set soloIdols(param1:Vector.<uint>) : void
      {
         this._soloIdols = param1;
      }
      
      public function get partyIdols() : Vector.<uint>
      {
         return this._partyIdols;
      }
      
      public function set partyIdols(param1:Vector.<uint>) : void
      {
         this._partyIdols = param1;
      }
      
      public function get idolsPresets() : Vector.<IdolsPresetWrapper>
      {
         return this._idolsPresets;
      }
      
      public function set idolsPresets(param1:Vector.<IdolsPresetWrapper>) : void
      {
         this._idolsPresets = param1;
      }
      
      public function destroy() : void
      {
         _self = null;
      }
      
      public function get tiphonEntityLook() : TiphonEntityLook
      {
         return EntityLookAdapter.fromNetwork(this.infos.entityLook);
      }
      
      public function levelDiff(param1:uint) : int
      {
         var _loc3_:int = 0;
         var _loc2_:int = this.limitedLevel;
         if(param1 > ProtocolConstantsEnum.MAX_LEVEL)
         {
            param1 = ProtocolConstantsEnum.MAX_LEVEL;
         }
         var _loc4_:int = 1;
         if(param1 < _loc2_)
         {
            _loc4_ = -1;
         }
         if(Math.abs(param1 - _loc2_) > 20)
         {
            _loc3_ = 1 * _loc4_;
         }
         else if(param1 > _loc2_)
         {
            if(param1 / _loc2_ < 1.2)
            {
               _loc3_ = 0;
            }
            else
            {
               _loc3_ = 1 * _loc4_;
            }
         }
         else if(_loc2_ / param1 < 1.2)
         {
            _loc3_ = 0;
         }
         else
         {
            _loc3_ = 1 * _loc4_;
         }
         return _loc3_;
      }
   }
}
