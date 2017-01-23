package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.dofus.uiApi.SystemApi;
   
   public class JobLevelUp
   {
       
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      public var btn_close:ButtonContainer;
      
      public var btn_ok:ButtonContainer;
      
      public var lbl_description:Label;
      
      public function JobLevelUp()
      {
         super();
      }
      
      public function main(param1:Object) : void
      {
         this.uiApi.addShortcutHook("validUi",this.onShortcut);
         this.uiApi.addShortcutHook("closeUi",this.onShortcut);
         this.lbl_description.text = this.uiApi.getText("ui.craft.newJobLevel",param1.jobName,param1.newLevel);
      }
      
      public function unload() : void
      {
      }
      
      public function onRelease(param1:Object) : void
      {
         switch(param1)
         {
            case this.btn_close:
            case this.btn_ok:
               this.uiApi.unloadUi(this.uiApi.me().name);
         }
      }
      
      public function onJobLevelUp(param1:uint, param2:String, param3:uint) : void
      {
         this.lbl_description.text = this.uiApi.getText("ui.craft.newJobLevel",param2,param3);
      }
      
      public function onShortcut(param1:String) : Boolean
      {
         switch(param1)
         {
            case "validUi":
            case "closeUi":
               this.uiApi.unloadUi(this.uiApi.me().name);
               return true;
            default:
               return false;
         }
      }
   }
}
