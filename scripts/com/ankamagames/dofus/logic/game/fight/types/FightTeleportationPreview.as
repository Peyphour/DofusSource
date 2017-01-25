package com.ankamagames.dofus.logic.game.fight.types
{
   import com.ankamagames.atouin.Atouin;
   import com.ankamagames.atouin.data.map.CellData;
   import com.ankamagames.atouin.enums.PlacementStrataEnums;
   import com.ankamagames.atouin.managers.EntitiesManager;
   import com.ankamagames.atouin.managers.MapDisplayManager;
   import com.ankamagames.berilia.managers.TooltipManager;
   import com.ankamagames.berilia.types.LocationEnum;
   import com.ankamagames.dofus.internalDatacenter.spells.SpellWrapper;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.game.common.misc.DofusEntities;
   import com.ankamagames.dofus.logic.game.fight.frames.FightContextFrame;
   import com.ankamagames.dofus.logic.game.fight.frames.FightEntitiesFrame;
   import com.ankamagames.dofus.logic.game.fight.managers.FightersStateManager;
   import com.ankamagames.dofus.logic.game.fight.miscs.CarrierAnimationModifier;
   import com.ankamagames.dofus.logic.game.fight.miscs.CarrierSubEntityBehaviour;
   import com.ankamagames.dofus.logic.game.fight.miscs.TeleportationUtil;
   import com.ankamagames.dofus.network.enums.SubEntityBindingPointCategoryEnum;
   import com.ankamagames.dofus.network.enums.TeamEnum;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightCharacterInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightFighterInformations;
   import com.ankamagames.dofus.types.entities.AnimatedCharacter;
   import com.ankamagames.dofus.types.entities.RiderBehavior;
   import com.ankamagames.dofus.types.enums.AnimationEnum;
   import com.ankamagames.jerakine.entities.interfaces.IEntity;
   import com.ankamagames.jerakine.interfaces.IRectangle;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   import com.ankamagames.jerakine.utils.display.Rectangle2;
   import com.ankamagames.tiphon.display.TiphonSprite;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   
   public class FightTeleportationPreview
   {
      
      private static const _log:Logger = Log.getLogger(getQualifiedClassName(FightTeleportationPreview));
       
      
      private var _currentSpell:SpellWrapper;
      
      private var _fightTeleportationCasterPos:MapPoint;
      
      private var _portalsExit:MapPoint;
      
      private var _previews:Vector.<AnimatedCharacter>;
      
      private var _teleFraggedEntities:Vector.<AnimatedCharacter>;
      
      private var _previewIdEntityIdAssoc:Dictionary;
      
      private var _fightTeleportations:Vector.<FightTeleportation>;
      
      private var _previewsPositions:Dictionary;
      
      public function FightTeleportationPreview(param1:SpellWrapper, param2:Vector.<FightTeleportation>, param3:MapPoint)
      {
         super();
         this._currentSpell = param1;
         this._previewIdEntityIdAssoc = new Dictionary();
         this._previewsPositions = new Dictionary();
         this._portalsExit = param3;
         this._fightTeleportations = param2;
      }
      
      public function getEntitiesIds() : Vector.<Number>
      {
         var _loc2_:FightTeleportation = null;
         var _loc3_:Number = NaN;
         var _loc1_:Vector.<Number> = new Vector.<Number>(0);
         for each(_loc2_ in this._fightTeleportations)
         {
            for each(_loc3_ in _loc2_.targets)
            {
               if(_loc1_.indexOf(_loc3_) == -1)
               {
                  _loc1_.push(_loc3_);
               }
            }
         }
         return _loc1_;
      }
      
      public function getTelefraggedEntitiesIds() : Vector.<Number>
      {
         var _loc2_:AnimatedCharacter = null;
         var _loc1_:Vector.<Number> = new Vector.<Number>(0);
         for each(_loc2_ in this._teleFraggedEntities)
         {
            _loc1_.push(!!this._previewIdEntityIdAssoc[_loc2_.id]?this._previewIdEntityIdAssoc[_loc2_.id]:_loc2_.id);
         }
         return _loc1_;
      }
      
      public function isPreview(param1:Number) : Boolean
      {
         return this.getPreview(param1) != null;
      }
      
      public function show() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:AnimatedCharacter = null;
         var _loc3_:AnimatedCharacter = null;
         var _loc4_:Number = NaN;
         var _loc5_:Function = null;
         var _loc6_:FightTeleportation = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         for each(_loc6_ in this._fightTeleportations)
         {
            _loc5_ = this.getTeleportFunction(_loc6_.effectId);
            this._fightTeleportationCasterPos = _loc6_.casterPos;
            _loc6_.targets.sort(this.compareDistanceFromCaster);
            _loc8_ = _loc6_.targets.length;
            _loc7_ = 0;
            while(_loc7_ < _loc8_)
            {
               _loc2_ = DofusEntities.getEntity(_loc6_.targets[_loc7_]) as AnimatedCharacter;
               if(_loc2_)
               {
                  _loc3_ = this.getParentEntity(_loc2_) as AnimatedCharacter;
                  _loc3_.visible = false;
                  _loc5_.apply(this,[!!_loc6_.allTargets?_loc2_.id:_loc3_.id,_loc6_]);
               }
               _loc7_++;
            }
         }
      }
      
      public function remove() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:AnimatedCharacter = null;
         var _loc3_:AnimatedCharacter = null;
         var _loc4_:Number = NaN;
         var _loc8_:AnimatedCharacter = null;
         var _loc9_:FightTeleportation = null;
         var _loc10_:AnimatedCharacter = null;
         var _loc5_:FightContextFrame = Kernel.getWorker().getFrame(FightContextFrame) as FightContextFrame;
         var _loc6_:Boolean = _loc5_.showPermanentTooltips && _loc5_.battleFrame.targetedEntities.length > 0;
         var _loc7_:AnimatedCharacter = EntitiesManager.getInstance().getEntityOnCell(FightContextFrame.currentCell,AnimatedCharacter) as AnimatedCharacter;
         _loc7_ = !!_loc7_?this.getParentEntity(_loc7_) as AnimatedCharacter:null;
         for each(_loc1_ in this.getEntitiesIds())
         {
            _loc2_ = DofusEntities.getEntity(_loc1_) as AnimatedCharacter;
            if(_loc2_)
            {
               _loc3_ = this.getParentEntity(_loc2_) as AnimatedCharacter;
               if(!_loc7_ || _loc7_.id != _loc3_.id)
               {
                  TooltipManager.hide("tooltipOverEntity_" + _loc3_.id);
                  if(_loc6_ && _loc5_.battleFrame.targetedEntities.indexOf(_loc3_.id) != -1)
                  {
                     _loc5_.displayEntityTooltip(_loc3_.id);
                  }
               }
               _loc3_.visible = true;
            }
         }
         if(this._previews)
         {
            for each(_loc8_ in this._previews)
            {
               _loc8_.destroy();
               _loc5_.entitiesFrame.updateEntityIconPosition(this._previewIdEntityIdAssoc[_loc8_.id]);
               delete this._previewsPositions[_loc8_.id];
            }
         }
         if(this._teleFraggedEntities)
         {
            for each(_loc8_ in this._teleFraggedEntities)
            {
               TooltipManager.hide("tooltipOverEntity_" + _loc8_.id);
               if(_loc6_ && _loc5_.battleFrame.targetedEntities.indexOf(_loc8_.id) != -1)
               {
                  _loc5_.displayEntityTooltip(_loc8_.id);
               }
               _loc8_.visible = true;
            }
         }
         for each(_loc9_ in this._fightTeleportations)
         {
            _loc10_ = DofusEntities.getEntity(_loc9_.casterId) as AnimatedCharacter;
            _loc10_.visible = true;
         }
      }
      
      private function getTeleportFunction(param1:uint) : Function
      {
         var _loc2_:Function = null;
         switch(param1)
         {
            case 1100:
               _loc2_ = this.teleportationToPreviousPosition;
               break;
            case 1104:
               _loc2_ = this.symetricTeleportation;
               break;
            case 1105:
               _loc2_ = this.symetricTeleportationFromCaster;
               break;
            case 1106:
               _loc2_ = this.symetricTeleportationFromImpactCell;
               break;
            case 8:
               _loc2_ = this.switchPositions;
         }
         return _loc2_;
      }
      
      private function symetricTeleportation(param1:Number, param2:FightTeleportation) : void
      {
         var _loc6_:AnimatedCharacter = null;
         var _loc3_:AnimatedCharacter = DofusEntities.getEntity(param1) as AnimatedCharacter;
         var _loc4_:MapPoint = !!this._portalsExit?this._portalsExit:param2.casterPos;
         var _loc5_:MapPoint = _loc4_.pointSymetry(param2.impactPos);
         if(_loc5_ && this.isValidCell(_loc5_.cellId) && EntitiesManager.getInstance().getEntitiesOnCell(param2.impactPos.cellId,AnimatedCharacter).length > 0)
         {
            _loc6_ = this.createFighterPreview(param1,_loc5_,_loc4_.advancedOrientationTo(param2.impactPos));
            this.checkTeleFrag(_loc6_,param1,_loc5_,_loc4_);
         }
         else
         {
            _loc3_.visible = true;
         }
      }
      
      private function symetricTeleportationFromCaster(param1:Number, param2:FightTeleportation) : void
      {
         var _loc10_:AnimatedCharacter = null;
         var _loc3_:AnimatedCharacter = DofusEntities.getEntity(param1) as AnimatedCharacter;
         var _loc4_:AnimatedCharacter = this.getPreview(param1);
         var _loc5_:MapPoint = !!_loc4_?_loc4_.position:_loc3_.position;
         var _loc6_:uint = this._currentSpell.playerId == param1?uint(_loc5_.advancedOrientationTo(param2.impactPos)):uint(_loc3_.getDirection());
         var _loc7_:AnimatedCharacter = this.getPreview(param2.casterId);
         var _loc8_:MapPoint = !!_loc7_?_loc7_.position:param2.casterPos;
         var _loc9_:MapPoint = _loc5_.pointSymetry(_loc8_);
         if(_loc9_ && this.isValidCell(_loc9_.cellId))
         {
            _loc10_ = this.createFighterPreview(param1,_loc9_,_loc6_);
            this.checkTeleFrag(_loc10_,param1,_loc9_,_loc5_);
         }
         else
         {
            _loc3_.visible = true;
         }
      }
      
      private function symetricTeleportationFromImpactCell(param1:Number, param2:FightTeleportation) : void
      {
         var _loc9_:uint = 0;
         var _loc10_:MapPoint = null;
         var _loc11_:AnimatedCharacter = null;
         var _loc3_:AnimatedCharacter = DofusEntities.getEntity(param1) as AnimatedCharacter;
         var _loc4_:AnimatedCharacter = this.getPreview(param1);
         var _loc5_:Boolean = _loc4_ && param2.multipleEffects;
         var _loc6_:MapPoint = param1 == param2.casterId?param2.casterPos:_loc3_.position;
         var _loc7_:MapPoint = !!_loc5_?_loc4_.position:_loc6_;
         var _loc8_:MapPoint = _loc7_.pointSymetry(param2.impactPos);
         if(_loc5_ && this.willSwitchPosition(_loc4_,_loc8_))
         {
            _loc8_ = _loc6_.pointSymetry(param2.impactPos);
         }
         if(_loc8_ && this.isValidCell(_loc8_.cellId))
         {
            _loc9_ = param1 == param2.targets[0]?uint(_loc6_.advancedOrientationTo(param2.impactPos)):uint(_loc3_.getDirection());
            _loc10_ = !!_loc4_?MapPoint.fromCellId(_loc4_.position.cellId):null;
            _loc11_ = this.createFighterPreview(param1,_loc8_,_loc9_);
            this.checkTeleFrag(_loc11_,param1,_loc8_,!!_loc10_?_loc10_:_loc6_);
         }
         else
         {
            _loc3_.visible = true;
         }
      }
      
      private function teleportationToPreviousPosition(param1:Number, param2:FightTeleportation) : void
      {
         var _loc6_:int = 0;
         var _loc7_:Vector.<uint> = null;
         var _loc8_:MapPoint = null;
         var _loc9_:MapPoint = null;
         var _loc10_:AnimatedCharacter = null;
         var _loc3_:FightContextFrame = Kernel.getWorker().getFrame(FightContextFrame) as FightContextFrame;
         var _loc4_:AnimatedCharacter = DofusEntities.getEntity(param1) as AnimatedCharacter;
         var _loc5_:AnimatedCharacter = this.getPreview(param1);
         if(_loc5_)
         {
            _loc7_ = this._previewsPositions[_loc5_.id];
            _loc6_ = _loc7_.length > 1?int(_loc7_[_loc7_.length - 2]):int(_loc4_.position.cellId);
         }
         else
         {
            _loc6_ = _loc3_.getFighterPreviousPosition(param1);
         }
         if(_loc6_ != -1)
         {
            if(param2.allTargets && _loc4_.parentSprite && _loc4_.parentSprite.carriedEntity == _loc4_)
            {
               return;
            }
            _loc8_ = MapPoint.fromCellId(_loc6_);
            if(_loc8_ && this.isValidCell(_loc8_.cellId))
            {
               _loc9_ = !!_loc5_?_loc5_.position:_loc4_.position;
               _loc10_ = this.createFighterPreview(param1,_loc8_,_loc4_.getDirection());
               this.checkTeleFrag(_loc10_,param1,_loc8_,_loc9_);
            }
            else
            {
               _loc4_.visible = true;
            }
         }
         else if(!_loc5_)
         {
            _loc4_.visible = true;
         }
      }
      
      private function switchPositions(param1:Number, param2:FightTeleportation) : void
      {
         var _loc3_:AnimatedCharacter = DofusEntities.getEntity(param1) as AnimatedCharacter;
         var _loc4_:AnimatedCharacter = this.getPreview(param1);
         var _loc5_:MapPoint = !!_loc4_?_loc4_.position:_loc3_.position;
         var _loc6_:uint = param1 == this._currentSpell.playerId?uint(_loc5_.advancedOrientationTo(param2.impactPos)):uint(_loc3_.getDirection());
         var _loc7_:AnimatedCharacter = DofusEntities.getEntity(param2.casterId) as AnimatedCharacter;
         _loc7_.visible = false;
         var _loc8_:AnimatedCharacter = this.getPreview(param2.casterId);
         var _loc9_:MapPoint = !!_loc8_?_loc8_.position:param2.casterPos;
         var _loc10_:uint = this._currentSpell.playerId == param2.casterId?uint(_loc9_.advancedOrientationTo(param2.impactPos)):uint(_loc7_.getDirection());
         this.createFighterPreview(param1,_loc9_,_loc6_);
         this.createFighterPreview(param2.casterId,_loc5_,_loc10_);
      }
      
      private function checkTeleFrag(param1:AnimatedCharacter, param2:Number, param3:MapPoint, param4:MapPoint) : void
      {
         var _loc6_:AnimatedCharacter = null;
         var _loc7_:Number = NaN;
         var _loc9_:FighterStatus = null;
         var _loc10_:Number = NaN;
         var _loc11_:AnimatedCharacter = null;
         var _loc5_:Array = EntitiesManager.getInstance().getEntitiesOnCell(param3.cellId,AnimatedCharacter);
         var _loc8_:FighterStatus = FightersStateManager.getInstance().getStatus(param2);
         if(_loc5_.length > 0)
         {
            for each(_loc6_ in _loc5_)
            {
               if(_loc6_ != param1 && _loc6_.id != param2)
               {
                  if(this._previewIdEntityIdAssoc[_loc6_.id])
                  {
                     _loc7_ = this._previewIdEntityIdAssoc[_loc6_.id];
                  }
                  else
                  {
                     if(this.getPreview(_loc6_.id))
                     {
                        continue;
                     }
                     _loc7_ = _loc6_.id;
                  }
                  _loc6_ = this.getParentEntity(_loc6_) as AnimatedCharacter;
                  _loc9_ = FightersStateManager.getInstance().getStatus(_loc7_);
                  if(!_loc8_.cantSwitchPosition && TeleportationUtil.canTeleport(_loc7_) && !_loc9_.cantSwitchPosition && !_loc6_.carriedEntity && !param1.carriedEntity)
                  {
                     this.telefrag(_loc6_,param1,param2,param4);
                  }
                  else
                  {
                     _loc10_ = this._previewIdEntityIdAssoc[param1.id];
                     _loc11_ = DofusEntities.getEntity(_loc10_) as AnimatedCharacter;
                     if(_loc11_)
                     {
                        _loc11_ = this.getParentEntity(_loc11_) as AnimatedCharacter;
                        _loc11_.visible = true;
                     }
                     param1.destroy();
                  }
                  break;
               }
            }
         }
      }
      
      private function telefrag(param1:AnimatedCharacter, param2:AnimatedCharacter, param3:Number, param4:MapPoint) : void
      {
         var _loc5_:AnimatedCharacter = this.getPreview(param1.id);
         var _loc6_:MapPoint = !!_loc5_?_loc5_.position:null;
         var _loc7_:AnimatedCharacter = this.createFighterPreview(param1.id,param4,param1.getDirection());
         var _loc8_:Number = !!this._previewIdEntityIdAssoc[param1.id]?Number(this._previewIdEntityIdAssoc[param1.id]):Number(param1.id);
         if(param4.equals(param2.position) && _loc6_)
         {
            this.telefrag(param2,_loc7_,_loc8_,_loc6_);
            return;
         }
         if(!this._previewIdEntityIdAssoc[param1.id])
         {
            param1.visible = false;
         }
         if(!this._teleFraggedEntities)
         {
            this._teleFraggedEntities = new Vector.<AnimatedCharacter>(0);
         }
         this._teleFraggedEntities.push(param1);
         this.showTelefragTooltip(_loc8_,_loc7_);
         this.showTelefragTooltip(param3,param2);
      }
      
      private function willSwitchPosition(param1:AnimatedCharacter, param2:MapPoint) : Boolean
      {
         var _loc3_:Array = null;
         var _loc4_:AnimatedCharacter = null;
         var _loc5_:Number = NaN;
         var _loc6_:FightContextFrame = null;
         var _loc7_:GameFightFighterInformations = null;
         var _loc8_:GameFightFighterInformations = null;
         var _loc9_:Number = NaN;
         if(param2 && this.isValidCell(param2.cellId))
         {
            _loc3_ = EntitiesManager.getInstance().getEntitiesOnCell(param2.cellId,AnimatedCharacter);
            _loc5_ = this._previewIdEntityIdAssoc[param1.id];
            _loc6_ = Kernel.getWorker().getFrame(FightContextFrame) as FightContextFrame;
            _loc7_ = _loc6_.entitiesFrame.getEntityInfos(_loc5_) as GameFightFighterInformations;
            for each(_loc4_ in _loc3_)
            {
               if(_loc4_ != param1 && _loc4_.id != _loc5_)
               {
                  _loc9_ = !!this._previewIdEntityIdAssoc[_loc4_.id]?Number(this._previewIdEntityIdAssoc[_loc4_.id]):Number(_loc4_.id);
                  _loc8_ = _loc6_.entitiesFrame.getEntityInfos(_loc9_) as GameFightFighterInformations;
                  if(_loc7_.teamId == _loc8_.teamId)
                  {
                     return true;
                  }
                  return false;
               }
            }
         }
         return false;
      }
      
      private function getPreview(param1:Number) : AnimatedCharacter
      {
         var _loc2_:* = undefined;
         var _loc3_:AnimatedCharacter = null;
         if(this._previewIdEntityIdAssoc[param1])
         {
            for each(_loc3_ in this._previews)
            {
               if(_loc3_.id == param1)
               {
                  return _loc3_;
               }
            }
         }
         else
         {
            for(_loc2_ in this._previewIdEntityIdAssoc)
            {
               if(this._previewIdEntityIdAssoc[_loc2_] == param1)
               {
                  for each(_loc3_ in this._previews)
                  {
                     if(_loc3_.id == _loc2_)
                     {
                        return _loc3_;
                     }
                  }
               }
            }
         }
         return null;
      }
      
      private function createFighterPreview(param1:Number, param2:MapPoint, param3:uint, param4:Boolean = true) : AnimatedCharacter
      {
         var _loc11_:GameFightFighterInformations = null;
         var _loc12_:String = null;
         var _loc13_:String = null;
         var _loc14_:IRectangle = null;
         var _loc5_:AnimatedCharacter = DofusEntities.getEntity(param1) as AnimatedCharacter;
         var _loc6_:TiphonSprite = !!param4?this.getParentEntity(_loc5_):_loc5_;
         var _loc7_:AnimatedCharacter = this.getPreview(param1);
         if(!_loc7_)
         {
            _loc7_ = new AnimatedCharacter(EntitiesManager.getInstance().getFreeEntityId(),_loc6_.look);
            this.addPreviewSubEntities(_loc6_,_loc7_);
            _loc7_.mouseEnabled = _loc7_.mouseChildren = false;
            if(!param4 && _loc7_.getSubEntitySlot(SubEntityBindingPointCategoryEnum.HOOK_POINT_CATEGORY_LIFTED_ENTITY,0))
            {
               _loc7_.removeAnimationModifierByClass(CarrierAnimationModifier);
               _loc7_.removeSubEntity(_loc7_.getSubEntitySlot(SubEntityBindingPointCategoryEnum.HOOK_POINT_CATEGORY_LIFTED_ENTITY,0));
               _loc7_.setAnimation(AnimationEnum.ANIM_STATIQUE);
            }
            if(!this._previews)
            {
               this._previews = new Vector.<AnimatedCharacter>(0);
            }
            this._previews.push(_loc7_);
            this._previewIdEntityIdAssoc[_loc7_.id] = param1;
         }
         _loc7_.position = param2;
         if(!this._previewsPositions[_loc7_.id])
         {
            this._previewsPositions[_loc7_.id] = new Vector.<uint>();
         }
         this._previewsPositions[_loc7_.id].push(param2.cellId);
         _loc7_.setDirection(param3);
         _loc7_.display(PlacementStrataEnums.STRATA_PLAYER);
         _loc7_.setCanSeeThrough(true);
         var _loc8_:Number = !!this._previewIdEntityIdAssoc[param1]?Number(this._previewIdEntityIdAssoc[param1]):Number(param1);
         var _loc9_:FightContextFrame = Kernel.getWorker().getFrame(FightContextFrame) as FightContextFrame;
         var _loc10_:Boolean = _loc9_.entitiesFrame.hasIcon(_loc8_);
         if(TooltipManager.isVisible("tooltipOverEntity_" + _loc8_))
         {
            _loc11_ = _loc9_.entitiesFrame.getEntityInfos(_loc8_) as GameFightFighterInformations;
            _loc12_ = _loc11_ is GameFightCharacterInformations?"PlayerShortInfos" + _loc8_:"EntityShortInfos" + _loc8_;
            _loc13_ = "tooltipOverEntity_" + _loc8_;
            _loc14_ = !!_loc10_?new Rectangle2(0,-(_loc9_.entitiesFrame.getIcon(_loc8_).height * Atouin.getInstance().currentZoom + 10 * Atouin.getInstance().currentZoom),0,0):null;
            TooltipManager.updatePosition(_loc12_,_loc13_,_loc7_.absoluteBounds,LocationEnum.POINT_BOTTOM,LocationEnum.POINT_TOP,0,true,true,_loc7_.position.cellId,_loc14_);
         }
         else if(_loc10_)
         {
            _loc9_.entitiesFrame.getIcon(_loc8_).place(_loc9_.entitiesFrame.getIconEntityBounds(_loc7_));
         }
         return _loc7_;
      }
      
      private function getParentEntity(param1:TiphonSprite) : TiphonSprite
      {
         var _loc2_:TiphonSprite = null;
         var _loc3_:TiphonSprite = param1.parentSprite;
         while(_loc3_)
         {
            _loc2_ = _loc3_;
            _loc3_ = _loc3_.parentSprite;
         }
         return !_loc2_?param1:_loc2_;
      }
      
      private function addPreviewSubEntities(param1:TiphonSprite, param2:TiphonSprite) : void
      {
         var _loc3_:Boolean = false;
         var _loc7_:TiphonSprite = null;
         if(param1.look.getSubEntitiesFromCategory(SubEntityBindingPointCategoryEnum.HOOK_POINT_CATEGORY_MOUNT_DRIVER) && param1.look.getSubEntitiesFromCategory(SubEntityBindingPointCategoryEnum.HOOK_POINT_CATEGORY_MOUNT_DRIVER).length)
         {
            _loc3_ = true;
            param2.setSubEntityBehaviour(SubEntityBindingPointCategoryEnum.HOOK_POINT_CATEGORY_MOUNT_DRIVER,new RiderBehavior());
         }
         var _loc4_:TiphonSprite = param1;
         if(_loc3_ && param1.getSubEntitySlot(SubEntityBindingPointCategoryEnum.HOOK_POINT_CATEGORY_MOUNT_DRIVER,0))
         {
            _loc4_ = param1.getSubEntitySlot(SubEntityBindingPointCategoryEnum.HOOK_POINT_CATEGORY_MOUNT_DRIVER,0) as TiphonSprite;
         }
         var _loc5_:TiphonSprite = param2;
         if(_loc3_ && param2.getSubEntitySlot(SubEntityBindingPointCategoryEnum.HOOK_POINT_CATEGORY_MOUNT_DRIVER,0))
         {
            _loc5_ = param2.getSubEntitySlot(SubEntityBindingPointCategoryEnum.HOOK_POINT_CATEGORY_MOUNT_DRIVER,0) as TiphonSprite;
         }
         var _loc6_:TiphonSprite = _loc4_.getSubEntitySlot(SubEntityBindingPointCategoryEnum.HOOK_POINT_CATEGORY_LIFTED_ENTITY,0) as TiphonSprite;
         this.addTeamCircle(param1,param2);
         if(_loc6_)
         {
            _loc7_ = new TiphonSprite(_loc6_.look);
            _loc5_.setSubEntityBehaviour(SubEntityBindingPointCategoryEnum.HOOK_POINT_CATEGORY_LIFTED_ENTITY,new CarrierSubEntityBehaviour());
            _loc5_.isCarrying = true;
            _loc5_.addAnimationModifier(CarrierAnimationModifier.getInstance());
            _loc5_.addSubEntity(_loc7_,SubEntityBindingPointCategoryEnum.HOOK_POINT_CATEGORY_LIFTED_ENTITY,0);
            _loc7_.setAnimation(AnimationEnum.ANIM_STATIQUE);
            _loc5_.setAnimation(AnimationEnum.ANIM_STATIQUE_CARRYING);
            this.addPreviewSubEntities(_loc6_,_loc7_);
         }
      }
      
      private function addTeamCircle(param1:TiphonSprite, param2:TiphonSprite) : void
      {
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc3_:FightEntitiesFrame = Kernel.getWorker().getFrame(FightEntitiesFrame) as FightEntitiesFrame;
         for each(_loc5_ in _loc3_.getEntitiesIdsList())
         {
            if(DofusEntities.getEntity(_loc5_) == param1)
            {
               _loc4_ = _loc5_;
            }
         }
         if(_loc4_ != 0)
         {
            _loc3_.addCircleToFighter(param2,(_loc3_.getEntityInfos(_loc4_) as GameFightFighterInformations).teamId == TeamEnum.TEAM_DEFENDER?uint(255):uint(16711680));
         }
      }
      
      private function isValidCell(param1:int) : Boolean
      {
         if(param1 == -1)
         {
            return false;
         }
         var _loc2_:CellData = MapDisplayManager.getInstance().getDataMapContainer().dataMap.cells[param1];
         return _loc2_.mov && !_loc2_.nonWalkableDuringFight;
      }
      
      private function compareDistanceFromCaster(param1:Number, param2:Number) : int
      {
         var _loc3_:IEntity = DofusEntities.getEntity(param1);
         var _loc4_:IEntity = DofusEntities.getEntity(param2);
         var _loc5_:int = _loc3_.position.distanceToCell(this._fightTeleportationCasterPos);
         var _loc6_:int = _loc4_.position.distanceToCell(this._fightTeleportationCasterPos);
         if(_loc5_ < _loc6_)
         {
            return -1;
         }
         if(_loc5_ > _loc6_)
         {
            return 1;
         }
         return 0;
      }
      
      private function showTelefragTooltip(param1:Number, param2:AnimatedCharacter) : void
      {
         var _loc3_:FightContextFrame = Kernel.getWorker().getFrame(FightContextFrame) as FightContextFrame;
         var _loc4_:GameFightFighterInformations = _loc3_.entitiesFrame.getEntityInfos(param1) as GameFightFighterInformations;
         TooltipManager.hide("tooltipOverEntity_" + param1);
         _loc3_.displayEntityTooltip(param1,this._currentSpell,null,true,FightContextFrame.currentCell,{
            "fightStatus":(_loc4_.teamId == TeamEnum.TEAM_DEFENDER?244:251),
            "target":param2.absoluteBounds,
            "cellId":param2.position.cellId
         });
      }
   }
}
