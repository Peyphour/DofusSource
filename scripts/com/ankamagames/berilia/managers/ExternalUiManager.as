package com.ankamagames.berilia.managers
{
   import com.ankamagames.berilia.types.graphic.ExternalUi;
   import com.ankamagames.jerakine.utils.display.StageShareManager;
   import flash.desktop.NativeApplication;
   import flash.display.NativeWindow;
   import flash.events.Event;
   import flash.events.NativeWindowDisplayStateEvent;
   
   public class ExternalUiManager
   {
      
      private static var _instance:ExternalUiManager;
       
      
      public function ExternalUiManager()
      {
         super();
         NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE,this.onWindowFocus,false,0,true);
         StageShareManager.stage.nativeWindow.addEventListener(Event.ACTIVATE,this.onWindowFocus,false,0,true);
         StageShareManager.stage.nativeWindow.addEventListener(Event.CLOSING,this.onMainWindowClose,false,0,true);
         StageShareManager.stage.nativeWindow.addEventListener(NativeWindowDisplayStateEvent.DISPLAY_STATE_CHANGE,this.onWindowFocus,false,0,true);
      }
      
      public static function getInstance() : ExternalUiManager
      {
         if(!_instance)
         {
            _instance = new ExternalUiManager();
         }
         return _instance;
      }
      
      protected function onMainWindowClose(param1:Event) : void
      {
         var _loc3_:NativeWindow = null;
         var _loc2_:Array = NativeApplication.nativeApplication.openedWindows;
         for each(_loc3_ in _loc2_)
         {
            if(!_loc3_.closed)
            {
               _loc3_.close();
            }
         }
      }
      
      public function registerExternalUi(param1:ExternalUi) : void
      {
         param1.addEventListener(Event.ACTIVATE,this.onWindowFocus,false,0,true);
         param1.addEventListener(NativeWindowDisplayStateEvent.DISPLAY_STATE_CHANGE,this.onWindowFocus,false,0,true);
      }
      
      protected function onWindowFocus(param1:Event) : void
      {
         var _loc3_:NativeWindow = null;
         var _loc2_:Array = NativeApplication.nativeApplication.openedWindows;
         for each(_loc3_ in _loc2_)
         {
            if(_loc3_ != StageShareManager.stage.nativeWindow)
            {
               _loc3_.orderInFrontOf(StageShareManager.stage.nativeWindow);
            }
         }
      }
   }
}
