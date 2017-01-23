package com.ankamagames.dofus.uiApi
{
   import com.ankamagames.berilia.interfaces.IApi;
   import com.ankamagames.dofus.logic.common.managers.HyperlinkDisplayArrowManager;
   import com.ankamagames.dofus.logic.common.managers.HyperlinkShowCellManager;
   import com.ankamagames.dofus.logic.common.managers.HyperlinkShowMonsterManager;
   import com.ankamagames.dofus.logic.common.managers.HyperlinkShowNpcManager;
   import com.ankamagames.jerakine.types.Callback;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Timer;
   
   [InstanciedApi]
   public class HighlightApi implements IApi
   {
      
      private static var _showCellTimer:Timer;
      
      private static var _cellIds:Array;
      
      private static var _currentCell:int;
       
      
      private var _nextDelayBeforeShow:uint = 0;
      
      private var _delayBeforeShowTimer:Timer;
      
      private var _delayBeforeShowCallback:Callback;
      
      public function HighlightApi()
      {
         super();
         this._delayBeforeShowTimer = new Timer(0);
         this._delayBeforeShowTimer.addEventListener(TimerEvent.TIMER,this.onDelayBeforeShowTimer,false,0,true);
      }
      
      private static function onCellTimer(param1:Event) : void
      {
         if(param1 == null && _showCellTimer && !_showCellTimer.running)
         {
            _showCellTimer.start();
         }
         HyperlinkShowCellManager.showCell(_cellIds[_currentCell]);
         _currentCell++;
         if(_currentCell >= _cellIds.length)
         {
            _currentCell = 0;
         }
      }
      
      [Untrusted]
      public function setDisplayDelay(param1:uint) : void
      {
         this._nextDelayBeforeShow = param1;
      }
      
      [Untrusted]
      public function forceArrowPosition(param1:String, param2:String, param3:Point) : void
      {
         this.show(HyperlinkDisplayArrowManager.setArrowPosition,param1,param2,param3);
      }
      
      [Untrusted]
      public function highlightUi(param1:String, param2:String, param3:int = 0, param4:int = 0, param5:int = 5, param6:Boolean = false) : void
      {
         this.show(HyperlinkDisplayArrowManager.showArrow,param1,param2,param3,param4,param5,!!param6?1:0);
      }
      
      [Untrusted]
      public function highlightCell(param1:Array, param2:Boolean = false) : void
      {
         if(param2)
         {
            if(!_showCellTimer)
            {
               _showCellTimer = new Timer(2000);
               _showCellTimer.addEventListener(TimerEvent.TIMER,onCellTimer);
            }
            _cellIds = param1;
            _currentCell = 0;
            _showCellTimer.reset();
            this.show(onCellTimer,null);
         }
         else
         {
            if(_showCellTimer)
            {
               _showCellTimer.reset();
            }
            this.show(HyperlinkShowCellManager.showCell,param1);
         }
      }
      
      [Untrusted]
      public function highlightAbsolute(param1:Rectangle, param2:uint, param3:int = 0, param4:int = 5, param5:Boolean = false) : void
      {
         this.show(HyperlinkDisplayArrowManager.showAbsoluteArrow,param1,param2,param3,param4,!!param5?1:0);
      }
      
      [Untrusted]
      public function highlightMapTransition(param1:int, param2:int, param3:int, param4:Boolean = false, param5:int = 5, param6:Boolean = false) : void
      {
         this.show(HyperlinkDisplayArrowManager.showMapTransition,param1,param2,param3,!!param4?1:0,param5,!!param6?1:0);
      }
      
      [Untrusted]
      public function highlightNpc(param1:int, param2:Boolean = false) : void
      {
         this.show(HyperlinkShowNpcManager.showNpc,param1,!!param2?1:0);
      }
      
      [Untrusted]
      public function highlightMonster(param1:Number, param2:Boolean = false) : void
      {
         this.show(HyperlinkShowMonsterManager.showMonster,param1,!!param2?1:0);
      }
      
      [Untrusted]
      public function stop() : void
      {
         this.clearDelayedShow();
         HyperlinkDisplayArrowManager.destroyArrow();
         if(_showCellTimer)
         {
            _showCellTimer.reset();
         }
      }
      
      [Untrusted]
      public function getArrowUiProperties() : Object
      {
         return HyperlinkDisplayArrowManager.getArrowUiProperties();
      }
      
      protected function onDelayBeforeShowTimer(param1:TimerEvent) : void
      {
         if(this._delayBeforeShowCallback)
         {
            try
            {
               this._delayBeforeShowCallback.exec();
            }
            catch(e:Error)
            {
            }
         }
         this._delayBeforeShowCallback = null;
      }
      
      private function show(param1:Function, ... rest) : void
      {
         this.clearDelayedShow();
         this._delayBeforeShowCallback = Callback.argFromArray(param1,rest);
         if(this._nextDelayBeforeShow == 0)
         {
            this.onDelayBeforeShowTimer(null);
         }
         else
         {
            this._delayBeforeShowTimer.delay = this._nextDelayBeforeShow;
            this._delayBeforeShowTimer.start();
         }
         this._nextDelayBeforeShow = 0;
      }
      
      private function clearDelayedShow() : void
      {
         this._delayBeforeShowCallback = null;
         this._delayBeforeShowTimer.reset();
      }
   }
}
