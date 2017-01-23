package com.ankamagames.atouin.managers
{
   import com.ankamagames.atouin.Atouin;
   import com.ankamagames.jerakine.entities.interfaces.IDisplayable;
   import com.ankamagames.jerakine.entities.interfaces.IEntity;
   import com.ankamagames.jerakine.entities.interfaces.IInteractive;
   import com.ankamagames.jerakine.entities.interfaces.IMovable;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.types.enums.InteractionsEnum;
   import com.ankamagames.jerakine.types.events.PropertyChangeEvent;
   import com.ankamagames.jerakine.utils.errors.SingletonError;
   import com.ankamagames.tiphon.display.TiphonSprite;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.utils.getQualifiedClassName;
   
   public class EntitiesManager
   {
      
      private static const RANDOM_ENTITIES_ID_START:Number = -1000000;
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(EntitiesManager));
      
      private static var _self:EntitiesManager;
       
      
      private var _entities:Array;
      
      private var _currentRandomEntity:Number = -1000000;
      
      public function EntitiesManager()
      {
         super();
         if(_self)
         {
            throw new SingletonError("Warning : EntitiesManager is a singleton class and shoulnd\'t be instancied directly!");
         }
         this._entities = new Array();
         Atouin.getInstance().options.addEventListener(PropertyChangeEvent.PROPERTY_CHANGED,this.onPropertyChanged);
      }
      
      public static function getInstance() : EntitiesManager
      {
         if(!_self)
         {
            _self = new EntitiesManager();
         }
         return _self;
      }
      
      public function initManager() : void
      {
         Atouin.getInstance().options.addEventListener(PropertyChangeEvent.PROPERTY_CHANGED,this.onPropertyChanged);
      }
      
      public function addAnimatedEntity(param1:Number, param2:IEntity, param3:uint) : void
      {
         if(this._entities[param1] != null)
         {
            _log.warn("Entity overwriting! Entity " + param1 + " has been replaced.");
         }
         this._entities[param1] = param2;
         if(param2 is IDisplayable)
         {
            EntitiesDisplayManager.getInstance().displayEntity(param2 as IDisplayable,param2.position,param3);
         }
         if(param2 is IInteractive)
         {
            this.registerInteractions(IInteractive(param2),true);
            Sprite(param2).buttonMode = IInteractive(param2).useHandCursor;
         }
      }
      
      public function getEntity(param1:Number) : IEntity
      {
         return this._entities[param1];
      }
      
      public function getEntityID(param1:IEntity) : Number
      {
         var _loc2_:* = null;
         for(_loc2_ in this._entities)
         {
            if(param1 === this._entities[_loc2_])
            {
               return parseFloat(_loc2_);
            }
         }
         return 0;
      }
      
      public function removeEntity(param1:Number) : void
      {
         if(this._entities[param1])
         {
            if(this._entities[param1] is IDisplayable)
            {
               EntitiesDisplayManager.getInstance().removeEntity(this._entities[param1] as IDisplayable);
            }
            if(this._entities[param1] is IInteractive)
            {
               this.registerInteractions(IInteractive(this._entities[param1]),false);
            }
            if(this._entities[param1] is IMovable && IMovable(this._entities[param1]).isMoving)
            {
               IMovable(this._entities[param1]).stop(true);
            }
            delete this._entities[param1];
         }
      }
      
      public function clearEntities() : void
      {
         var _loc2_:* = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Number = NaN;
         var _loc6_:TiphonSprite = null;
         var _loc1_:Array = new Array();
         for(_loc2_ in this._entities)
         {
            _loc1_.push(_loc2_);
         }
         _loc3_ = -1;
         _loc4_ = _loc1_.length;
         while(++_loc3_ < _loc4_)
         {
            _loc5_ = _loc1_[_loc3_];
            _loc6_ = this._entities[_loc5_] as TiphonSprite;
            this.removeEntity(_loc5_);
            if(_loc6_)
            {
               _loc6_.destroy();
            }
         }
         this._entities = new Array();
      }
      
      public function setEntitiesVisibility(param1:Boolean) : void
      {
         var _loc3_:* = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Number = NaN;
         var _loc7_:TiphonSprite = null;
         var _loc2_:Array = new Array();
         for(_loc3_ in this._entities)
         {
            _loc2_.push(_loc3_);
         }
         _loc4_ = -1;
         _loc5_ = _loc2_.length;
         while(++_loc4_ < _loc5_)
         {
            _loc6_ = _loc2_[_loc4_];
            _loc7_ = this._entities[_loc6_] as TiphonSprite;
            _loc7_.visible = param1;
         }
      }
      
      public function get entities() : Array
      {
         return this._entities;
      }
      
      public function get entitiesCount() : int
      {
         var _loc2_:* = undefined;
         var _loc1_:int = 0;
         for each(_loc2_ in this._entities)
         {
            _loc1_++;
         }
         return _loc1_;
      }
      
      public function getFreeEntityId() : Number
      {
         while(true)
         {
            if(this._entities[--this._currentRandomEntity] == null)
            {
               break;
            }
            this._currentRandomEntity--;
         }
         return this._currentRandomEntity;
      }
      
      private function registerInteractions(param1:IInteractive, param2:Boolean) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = param1.enabledInteractions;
         while(_loc4_ > 0)
         {
            this.registerInteraction(param1,1 << _loc3_++,param2);
            _loc4_ = _loc4_ >> 1;
         }
      }
      
      public function registerInteraction(param1:IInteractive, param2:uint, param3:Boolean) : void
      {
         var _loc5_:String = null;
         var _loc4_:Array = InteractionsEnum.getEvents(param2);
         for each(_loc5_ in _loc4_)
         {
            if(param3 && !param1.hasEventListener(_loc5_))
            {
               param1.addEventListener(_loc5_,this.onInteraction,false,0,true);
            }
            else if(!param3 && param1.hasEventListener(_loc5_))
            {
               param1.removeEventListener(_loc5_,this.onInteraction,false);
            }
         }
      }
      
      public function getEntityOnCell(param1:uint, param2:* = null) : IEntity
      {
         var _loc5_:IEntity = null;
         var _loc6_:uint = 0;
         var _loc3_:* = param2 != null;
         var _loc4_:Boolean = _loc3_ && param2 is Array;
         for each(_loc5_ in this._entities)
         {
            if(_loc5_ && _loc5_.position && _loc5_.position.cellId == param1)
            {
               if(!_loc4_)
               {
                  if(!_loc3_ || !_loc4_ && _loc5_ is param2)
                  {
                     return _loc5_;
                  }
               }
               else
               {
                  _loc6_ = 0;
                  while(_loc6_ < (param2 as Array).length)
                  {
                     if(_loc5_ is param2[_loc6_])
                     {
                        return _loc5_;
                     }
                     _loc6_++;
                  }
               }
               continue;
            }
         }
         return null;
      }
      
      public function getEntitiesOnCell(param1:uint, param2:* = null) : Array
      {
         var _loc6_:IEntity = null;
         var _loc7_:uint = 0;
         var _loc3_:* = param2 != null;
         var _loc4_:Boolean = _loc3_ && param2 is Array;
         var _loc5_:Array = [];
         for each(_loc6_ in this._entities)
         {
            if(_loc6_ && _loc6_.position && _loc6_.position.cellId == param1)
            {
               if(!_loc4_)
               {
                  if(!_loc3_ || !_loc4_ && _loc6_ is param2)
                  {
                     _loc5_.push(_loc6_);
                  }
               }
               else
               {
                  _loc7_ = 0;
                  while(_loc7_ < (param2 as Array).length)
                  {
                     if(_loc6_ is param2[_loc7_])
                     {
                        _loc5_.push(_loc6_);
                     }
                     _loc7_++;
                  }
               }
               continue;
            }
         }
         return _loc5_;
      }
      
      private function onInteraction(param1:Event) : void
      {
         var _loc2_:IInteractive = IInteractive(param1.target);
         var _loc3_:Class = InteractionsEnum.getMessage(param1.type);
         _loc2_.handler.process(new _loc3_(_loc2_));
      }
      
      private function onPropertyChanged(param1:PropertyChangeEvent) : void
      {
         var _loc2_:IEntity = null;
         if(param1.propertyName == "transparentOverlayMode")
         {
            for each(_loc2_ in this._entities)
            {
               if(_loc2_ is IDisplayable)
               {
                  EntitiesDisplayManager.getInstance().refreshAlphaEntity(_loc2_ as IDisplayable,_loc2_.position);
               }
            }
         }
      }
   }
}
