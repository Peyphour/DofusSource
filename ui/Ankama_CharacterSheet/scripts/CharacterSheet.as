package
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.dofus.uiApi.PlayedCharacterApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofusModuleLibrary.enum.interfaces.UIEnum;
   import d2hooks.OpenStats;
   import flash.display.Sprite;
   import ui.CharacterSheetUi;
   import ui.StatBoost;
   
   public class CharacterSheet extends Sprite
   {
      
      private static var _self:CharacterSheet;
       
      
      protected var characterSheetUi:CharacterSheetUi;
      
      protected var statBoost:StatBoost;
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      public var playerApi:PlayedCharacterApi;
      
      public var statPointsBoostType:int = 0;
      
      public function CharacterSheet()
      {
         super();
      }
      
      public static function getInstance() : CharacterSheet
      {
         return _self;
      }
      
      public function main() : void
      {
         this.sysApi.addHook(OpenStats,this.onCharacterSheetOpen);
         _self = this;
      }
      
      public function destroy() : void
      {
         _self = null;
      }
      
      protected function onCharacterSheetOpen(param1:Object) : void
      {
         if(!this.uiApi.getUi(UIEnum.CHARACTER_SHEET_UI))
         {
            if(!this.playerApi.characteristics())
            {
               return;
            }
            if(this.uiApi.getUi(UIEnum.GRIMOIRE))
            {
               this.uiApi.unloadUi(UIEnum.GRIMOIRE);
            }
            this.uiApi.loadUi(UIEnum.CHARACTER_SHEET_UI,UIEnum.CHARACTER_SHEET_UI,{"inventory":param1},1);
         }
         else
         {
            this.uiApi.unloadUi(UIEnum.CHARACTER_SHEET_UI);
         }
      }
   }
}
