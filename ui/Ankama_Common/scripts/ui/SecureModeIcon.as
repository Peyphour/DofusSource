package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import d2enums.ComponentHookList;
   import d2enums.StrataEnum;
   
   public class SecureModeIcon
   {
       
      
      private var _secureModeNeedReboot:Object;
      
      public var btn_open:ButtonContainer;
      
      public var uiApi:UiApi;
      
      public function SecureModeIcon()
      {
         super();
      }
      
      public function main(param1:Object) : void
      {
         this._secureModeNeedReboot = param1;
         this.uiApi.addComponentHook(this.btn_open,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.btn_open,ComponentHookList.ON_ROLL_OUT);
      }
      
      public function onRelease(param1:ButtonContainer) : void
      {
         if(!this.uiApi.getUi("secureMode"))
         {
            this.uiApi.loadUi("secureMode","secureMode",this._secureModeNeedReboot,StrataEnum.STRATA_HIGH);
         }
      }
      
      public function onRollOver(param1:ButtonContainer) : void
      {
         this.uiApi.showTooltip(this.uiApi.getText("ui.modeSecure.tooltip.icon"),param1);
      }
      
      public function onRollOut(param1:ButtonContainer) : void
      {
         this.uiApi.hideTooltip();
      }
   }
}
