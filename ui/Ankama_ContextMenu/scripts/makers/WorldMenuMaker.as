package makers
{
   import d2actions.ShowAllNames;
   
   public class WorldMenuMaker
   {
      
      public static var disabled:Boolean = false;
       
      
      public function WorldMenuMaker()
      {
         super();
      }
      
      private function onQualityChange(param1:uint) : void
      {
         Api.config.setConfigProperty("dofus","flashQuality",param1);
         Api.config.setConfigProperty("dofus","dofusQuality",3);
      }
      
      private function onZoom(param1:Boolean) : void
      {
         Api.system.mouseZoom(param1);
      }
      
      private function onResetZoom() : void
      {
         Api.system.resetZoom();
      }
      
      private function onDisplayGridChange(param1:Boolean) : void
      {
         this.switchOption("atouin","alwaysShowGrid");
      }
      
      private function onTransparentOverlayModeChange(param1:Boolean) : void
      {
         this.switchOption("atouin","transparentOverlayMode");
      }
      
      private function onMapInfoChange(param1:Boolean) : void
      {
         this.switchOption("dofus","mapCoordinates");
      }
      
      private function onShowPlayersNames(param1:Boolean) : void
      {
         ContextMenu.getInstance().playersNamesVisible = param1;
         Api.system.sendAction(new ShowAllNames());
      }
      
      public function createMenu(param1:*, param2:Object) : Array
      {
         var _loc3_:Array = new Array();
         _loc3_.push(ContextMenu.static_createContextMenuItemObject(Api.ui.getText("ui.common.zoom") + " +",this.onZoom,[true],Api.system.getMaxZoom() == Api.system.getCurrentZoom() || disabled));
         _loc3_.push(ContextMenu.static_createContextMenuItemObject(Api.ui.getText("ui.common.zoom") + " -",this.onZoom,[false],Api.system.getCurrentZoom() == 1 || disabled));
         _loc3_.push(ContextMenu.static_createContextMenuItemObject(Api.ui.getText("ui.common.zoom") + " 100%",this.onResetZoom,null,Api.system.getCurrentZoom() == 1 || disabled));
         _loc3_.push(ContextMenu.static_createContextMenuSeparatorObject());
         var _loc4_:Array = new Array();
         _loc3_.push(ContextMenu.static_createContextMenuItemObject(Api.ui.getText("ui.option.flashQuality"),null,null,!Api.system.setQualityIsEnable() || disabled,_loc4_));
         var _loc5_:uint = Api.config.getConfigProperty("dofus","flashQuality");
         _loc4_.push(ContextMenu.static_createContextMenuItemObject(Api.ui.getText("ui.option.quality.low"),this.onQualityChange,[0],false,null,_loc5_ == 0,true));
         _loc4_.push(ContextMenu.static_createContextMenuItemObject(Api.ui.getText("ui.option.quality.medium"),this.onQualityChange,[1],false,null,_loc5_ == 1,true));
         _loc4_.push(ContextMenu.static_createContextMenuItemObject(Api.ui.getText("ui.option.quality.high"),this.onQualityChange,[2],false,null,_loc5_ == 2,true));
         _loc4_ = new Array();
         _loc3_.push(ContextMenu.static_createContextMenuItemObject(Api.ui.getText("ui.option.general"),null,null,disabled,_loc4_));
         _loc4_.push(this.createItemOption(Api.ui.getText("ui.option.displayGrid"),this.onDisplayGridChange,Api.system.getOption("alwaysShowGrid","atouin"),"showGrid"));
         _loc4_.push(this.createItemOption(Api.ui.getText("ui.option.transparentOverlayMode"),this.onTransparentOverlayModeChange,Api.system.getOption("transparentOverlayMode","atouin"),"transparancyMode"));
         _loc4_.push(this.createItemOption(Api.ui.getText("ui.option.mapInfo"),this.onMapInfoChange,Api.system.getOption("mapCoordinates","dofus"),"showCoord"));
         _loc4_.push(this.createItemOption(Api.ui.getText("ui.shortcuts.displayNames"),this.onShowPlayersNames,ContextMenu.getInstance().playersNamesVisible,"showAllNames"));
         return _loc3_;
      }
      
      protected function switchOption(param1:String, param2:String) : void
      {
         Api.config.setConfigProperty(param1,param2,!Api.system.getOption(param2,param1));
      }
      
      protected function createItemOption(param1:String, param2:Function, param3:Boolean, param4:String = null) : Object
      {
         var _loc6_:String = null;
         var _loc5_:String = param1;
         if(param4)
         {
            _loc6_ = Api.binds.getShortcutBindStr(param4);
            if(_loc6_)
            {
               _loc5_ = _loc5_ + (" (" + _loc6_ + ")");
            }
         }
         return ContextMenu.static_createContextMenuItemObject(_loc5_,param2,[!param3],false,null,param3,false);
      }
   }
}
