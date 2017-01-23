package
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import d2enums.TeleporterTypeEnum;
   import d2hooks.TeleportDestinationList;
   import flash.display.Sprite;
   import ui.ZaapSelection;
   import ui.ZaapiSelection;
   
   public class Taxi extends Sprite
   {
       
      
      protected var zaapSelection:ZaapSelection;
      
      protected var zaapiSelection:ZaapiSelection;
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      public function Taxi()
      {
         super();
      }
      
      public function main() : void
      {
         this.sysApi.addHook(TeleportDestinationList,this.onTeleportDestinationList);
      }
      
      private function onTeleportDestinationList(param1:Object, param2:uint) : void
      {
         if(param2 == TeleporterTypeEnum.TELEPORTER_SUBWAY)
         {
            this.uiApi.loadUi("zaapiSelection","zaapiSelection",[param1,param2]);
         }
         else if(!this.uiApi.getUi("zaapSelection"))
         {
            this.uiApi.loadUi("zaapSelection","zaapSelection",[param1,param2]);
         }
      }
   }
}
