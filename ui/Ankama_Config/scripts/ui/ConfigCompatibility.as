package ui
{
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import d2enums.ComponentHookList;
   
   public class ConfigCompatibility extends ConfigUi
   {
       
      
      [Module(name="Ankama_Common")]
      public var modCommon:Object;
      
      public var btnUseOther:ButtonContainer;
      
      public var tx_bgForeground1:Texture;
      
      public var tx_bgForeground2:Texture;
      
      public var lblTitleCurrentVersion:Label;
      
      public var lblCurrentVersionDescription:Label;
      
      public var lblTitleOtherVersion:Label;
      
      public var lblOtherVersionDescription:Label;
      
      public var btn_lbl_btnUseOther:Label;
      
      public function ConfigCompatibility()
      {
         super();
      }
      
      public function main(param1:*) : void
      {
         var _loc2_:uint = sysApi.getAirVersion();
         this.lblTitleCurrentVersion.x = 0;
         this.lblTitleCurrentVersion.y = 0;
         this.tx_bgForeground1.x = 0;
         this.tx_bgForeground1.y = 45;
         this.lblCurrentVersionDescription.x = 10;
         this.lblCurrentVersionDescription.y = 60;
         this.lblTitleOtherVersion.x = 0;
         this.tx_bgForeground2.x = 0;
         this.lblOtherVersionDescription.x = 10;
         if(_loc2_ == 1)
         {
            this.tx_bgForeground1.height = 110;
            this.lblCurrentVersionDescription.height = 90;
            this.tx_bgForeground2.height = 195;
            this.lblOtherVersionDescription.height = 175;
            this.lblTitleOtherVersion.y = 165;
            this.tx_bgForeground2.y = 210;
            this.lblOtherVersionDescription.y = 225;
         }
         else
         {
            this.lblTitleOtherVersion.y = 255;
            this.tx_bgForeground2.y = 300;
            this.lblOtherVersionDescription.y = 315;
         }
         uiApi.me().render();
         this.lblTitleCurrentVersion.text = uiApi.getText("ui.config.current.version",_loc2_ == 1?uiApi.getText("ui.config.old.air"):uiApi.getText("ui.config.new.air"));
         this.lblCurrentVersionDescription.text = _loc2_ == 1?uiApi.getText("ui.config.old.air.desc"):uiApi.getText("ui.config.new.air.desc");
         this.lblOtherVersionDescription.text = _loc2_ == 2?uiApi.getText("ui.config.old.air.desc"):uiApi.getText("ui.config.new.air.desc");
         this.lblTitleOtherVersion.text = uiApi.getText("ui.config.other.version",_loc2_ == 2?uiApi.getText("ui.config.old.air"):uiApi.getText("ui.config.new.air"));
         this.btn_lbl_btnUseOther.text = uiApi.getText(!!sysApi.isAirVersionAvailable(_loc2_ == 1?uint(2):uint(1))?"ui.common.use.something":"ui.common.install.something",_loc2_ == 2?uiApi.getText("ui.config.old.air"):uiApi.getText("ui.config.new.air"));
         uiApi.addComponentHook(this.btnUseOther,ComponentHookList.ON_RELEASE);
         showDefaultBtn(false);
      }
      
      override public function onRelease(param1:Object) : void
      {
         var _loc2_:uint = sysApi.getAirVersion() == 1?uint(2):uint(1);
         if(!sysApi.isAirVersionAvailable(_loc2_))
         {
            if(_loc2_ == 1)
            {
               switch(sysApi.getOs())
               {
                  case "Windows":
                     sysApi.goToUrl("http://dl.ak.ankama.com/games/dofus2/adobe/AdobeAIRInstaller_1_5.exe");
                     break;
                  case "Mac OS":
                     sysApi.goToUrl("http://dl.ak.ankama.com/games/dofus2/adobe/AdobeAIRInstaller_1_5.dmg");
                     break;
                  case "Linux":
                     sysApi.goToUrl("http://dl.ak.ankama.com/games/dofus2/adobe/AdobeAIRInstaller_1_5.bin");
               }
            }
            else
            {
               sysApi.goToUrl("http://get.adobe.com/fr/air/");
            }
         }
         else
         {
            sysApi.setAirVersion(_loc2_);
            this.modCommon.openPopup(uiApi.getText("ui.popup.warning"),uiApi.getText("ui.option.needReset"),[uiApi.getText("ui.common.ok"),uiApi.getText("ui.common.cancel")],[this.onReset,this.onCancel],this.onReset,this.onCancel);
         }
      }
      
      private function onReset() : void
      {
         sysApi.reset();
      }
      
      private function onCancel() : void
      {
      }
   }
}
