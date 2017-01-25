package com.ankamagames.dofus.externalnotification
{
   import com.ankamagames.berilia.Berilia;
   import com.ankamagames.berilia.managers.UiModuleManager;
   import com.ankamagames.berilia.types.data.UiModule;
   import com.ankamagames.berilia.types.event.UiRenderEvent;
   import com.ankamagames.berilia.types.graphic.UiRootContainer;
   import com.ankamagames.jerakine.handlers.HumanInputHandler;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import flash.display.NativeWindow;
   import flash.display.NativeWindowInitOptions;
   import flash.display.Sprite;
   import flash.display.StageAlign;
   import flash.display.StageScaleMode;
   import flash.utils.getQualifiedClassName;
   
   public class ExternalNotificationWindow extends NativeWindow
   {
      
      private static const DEBUG:Boolean = false;
      
      private static const _log:Logger = Log.getLogger(getQualifiedClassName(ExternalNotificationWindow));
       
      
      private var _container:UiRootContainer;
      
      private var _notificationType:int;
      
      private var _id:String;
      
      private var _clientId:String;
      
      private var _playSound:Boolean;
      
      private var _soundId:String;
      
      private var _notify:Boolean;
      
      private var _contentWidth:Number;
      
      private var _contentHeight:Number;
      
      private var _hookName:String;
      
      private var _hookParams:Array;
      
      public var timeoutId:uint;
      
      public function ExternalNotificationWindow(param1:ExternalNotificationRequest, param2:NativeWindowInitOptions)
      {
         var _loc3_:UiModule = UiModuleManager.getInstance().getModule("Ankama_GameUiCore");
         var _loc4_:Sprite = new Sprite();
         this._container = new UiRootContainer(stage,_loc3_.uis[param1.uiName],_loc4_);
         this._container.uiModule = _loc3_;
         _loc4_.addChild(this._container);
         this._container.addEventListener(UiRenderEvent.UIRenderComplete,this.onUiLoaded);
         Berilia.getInstance().loadUiInside(this._container.uiData,param1.instanceId,this._container,param1.displayData);
         this._notificationType = param1.notificationType;
         this._id = param1.id;
         this._clientId = param1.clientId;
         this._playSound = param1.playSound;
         this._soundId = param1.soundId;
         this._notify = param1.notify;
         this._hookName = param1.hookName;
         this._hookParams = param1.hookParams;
         super(param2);
         visible = false;
         alwaysInFront = true;
         stage.scaleMode = StageScaleMode.NO_SCALE;
         stage.align = StageAlign.TOP_LEFT;
         HumanInputHandler.getInstance().registerListeners(stage);
         stage.addChild(_loc4_);
      }
      
      private static function log(param1:Object) : void
      {
         if(DEBUG)
         {
            _log.debug(param1);
         }
      }
      
      public function get notificationType() : int
      {
         return this._notificationType;
      }
      
      public function get id() : String
      {
         return this._id;
      }
      
      public function get clientId() : String
      {
         return this._clientId;
      }
      
      public function get playSound() : Boolean
      {
         return this._playSound;
      }
      
      public function get soundId() : String
      {
         return this._soundId;
      }
      
      public function get notify() : Boolean
      {
         return this._notify;
      }
      
      public function get instanceId() : String
      {
         return this._clientId + "#" + this._id;
      }
      
      public function get contentWidth() : Number
      {
         return this._contentWidth;
      }
      
      public function get contentHeight() : Number
      {
         return this._contentHeight;
      }
      
      public function get hookName() : String
      {
         return this._hookName;
      }
      
      public function get hookParams() : Array
      {
         return this._hookParams;
      }
      
      private function onUiLoaded(param1:UiRenderEvent) : void
      {
         this._container.removeEventListener(UiRenderEvent.UIRenderComplete,this.onUiLoaded);
         this._contentWidth = this._container.contentWidth;
         this._contentHeight = this._container.contentHeight;
         ExternalNotificationManager.getInstance().addNotification(this);
      }
      
      public function show() : void
      {
         visible = true;
      }
      
      public function destroy() : void
      {
         this._container.removeEventListener(UiRenderEvent.UIRenderComplete,this.onUiLoaded);
         HumanInputHandler.getInstance().unregisterListeners(stage);
         visible = false;
         Berilia.getInstance().unloadUi(this.instanceId);
         stage.removeChildAt(0);
         close();
      }
   }
}
