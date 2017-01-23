package
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import d2enums.StrataEnum;
   import d2hooks.OpenSharePopup;
   import d2hooks.OpenWebService;
   import flash.display.Sprite;
   import ui.SharePopup;
   import ui.WebBak;
   import ui.WebBase;
   import ui.WebLibrary;
   import ui.WebReader;
   import ui.WebShop;
   import ui.WebVetRwds;
   
   public class Web extends Sprite
   {
       
      
      public var uiApi:UiApi;
      
      public var sysApi:SystemApi;
      
      [Module(name="Ankama_Common")]
      public var modCommon:Object;
      
      private var include_webBase:WebBase = null;
      
      private var include_webShop:WebShop = null;
      
      private var include_webBak:WebBak = null;
      
      private var include_webVetRwds:WebVetRwds = null;
      
      private var include_webLibrary:WebLibrary = null;
      
      private var include_webReader:WebReader = null;
      
      private var include_shareItem:SharePopup = null;
      
      public function Web()
      {
         super();
      }
      
      public function main() : void
      {
         this.sysApi.addHook(OpenWebService,this.onOpenWebService);
         this.sysApi.addHook(OpenSharePopup,this.onOpenSharePopup);
      }
      
      private function onOpenWebService(param1:String, param2:*) : void
      {
         if(this.uiApi.getUi("webBase"))
         {
            if(param1 && WebBase.currentTabUi != param1)
            {
               this.uiApi.getUi("webBase").uiClass.openTab(param1,param2);
            }
            else
            {
               this.uiApi.unloadUi("webBase");
            }
         }
         else
         {
            this.uiApi.loadUi("webBase","webBase",[param1,param2],StrataEnum.STRATA_HIGH);
         }
      }
      
      private function onOpenSharePopup(param1:String) : void
      {
         this.uiApi.loadUi("sharePopup","sharePopup",{"url":param1},StrataEnum.STRATA_HIGH,null,true);
      }
      
      private function onOpenComic(param1:String, param2:String) : void
      {
         var _loc3_:* = this.uiApi.getUi("webReader");
         var _loc4_:Object = {
            "remoteId":param1,
            "language":param2
         };
         if(_loc3_)
         {
            _loc3_.uiClass.main(_loc4_);
         }
         else
         {
            this.uiApi.loadUi("webReader","webReader",_loc4_,StrataEnum.STRATA_TOP);
         }
      }
   }
}
