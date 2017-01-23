package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import d2actions.ChangeCharacter;
   
   public class HardcoreDeath
   {
       
      
      public var uiApi:UiApi;
      
      public var sysApi:SystemApi;
      
      public var btn_close:ButtonContainer;
      
      public var btn_yes:ButtonContainer;
      
      public function HardcoreDeath()
      {
         super();
      }
      
      public function main(param1:Object) : void
      {
      }
      
      public function onRelease(param1:Object) : void
      {
         switch(param1)
         {
            case this.btn_yes:
               this.sysApi.sendAction(new ChangeCharacter(this.sysApi.getCurrentServer().id));
               break;
            case this.btn_close:
               this.uiApi.unloadUi(this.uiApi.me().name);
         }
      }
      
      public function onShortcut(param1:String) : Boolean
      {
         return true;
      }
   }
}
