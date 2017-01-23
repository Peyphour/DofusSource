package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.WebBrowser;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import d2enums.ShortcutHookListEnum;
   import d2enums.WebLocationEnum;
   import d2hooks.NumericWhoIs;
   
   public class WebPortal
   {
      
      private static var _lastDomain:int = -1;
       
      
      public var uiApi:UiApi;
      
      public var sysApi:SystemApi;
      
      public var btnClose:ButtonContainer;
      
      public var browser:WebBrowser;
      
      public var mainCtr:GraphicContainer;
      
      private var _domain:int = -1;
      
      private var _args:Object;
      
      public function WebPortal()
      {
         super();
      }
      
      public function main(param1:*) : void
      {
         var _loc2_:uint = 0;
         this.uiApi.addComponentHook(this.btnClose,"onRelease");
         this.uiApi.addComponentHook(this.browser,"onBrowserSessionTimeout");
         this.uiApi.addComponentHook(this.browser,"onBrowserDomReady");
         this.uiApi.addShortcutHook(ShortcutHookListEnum.CLOSE_UI,this.onShortcut);
         this._domain = param1[0];
         _lastDomain = this._domain;
         this._args = param1[2];
         if(this._domain == WebLocationEnum.WEB_LOCATION_ANKABOX_SEND_MESSAGE && this._args && this._args.length > 1 && this._args[0] == 0 && this._args[1])
         {
            _loc2_ = this.sysApi.getAccountId(this._args[1]);
            if(!_loc2_)
            {
               this._args = [0,this._args[1]];
               this.sysApi.addHook(NumericWhoIs,this.onAccountInfo);
            }
         }
         this.refreshPortal();
      }
      
      public function goTo(param1:int, param2:Boolean, param3:Array) : void
      {
         this._domain = param1;
         _lastDomain = this._domain;
         this._args = param3;
         this.refreshPortal();
      }
      
      public function onRelease(param1:Object) : void
      {
         switch(param1)
         {
            case this.btnClose:
               this.uiApi.unloadUi(this.uiApi.me().name);
         }
      }
      
      public function onShortcut(param1:String) : Boolean
      {
         if(param1 == "closeUi")
         {
            this.uiApi.unloadUi(this.uiApi.me().name);
         }
         if(param1 == "validUi")
         {
            this.uiApi.unloadUi(this.uiApi.me().name);
         }
         return true;
      }
      
      public function onBrowserSessionTimeout(param1:*) : void
      {
         this.sysApi.refreshUrl(this.browser,this._domain);
      }
      
      public function onBrowserDomReady(param1:*) : void
      {
      }
      
      public function onAccountInfo(param1:Number, param2:uint) : void
      {
         this._args[0] = param2;
         this.refreshPortal();
      }
      
      private function refreshPortal() : void
      {
         var _loc1_:WebBrowser = !!this.sysApi.isStreaming()?null:this.browser;
         if(this._domain == WebLocationEnum.WEB_LOCATION_OGRINE)
         {
            this.sysApi.goToOgrinePortal(_loc1_);
         }
         else if(this._domain == WebLocationEnum.WEB_LOCATION_ANKABOX)
         {
            this.sysApi.goToAnkaBoxPortal(_loc1_);
         }
         else if(this._domain == WebLocationEnum.WEB_LOCATION_ANKABOX_LAST_UNREAD)
         {
            this.sysApi.goToAnkaBoxLastMessage(_loc1_);
         }
         else if(this._domain == WebLocationEnum.WEB_LOCATION_ANKABOX_SEND_MESSAGE)
         {
            if(this._args)
            {
               if(this._args[0])
               {
                  this.sysApi.goToAnkaBoxSend(_loc1_,uint(this._args[0]));
               }
               else
               {
                  this.sysApi.goToAnkaBoxPortal(_loc1_);
               }
            }
         }
         if(!_loc1_)
         {
            this.uiApi.unloadUi(this.uiApi.me().name);
         }
      }
   }
}
