package com.ankamagames.dofus.logic.common.managers
{
   import com.ankamagames.atouin.Atouin;
   import com.ankamagames.berilia.Berilia;
   import com.ankamagames.berilia.components.Grid;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.berilia.types.graphic.UiRootContainer;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.misc.lists.HookList;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.types.enums.DirectionsEnum;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import flash.utils.getQualifiedClassName;
   
   public class HyperlinkDisplayArrowManager
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(HyperlinkDisplayArrowManager));
      
      private static const ARROW_CLIP:Class = HyperlinkDisplayArrowManager_ARROW_CLIP;
      
      private static var _arrowClip:MovieClip;
      
      private static var _arrowStartX:int;
      
      private static var _arrowStartY:int;
      
      private static var _arrowStrata:int;
      
      private static var _arrowTimer:Timer;
      
      private static var _displayLastArrow:Boolean = false;
      
      private static var _lastArrowX:int;
      
      private static var _lastArrowY:int;
      
      private static var _lastArrowPos:int;
      
      private static var _lastStrata:int;
      
      private static var _lastReverse:int;
      
      private static var _arrowPositions:Dictionary = new Dictionary();
      
      private static var _arrowUiProperties:UiArrowProperties;
       
      
      public function HyperlinkDisplayArrowManager()
      {
         super();
      }
      
      public static function getArrowClip() : MovieClip
      {
         return _arrowClip;
      }
      
      public static function getArrowStartX() : int
      {
         return _arrowStartX;
      }
      
      public static function getArrowStartY() : int
      {
         return _arrowStartY;
      }
      
      public static function getArrowStrata() : int
      {
         return _arrowStrata;
      }
      
      public static function getArrowUiProperties() : UiArrowProperties
      {
         return _arrowUiProperties;
      }
      
      public static function showArrow(param1:String, param2:String, param3:int = 0, param4:int = 0, param5:int = 5, param6:int = 0) : MovieClip
      {
         var _loc9_:UiRootContainer = null;
         var _loc10_:Array = null;
         var _loc11_:DisplayObject = null;
         var _loc12_:String = null;
         var _loc13_:Rectangle = null;
         var _loc14_:Grid = null;
         var _loc15_:int = 0;
         var _loc7_:MovieClip = getArrow(param6 == 1);
         _arrowStrata = param5;
         var _loc8_:DisplayObjectContainer = Berilia.getInstance().docMain.getChildAt(param5) as DisplayObjectContainer;
         _loc8_.addChild(_loc7_);
         if(isNaN(Number(param1)))
         {
            _loc9_ = Berilia.getInstance().getUi(param1);
            if(_loc9_)
            {
               _loc10_ = param2.split("|");
               _loc11_ = _loc9_.getElement(_loc10_[0]);
               if(_loc11_ && _loc11_.visible)
               {
                  _loc12_ = param1;
                  if(_loc10_.length == 1)
                  {
                     _loc13_ = _loc11_.getRect(_loc8_);
                     _loc12_ = _loc12_ + ("_" + _loc10_[0]);
                  }
                  else
                  {
                     _arrowUiProperties = new UiArrowProperties(param1,param2,param3,param4,param5,param6);
                     _loc14_ = _loc11_ as Grid;
                     _loc15_ = 0;
                     while(_loc15_ < _loc14_.dataProvider.length)
                     {
                        if(_loc14_.dataProvider[_loc15_] && _loc14_.dataProvider[_loc15_].hasOwnProperty(_loc10_[1]) && _loc14_.dataProvider[_loc15_][_loc10_[1]] == _loc10_[2])
                        {
                           _loc13_ = (_loc14_.slots[_loc15_] as DisplayObject).getRect(_loc8_);
                           break;
                        }
                        _loc15_++;
                     }
                     KernelEventsManager.getInstance().processCallback(HookList.DisplayUiArrow,_arrowUiProperties);
                     if(!_loc13_)
                     {
                        _log.error("The arrow can\'t be displayed : no data with " + _loc10_[1] + " = " + _loc10_[2] + " in " + _loc10_[0] + ".");
                        return null;
                     }
                  }
                  if(_arrowPositions[_loc12_])
                  {
                     _loc7_.x = _arrowPositions[_loc12_].x;
                     _loc7_.y = _arrowPositions[_loc12_].y;
                  }
                  else
                  {
                     place(_arrowClip,_loc13_,param3);
                  }
               }
            }
            if(param4 == 1)
            {
               _arrowClip.scaleX = _arrowClip.scaleX * -1;
            }
            if(param6)
            {
               _displayLastArrow = true;
               _lastArrowX = _loc7_.x;
               _lastArrowY = _loc7_.y;
               _lastArrowPos = param3;
               _lastStrata = param5;
               _lastReverse = _arrowClip.scaleX;
            }
            return _arrowClip;
         }
         return showAbsoluteArrow(new Rectangle(int(param1),int(param2)),param3,param4,param5,param6);
      }
      
      public static function showAbsoluteArrow(param1:Rectangle, param2:int = 0, param3:int = 0, param4:int = 5, param5:int = 0) : MovieClip
      {
         var _loc6_:MovieClip = getArrow(param5 == 1);
         _arrowStrata = param4;
         DisplayObjectContainer(Berilia.getInstance().docMain.getChildAt(param4)).addChild(_loc6_);
         place(_loc6_,param1,param2);
         if(param3 == 1)
         {
            _arrowClip.scaleX = _arrowClip.scaleX * -1;
         }
         if(param5)
         {
            _displayLastArrow = true;
            _lastArrowX = _loc6_.x;
            _lastArrowY = _loc6_.y;
            _lastArrowPos = param2;
            _lastStrata = param4;
            _lastReverse = _arrowClip.scaleX;
         }
         return _loc6_;
      }
      
      public static function setArrowPosition(param1:String, param2:String, param3:Point) : void
      {
         _arrowPositions[param1 + "_" + param2] = param3;
      }
      
      public static function showMapTransition(param1:int, param2:int, param3:int, param4:int = 0, param5:int = 5, param6:int = 0) : MovieClip
      {
         var _loc7_:MovieClip = null;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         var _loc10_:uint = 0;
         if(param1 == -1 || param1 == PlayedCharacterManager.getInstance().currentMap.mapId)
         {
            _loc7_ = getArrow(param6 == 1);
            _arrowStrata = param5;
            DisplayObjectContainer(Berilia.getInstance().docMain.getChildAt(param5)).addChild(_loc7_);
            switch(param2)
            {
               case DirectionsEnum.DOWN:
                  _loc8_ = param3;
                  _loc9_ = 880;
                  _loc10_ = 1;
                  break;
               case DirectionsEnum.LEFT:
                  _loc8_ = 0;
                  _loc9_ = param3;
                  _loc10_ = 5;
                  break;
               case DirectionsEnum.UP:
                  _loc8_ = param3;
                  _loc9_ = 0;
                  _loc10_ = 7;
                  break;
               case DirectionsEnum.RIGHT:
                  _loc8_ = 1280;
                  _loc9_ = param3;
                  _loc10_ = 1;
            }
            place(_loc7_,new Rectangle(_loc8_,_loc9_),_loc10_);
            if(param4 == 1)
            {
               _arrowClip.scaleX = _arrowClip.scaleX * -1;
            }
            if(param6)
            {
               _displayLastArrow = true;
               _lastArrowX = _loc7_.x;
               _lastArrowY = _loc7_.y;
               _lastArrowPos = _loc10_;
               _lastStrata = param5;
               _lastReverse = _arrowClip.scaleX;
            }
            return _loc7_;
         }
         return null;
      }
      
      public static function destroyArrow(param1:Event = null) : void
      {
         if(param1)
         {
            param1.currentTarget.removeEventListener(TimerEvent.TIMER,destroyArrow);
            if(_displayLastArrow)
            {
               (Berilia.getInstance().docMain.getChildAt(_lastStrata) as DisplayObjectContainer).addChild(_arrowClip);
               place(_arrowClip,new Rectangle(_lastArrowX,_lastArrowY),_lastArrowPos);
               _arrowClip.scaleX = _lastReverse;
               return;
            }
         }
         else
         {
            _displayLastArrow = false;
         }
         if(_arrowClip)
         {
            _arrowClip.gotoAndStop(1);
            if(_arrowClip.parent)
            {
               _arrowClip.parent.removeChild(_arrowClip);
            }
         }
         if(_arrowTimer)
         {
            _arrowTimer.reset();
            _arrowTimer = null;
         }
         _arrowUiProperties = null;
      }
      
      private static function getArrow(param1:Boolean = false) : MovieClip
      {
         if(_arrowClip)
         {
            _arrowClip.gotoAndPlay(1);
         }
         else
         {
            _arrowClip = new ARROW_CLIP() as MovieClip;
            _arrowClip.mouseEnabled = false;
            _arrowClip.mouseChildren = false;
         }
         if(param1)
         {
            if(_arrowTimer)
            {
               _arrowTimer.reset();
               _arrowTimer = null;
            }
         }
         else
         {
            if(_arrowTimer)
            {
               _arrowTimer.reset();
            }
            else
            {
               _arrowTimer = new Timer(5000,1);
               _arrowTimer.addEventListener(TimerEvent.TIMER,destroyArrow);
            }
            _arrowTimer.start();
         }
         return _arrowClip;
      }
      
      public static function place(param1:MovieClip, param2:Rectangle, param3:int) : void
      {
         var _loc4_:Point = null;
         if(param3 == 0)
         {
            param1.scaleX = 1;
            param1.scaleY = 1;
            param1.x = int(param2.x);
            param1.y = int(param2.y);
         }
         else if(param3 == 1)
         {
            param1.scaleX = 1;
            param1.scaleY = 1;
            param1.x = int(param2.x + param2.width / 2);
            param1.y = int(param2.y);
         }
         else if(param3 == 2)
         {
            param1.scaleX = -1;
            param1.scaleY = 1;
            param1.x = int(param2.x + param2.width);
            param1.y = int(param2.y);
         }
         else if(param3 == 3)
         {
            param1.scaleX = 1;
            param1.scaleY = 1;
            param1.x = int(param2.x);
            param1.y = int(param2.y + param2.height / 2);
         }
         else if(param3 == 4)
         {
            param1.scaleX = 1;
            param1.scaleY = 1;
            param1.x = int(param2.x + param2.width / 2);
            param1.y = int(param2.y + param2.height / 2);
         }
         else if(param3 == 5)
         {
            param1.scaleX = -1;
            param1.scaleY = 1;
            param1.x = int(param2.x + param2.width);
            param1.y = int(param2.y + param2.height / 2);
         }
         else if(param3 == 6)
         {
            param1.scaleX = 1;
            param1.scaleY = -1;
            param1.x = int(param2.x);
            param1.y = int(param2.y + param2.height);
         }
         else if(param3 == 7)
         {
            param1.scaleX = 1;
            param1.scaleY = -1;
            param1.x = int(param2.x + param2.width / 2);
            param1.y = int(param2.y + param2.height);
         }
         else if(param3 == 8)
         {
            param1.scaleY = -1;
            param1.scaleX = -1;
            param1.x = int(param2.x + param2.width);
            param1.y = int(param2.y + param2.height);
         }
         else
         {
            param1.scaleX = 1;
            param1.scaleY = 1;
            param1.x = int(param2.x);
            param1.y = int(param2.y);
         }
         _arrowStartX = param1.x;
         _arrowStartY = param1.y;
         if(_arrowStrata != 5)
         {
            _loc4_ = Atouin.getInstance().rootContainer.localToGlobal(new Point(_arrowStartX,_arrowStartY));
            param1.x = _loc4_.x;
            param1.y = _loc4_.y;
         }
      }
   }
}

class UiArrowProperties
{
    
   
   public var uiName:String;
   
   public var componentName:String;
   
   public var pos:int;
   
   public var reverse:int;
   
   public var strata:int;
   
   public var loop:int;
   
   function UiArrowProperties(param1:String, param2:String, param3:int, param4:int, param5:int, param6:int)
   {
      super();
      this.uiName = param1;
      this.componentName = param2;
      this.pos = param3;
      this.reverse = param4;
      this.strata = param5;
      this.loop = param6;
   }
}
