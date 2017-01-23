package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.SwfApplication;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.uiApi.ConfigApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import d2actions.GetComicRequest;
   import d2actions.LeaveDialogRequest;
   import d2enums.ComponentHookList;
   import d2enums.ShortcutHookListEnum;
   import d2hooks.ComicLoaded;
   import flash.display.Shape;
   import flash.geom.Rectangle;
   import flash.net.URLRequest;
   
   public class FlashComicReaderUi
   {
       
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      public var configApi:ConfigApi;
      
      public var ctr_fullscreenBg:GraphicContainer;
      
      public var ctr_main:GraphicContainer;
      
      public var ctr_btns:GraphicContainer;
      
      public var ctr_loading:GraphicContainer;
      
      public var btn_close:ButtonContainer;
      
      public var btn_fullScreen:ButtonContainer;
      
      public var btn_fullScreen_selected:ButtonContainer;
      
      public var lbl_title:Label;
      
      public var tx_btnsZone:Texture;
      
      public var app:SwfApplication;
      
      [Module(name="Ankama_Common")]
      public var modCommon:Object;
      
      private var _comicRemoteId:String;
      
      private var _comicLanguage:String;
      
      private var _callback:Function;
      
      private var _fullScreenBg:Shape;
      
      private var _lastDebugBookId:int;
      
      private var _commidId:String;
      
      private var _rec:Rectangle;
      
      public function FlashComicReaderUi()
      {
         super();
      }
      
      public function main(param1:Object = null) : void
      {
         this.btn_fullScreen_selected.visible = false;
         this.uiApi.addComponentHook(this.tx_btnsZone,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.tx_btnsZone,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.btn_fullScreen,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.btn_fullScreen,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.btn_close,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.btn_close,ComponentHookList.ON_ROLL_OUT);
         this._commidId = param1.remoteId;
         this.sysApi.showWorld(false);
         this.sysApi.addHook(ComicLoaded,this.onComicLoaded);
         this.uiApi.addShortcutHook(ShortcutHookListEnum.CLOSE_UI,this.onShortcut);
         this.uiApi.addShortcutHook("toggleFullscreen",this.onShortcut);
         this._fullScreenBg = new Shape();
         this.ctr_fullscreenBg.addChild(this._fullScreenBg);
         this.ctr_fullscreenBg.visible = false;
         this.app.loadedHandler = this.onAppLoaded;
         this.sysApi.setFlashCommicReaderApp(this.app);
      }
      
      public function unload() : void
      {
         if(!this.ctr_main.visible)
         {
            this.toggleFullScreen();
         }
         this.sysApi.showWorld(true);
      }
      
      public function onRollOver(param1:Object) : void
      {
         if(!this.ctr_main.visible)
         {
            this.ctr_btns.visible = true;
         }
      }
      
      public function onRollOut(param1:Object) : void
      {
         if(!this.ctr_main.visible && param1 == this.tx_btnsZone)
         {
            this.ctr_btns.visible = false;
         }
      }
      
      public function onRelease(param1:Object) : void
      {
         switch(param1)
         {
            case this.btn_fullScreen:
            case this.btn_fullScreen_selected:
               this.toggleFullScreen();
               break;
            case this.btn_close:
               this.close();
         }
      }
      
      public function close() : void
      {
         this.sysApi.sendAction(new LeaveDialogRequest());
         this.uiApi.unloadUi(this.uiApi.me().name);
      }
      
      private function onAppLoaded(param1:Object) : void
      {
         var _loc2_:* = this.sysApi.getData("comic_" + this._commidId + "_index");
         this.app.dispatchEventToApp("resizeComic",{
            "width":this.app.width,
            "height":this.app.height
         });
         this.app.dispatchEventToApp("openComic",{
            "id":this._commidId,
            "lang":this.sysApi.getCurrentLanguage(),
            "index":(!!_loc2_?_loc2_:0)
         });
         this.app.bindApi("changeIndexHandler",this.changeIndexHandler);
      }
      
      private function toggleFullScreen() : void
      {
         var _loc1_:Object = null;
         if(this.ctr_main.visible)
         {
            this.drawFullScreenBg();
            this.ctr_fullscreenBg.visible = true;
            this.ctr_main.visible = false;
            this.btn_fullScreen.visible = false;
            this.btn_fullScreen_selected.visible = true;
            this._rec = new Rectangle(this.app.x,this.app.y,this.app.width,this.app.height);
            _loc1_ = this.uiApi.getVisibleStageBounds();
            this.app.x = _loc1_.x;
            this.app.y = _loc1_.y;
            this.app.height = _loc1_.height;
            this.app.width = _loc1_.width;
         }
         else
         {
            this._fullScreenBg.graphics.clear();
            this.ctr_fullscreenBg.visible = false;
            this.ctr_main.visible = true;
            this.ctr_btns.visible = true;
            this.btn_fullScreen.visible = true;
            this.btn_fullScreen_selected.visible = false;
            this.app.x = this._rec.x;
            this.app.y = this._rec.y;
            this.app.width = this._rec.width;
            this.app.height = this._rec.height;
         }
         this.app.dispatchEventToApp("resizeComic",{
            "width":this.app.width,
            "height":this.app.height
         });
      }
      
      private function drawFullScreenBg() : void
      {
         var _loc1_:Object = this.uiApi.getVisibleStageBounds();
         this._fullScreenBg.graphics.clear();
         this._fullScreenBg.graphics.beginFill(1316370);
         this._fullScreenBg.graphics.drawRect(_loc1_.x,_loc1_.y,_loc1_.width,_loc1_.height);
      }
      
      public function onShortcut(param1:String) : Boolean
      {
         switch(param1)
         {
            case "closeUi":
               if(!this.ctr_main.visible)
               {
                  this.btn_fullScreen.selected = !this.btn_fullScreen.selected;
                  this.toggleFullScreen();
               }
               else
               {
                  this.close();
               }
               return true;
            default:
               return false;
         }
      }
      
      private function onUrlInput(param1:String) : void
      {
         this._lastDebugBookId = parseInt(param1);
         var _loc2_:URLRequest = new URLRequest(param1);
      }
      
      public function onComicLoaded(param1:Object) : void
      {
         this._callback(null,param1);
         this.lbl_title.text = param1.title + " - " + param1.subtitle;
         this.ctr_loading.visible = false;
         this.app.visible = true;
      }
      
      private function getComic(param1:String, param2:String, param3:Boolean, param4:Function) : void
      {
         if(param4 != null)
         {
            this._callback = param4;
            this.sysApi.sendAction(new GetComicRequest(param1,param2,param3));
         }
      }
      
      private function changeIndexHandler(param1:uint) : void
      {
         this.sysApi.setData("comic_" + this._commidId + "_index",param1);
      }
      
      private function logWrite(param1:String, param2:String) : void
      {
         var _loc3_:Object = {
            "debug":2,
            "error":5,
            "info":3,
            "log":3,
            "trace":1,
            "warn":4
         };
         var _loc4_:int = int(_loc3_[param1]) || 2;
         this.sysApi.log(_loc4_,param2);
      }
   }
}
