package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.uiApi.SoundApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofusModuleLibrary.enum.SoundTypeEnum;
   
   public class ServerPopup
   {
       
      
      public var output:Object;
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      public var soundApi:SoundApi;
      
      private var _selectedServer:Object;
      
      public var ctr_content:GraphicContainer;
      
      public var btn_ok:ButtonContainer;
      
      public var btn_undo:ButtonContainer;
      
      public var btn_close:ButtonContainer;
      
      public function ServerPopup()
      {
         super();
      }
      
      public function main(param1:Object) : void
      {
         this.uiApi.addShortcutHook("validUi",this.onShortcut);
         this.uiApi.addShortcutHook("closeUi",this.onShortcut);
         this._selectedServer = param1[0];
         this.uiApi.loadUiInside("serverForm",this.ctr_content,"serverForm",{"server":this._selectedServer});
      }
      
      public function unload() : void
      {
         this.uiApi.unloadUi("serverForm");
      }
      
      public function onRelease(param1:Object) : void
      {
         switch(param1)
         {
            case this.btn_ok:
               this.onValidateServer();
               break;
            case this.btn_undo:
            case this.btn_close:
               if(this.uiApi.getUi("serverTypeSelection"))
               {
                  this.uiApi.getUi("serverTypeSelection").uiClass.onSelectedServerRefused(0,"",null);
               }
               this.uiApi.unloadUi(this.uiApi.me().name);
         }
      }
      
      public function onShortcut(param1:String) : Boolean
      {
         switch(param1)
         {
            case "validUi":
               this.onValidateServer();
               return true;
            case "closeUi":
               this.uiApi.unloadUi(this.uiApi.me().name);
               return true;
            default:
               return false;
         }
      }
      
      public function onValidateServer() : void
      {
         this.soundApi.playSound(SoundTypeEnum.OK_BUTTON);
         this.btn_ok.disabled = true;
         this.btn_undo.disabled = true;
         this.sysApi.sendAction(new d2actions.ServerSelection(this._selectedServer.id));
         if(this.uiApi.getUi("serverTypeSelection"))
         {
            this.uiApi.unloadUi("serverTypeSelection");
         }
         this.uiApi.unloadUi(this.uiApi.me().name);
      }
   }
}
