package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.ComboBox;
   import com.ankamagames.berilia.components.Grid;
   import com.ankamagames.berilia.components.Input;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.Slot;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import com.ankamagames.dofus.uiApi.ContextMenuApi;
   import com.ankamagames.dofus.uiApi.InventoryApi;
   import com.ankamagames.dofus.uiApi.JobsApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofus.uiApi.UtilApi;
   import d2enums.LocationEnum;
   import d2hooks.KeyUp;
   
   public class ItemRecipes
   {
      
      private static var uriMissingIngredients:Object;
      
      private static var uriNoIngredients:Object;
      
      private static var uriMissingIngredientsSlot:Object;
      
      private static var uriNoIngredientsSlot:Object;
       
      
      [Module(name="Ankama_ContextMenu")]
      public var modContextMenu:Object;
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      [Module(name="Ankama_Common")]
      public var modCommon:Object;
      
      public var jobsApi:JobsApi;
      
      public var menuApi:ContextMenuApi;
      
      public var inventoryApi:InventoryApi;
      
      public var utilApi:UtilApi;
      
      private var _item:Object;
      
      private var _recipesList:Array;
      
      private var _filterType:int = -1;
      
      public var gd_recipes:Grid;
      
      public var cb_filter:ComboBox;
      
      public var ctr_search:GraphicContainer;
      
      public var ctr_useItem:GraphicContainer;
      
      public var btn_close:ButtonContainer;
      
      public var btn_closeSearch:ButtonContainer;
      
      public var lbl_input:Input;
      
      public var lbl_noRecipe:Label;
      
      public var lbl_title:Label;
      
      public var lbl_noRecipesWithItem:Label;
      
      public var slot_0:Slot;
      
      public var slot_1:Slot;
      
      public var slot_2:Slot;
      
      public var slot_3:Slot;
      
      public var slot_4:Slot;
      
      public var slot_5:Slot;
      
      public var slot_6:Slot;
      
      public var slot_7:Slot;
      
      public var tx_ingredientStateIcon0:Texture;
      
      public var tx_ingredientStateIcon1:Texture;
      
      public var tx_ingredientStateIcon2:Texture;
      
      public var tx_ingredientStateIcon3:Texture;
      
      public var tx_ingredientStateIcon4:Texture;
      
      public var tx_ingredientStateIcon5:Texture;
      
      public var tx_ingredientStateIcon6:Texture;
      
      public var tx_ingredientStateIcon7:Texture;
      
      public var slotItem:Slot;
      
      public var lbl_item_name:Label;
      
      public var lbl_item_level:Label;
      
      public function ItemRecipes()
      {
         super();
      }
      
      public function main(param1:Object) : void
      {
         var _loc4_:String = null;
         var _loc5_:Object = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         var _loc10_:Object = null;
         var _loc11_:Object = null;
         if(!uriMissingIngredients)
         {
            _loc4_ = this.uiApi.me().getConstant("assets");
            uriMissingIngredients = this.uiApi.createUri(_loc4_ + "tx_coloredWarning");
            uriNoIngredients = this.uiApi.createUri(_loc4_ + "tx_coloredCross");
            _loc4_ = this.uiApi.me().getConstant("slotTexture");
            uriMissingIngredientsSlot = this.uiApi.createUri(_loc4_ + "warningSlot.png");
            uriNoIngredientsSlot = this.uiApi.createUri(_loc4_ + "refuseDrop.png");
         }
         this.uiApi.addShortcutHook("closeUi",this.onShortcut);
         this._item = param1.item;
         this.showItem(param1.item);
         var _loc2_:Object = this.jobsApi.getRecipe(this._item.objectGID);
         if(_loc2_)
         {
            _loc5_ = _loc2_.ingredients;
            _loc6_ = _loc5_.length;
            _loc7_ = 0;
            while(_loc7_ < _loc6_)
            {
               this.uiApi.addComponentHook(this["slot_" + _loc7_],"onRollOver");
               this.uiApi.addComponentHook(this["slot_" + _loc7_],"onRollOut");
               this.uiApi.addComponentHook(this["slot_" + _loc7_],"onRightClick");
               this.uiApi.addComponentHook(this["slot_" + _loc7_],"onRelease");
               this.uiApi.addComponentHook(this["tx_ingredientStateIcon" + _loc7_],"onRollOver");
               this.uiApi.addComponentHook(this["tx_ingredientStateIcon" + _loc7_],"onRollOut");
               _loc8_ = this.inventoryApi.getItemQty(_loc5_[_loc7_].id);
               _loc9_ = _loc5_[_loc7_].quantity;
               _loc10_ = null;
               _loc11_ = null;
               if(_loc8_ == 0)
               {
                  _loc10_ = this.uiApi.createUri(this.uiApi.me().getConstant("slotTexture") + "refuseDrop.png");
                  _loc11_ = this.uiApi.createUri(this.uiApi.me().getConstant("assets") + "tx_coloredCross");
               }
               else if(_loc8_ < _loc9_)
               {
                  _loc10_ = uriMissingIngredientsSlot;
                  _loc11_ = uriMissingIngredients;
               }
               this["slot_" + _loc7_].data = _loc5_[_loc7_];
               this["slot_" + _loc7_].visible = true;
               this["slot_" + _loc7_].customTexture = _loc10_;
               this["slot_" + _loc7_].selectedTexture = _loc10_;
               this["slot_" + _loc7_].highlightTexture = _loc10_;
               this["tx_ingredientStateIcon" + _loc7_].uri = _loc11_;
               _loc7_++;
            }
            this.hideSlots(_loc7_);
         }
         else
         {
            this.hideSlots(0);
            if(this._item.secretRecipe)
            {
               this.lbl_noRecipe.text = this.uiApi.getText("ui.item.secretReceipt");
            }
            else
            {
               this.lbl_noRecipe.text = this.uiApi.getText("ui.item.utilityNoReceipt");
            }
            this.lbl_noRecipe.visible = true;
         }
         this.getRecipes();
         var _loc3_:Array = this.filteredRecipes();
         if(_loc3_.length == 0)
         {
            this.ctr_useItem.visible = false;
            this.lbl_noRecipesWithItem.visible = true;
         }
         else
         {
            this.lbl_noRecipesWithItem.visible = false;
            this.gd_recipes.dataProvider = _loc3_;
            this.ctr_useItem.visible = true;
         }
         this.uiApi.addComponentHook(this.btn_closeSearch,"onRelease");
         this.uiApi.addComponentHook(this.btn_close,"onRelease");
         this.uiApi.addComponentHook(this.cb_filter,"onSelectItem");
         this.sysApi.addHook(KeyUp,this.onKeyUp);
      }
      
      public function unload() : void
      {
      }
      
      private function hideSlots(param1:uint) : void
      {
         var _loc2_:int = 0;
         _loc2_ = param1;
         while(_loc2_ < 8)
         {
            this["slot_" + _loc2_].data = null;
            this["slot_" + _loc2_].visible = false;
            this["slot_" + _loc2_].customTexture = null;
            this["slot_" + _loc2_].selectedTexture = null;
            this["slot_" + _loc2_].highlightTexture = null;
            this["tx_ingredientStateIcon" + _loc2_].uri = null;
            _loc2_++;
         }
      }
      
      private function getRecipes() : void
      {
         var _loc8_:Object = null;
         var _loc9_:Object = null;
         var _loc10_:Object = null;
         this._recipesList = new Array();
         var _loc1_:Array = new Array();
         var _loc2_:Object = this.jobsApi.getRecipesList(this._item.objectGID);
         var _loc3_:int = _loc2_.length;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc8_ = _loc2_[_loc4_];
            _loc9_ = _loc8_.result;
            this._recipesList.push(_loc8_);
            if(_loc1_.indexOf(_loc9_.type.id) == -1)
            {
               _loc1_.push(_loc9_.type,_loc9_.type.id);
            }
            _loc4_++;
         }
         var _loc5_:Array = new Array();
         var _loc6_:int = _loc1_.length;
         var _loc7_:int = 0;
         while(_loc7_ < _loc6_)
         {
            _loc10_ = _loc1_[_loc7_];
            _loc5_.push({
               "label":_loc10_.name,
               "filterType":_loc10_.id
            });
            _loc7_ = _loc7_ + 2;
         }
         this.utilApi.sortOnString(_loc5_,"label");
         _loc5_.unshift({
            "label":this.uiApi.getText("ui.common.allTypesForObject"),
            "filterType":-1
         });
         this.cb_filter.dataProvider = _loc5_;
      }
      
      private function filteredRecipes() : Array
      {
         var _loc6_:Object = null;
         var _loc7_:Object = null;
         var _loc1_:Array = new Array();
         var _loc2_:String = this.lbl_input.text.toLowerCase();
         var _loc3_:* = _loc2_ != "";
         var _loc4_:int = this._recipesList.length;
         var _loc5_:int = 0;
         for(; _loc5_ < _loc4_; _loc5_++)
         {
            _loc6_ = this._recipesList[_loc5_];
            _loc7_ = _loc6_.result;
            if(_loc3_)
            {
               if(_loc7_.undiatricalName.indexOf(this.utilApi.noAccent(_loc2_)) == -1)
               {
                  continue;
               }
            }
            if(this._filterType != -1)
            {
               if(_loc7_.type.id != this._filterType)
               {
                  continue;
               }
            }
            _loc1_.push(_loc6_);
         }
         return _loc1_;
      }
      
      private function showItem(param1:ItemWrapper) : void
      {
         this.lbl_item_name.cssClass = "whitebold";
         if(param1.etheral)
         {
            this.lbl_item_name.cssClass = "itemetheral";
         }
         if(param1.itemSetId != -1)
         {
            this.lbl_item_name.cssClass = "itemset";
         }
         this.lbl_item_name.text = param1.name;
         if(this.sysApi.getPlayerManager().hasRights)
         {
            this.lbl_item_name.text = this.lbl_item_name.text + (" (" + param1.id + ")");
         }
         this.lbl_item_level.text = this.uiApi.getText("ui.common.short.level") + " " + param1.level;
         this.slotItem.data = param1;
      }
      
      public function onRollOver(param1:Object) : void
      {
         var _loc2_:String = null;
         switch(param1)
         {
            case this.slot_0:
            case this.slot_1:
            case this.slot_2:
            case this.slot_3:
            case this.slot_4:
            case this.slot_5:
            case this.slot_6:
            case this.slot_7:
               if(param1.data)
               {
                  this.uiApi.showTooltip(param1.data,param1,false,"standard",8,0,0,"itemName",null,{
                     "showEffects":true,
                     "header":true
                  },"ItemInfo");
               }
               break;
            case this.tx_ingredientStateIcon0:
            case this.tx_ingredientStateIcon1:
            case this.tx_ingredientStateIcon2:
            case this.tx_ingredientStateIcon3:
            case this.tx_ingredientStateIcon4:
            case this.tx_ingredientStateIcon5:
            case this.tx_ingredientStateIcon6:
            case this.tx_ingredientStateIcon7:
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
            case this.slotItem:
               this.uiApi.showTooltip(this._item,param1,false,"standard",8,0,0,"itemName",null,{
                  "showEffects":false,
                  "header":true
               },"ItemInfo");
         }
      }
      
      public function onRollOut(param1:Object) : void
      {
         this.uiApi.hideTooltip();
      }
      
      public function onRelease(param1:Object) : void
      {
         if(param1 == this.btn_close)
         {
            this.uiApi.unloadUi(this.uiApi.me().name);
         }
         else if(param1 == this.btn_closeSearch)
         {
            this.lbl_input.text = "";
            this.gd_recipes.dataProvider = this.filteredRecipes();
         }
      }
      
      public function onSelectItem(param1:Object, param2:uint, param3:Boolean) : void
      {
         if(param1 == this.cb_filter)
         {
            if(param3 && param2 != 2)
            {
               this._filterType = this.cb_filter.value.filterType;
               this.gd_recipes.dataProvider = this.filteredRecipes();
            }
         }
      }
      
      public function onKeyUp(param1:Object, param2:uint) : void
      {
         if(this.ctr_search.visible && this.lbl_input.haveFocus)
         {
            this.gd_recipes.dataProvider = this.filteredRecipes();
         }
      }
      
      public function onShortcut(param1:String) : Boolean
      {
         switch(param1)
         {
            case "closeUi":
               this.uiApi.unloadUi(this.uiApi.me().name);
               return true;
            default:
               return false;
         }
      }
      
      public function onRightClick(param1:Object) : void
      {
         var _loc3_:Object = null;
         var _loc2_:Object = param1.data;
         if(_loc2_)
         {
            _loc3_ = this.menuApi.create(_loc2_);
            if(_loc3_.content.length > 0)
            {
               this.modContextMenu.createContextMenu(_loc3_);
            }
         }
      }
   }
}
