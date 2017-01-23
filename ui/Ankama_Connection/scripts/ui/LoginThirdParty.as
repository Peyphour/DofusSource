package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.WebBrowser;
   import com.ankamagames.dofus.uiApi.SoundApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofus.uiApi.TimeApi;
   import d2actions.LoginValidation;
   import d2actions.LoginValidationWithTicket;
   import d2enums.ComponentHookList;
   import flash.utils.setTimeout;
   
   public class LoginThirdParty
   {
       
      
      private var _jsApi:Object;
      
      private var _timeoutId:uint;
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      [Module(name="Ankama_Common")]
      public var modCommon:Object;
      
      public var soundApi:SoundApi;
      
      public var timeApi:TimeApi;
      
      public var browser:WebBrowser;
      
      public function LoginThirdParty()
      {
         super();
      }
      
      public function main(param1:String = null) : void
      {
         this._jsApi = {
            "loginClassic":this.JS_API_LoginClassic,
            "loginWithTicket":this.JS_API_LoginWithTicket,
            "getLastLogin":this.JS_API_GetLastLogin,
            "setLastLogin":this.JS_API_SetLastLogin,
            "setPort":this.sysApi.setPort,
            "getPort":this.sysApi.getPort,
            "getLaunchArgs":this.sysApi.getLaunchArgs,
            "setBlankLink":this.browser.setBlankLink,
            "getPartnerInfo":this.sysApi["getPartnerInfo"]
         };
         this._timeoutId = setTimeout(this.init,1);
      }
      
      public function init() : void
      {
         this.sysApi.goToThirdPartyLogin(this.browser);
         this.uiApi.addComponentHook(this.browser,ComponentHookList.ON_DOM_READY);
      }
      
      public function onBrowserDomReady(param1:Object) : void
      {
         this.browser.javascriptCall("ankInit",this._jsApi);
      }
      
      private function JS_API_LoginClassic(param1:String, param2:String) : void
      {
         this.sysApi.sendAction(new LoginValidation(param1,param2,true));
      }
      
      private function JS_API_LoginWithTicket(param1:String, param2:Boolean, param3:uint = 0) : void
      {
         this.sysApi.sendAction(new LoginValidationWithTicket(param1,param2,param3));
      }
      
      private function JS_API_GetLastLogin() : String
      {
         return !!this.sysApi.getData("LastLogin")?this.sysApi.getData("LastLogin"):"";
      }
      
      private function JS_API_SetLastLogin(param1:String) : void
      {
         this.sysApi.setData("LastLogin",param1);
      }
   }
}
