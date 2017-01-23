package com.ankamagames.berilia.types.graphic
{
   import com.ankamagames.berilia.UIComponent;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.enums.StatesEnum;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.types.Uri;
   import com.ankamagames.jerakine.utils.misc.DescribeTypeCache;
   import flash.utils.getQualifiedClassName;
   
   public class StateContainer extends GraphicContainer implements UIComponent
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(StateContainer));
       
      
      protected var _state;
      
      protected var _snapshot:Array;
      
      protected var _describeType:Function;
      
      protected var _lockedProperties:Array;
      
      protected var _lockedPropertiesStr:String;
      
      private var _changingStateData:Array;
      
      public function StateContainer()
      {
         this._describeType = DescribeTypeCache.typeDescription;
         super();
         this._state = StatesEnum.STATE_NORMAL;
         this._snapshot = new Array();
         this.lockedProperties = "x,y,width,height,selected,greyedOut,text,htmlText";
      }
      
      public function get changingStateData() : Array
      {
         return this._changingStateData;
      }
      
      public function set changingStateData(param1:Array) : void
      {
         this._changingStateData = param1;
      }
      
      public function set state(param1:*) : void
      {
         if(this._state == param1)
         {
            return;
         }
         if(param1 == null)
         {
            param1 = StatesEnum.STATE_NORMAL;
         }
         this.changeState(param1);
         this._state = param1;
      }
      
      public function get state() : *
      {
         return this._state;
      }
      
      override public function free() : void
      {
         super.free();
         this._state = null;
         this._snapshot = null;
      }
      
      override public function remove() : void
      {
         super.remove();
         this._snapshot = null;
         this._state = null;
      }
      
      public function get lockedProperties() : String
      {
         return this._lockedPropertiesStr;
      }
      
      public function set lockedProperties(param1:String) : void
      {
         var _loc2_:Array = null;
         var _loc3_:String = null;
         this._lockedPropertiesStr = param1;
         this._lockedProperties = [];
         if(this._lockedPropertiesStr)
         {
            _loc2_ = param1.split(",");
            for each(_loc3_ in _loc2_)
            {
               this._lockedProperties[_loc3_] = true;
            }
         }
      }
      
      protected function changeState(param1:*) : void
      {
         var _loc2_:GraphicContainer = null;
         var _loc3_:Array = null;
         var _loc4_:UiRootContainer = null;
         var _loc5_:* = null;
         var _loc6_:* = null;
         if(!this._snapshot)
         {
            return;
         }
         if(param1 == StatesEnum.STATE_NORMAL)
         {
            this._state = param1;
            this.restoreSnapshot(StatesEnum.STATE_NORMAL);
         }
         else if(this.changingStateData != null && this.changingStateData[param1])
         {
            this._snapshot[this._state] = new Array();
            if(this._state != StatesEnum.STATE_NORMAL)
            {
               this.restoreSnapshot(StatesEnum.STATE_NORMAL);
            }
            for(_loc5_ in this.changingStateData[param1])
            {
               _loc4_ = getUi();
               if(!_loc4_)
               {
                  break;
               }
               _loc2_ = _loc4_.getElement(_loc5_);
               if(_loc2_)
               {
                  if(this._state == StatesEnum.STATE_NORMAL)
                  {
                     this.makeSnapshot(StatesEnum.STATE_NORMAL,_loc2_);
                  }
                  _loc3_ = this.changingStateData[param1][_loc5_];
                  for(_loc6_ in _loc3_)
                  {
                     if(_loc2_[_loc6_] is Boolean && _loc3_[_loc6_] is String)
                     {
                        _loc2_[_loc6_] = _loc3_[_loc6_] == "true";
                     }
                     else if(_loc6_ == "uri" && !(_loc3_[_loc6_] is Uri))
                     {
                        _loc2_[_loc6_] = new Uri(_loc3_[_loc6_]);
                        if(_loc2_ is Texture)
                        {
                           _loc2_.finalize();
                        }
                     }
                     else
                     {
                        _loc2_[_loc6_] = _loc3_[_loc6_];
                     }
                  }
                  this.makeSnapshot(this._state,_loc2_);
               }
            }
         }
         else
         {
            _log.warn(name + " : No data for state \'" + param1 + "\' (" + this.changingStateData.length + " states)");
         }
      }
      
      protected function makeSnapshot(param1:*, param2:GraphicContainer) : void
      {
         var _loc4_:String = null;
         var _loc5_:XML = null;
         if(!this._snapshot[param1])
         {
            this._snapshot[param1] = new Object();
         }
         if(!this._snapshot[param1][param2.name])
         {
            this._snapshot[param1][param2.name] = new Object();
            var _loc3_:XML = this._describeType(param2);
            for each(_loc5_ in _loc3_..accessor)
            {
               if(_loc5_.@access == "readwrite")
               {
                  _loc4_ = _loc5_.@name;
                  if(!this._lockedProperties[_loc4_])
                  {
                     switch(true)
                     {
                        case param2[_loc4_] is Boolean:
                        case param2[_loc4_] is uint:
                        case param2[_loc4_] is int:
                        case param2[_loc4_] is Number:
                        case param2[_loc4_] is String:
                        case param2[_loc4_] is Uri:
                        case param2[_loc4_] == null:
                           this._snapshot[param1][param2.name][_loc4_] = param2[_loc4_];
                        default:
                           this._snapshot[param1][param2.name][_loc4_] = param2[_loc4_];
                     }
                  }
               }
            }
            return;
         }
      }
      
      protected function restoreSnapshot(param1:*) : void
      {
         var _loc2_:GraphicContainer = null;
         var _loc3_:UiRootContainer = null;
         var _loc4_:* = null;
         var _loc5_:* = null;
         if(!this._snapshot)
         {
            return;
         }
         for(_loc4_ in this._snapshot[param1])
         {
            _loc3_ = getUi();
            if(!_loc3_)
            {
               break;
            }
            _loc2_ = _loc3_.getElement(_loc4_);
            if(_loc2_)
            {
               for(_loc5_ in this._snapshot[param1][_loc4_])
               {
                  if(_loc2_[_loc5_] !== this._snapshot[param1][_loc4_][_loc5_])
                  {
                     if(!(_loc2_ is ButtonContainer) || _loc5_ != "selected")
                     {
                        if(!this._lockedProperties[_loc5_])
                        {
                           if(_loc2_[_loc5_] is Boolean && this._snapshot[param1][_loc4_][_loc5_] is String)
                           {
                              _loc2_[_loc5_] = this._snapshot[param1][_loc4_][_loc5_] == "true";
                           }
                           else
                           {
                              _loc2_[_loc5_] = this._snapshot[param1][_loc4_][_loc5_];
                              if(_loc5_ == "uri")
                              {
                                 _loc2_.finalize();
                              }
                           }
                        }
                     }
                  }
               }
            }
         }
      }
   }
}
