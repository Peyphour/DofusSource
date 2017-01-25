package com.ankamagames.dofus.logic.game.fight.types
{
   import com.ankamagames.atouin.managers.EntitiesManager;
   import com.ankamagames.dofus.datacenter.effects.EffectInstance;
   import com.ankamagames.dofus.internalDatacenter.spells.SpellWrapper;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.game.fight.frames.FightContextFrame;
   import com.ankamagames.dofus.logic.game.fight.frames.FightEntitiesFrame;
   import com.ankamagames.dofus.logic.game.fight.managers.SpellZoneManager;
   import com.ankamagames.dofus.logic.game.fight.miscs.DamageUtil;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightFighterInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightMinimalStats;
   import com.ankamagames.dofus.types.entities.AnimatedCharacter;
   import com.ankamagames.jerakine.entities.interfaces.IEntity;
   import com.ankamagames.jerakine.types.zones.IZone;
   
   public class TriggeredSpell
   {
       
      
      private var _casterId:Number;
      
      private var _targetId:Number;
      
      private var _spell:SpellWrapper;
      
      private var _triggers:String;
      
      private var _targets:Vector.<Number>;
      
      private var _effectId:uint;
      
      private var _sourceSpellEffectOrder:int;
      
      public function TriggeredSpell(param1:Number, param2:Number, param3:SpellWrapper, param4:String, param5:Vector.<Number>, param6:uint, param7:int)
      {
         super();
         this._casterId = param1;
         this._targetId = param2;
         this._spell = param3;
         this._triggers = param4;
         this._targets = param5;
         this._effectId = param6;
         this._sourceSpellEffectOrder = param7;
      }
      
      public static function create(param1:String, param2:uint, param3:int, param4:Number, param5:Number, param6:uint, param7:int, param8:Boolean = true) : TriggeredSpell
      {
         var _loc15_:uint = 0;
         var _loc16_:EffectInstance = null;
         var _loc17_:Array = null;
         var _loc18_:IEntity = null;
         var _loc19_:FightContextFrame = null;
         var _loc20_:Vector.<Number> = null;
         var _loc21_:Number = NaN;
         var _loc22_:GameFightFighterInformations = null;
         var _loc9_:SpellWrapper = SpellWrapper.create(param2,param3,param8,param4);
         var _loc10_:IZone = SpellZoneManager.getInstance().getSpellZone(_loc9_,false,false);
         var _loc11_:FightEntitiesFrame = Kernel.getWorker().getFrame(FightEntitiesFrame) as FightEntitiesFrame;
         var _loc12_:int = _loc11_ && _loc11_.getEntityInfos(param5)?int(_loc11_.getEntityInfos(param5).disposition.cellId):0;
         var _loc13_:Vector.<uint> = _loc10_.getCells(_loc12_);
         var _loc14_:Vector.<Number> = new Vector.<Number>(0);
         for each(_loc15_ in _loc13_)
         {
            _loc17_ = EntitiesManager.getInstance().getEntitiesOnCell(_loc15_,AnimatedCharacter);
            for each(_loc18_ in _loc17_)
            {
               if(_loc11_.getEntityInfos(_loc18_.id))
               {
                  for each(_loc16_ in _loc9_.effects)
                  {
                     if(DamageUtil.verifySpellEffectMask(param4,_loc18_.id,_loc16_,_loc12_))
                     {
                        _loc14_.push(_loc18_.id);
                        break;
                     }
                  }
               }
            }
         }
         if(_loc10_.radius == 63)
         {
            _loc19_ = Kernel.getWorker().getFrame(FightContextFrame) as FightContextFrame;
            _loc20_ = _loc19_.entitiesFrame.getEntitiesIdsList();
            for each(_loc16_ in _loc9_.effects)
            {
               if(_loc16_.targetMask.indexOf("E263") != -1)
               {
                  for each(_loc21_ in _loc20_)
                  {
                     _loc22_ = _loc19_.entitiesFrame.getEntityInfos(_loc21_) as GameFightFighterInformations;
                     if(_loc22_.disposition.cellId == -1 && DamageUtil.verifySpellEffectMask(param4,_loc21_,_loc16_,_loc12_))
                     {
                        _loc14_.push(_loc21_);
                     }
                  }
                  break;
               }
            }
         }
         return new TriggeredSpell(param4,param5,_loc9_,param1,_loc14_,param6,param7);
      }
      
      public function get casterId() : Number
      {
         return this._casterId;
      }
      
      public function get casterStats() : GameFightMinimalStats
      {
         return ((Kernel.getWorker().getFrame(FightContextFrame) as FightContextFrame).entitiesFrame.getEntityInfos(this._targetId) as GameFightFighterInformations).stats;
      }
      
      public function get targetId() : Number
      {
         return this._targetId;
      }
      
      public function get spell() : SpellWrapper
      {
         return this._spell;
      }
      
      public function get triggers() : String
      {
         return this._triggers;
      }
      
      public function get targets() : Vector.<Number>
      {
         return this._targets;
      }
      
      public function get targetCell() : int
      {
         return (Kernel.getWorker().getFrame(FightContextFrame) as FightContextFrame).entitiesFrame.getEntityInfos(this._targetId).disposition.cellId;
      }
      
      public function get effectId() : uint
      {
         return this._effectId;
      }
      
      public function get sourceSpellEffectOrder() : int
      {
         return this._sourceSpellEffectOrder;
      }
   }
}
