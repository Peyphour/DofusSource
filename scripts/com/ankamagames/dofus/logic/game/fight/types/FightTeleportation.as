package com.ankamagames.dofus.logic.game.fight.types
{
   import com.ankamagames.jerakine.types.positions.MapPoint;
   
   public class FightTeleportation
   {
       
      
      private var _effectId:uint;
      
      public var targets:Vector.<Number>;
      
      public var casterId:Number;
      
      public var casterPos:MapPoint;
      
      public var impactPos:MapPoint;
      
      public var multipleEffects:Boolean;
      
      public var allTargets:Boolean;
      
      public function FightTeleportation(param1:uint, param2:Number, param3:uint, param4:uint)
      {
         super();
         this._effectId = param1;
         this.targets = new Vector.<Number>(0);
         this.casterId = param2;
         this.casterPos = MapPoint.fromCellId(param3);
         this.impactPos = MapPoint.fromCellId(param4);
      }
      
      public function get effectId() : uint
      {
         return this._effectId;
      }
   }
}
