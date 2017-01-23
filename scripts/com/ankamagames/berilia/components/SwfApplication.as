package com.ankamagames.berilia.components
{
   import com.ankamagames.berilia.UIComponent;
   import com.ankamagames.berilia.managers.SecureCenter;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.jerakine.types.Uri;
   import flash.display.DisplayObject;
   import flash.display.Loader;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.events.ProgressEvent;
   import flash.events.UncaughtErrorEvent;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   import flash.utils.ByteArray;
   
   public class SwfApplication extends GraphicContainer implements UIComponent
   {
       
      
      private var _ldr:Loader;
      
      private var _uri:Uri;
      
      private var _app:DisplayObject;
      
      public var loadedHandler:Function;
      
      public var loadErrorHandler:Function;
      
      public var loadProgressHandler:Function;
      
      public var autoResize:Boolean = true;
      
      public function SwfApplication()
      {
         super();
         mouseEnabled = true;
      }
      
      public function set uri(param1:Uri) : void
      {
         if(!getUi() || !getUi().uiModule.trusted)
         {
            return;
         }
         this._uri = param1;
         this.initLoader();
         this._ldr.load(new URLRequest(param1.normalizedUri));
      }
      
      public function get uri() : Uri
      {
         return this._uri;
      }
      
      public function setByte(param1:ByteArray, param2:Object) : void
      {
         SecureCenter.checkAccessKey(param2);
         this.initLoader();
         var _loc3_:LoaderContext = new LoaderContext();
         _loc3_.applicationDomain = new ApplicationDomain(ApplicationDomain.currentDomain);
         _loc3_.allowCodeImport = true;
         _loc3_.allowLoadBytesCodeExecution = true;
         this._ldr.loadBytes(param1,_loc3_);
      }
      
      override public function set width(param1:Number) : void
      {
         super.width = param1;
         if(this._app && this.autoResize)
         {
            this._app.width = param1;
         }
      }
      
      override public function set height(param1:Number) : void
      {
         super.height = param1;
         if(this._app && this.autoResize)
         {
            this._app.height = param1;
         }
      }
      
      override public function remove() : void
      {
         this.clearLoader();
         if(this._ldr && this._ldr.contentLoaderInfo)
         {
            this._ldr.contentLoaderInfo.removeEventListener(Event.INIT,this.onInit);
            this._ldr.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onError);
         }
         if(this._app)
         {
            this._app.removeEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMouse);
         }
         this._ldr = null;
         this.loadedHandler = null;
         this.loadErrorHandler = null;
      }
      
      public function bindApi(param1:String, param2:*) : Boolean
      {
         var propertyName:String = param1;
         var value:* = param2;
         if(!getUi() || !getUi().uiModule.trusted)
         {
            return false;
         }
         if(!this._app)
         {
            return false;
         }
         try
         {
            this._app[propertyName] = value;
         }
         catch(e:Error)
         {
            return false;
         }
         return true;
      }
      
      public function dispatchEventToApp(param1:String, param2:Object) : void
      {
         if(this._app)
         {
            this._app.dispatchEvent(new AppEvent(param1,param2));
         }
      }
      
      private function initLoader() : void
      {
         if(!this._ldr)
         {
            this._ldr = new Loader();
            this._ldr.contentLoaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR,trace,false,0,true);
            this._ldr.contentLoaderInfo.addEventListener(Event.INIT,this.onInit);
            this._ldr.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,this.onProgress);
            this._ldr.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onError);
         }
         else
         {
            this.clearLoader();
         }
      }
      
      private function clearLoader() : void
      {
         if(this._ldr)
         {
            this._ldr.unloadAndStop(true);
         }
         while(numChildren)
         {
            removeChildAt(0);
         }
      }
      
      private function onInit(param1:Event) : void
      {
         this._app = this._ldr.content;
         addChild(this._app);
         this._app.addEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMouse);
         if(this.loadedHandler != null)
         {
            this.loadedHandler(this);
         }
      }
      
      private function onMouseMouse(param1:MouseEvent) : void
      {
         stage.dispatchEvent(param1);
      }
      
      private function onProgress(param1:ProgressEvent) : void
      {
         if(this.loadProgressHandler != null)
         {
            this.loadProgressHandler(this,param1);
         }
      }
      
      private function onError(param1:Event) : void
      {
         this.clearLoader();
         if(this.loadErrorHandler != null)
         {
            this.loadErrorHandler(this,param1);
         }
      }
   }
}

import flash.events.Event;

class AppEvent extends Event
{
    
   
   public var parameters:Object;
   
   function AppEvent(param1:String, param2:Object)
   {
      super(param1,false,false);
      this.parameters = param2;
   }
}
