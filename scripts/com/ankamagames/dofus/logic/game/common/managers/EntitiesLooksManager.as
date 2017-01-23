package com.ankamagames.dofus.logic.game.common.managers
{
   import com.ankamagames.dofus.datacenter.appearance.Appearance;
   import com.ankamagames.dofus.datacenter.appearance.CreatureBoneOverride;
   import com.ankamagames.dofus.datacenter.appearance.CreatureBoneType;
   import com.ankamagames.dofus.datacenter.breeds.Breed;
   import com.ankamagames.dofus.datacenter.effects.instances.EffectInstanceDice;
   import com.ankamagames.dofus.datacenter.items.Incarnation;
   import com.ankamagames.dofus.datacenter.monsters.Companion;
   import com.ankamagames.dofus.datacenter.monsters.Monster;
   import com.ankamagames.dofus.datacenter.spells.SpellLevel;
   import com.ankamagames.dofus.logic.game.common.frames.AbstractEntitiesFrame;
   import com.ankamagames.dofus.logic.game.common.misc.DofusEntities;
   import com.ankamagames.dofus.logic.game.fight.frames.FightEntitiesFrame;
   import com.ankamagames.dofus.logic.game.fight.managers.BuffManager;
   import com.ankamagames.dofus.logic.game.fight.miscs.ActionIdConverter;
   import com.ankamagames.dofus.logic.game.fight.types.BasicBuff;
   import com.ankamagames.dofus.logic.game.roleplay.frames.RoleplayEntitiesFrame;
   import com.ankamagames.dofus.misc.EntityLookAdapter;
   import com.ankamagames.dofus.misc.utils.GameDataQuery;
   import com.ankamagames.dofus.network.enums.SubEntityBindingPointCategoryEnum;
   import com.ankamagames.dofus.network.types.game.context.GameContextActorInformations;
   import com.ankamagames.dofus.network.types.game.context.GameRolePlayTaxCollectorInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightCharacterInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightCompanionInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightMonsterInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightMutantInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightTaxCollectorInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayActorInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayGroupMonsterInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayHumanoidInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayMerchantInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayPrismInformations;
   import com.ankamagames.dofus.network.types.game.look.EntityLook;
   import com.ankamagames.dofus.types.entities.AnimatedCharacter;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.tiphon.types.TiphonUtility;
   import com.ankamagames.tiphon.types.look.TiphonEntityLook;
   import flash.utils.getQualifiedClassName;
   
   public class EntitiesLooksManager
   {
      
      private static const _log:Logger = Log.getLogger(getQualifiedClassName(EntitiesLooksManager));
      
      private static var _self:EntitiesLooksManager;
       
      
      private var _entitiesFrame:AbstractEntitiesFrame;
      
      public function EntitiesLooksManager()
      {
         super();
      }
      
      public static function getInstance() : EntitiesLooksManager
      {
         if(!_self)
         {
            _self = new EntitiesLooksManager();
         }
         return _self;
      }
      
      public function set entitiesFrame(param1:AbstractEntitiesFrame) : void
      {
         this._entitiesFrame = param1;
      }
      
      public function isCreatureMode() : Boolean
      {
         if(!this._entitiesFrame)
         {
            return false;
         }
         return this._entitiesFrame is RoleplayEntitiesFrame?Boolean((this._entitiesFrame as RoleplayEntitiesFrame).isCreatureMode):Boolean((this._entitiesFrame as FightEntitiesFrame).isInCreaturesFightMode());
      }
      
      public function isCreature(param1:Number) : Boolean
      {
         var _loc2_:TiphonEntityLook = this.getTiphonEntityLook(param1);
         if(_loc2_)
         {
            if(this.isCreatureFromLook(_loc2_) || this.isCreatureMode() && this.getLookFromContext(param1).getBone() == _loc2_.getBone())
            {
               return true;
            }
         }
         return false;
      }
      
      public function isCreatureFromLook(param1:TiphonEntityLook) : Boolean
      {
         var _loc4_:Breed = null;
         var _loc2_:uint = param1.getBone();
         var _loc3_:Array = Breed.getBreeds();
         for each(_loc4_ in _loc3_)
         {
            if(_loc4_.creatureBonesId == _loc2_)
            {
               return true;
            }
         }
         if(param1.getBone() == CreatureBoneType.getPlayerIncarnationCreatureBone())
         {
            return true;
         }
         return false;
      }
      
      public function isIncarnation(param1:Number) : Boolean
      {
         var _loc2_:TiphonEntityLook = this.getRealTiphonEntityLook(param1,true);
         if(_loc2_ && this.isIncarnationFromLook(_loc2_))
         {
            return true;
         }
         return false;
      }
      
      public function isIncarnationFromLook(param1:TiphonEntityLook) : Boolean
      {
         var _loc3_:Incarnation = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         if(param1.getBone() == CreatureBoneType.getPlayerIncarnationCreatureBone())
         {
            return true;
         }
         var _loc2_:Array = Incarnation.getAllIncarnation();
         var _loc4_:String = param1.toString();
         var _loc5_:String = _loc4_.slice(1,_loc4_.indexOf("|"));
         for each(_loc3_ in _loc2_)
         {
            _loc6_ = _loc3_.lookMale.slice(1,_loc3_.lookMale.indexOf("|"));
            _loc7_ = _loc3_.lookFemale.slice(1,_loc3_.lookFemale.indexOf("|"));
            if(_loc5_ == _loc6_ || _loc5_ == _loc7_)
            {
               return true;
            }
         }
         return false;
      }
      
      public function getTiphonEntityLook(param1:Number) : TiphonEntityLook
      {
         var _loc2_:AnimatedCharacter = DofusEntities.getEntity(param1) as AnimatedCharacter;
         return !!_loc2_?_loc2_.look.clone():null;
      }
      
      public function getRealTiphonEntityLook(param1:Number, param2:Boolean = false) : TiphonEntityLook
      {
         var _loc3_:EntityLook = null;
         var _loc5_:GameContextActorInformations = null;
         var _loc6_:TiphonEntityLook = null;
         if(this._entitiesFrame)
         {
            if(this._entitiesFrame is FightEntitiesFrame)
            {
               _loc3_ = (this._entitiesFrame as FightEntitiesFrame).getRealFighterLook(param1);
            }
            else
            {
               _loc5_ = this._entitiesFrame.getEntityInfos(param1);
               _loc3_ = !!_loc5_?_loc5_.look:null;
            }
         }
         if(!_loc3_ && param1 == PlayedCharacterManager.getInstance().id)
         {
            _loc3_ = PlayedCharacterManager.getInstance().infos.entityLook;
         }
         var _loc4_:TiphonEntityLook = !!_loc3_?EntityLookAdapter.fromNetwork(_loc3_):null;
         if(_loc4_ && param2)
         {
            _loc6_ = _loc4_.getSubEntity(SubEntityBindingPointCategoryEnum.HOOK_POINT_CATEGORY_MOUNT_DRIVER,0);
            if(_loc6_)
            {
               _loc4_ = _loc6_;
            }
         }
         return _loc4_;
      }
      
      public function getCreatureLook(param1:Number) : TiphonEntityLook
      {
         var _loc2_:GameContextActorInformations = !!this._entitiesFrame?this._entitiesFrame.getEntityInfos(param1):null;
         return !!_loc2_?this.getLookFromContextInfos(_loc2_,true):null;
      }
      
      public function getLookFromContext(param1:Number, param2:Boolean = false) : TiphonEntityLook
      {
         var _loc3_:GameContextActorInformations = !!this._entitiesFrame?this._entitiesFrame.getEntityInfos(param1):null;
         return !!_loc3_?this.getLookFromContextInfos(_loc3_,param2):null;
      }
      
      public function getLookFromContextInfos(param1:GameContextActorInformations, param2:Boolean = false) : TiphonEntityLook
      {
         var _loc4_:int = 0;
         var _loc5_:GameFightCompanionInformations = null;
         var _loc6_:Companion = null;
         var _loc7_:GameFightMonsterInformations = null;
         var _loc8_:* = false;
         var _loc9_:Monster = null;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:Breed = null;
         var _loc13_:TiphonEntityLook = null;
         var _loc14_:int = 0;
         var _loc15_:Array = null;
         var _loc16_:BasicBuff = null;
         var _loc17_:BasicBuff = null;
         var _loc18_:int = 0;
         var _loc3_:TiphonEntityLook = EntityLookAdapter.fromNetwork(param1.look);
         if(this.isCreatureMode() || param2)
         {
            if(param1 is GameRolePlayHumanoidInformations || param1 is GameFightCharacterInformations)
            {
               _loc3_ = !!_loc3_.getSubEntity(SubEntityBindingPointCategoryEnum.HOOK_POINT_CATEGORY_MOUNT_DRIVER,0)?TiphonUtility.getLookWithoutMount(_loc3_):_loc3_;
            }
            _loc4_ = CreatureBoneOverride.getCreatureBones(_loc3_.getBone());
            if(!(param1 is GameRolePlayGroupMonsterInformations) && _loc4_ != -1)
            {
               _loc3_.setBone(_loc4_);
            }
            else
            {
               switch(true)
               {
                  case param1 is GameRolePlayHumanoidInformations:
                  case param1 is GameFightCharacterInformations:
                     if(this.isIncarnation(param1.contextualId))
                     {
                        _loc3_.setBone(CreatureBoneType.getPlayerIncarnationCreatureBone());
                     }
                     else
                     {
                        _loc11_ = !!param1.hasOwnProperty("breed")?int(param1["breed"]):0;
                        _loc12_ = Breed.getBreedFromSkin(_loc3_.firstSkin);
                        if(_loc11_ <= 0 && _loc12_)
                        {
                           _loc11_ = _loc12_.id;
                        }
                        if(_loc11_ > 0)
                        {
                           _loc3_.setBone(Breed.getBreedById(_loc11_).creatureBonesId);
                        }
                        else
                        {
                           return _loc3_;
                        }
                     }
                     break;
                  case param1 is GameRolePlayPrismInformations:
                     _loc3_.setBone(CreatureBoneType.getPrismCreatureBone());
                     break;
                  case param1 is GameRolePlayMerchantInformations:
                     _loc3_.setBone(CreatureBoneType.getPlayerMerchantCreatureBone());
                     break;
                  case param1 is GameRolePlayTaxCollectorInformations:
                  case param1 is GameFightTaxCollectorInformations:
                     _loc3_.setBone(CreatureBoneType.getTaxCollectorCreatureBone());
                     break;
                  case param1 is GameFightCompanionInformations:
                     _loc5_ = param1 as GameFightCompanionInformations;
                     _loc6_ = Companion.getCompanionById(_loc5_.companionGenericId);
                     _loc3_.setBone(_loc6_.creatureBoneId);
                     break;
                  case param1 is GameFightMutantInformations:
                     _loc3_.setBone(CreatureBoneType.getMonsterCreatureBone());
                     break;
                  case param1 is GameFightMonsterInformations:
                     _loc7_ = param1 as GameFightMonsterInformations;
                     _loc8_ = _loc7_.creatureGenericId == 3451;
                     _loc9_ = Monster.getMonsterById(_loc7_.creatureGenericId);
                     if(_loc7_.stats.summoned)
                     {
                        _loc10_ = CreatureBoneType.getMonsterInvocationCreatureBone();
                     }
                     else if(_loc9_.isBoss)
                     {
                        _loc10_ = CreatureBoneType.getBossMonsterCreatureBone();
                     }
                     else if(_loc8_)
                     {
                        _loc10_ = CreatureBoneType.getPrismCreatureBone();
                     }
                     else
                     {
                        _loc10_ = CreatureBoneType.getMonsterCreatureBone();
                     }
                     _loc3_.setBone(_loc10_);
                     break;
                  case param1 is GameRolePlayActorInformations:
                     return _loc3_;
               }
            }
            _loc3_.setScales(0.9,0.9);
         }
         else if(param1 is GameFightCharacterInformations && !(this._entitiesFrame as FightEntitiesFrame).charactersMountsVisible)
         {
            _loc13_ = _loc3_.getSubEntity(SubEntityBindingPointCategoryEnum.HOOK_POINT_CATEGORY_MOUNT_DRIVER,0);
            if(!_loc13_)
            {
               _loc13_ = _loc3_;
            }
            _loc14_ = _loc13_.getBone();
            _loc3_ = TiphonUtility.getLookWithoutMount(_loc3_);
            if(_loc14_ == 2)
            {
               _loc15_ = BuffManager.getInstance().getAllBuff(param1.contextualId);
               if(_loc15_ && _loc15_.length > 0)
               {
                  _loc18_ = -1;
                  for each(_loc16_ in _loc15_)
                  {
                     if(_loc16_.actionId == ActionIdConverter.ACTION_CHARACTER_ADD_APPEARANCE)
                     {
                        if(_loc16_.stack && _loc16_.stack.length > 0)
                        {
                           for each(_loc17_ in _loc16_.stack)
                           {
                              _loc18_ = this.getAppearanceBone(_loc17_.dataUid);
                              if(_loc18_ != -1)
                              {
                                 break;
                              }
                           }
                        }
                        if(_loc18_ == -1)
                        {
                           _loc18_ = this.getAppearanceBone(_loc16_.dataUid);
                        }
                        if(_loc18_ != -1)
                        {
                           _loc3_.setBone(_loc18_);
                           break;
                        }
                     }
                  }
               }
            }
         }
         return _loc3_;
      }
      
      private function getAppearanceBone(param1:int) : int
      {
         var _loc5_:Boolean = false;
         var _loc7_:SpellLevel = null;
         var _loc8_:Vector.<EffectInstanceDice> = null;
         var _loc9_:EffectInstanceDice = null;
         var _loc2_:int = -1;
         var _loc3_:int = -1;
         var _loc4_:Vector.<uint> = GameDataQuery.queryEquals(SpellLevel,"effects.effectUid",param1);
         if(_loc4_.length == 0)
         {
            _loc4_ = GameDataQuery.queryEquals(SpellLevel,"criticalEffect.effectUid",param1);
            _loc5_ = true;
         }
         if(_loc4_.length > 0)
         {
            _loc7_ = SpellLevel.getLevelById(_loc4_[0]);
            _loc8_ = !_loc5_?_loc7_.effects:_loc7_.criticalEffect;
            for each(_loc9_ in _loc8_)
            {
               if(_loc9_.effectUid == param1)
               {
                  _loc3_ = _loc9_.parameter2 as int;
                  break;
               }
            }
         }
         var _loc6_:Appearance = Appearance.getAppearanceById(_loc3_);
         if(_loc6_ && _loc6_.type == 5)
         {
            return parseInt(_loc6_.data);
         }
         return -1;
      }
   }
}
