package com.ankamagames.dofus.logic.game.fight.miscs
{
   import com.ankamagames.dofus.logic.game.common.misc.DofusEntities;
   import com.ankamagames.dofus.logic.game.common.misc.IEntityLocalizer;
   import com.ankamagames.jerakine.entities.interfaces.IDisplayable;
   import com.ankamagames.jerakine.entities.interfaces.IEntity;
   import com.ankamagames.tiphon.display.TiphonSprite;
   import flash.utils.Dictionary;
   
   public class FightEntitiesHolder implements IEntityLocalizer
   {
      
      private static var _self:FightEntitiesHolder;
       
      
      private var _holdedEntities:Dictionary;
      
      public function FightEntitiesHolder()
      {
         this._holdedEntities = new Dictionary();
         super();
      }
      
      public static function getInstance() : FightEntitiesHolder
      {
         if(!_self)
         {
            _self = new FightEntitiesHolder();
            DofusEntities.registerLocalizer(_self);
         }
         return _self;
      }
      
      public function getEntity(param1:Number) : IEntity
      {
         return this._holdedEntities[param1];
      }
      
      public function holdEntity(param1:IEntity) : void
      {
         this._holdedEntities[param1.id] = param1;
      }
      
      public function unholdEntity(param1:Number) : void
      {
         delete this._holdedEntities[param1];
      }
      
      public function reset() : void
      {
         this._holdedEntities = new Dictionary();
      }
      
      public function getEntities() : Dictionary
      {
         return this._holdedEntities;
      }
      
      public function unregistered() : void
      {
         var _loc1_:IEntity = null;
         for each(_loc1_ in this._holdedEntities)
         {
            if(_loc1_ is IDisplayable)
            {
               (_loc1_ as IDisplayable).remove();
            }
            if(_loc1_ is TiphonSprite)
            {
               (_loc1_ as TiphonSprite).destroy();
            }
         }
         this._holdedEntities = null;
         _self = null;
      }
   }
}
