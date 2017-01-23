package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.components.WebBrowser;
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
   import flash.net.URLRequest;
   
   public class WebReader
   {
      
      private static var _lastDebugUrl:String = "http://api.ankama.lan/fr/gamecomics?debug=1";
       
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      public var configApi:ConfigApi;
      
      public var browser_reader:WebBrowser;
      
      public var ctr_fullscreenBg:GraphicContainer;
      
      public var ctr_main:GraphicContainer;
      
      public var ctr_btns:GraphicContainer;
      
      public var ctr_loading:GraphicContainer;
      
      public var btn_close:ButtonContainer;
      
      public var btn_fullScreen:ButtonContainer;
      
      public var lbl_title:Label;
      
      public var tx_btnsZone:Texture;
      
      [Module(name="Ankama_Common")]
      public var modCommon:Object;
      
      private var _comicRemoteId:String;
      
      private var _comicLanguage:String;
      
      private var _callback:Function;
      
      private var _fullScreenBg:Shape;
      
      public function WebReader()
      {
         super();
      }
      
      public function main(param1:Object = null) : void
      {
         this.uiApi.addComponentHook(this.browser_reader,"onBrowserDomReady");
         this.uiApi.addComponentHook(this.tx_btnsZone,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.tx_btnsZone,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.btn_fullScreen,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.btn_fullScreen,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.btn_close,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.btn_close,ComponentHookList.ON_ROLL_OUT);
         this.sysApi.showWorld(false);
         this.sysApi.addHook(ComicLoaded,this.onComicLoaded);
         this.uiApi.addShortcutHook(ShortcutHookListEnum.CLOSE_UI,this.onShortcut);
         this.uiApi.addShortcutHook("toggleFullscreen",this.onShortcut);
         this._fullScreenBg = new Shape();
         this.ctr_fullscreenBg.addChild(this._fullScreenBg);
         this.ctr_fullscreenBg.visible = false;
         if(param1)
         {
            this._comicRemoteId = param1.remoteId;
            this._comicLanguage = param1.language;
            if(this._comicRemoteId)
            {
               if(this._comicRemoteId == "DEBUG")
               {
                  this.modCommon.openInputPopup("Debug Reader","Please input the URL of the reader to load",this.onUrlInput,null,_lastDebugUrl);
               }
               else if(this.sysApi.isStreaming())
               {
                  if(this.sysApi.getBrowser() == "chrome" || this.sysApi.getBrowser() == "safari")
                  {
                     this.sysApi.goToWebReader(null,this._comicRemoteId);
                  }
                  else
                  {
                     this.sysApi.log(3,this.sysApi.getBrowser() + " is not supported for the Reader");
                  }
               }
               else
               {
                  this.sysApi.goToWebReader(this.browser_reader,this._comicRemoteId);
               }
            }
         }
      }
      
      public function unload() : void
      {
         if(!this.ctr_main.visible)
         {
            this.toggleFullScreen();
         }
         this.browser_reader.clearLocation();
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
      
      private function toggleFullScreen() : void
      {
         if(this.ctr_main.visible)
         {
            this.drawFullScreenBg();
            this.ctr_fullscreenBg.visible = true;
            this.ctr_main.visible = false;
            this.browser_reader.x = 0;
            this.browser_reader.y = 0;
            this.browser_reader.height = this.uiApi.getStageHeight();
            this.browser_reader.width = this.uiApi.getStageWidth();
         }
         else
         {
            this._fullScreenBg.graphics.clear();
            this.ctr_fullscreenBg.visible = false;
            this.ctr_main.visible = true;
            this.ctr_btns.visible = true;
            this.browser_reader.x = 12;
            this.browser_reader.y = 80;
            this.browser_reader.height = 788;
            this.browser_reader.width = 1258;
         }
         this.browser_reader.finalize();
      }
      
      private function drawFullScreenBg() : void
      {
         var _loc1_:uint = 16777215;
         if(!this.browser_reader.visible)
         {
            switch(this.configApi.getCurrentTheme())
            {
               case "dofus1":
                  _loc1_ = 14012330;
                  break;
               case "black":
                  _loc1_ = 3682348;
            }
         }
         this._fullScreenBg.graphics.clear();
         this._fullScreenBg.graphics.beginFill(_loc1_);
         this._fullScreenBg.graphics.drawRect(0,0,this.uiApi.getStageWidth(),this.uiApi.getStageHeight());
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
      
      public function onBrowserDomReady(param1:Object) : void
      {
         this.lbl_title.text = "";
         this.ctr_loading.visible = false;
         this.browser_reader.visible = true;
         this.browser_reader.focus();
         this.browser_reader.javascriptSetVar("comicHost",{});
         this.browser_reader.javascriptSetVar("comicHost.getComic",this.getComic);
         this.browser_reader.javascriptSetVar("comicHost.logWrite",this.logWrite);
         this.browser_reader.javascriptCall("comicReader.setupLogger");
         this.browser_reader.javascriptCall("comicReader.setupReader",this.sysApi.getCurrentLanguage());
      }
      
      private function onUrlInput(param1:String) : void
      {
         _lastDebugUrl = param1;
         var _loc2_:URLRequest = new URLRequest(param1);
         this.browser_reader.load(_loc2_);
      }
      
      public function onComicLoaded(param1:Object) : void
      {
         this._callback(null,param1);
         this.lbl_title.text = param1.title + " - " + param1.subtitle;
         this.ctr_loading.visible = false;
         this.browser_reader.visible = true;
      }
      
      private function getComic(param1:String, param2:String, param3:Boolean, param4:Function) : void
      {
         if(param4 != null)
         {
            this._callback = param4;
            this.sysApi.sendAction(new GetComicRequest(param1,param2,param3));
         }
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
