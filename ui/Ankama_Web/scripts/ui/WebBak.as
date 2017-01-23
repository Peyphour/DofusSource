package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.WebBrowser;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.uiApi.ConfigApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import d2enums.WebLocationEnum;
   import flash.geom.Point;
   
   public class WebBak
   {
       
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      public var configApi:ConfigApi;
      
      private var _domain:int = -1;
      
      public var wb_ogrineBrowser:WebBrowser;
      
      public function WebBak()
      {
         super();
      }
      
      public function main(param1:Object = null) : void
      {
         if(!this.sysApi.isStreaming())
         {
            this.uiApi.addComponentHook(this.wb_ogrineBrowser,"onBrowserSessionTimeout");
            this.uiApi.addComponentHook(this.wb_ogrineBrowser,"onBrowserDomChange");
            this._domain = WebLocationEnum.WEB_LOCATION_OGRINE;
            this.sysApi.goToOgrinePortal(this.wb_ogrineBrowser);
         }
         else
         {
            this.uiApi.setFullScreen(false);
            this.configApi.setConfigProperty("dofus","fullScreen",false);
            this.sysApi.openWebModalOgrinePortal(this.goToShopArticle,this.openUnlockSecureModeUi);
         }
      }
      
      public function destroy() : *
      {
         this.uiApi.removeComponentHook(this.wb_ogrineBrowser,"onBrowserSessionTimeout");
         this.uiApi.removeComponentHook(this.wb_ogrineBrowser,"onBrowserDomChange");
      }
      
      public function goToShopArticle(param1:uint = 0, param2:uint = 0, param3:uint = 0) : String
      {
         var pArticleId:uint = param1;
         var pCategoryId:uint = param2;
         var pPage:uint = param3;
         this.sysApi.log(4,"goToShopArticle(" + pArticleId + ", " + pCategoryId + ", " + pPage + ")");
         try
         {
            if(!pCategoryId)
            {
               this.sysApi.log(4,"goToShopArticle() has no categoryId defined!");
               return "categoryId cannot be null!";
            }
            if(!pArticleId)
            {
               pPage = 1;
            }
            this.uiApi.getUi("webBase").uiClass.openTab("webShop",{
               "articleId":pArticleId,
               "categoryId":pCategoryId,
               "page":pPage
            });
            return "success";
         }
         catch(error:Error)
         {
            return error.message;
         }
         return "unknown error";
      }
      
      public function openUnlockSecureModeUi() : void
      {
         var _loc1_:GraphicContainer = null;
         try
         {
            this.uiApi.getUi(this.uiApi.me().name).filters = [WebBase.blurFilter];
            this.uiApi.getUi(this.uiApi.me().name).disabled = true;
            _loc1_ = WebBase(this.uiApi.getUi("webBase").uiClass).uiCtr;
            this.uiApi.loadUiInside("Ankama_Common::secureMode",_loc1_,"secureMode",{
               "reboot":false,
               "callBackOnSecured":this.onSecureModeUnlocked,
               "callBackOnCancelled":this.onSecureModeCancelled,
               "offset":new Point(-80,-100),
               "step":100
            });
            return;
         }
         catch(error:Error)
         {
            return;
         }
      }
      
      public function onSecureModeUnlocked(param1:* = null) : void
      {
         this.uiApi.getUi(this.uiApi.me().name).filters = [];
         this.uiApi.getUi(this.uiApi.me().name).disabled = false;
         this.sysApi.goToOgrinePortal(this.wb_ogrineBrowser);
      }
      
      public function onSecureModeCancelled(param1:* = null) : void
      {
         this.uiApi.getUi(this.uiApi.me().name).filters = [];
         this.uiApi.getUi(this.uiApi.me().name).disabled = false;
      }
      
      public function onBrowserDomChange(param1:*) : void
      {
         this.wb_ogrineBrowser.javascriptSetVar("window.goToShopArticle",this.goToShopArticle);
         this.wb_ogrineBrowser.javascriptSetVar("window.openUnlockSecureModeUi",this.openUnlockSecureModeUi);
      }
      
      public function onBrowserSessionTimeout(param1:*) : void
      {
         this.sysApi.refreshUrl(this.wb_ogrineBrowser,this._domain);
      }
   }
}
