package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.uiApi.SoundApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofusModuleLibrary.enum.SoundEnum;
   import d2enums.ComponentHookList;
   import d2enums.SoundTypeEnum;
   
   public class SharePopup
   {
      
      private static const SHARE_URL_FACEBOOK:String = "https://www.facebook.com/sharer/sharer.php?u=%url%";
      
      private static const SHARE_URL_TWITTER:String = "https://twitter.com/intent/tweet?url=%url%&hashtags=DOFUS";
       
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      public var soundApi:SoundApi;
      
      public var ctr_main:GraphicContainer;
      
      public var btn_close:ButtonContainer;
      
      public var btn_web:ButtonContainer;
      
      public var btn_fb:ButtonContainer;
      
      public var btn_twitter:ButtonContainer;
      
      public var btn_goTo:ButtonContainer;
      
      public var lbl_url:Label;
      
      private var _url:String;
      
      public function SharePopup()
      {
         super();
      }
      
      public function main(param1:Object) : void
      {
         this._url = param1.url;
         if(!this._url)
         {
            this.uiApi.unloadUi((this.uiApi.me() as Object).name);
            return;
         }
         this.uiApi.addComponentHook(this.btn_fb,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.btn_fb,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.btn_twitter,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.btn_twitter,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.btn_goTo,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.btn_goTo,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.lbl_url,ComponentHookList.ON_RELEASE);
         this.soundApi.playSound(SoundTypeEnum.POPUP_INFO);
         this.btn_close.soundId = SoundEnum.WINDOW_CLOSE;
         this.lbl_url.text = this._url;
         this.lbl_url.allowTextMouse(true);
         this.uiApi.addShortcutHook("closeUi",this.onShortcut);
      }
      
      public function unload() : void
      {
         this._url = null;
      }
      
      public function onRollOver(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc3_:uint = 7;
         var _loc4_:uint = 1;
         switch(param1)
         {
            case this.btn_fb:
               _loc2_ = this.uiApi.getText("ui.social.share.popup.serviceTooltip","Facebook");
               break;
            case this.btn_twitter:
               _loc2_ = this.uiApi.getText("ui.social.share.popup.serviceTooltip","Twitter");
               break;
            case this.btn_goTo:
               _loc2_ = this.uiApi.getText("ui.shortcuts.openWebBrowser");
         }
         if(_loc2_)
         {
            this.uiApi.showTooltip(this.uiApi.textTooltipInfo(_loc2_),param1,false,"standard",_loc3_,_loc4_,3,null,null,null,"TextInfo");
         }
      }
      
      public function onRollOut(param1:Object) : void
      {
         this.uiApi.hideTooltip();
      }
      
      public function toggleVisibility() : void
      {
         this.ctr_main.visible = !this.ctr_main.visible;
      }
      
      public function onRelease(param1:Object) : void
      {
         var _loc2_:String = null;
         switch(param1)
         {
            case this.lbl_url:
               this.lbl_url.selectAll();
               break;
            case this.btn_close:
               this.toggleVisibility();
               return;
            case this.btn_fb:
               _loc2_ = SHARE_URL_FACEBOOK.replace("%url%",this._url);
               break;
            case this.btn_twitter:
               _loc2_ = SHARE_URL_TWITTER.replace("%url%",this._url);
               break;
            case this.btn_goTo:
               this.sysApi.goToUrl(this._url);
               break;
            case this.btn_web:
            default:
               _loc2_ = this._url;
         }
         if(_loc2_)
         {
            this.sysApi.goToUrl(encodeURI(_loc2_));
         }
      }
      
      public function onShortcut(param1:String) : Boolean
      {
         switch(param1)
         {
            case "closeUi":
               if(this.ctr_main.visible)
               {
                  this.ctr_main.visible = false;
                  return true;
               }
               return false;
            default:
               return false;
         }
      }
   }
}
