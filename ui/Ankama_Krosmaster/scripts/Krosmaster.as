package
{
   import d2api.ConfigApi;
   import d2api.DataApi;
   import d2api.SystemApi;
   import d2api.UiApi;
   import d2data.OptionalFeature;
   import d2enums.StrataEnum;
   import d2hooks.OpenKrosmaster;
   import flash.display.Sprite;
   
   public class Krosmaster extends Sprite
   {
       
      
      public var uiApi:UiApi;
      
      public var dataApi:DataApi;
      
      public var configApi:ConfigApi;
      
      public var sysApi:SystemApi;
      
      public function Krosmaster()
      {
         super();
      }
      
      public function main() : void
      {
         if(this.sysApi.isStreaming())
         {
            return;
         }
         this.sysApi.addHook(OpenKrosmaster,this.openArena);
      }
      
      public function openArena() : void
      {
         var _loc1_:OptionalFeature = this.dataApi.getOptionalFeatureByKeyword("game.krosmaster");
         if(this.configApi.isOptionalFeatureActive(_loc1_.id) && this.uiApi.getUi("ArenaGameUi") == null)
         {
            this.uiApi.loadUi("ArenaGameUi","ArenaGameUi",[true],StrataEnum.STRATA_HIGH);
         }
      }
   }
}
