package ui.items
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.Slot;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.internalDatacenter.jobs.KnownJobWrapper;
   import com.ankamagames.dofus.uiApi.ContextMenuApi;
   import com.ankamagames.dofus.uiApi.InventoryApi;
   import com.ankamagames.dofus.uiApi.JobsApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import d2enums.LocationEnum;
   
   public class RecipeItem
   {
      
      private static var uriMissingIngredients:Object;
      
      private static var uriNoIngredients:Object;
      
      private static var uriMissingIngredientsSlot:Object;
      
      private static var uriNoIngredientsSlot:Object;
       
      
      public var output:Object;
      
      [Module(name="Ankama_ContextMenu")]
      public var modContextMenu:Object;
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      public var jobApi:JobsApi;
      
      public var menuApi:ContextMenuApi;
      
      public var inventoryApi:InventoryApi;
      
      private var _grid:Object;
      
      private var _data;
      
      private var _selected:Boolean;
      
      public var tx_slot_background:Texture;
      
      public var slotCraftedItem:Slot;
      
      public var slot1:Slot;
      
      public var slot2:Slot;
      
      public var slot3:Slot;
      
      public var slot4:Slot;
      
      public var slot5:Slot;
      
      public var slot6:Slot;
      
      public var slot7:Slot;
      
      public var slot8:Slot;
      
      public var tx_ingredientStateIcon1:Texture;
      
      public var tx_ingredientStateIcon2:Texture;
      
      public var tx_ingredientStateIcon3:Texture;
      
      public var tx_ingredientStateIcon4:Texture;
      
      public var tx_ingredientStateIcon5:Texture;
      
      public var tx_ingredientStateIcon6:Texture;
      
      public var tx_ingredientStateIcon7:Texture;
      
      public var tx_ingredientStateIcon8:Texture;
      
      public var lblLevel:Label;
      
      public var lblJob:Label;
      
      public var lblName:Label;
      
      public var mainCtr:GraphicContainer;
      
      public function RecipeItem()
      {
         super();
      }
      
      public function main(param1:Object = null) : void
      {
         var _loc3_:String = null;
         if(!uriMissingIngredients)
         {
            _loc3_ = this.uiApi.me().getConstant("assets");
            uriMissingIngredients = this.uiApi.createUri(_loc3_ + "tx_coloredWarning");
            uriNoIngredients = this.uiApi.createUri(_loc3_ + "tx_coloredCross");
            _loc3_ = this.uiApi.me().getConstant("slotTexture");
            uriMissingIngredientsSlot = this.uiApi.createUri(_loc3_ + "warningSlot.png");
            uriNoIngredientsSlot = this.uiApi.createUri(_loc3_ + "refuseDrop.png");
         }
         this._grid = param1.grid;
         this._data = param1.data;
         this._selected = param1.selected;
         var _loc2_:uint = 1;
         while(_loc2_ < 9)
         {
            this.uiApi.addComponentHook(this["slot" + _loc2_],"onRollOver");
            this.uiApi.addComponentHook(this["slot" + _loc2_],"onRollOut");
            this.uiApi.addComponentHook(this["slot" + _loc2_],"onRightClick");
            this.uiApi.addComponentHook(this["slot" + _loc2_],"onRelease");
            this.uiApi.addComponentHook(this["tx_ingredientStateIcon" + _loc2_],"onRollOver");
            this.uiApi.addComponentHook(this["tx_ingredientStateIcon" + _loc2_],"onRollOut");
            _loc2_++;
         }
         this.uiApi.addComponentHook(this.slotCraftedItem,"onRollOver");
         this.uiApi.addComponentHook(this.slotCraftedItem,"onRollOut");
         this.uiApi.addComponentHook(this.slotCraftedItem,"onRightClick");
         this.update(this._data,this._selected);
      }
      
      public function get data() : *
      {
         return this._data;
      }
      
      public function get selected() : Boolean
      {
         return this._selected;
      }
      
      public function update(param1:*, param2:Boolean) : void
      {
         var _loc3_:KnownJobWrapper = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Object = null;
         var _loc7_:int = 0;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         var _loc10_:Object = null;
         var _loc11_:Object = null;
         if(param1)
         {
            this._data = param1;
            this.lblName.text = this._data.result.name;
            this.lblLevel.text = this.uiApi.getText("ui.common.short.level") + " " + this._data.result.level.toString();
            _loc3_ = this.jobApi.getKnownJob(this._data.jobId);
            if(_loc3_ && this._data.jobId > 1)
            {
               this.lblJob.text = "(" + _loc3_.name + ")";
            }
            else
            {
               this.lblJob.text = "";
            }
            this.slotCraftedItem.data = this._data.result;
            this.slotCraftedItem.visible = this.tx_slot_background.visible = true;
            _loc4_ = 1;
            _loc6_ = this._data.ingredients;
            _loc7_ = _loc6_.length + 1;
            while(_loc4_ < _loc7_)
            {
               _loc5_ = _loc4_ - 1;
               this["slot" + _loc4_].data = _loc6_[_loc5_];
               _loc8_ = this.inventoryApi.getItemQty(_loc6_[_loc5_].id);
               _loc9_ = _loc6_[_loc5_].quantity;
               _loc10_ = null;
               _loc11_ = null;
               if(_loc8_ == 0)
               {
                  _loc10_ = uriNoIngredientsSlot;
                  _loc11_ = uriNoIngredients;
               }
               else if(_loc8_ < _loc9_)
               {
                  _loc10_ = uriMissingIngredientsSlot;
                  _loc11_ = uriMissingIngredients;
               }
               this["tx_ingredientStateIcon" + _loc4_].uri = _loc11_;
               this["slot" + _loc4_].customTexture = _loc10_;
               this["slot" + _loc4_].selectedTexture = _loc10_;
               this["slot" + _loc4_].highlightTexture = _loc10_;
               this["slot" + _loc4_].visible = true;
               _loc4_++;
            }
            while(_loc4_ < 9)
            {
               this["slot" + _loc4_].data = null;
               this["tx_ingredientStateIcon" + _loc4_].uri = null;
               this["slot" + _loc4_].customTexture = null;
               this["slot" + _loc4_].selectedTexture = null;
               this["slot" + _loc4_].highlightTexture = null;
               this["slot" + _loc4_].visible = false;
               _loc4_++;
            }
         }
         else
         {
            this.slotCraftedItem.data = null;
            this.slotCraftedItem.visible = this.tx_slot_background.visible = false;
            _loc4_ = 1;
            while(_loc4_ < 9)
            {
               this["tx_ingredientStateIcon" + _loc4_].uri = null;
               this["slot" + _loc4_].customTexture = null;
               this["slot" + _loc4_].selectedTexture = null;
               this["slot" + _loc4_].highlightTexture = null;
               this["slot" + _loc4_].data = null;
               this["slot" + _loc4_].visible = false;
               _loc4_++;
            }
            this.lblLevel.text = "";
            this.lblName.text = "";
            this.lblJob.text = "";
            this.mainCtr.softDisabled = false;
         }
      }
      
      public function select(param1:Boolean) : void
      {
      }
      
      public function onRollOver(param1:Object) : void
      {
         var _loc2_:String = null;
         switch(param1)
         {
            case this.slot1:
            case this.slot2:
            case this.slot3:
            case this.slot4:
            case this.slot5:
            case this.slot6:
            case this.slot7:
            case this.slot8:
               if(param1.data)
               {
                  this.uiApi.showTooltip(param1.data,param1,false,"standard",6,2,3,"itemName",null,{
                     "showEffects":true,
                     "header":true
                  },"ItemInfo");
               }
               break;
            case this.tx_ingredientStateIcon1:
            case this.tx_ingredientStateIcon2:
            case this.tx_ingredientStateIcon3:
            case this.tx_ingredientStateIcon4:
            case this.tx_ingredientStateIcon5:
            case this.tx_ingredientStateIcon6:
            case this.tx_ingredientStateIcon7:
            case this.tx_ingredientStateIcon8:
               if(param1.uri)
               {
                  if(param1.uri.fileName == uriNoIngredients.fileName)
                  {
                     _loc2_ = this.uiApi.getText("ui.craft.noIngredient");
                  }
                  else if(param1.uri.fileName == uriMissingIngredients.fileName)
                  {
                     _loc2_ = this.uiApi.getText("ui.craft.ingredientNotEnough");
                  }
                  this.uiApi.showTooltip(this.uiApi.textTooltipInfo(_loc2_),param1,false,"standard",LocationEnum.POINT_TOPLEFT,LocationEnum.POINT_BOTTOMRIGHT,6);
               }
               break;
            case this.slotCraftedItem:
               if(param1.data)
               {
                  this.uiApi.showTooltip(param1.data,param1,false,"standard",8,0,0,"itemName",null,{
                     "showEffects":true,
                     "header":true
                  },"ItemInfo");
               }
         }
      }
      
      public function onRollOut(param1:Object) : void
      {
         this.uiApi.hideTooltip();
      }
      
      public function onRelease(param1:Object) : void
      {
      }
      
      public function onRightClick(param1:Object) : void
      {
         var _loc2_:Object = null;
         if(param1.data)
         {
            _loc2_ = this.menuApi.create(param1.data);
            if(_loc2_.content.length > 0)
            {
               this.modContextMenu.createContextMenu(_loc2_);
            }
         }
      }
   }
}
