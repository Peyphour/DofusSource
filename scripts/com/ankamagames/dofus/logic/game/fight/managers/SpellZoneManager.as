package com.ankamagames.dofus.logic.game.fight.managers
{
   import com.ankamagames.atouin.enums.PlacementStrataEnums;
   import com.ankamagames.atouin.managers.SelectionManager;
   import com.ankamagames.atouin.renderers.ZoneDARenderer;
   import com.ankamagames.atouin.types.Selection;
   import com.ankamagames.atouin.utils.DataMapProvider;
   import com.ankamagames.dofus.datacenter.effects.EffectInstance;
   import com.ankamagames.dofus.internalDatacenter.spells.SpellWrapper;
   import com.ankamagames.dofus.logic.game.fight.frames.FightEntitiesFrame;
   import com.ankamagames.dofus.network.types.game.context.GameContextActorInformations;
   import com.ankamagames.jerakine.interfaces.IDestroyable;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.types.Color;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   import com.ankamagames.jerakine.types.zones.Cone;
   import com.ankamagames.jerakine.types.zones.Cross;
   import com.ankamagames.jerakine.types.zones.HalfLozenge;
   import com.ankamagames.jerakine.types.zones.IZone;
   import com.ankamagames.jerakine.types.zones.Line;
   import com.ankamagames.jerakine.types.zones.Lozenge;
   import com.ankamagames.jerakine.types.zones.Square;
   import com.ankamagames.jerakine.utils.display.spellZone.SpellShapeEnum;
   import com.ankamagames.jerakine.utils.errors.SingletonError;
   import flash.utils.getQualifiedClassName;
   
   public class SpellZoneManager implements IDestroyable
   {
      
      private static var _log:Logger = Log.getLogger(getQualifiedClassName(SpellZoneManager));
      
      private static var _self:SpellZoneManager;
      
      private static const ZONE_COLOR:Color = new Color(10929860);
      
      private static const SELECTION_ZONE:String = "SpellCastZone";
       
      
      private var _targetSelection:Selection;
      
      private var _spellWrapper:SpellWrapper;
      
      public function SpellZoneManager()
      {
         super();
         if(_self != null)
         {
            throw new SingletonError("SpellZoneManager is a singleton and should not be instanciated directly.");
         }
      }
      
      public static function getInstance() : SpellZoneManager
      {
         if(_self == null)
         {
            _self = new SpellZoneManager();
         }
         return _self;
      }
      
      public function destroy() : void
      {
         _self = null;
      }
      
      public function displaySpellZone(param1:Number, param2:int, param3:int, param4:uint, param5:uint) : void
      {
         this._spellWrapper = SpellWrapper.create(param4,param5,false,param1);
         if(this._spellWrapper && param2 != -1 && param3 != -1)
         {
            this._targetSelection = new Selection();
            this._targetSelection.renderer = new ZoneDARenderer(PlacementStrataEnums.STRATA_AREA);
            this._targetSelection.color = ZONE_COLOR;
            this._targetSelection.zone = this.getSpellZone(this._spellWrapper);
            this._targetSelection.zone.direction = MapPoint.fromCellId(param3).advancedOrientationTo(MapPoint.fromCellId(param2),false);
            SelectionManager.getInstance().addSelection(this._targetSelection,SELECTION_ZONE);
            SelectionManager.getInstance().update(SELECTION_ZONE,param2);
         }
         else
         {
            this.removeTarget();
         }
      }
      
      public function removeSpellZone() : void
      {
         this.removeTarget();
      }
      
      private function removeTarget() : void
      {
         var _loc1_:Selection = SelectionManager.getInstance().getSelection(SELECTION_ZONE);
         if(_loc1_)
         {
            _loc1_.remove();
         }
      }
      
      public function getSpellZone(param1:*, param2:Boolean = false, param3:Boolean = true) : IZone
      {
         var _loc7_:uint = 0;
         var _loc8_:EffectInstance = null;
         var _loc4_:uint = 88;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         if(!param1.hasOwnProperty("shape"))
         {
            for each(_loc8_ in param1.effects)
            {
               if(_loc8_.zoneShape != 0 && (!param3 || _loc8_.zoneSize < 63) && (_loc8_.zoneSize > _loc5_ || _loc8_.zoneSize == _loc5_ && (_loc4_ == SpellShapeEnum.P || _loc8_.zoneMinSize < _loc6_)))
               {
                  _loc4_ = _loc8_.zoneShape;
                  _loc5_ = uint(_loc8_.zoneSize);
                  _loc6_ = uint(_loc8_.zoneMinSize);
                  _loc7_ = uint(_loc8_.zoneStopAtTarget);
               }
            }
         }
         else
         {
            _loc4_ = param1.shape;
            _loc5_ = param1.ray;
         }
         return this.getZone(_loc4_,_loc5_,_loc6_,param2,_loc7_);
      }
      
      public function getZone(param1:uint, param2:uint, param3:uint, param4:Boolean = false, param5:uint = 0) : IZone
      {
         var _loc6_:Line = null;
         var _loc7_:GameContextActorInformations = null;
         var _loc8_:Cross = null;
         var _loc9_:Square = null;
         var _loc10_:Cross = null;
         var _loc11_:Cross = null;
         var _loc12_:Cross = null;
         var _loc13_:Cross = null;
         switch(param1)
         {
            case SpellShapeEnum.X:
               return new Cross(param3,param2,DataMapProvider.getInstance());
            case SpellShapeEnum.L:
               return new Line(param2,DataMapProvider.getInstance());
            case SpellShapeEnum.l:
               _loc6_ = new Line(param2,DataMapProvider.getInstance());
               _loc7_ = FightEntitiesFrame.getCurrentInstance().getEntityInfos(CurrentPlayedFighterManager.getInstance().currentFighterId);
               _loc6_.minRadius = param3;
               _loc6_.fromCaster = true;
               _loc6_.stopAtTarget = param5 == 1?true:false;
               _loc6_.casterCellId = _loc7_.disposition.cellId;
               return _loc6_;
            case SpellShapeEnum.T:
               _loc8_ = new Cross(0,param2,DataMapProvider.getInstance());
               _loc8_.onlyPerpendicular = true;
               return _loc8_;
            case SpellShapeEnum.D:
               return new Cross(0,param2,DataMapProvider.getInstance());
            case SpellShapeEnum.C:
               return new Lozenge(param3,param2,DataMapProvider.getInstance());
            case SpellShapeEnum.O:
               return new Lozenge(param2,param2,DataMapProvider.getInstance());
            case SpellShapeEnum.Q:
               return new Cross(!!param3?uint(param3):uint(1),param2,DataMapProvider.getInstance());
            case SpellShapeEnum.V:
               return new Cone(0,param2,DataMapProvider.getInstance());
            case SpellShapeEnum.W:
               _loc9_ = new Square(0,param2,DataMapProvider.getInstance());
               _loc9_.diagonalFree = true;
               return _loc9_;
            case SpellShapeEnum.plus:
               _loc10_ = new Cross(0,param2,DataMapProvider.getInstance());
               _loc10_.diagonal = true;
               return _loc10_;
            case SpellShapeEnum.sharp:
               _loc11_ = new Cross(param3,param2,DataMapProvider.getInstance());
               _loc11_.diagonal = true;
               return _loc11_;
            case SpellShapeEnum.slash:
               return new Line(param2,DataMapProvider.getInstance());
            case SpellShapeEnum.star:
               _loc12_ = new Cross(0,param2,DataMapProvider.getInstance());
               _loc12_.allDirections = true;
               return _loc12_;
            case SpellShapeEnum.minus:
               _loc13_ = new Cross(0,param2,DataMapProvider.getInstance());
               _loc13_.onlyPerpendicular = true;
               _loc13_.diagonal = true;
               return _loc13_;
            case SpellShapeEnum.G:
               return new Square(0,param2,DataMapProvider.getInstance());
            case SpellShapeEnum.I:
               return new Lozenge(param2,63,DataMapProvider.getInstance());
            case SpellShapeEnum.U:
               return new HalfLozenge(0,param2,DataMapProvider.getInstance());
            case SpellShapeEnum.A:
            case SpellShapeEnum.a:
               if(!param4)
               {
                  return new Lozenge(0,63,DataMapProvider.getInstance());
               }
            case SpellShapeEnum.P:
            default:
               return new Cross(0,0,DataMapProvider.getInstance());
         }
      }
   }
}
