package ui
{
   public class Decraft extends Craft
   {
       
      
      public function Decraft()
      {
         super();
      }
      
      override public function main(param1:Object) : void
      {
         showRecipes = false;
         btn_lbl_btn_ok.text = uiApi.getText("ui.common.decraft");
         super.main(param1);
      }
      
      override public function onRelease(param1:Object) : void
      {
         switch(param1)
         {
            case btn_ok:
               modCommon.openPopup(uiApi.getText("ui.popup.warning"),uiApi.getText("ui.craft.decraftConfirm"),[uiApi.getText("ui.common.yes"),uiApi.getText("ui.common.no")],[onConfirmCraftRecipe,onCancelCraftRecipe],onConfirmCraftRecipe,onCancelCraftRecipe);
               break;
            default:
               super.onRelease(param1);
         }
      }
   }
}
