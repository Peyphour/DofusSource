package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import d2actions.HavenbagExit;
   
   public class HavenbagUi
   {
       
      
      public var uiApi:UiApi;
      
      public var sysApi:SystemApi;
      
      public var btn_havenbag:ButtonContainer;
      
      public var btn_leave:ButtonContainer;
      
      public function HavenbagUi()
      {
         super();
      }
      
      public function main(param1:Object) : void
      {
      }
      
      public function onRelease(param1:Object) : void
      {
         if(param1 == this.btn_havenbag)
         {
            this.uiApi.getUi("havenbagManager").uiClass.onRelease("btn_havenbag");
         }
         else if(param1 == this.btn_leave)
         {
            this.sysApi.sendAction(new HavenbagExit());
         }
      }
   }
}
