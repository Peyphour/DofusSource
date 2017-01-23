package ui
{
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import d2enums.ComponentHookList;
   import types.ConfigProperty;
   
   public class ConfigSupport extends ConfigUi
   {
       
      
      public var btnGotoSupport:ButtonContainer;
      
      public var btnBugReport:ButtonContainer;
      
      public var btn_allowLog:ButtonContainer;
      
      public var btn_allowDebug:ButtonContainer;
      
      public var lbl_infoDebug:Label;
      
      public function ConfigSupport()
      {
         super();
      }
      
      public function main(param1:*) : void
      {
         uiApi.addComponentHook(this.btnGotoSupport,ComponentHookList.ON_RELEASE);
         if(sysApi.getCurrentLanguage() == "fr")
         {
            uiApi.addComponentHook(this.btnBugReport,ComponentHookList.ON_RELEASE);
         }
         else
         {
            this.btnBugReport.disabled = true;
         }
         var _loc2_:Array = new Array();
         _loc2_.push(new ConfigProperty("btn_allowLog","allowLog","dofus"));
         _loc2_.push(new ConfigProperty("btn_allowDebug","allowDebug","dofus"));
         init(_loc2_);
         showDefaultBtn(false);
         var _loc3_:String = sysApi.getOs();
         var _loc4_:String = _loc3_ == "Mac OS"?"F1":"F11";
         var _loc5_:Boolean = configApi.getDebugMode();
         this.lbl_infoDebug.text = uiApi.getText("ui.option.debugMode.info",_loc4_);
         setProperty("dofus","allowDebug",_loc5_);
         this.btn_allowDebug.selected = _loc5_;
         uiApi.addComponentHook(this.btn_allowDebug,ComponentHookList.ON_RELEASE);
         if(configApi.debugFileExists())
         {
            this.btn_allowDebug.softDisabled = true;
            uiApi.addComponentHook(this.btn_allowDebug,ComponentHookList.ON_ROLL_OVER);
            uiApi.addComponentHook(this.btn_allowDebug,ComponentHookList.ON_ROLL_OUT);
         }
      }
      
      override public function onRelease(param1:Object) : void
      {
         switch(param1)
         {
            case this.btnGotoSupport:
               sysApi.goToUrl(uiApi.getText("ui.link.support"));
               break;
            case this.btnBugReport:
               sysApi.goToUrl(uiApi.getText("ui.link.betaReport"));
               break;
            case this.btn_allowDebug:
               configApi.setConfigProperty("dofus","allowDebug",this.btn_allowDebug.selected);
               configApi.setDebugMode(this.btn_allowDebug.selected);
         }
      }
      
      public function onRollOver(param1:Object) : void
      {
         uiApi.showTooltip(uiApi.textTooltipInfo(uiApi.getText("ui.option.debugMode.hasFile")),param1,false,"standard",5,3,3,null,null,null,"TextInfo");
      }
      
      public function onRollOut(param1:Object) : void
      {
         uiApi.hideTooltip();
      }
   }
}
