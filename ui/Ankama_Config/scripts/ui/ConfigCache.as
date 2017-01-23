package ui
{
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.SoundApi;
   
   public class ConfigCache extends ConfigUi
   {
       
      
      public var dataApi:DataApi;
      
      public var soundApi:SoundApi;
      
      [Module(name="Ankama_Common")]
      public var modCommon:Object;
      
      public var btnSelectiveClearCache:ButtonContainer;
      
      public var btnCompleteClearCache:ButtonContainer;
      
      public var lbl_SelectiveClearCacheExplicativeText:Label;
      
      public var lbl_CompleteClearCacheExplicativeText:Label;
      
      public function ConfigCache()
      {
         super();
      }
      
      public function main(param1:*) : void
      {
         uiApi.addComponentHook(this.btnSelectiveClearCache,"onRelease");
         uiApi.addComponentHook(this.btnCompleteClearCache,"onRelease");
         showDefaultBtn(false);
      }
      
      public function unload() : void
      {
      }
      
      override public function onRelease(param1:Object) : void
      {
         switch(param1)
         {
            case this.btnSelectiveClearCache:
               this.modCommon.openPopup(uiApi.getText("ui.popup.warning"),uiApi.getText("ui.popup.clearCache"),[uiApi.getText("ui.common.ok"),uiApi.getText("ui.common.cancel")],[this.onSelectiveClearCache,this.onPopupClose],this.onSelectiveClearCache,this.onPopupClose);
               break;
            case this.btnCompleteClearCache:
               this.modCommon.openPopup(uiApi.getText("ui.popup.warning"),uiApi.getText("ui.popup.clearCache"),[uiApi.getText("ui.common.ok"),uiApi.getText("ui.common.cancel")],[this.onCompleteClearCache,this.onPopupClose],this.onCompleteClearCache,this.onPopupClose);
         }
      }
      
      public function onSelectItem(param1:Object, param2:uint, param3:Boolean) : void
      {
      }
      
      public function onRollOver(param1:Object) : void
      {
      }
      
      public function onRollOut(param1:Object) : void
      {
         uiApi.hideTooltip();
      }
      
      public function onSelectiveClearCache() : void
      {
         sysApi.clearCache(true);
      }
      
      public function onCompleteClearCache() : void
      {
         sysApi.clearCache(false);
      }
      
      private function onPopupClose() : void
      {
      }
   }
}
