package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Grid;
   import com.ankamagames.dofus.uiApi.UtilApi;
   import d2enums.ComponentHookList;
   import d2enums.LocationEnum;
   import d2enums.StatesEnum;
   
   public class HavenbagFurnituresTypes
   {
       
      
      public var uiApi:UiApi;
      
      public var utilApi:UtilApi;
      
      public var gd_categories:Grid;
      
      public function HavenbagFurnituresTypes()
      {
         super();
      }
      
      public function main(param1:Object) : void
      {
         var _loc2_:Array = new Array();
         _loc2_.push({
            "text":this.uiApi.getText("ui.havenbag.layer.floors"),
            "uri":this.utilApi.getGfxUri(270)
         });
         _loc2_.push({
            "text":this.uiApi.getText("ui.havenbag.layer.supports"),
            "uri":this.utilApi.getGfxUri(3753)
         });
         _loc2_.push({
            "text":this.uiApi.getText("ui.havenbag.layer.objects"),
            "uri":this.utilApi.getGfxUri(32816)
         });
         this.gd_categories.dataProvider = _loc2_;
      }
      
      public function updateCategory(param1:*, param2:*, param3:Boolean) : void
      {
         this.uiApi.addComponentHook(param2.tx_category,ComponentHookList.ON_TEXTURE_READY);
         param2.tx_category.dispatchMessages = true;
         param2.tx_category.uri = this.uiApi.createUri(param1.uri);
         if(param2.btn_slot.state == StatesEnum.STATE_NORMAL && param3)
         {
            param2.btn_slot.selected = true;
         }
      }
      
      public function onTextureReady(param1:Object) : void
      {
         var _loc2_:int = parseInt(this.uiApi.me().getConstant("categoryIconWidth"));
         if(param1.width > _loc2_)
         {
            param1.height = _loc2_ / (param1.width / param1.height);
            param1.width = _loc2_;
         }
         param1.x = param1.width + (this.gd_categories.slotWidth / 2 - param1.width / 2);
         param1.y = this.gd_categories.slotHeight / 2 - param1.height / 2;
      }
      
      public function onSelectItem(param1:Object, param2:uint, param3:Boolean) : void
      {
         this.uiApi.getUi("havenbagManager").uiClass.selectFurnitureType(this.gd_categories.selectedIndex);
      }
      
      public function onItemRollOver(param1:Object, param2:Object) : void
      {
         this.uiApi.showTooltip(this.uiApi.textTooltipInfo(param2.data.text),param2.container,false,"standard",LocationEnum.POINT_LEFT,LocationEnum.POINT_RIGHT);
      }
      
      public function onItemRollOut(param1:Object, param2:Object) : void
      {
         this.uiApi.hideTooltip();
      }
   }
}
