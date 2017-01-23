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
   
   public class IllustratedPopup
   {
       
      
      public var uiApi:UiApi;
      
      public var sysApi:SystemApi;
      
      public var soundApi:SoundApi;
      
      public var btn_close_popup:ButtonContainer;
      
      public var tx_illu:Texture;
      
      public var ta_content:Label;
      
      private var _onCloseCallback:Function;
      
      public function IllustratedPopup()
      {
         super();
      }
      
      public function main(param1:Object) : void
      {
         if(!param1)
         {
            param1 = new Object();
            param1.content = "Hello World";
            param1.illustrationFileName = "tx_illuHavenbagUnlocked.png";
            param1.onClose = null;
         }
         this.soundApi.playSound(SoundTypeEnum.POPUP_INFO);
         this.btn_close_popup.soundId = SoundEnum.WINDOW_CLOSE;
         if(param1)
         {
            this.tx_illu.uri = this.uiApi.createUri((this.uiApi.me() as Object).getConstant("illus") + param1.illustrationFileName);
            this.ta_content.text = param1.content;
            this._onCloseCallback = param1.onClose;
         }
         else
         {
            this.sysApi.log(16,"No params for this IllustratedPopup? You probably did something wrong, chap.");
         }
         this.uiApi.addShortcutHook("validUi",this.onShortcut);
         this.uiApi.addShortcutHook("closeUi",this.onShortcut);
      }
      
      public function onRelease(param1:Object) : void
      {
         switch(param1)
         {
            case this.btn_close_popup:
               this.closeMe();
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
