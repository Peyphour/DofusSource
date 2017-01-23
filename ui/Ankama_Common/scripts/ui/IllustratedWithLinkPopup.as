package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.dofus.uiApi.SoundApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofusModuleLibrary.enum.SoundEnum;
   import com.ankamagames.dofusModuleLibrary.enum.SoundTypeEnum;
   
   public class IllustratedWithLinkPopup
   {
       
      
      public var uiApi:UiApi;
      
      public var sysApi:SystemApi;
      
      public var soundApi:SoundApi;
      
      public var btn_close_popup:ButtonContainer;
      
      public var tx_illu:Texture;
      
      public var lbl_title:Label;
      
      public var lbl_content:Label;
      
      public var btn_link:ButtonContainer;
      
      private var _onCloseCallback:Function;
      
      private var _link:String;
      
      public function IllustratedWithLinkPopup()
      {
         super();
      }
      
      public function main(param1:Object) : void
      {
         if(!param1)
         {
            this.sysApi.log(16,"No params for this IllustratedPopup? You probably did something wrong, chap.");
            return;
         }
         this.soundApi.playSound(SoundTypeEnum.POPUP_INFO);
         this.btn_close_popup.soundId = SoundEnum.WINDOW_CLOSE;
         this.tx_illu.uri = this.uiApi.createUri((this.uiApi.me() as Object).getConstant("illus") + param1.illustrationFileName);
         this.lbl_title.text = param1.title;
         this.lbl_content.text = param1.content;
         this._link = param1.link;
         this._onCloseCallback = param1.onClose;
         this.uiApi.addShortcutHook("validUi",this.onShortcut);
         this.uiApi.addShortcutHook("closeUi",this.onShortcut);
      }
      
      public function onRelease(param1:Object) : void
      {
         switch(param1)
         {
            case this.btn_close_popup:
               this.closeMe();
               break;
            case this.btn_link:
               this.sysApi.goToUrl(this._link);
         }
      }
      
      public function onShortcut(param1:String) : Boolean
      {
         switch(param1)
         {
            case "validUi":
            case "closeUi":
               this.closeMe();
               return true;
            default:
               return false;
         }
      }
      
      private function closeMe() : void
      {
         if(this.uiApi)
         {
            this.uiApi.unloadUi((this.uiApi.me() as Object).name);
         }
         if(this._onCloseCallback != null)
         {
            this._onCloseCallback();
         }
      }
   }
}
