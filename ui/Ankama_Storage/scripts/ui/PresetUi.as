package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Grid;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import com.ankamagames.dofus.internalDatacenter.items.MountWrapper;
   import com.ankamagames.dofus.internalDatacenter.items.PresetWrapper;
   import com.ankamagames.dofus.internalDatacenter.items.SimpleTextureWrapper;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.InventoryApi;
   import com.ankamagames.dofus.uiApi.PlayedCharacterApi;
   import com.ankamagames.dofus.uiApi.StorageApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofusModuleLibrary.enum.components.GridItemSelectMethodEnum;
   import com.ankamagames.dofusModuleLibrary.enum.interfaces.UIEnum;
   import com.ankamagames.dofusModuleLibrary.enum.interfaces.tooltip.LocationEnum;
   import d2actions.InventoryPresetDelete;
   import d2actions.InventoryPresetSave;
   import d2actions.InventoryPresetSaveCustom;
   import d2actions.InventoryPresetUse;
   import d2enums.ComponentHookList;
   import d2enums.ProtocolConstantsEnum;
   import d2hooks.ObjectSelected;
   import d2hooks.PresetError;
   import d2hooks.PresetSelected;
   import d2hooks.PresetsUpdate;
   import flash.utils.Dictionary;
   
   public class PresetUi
   {
       
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      public var inventoryApi:InventoryApi;
      
      public var dataApi:DataApi;
      
      public var playerApi:PlayedCharacterApi;
      
      [Module(name="Ankama_Common")]
      public var modCommon:Object;
      
      public var storageApi:StorageApi;
      
      private var _maxPresetCount:int;
      
      private var _currentPreset:PresetWrapper;
      
      private var _presets:Array;
      
      private var _currentIndex:int = -1;
      
      private var _newItems:Boolean;
      
      private var _itemsAltered:Boolean;
      
      private var _popupName:String;
      
      private var _itemToDeleteIndex:int = -1;
      
      private var _componentsList:Dictionary;
      
      public var ctr_bottom:GraphicContainer;
      
      public var gd_presets:Grid;
      
      public var gd_items:Grid;
      
      public var gd_icons:Grid;
      
      public var btn_save:ButtonContainer;
      
      public var btn_new:ButtonContainer;
      
      public var btn_delete:ButtonContainer;
      
      public var btn_update:ButtonContainer;
      
      public var lbl_title:Label;
      
      public var lbl_explanation:Label;
      
      public var btn_lbl_btn_save:Label;
      
      public function PresetUi()
      {
         this._componentsList = new Dictionary(true);
         super();
      }
      
      public function main(param1:Object = null) : void
      {
         var _loc3_:Object = null;
         this.sysApi.addHook(PresetsUpdate,this.onPresetsUpdate);
         this.sysApi.addHook(PresetSelected,this.onPresetSelected);
         this.sysApi.addHook(PresetError,this.onPresetError);
         this.uiApi.addComponentHook(this.btn_save,"onRollOver");
         this.uiApi.addComponentHook(this.btn_save,"onRollOut");
         this.uiApi.addComponentHook(this.btn_delete,"onRollOver");
         this.uiApi.addComponentHook(this.btn_delete,"onRollOut");
         this.uiApi.addComponentHook(this.btn_update,"onRollOver");
         this.uiApi.addComponentHook(this.btn_update,"onRollOut");
         this._maxPresetCount = ProtocolConstantsEnum.MAX_PRESET_COUNT;
         this.gd_presets.renderer.dropValidatorFunction = this.dropValidatorFunction;
         this.gd_presets.renderer.processDropFunction = this.processDrop;
         this.gd_presets.renderer.removeDropSourceFunction = this.removeDropSourceFunction;
         this.onPresetsUpdate();
         this.displayPreset(-2);
         var _loc2_:Array = new Array();
         for each(_loc3_ in this.dataApi.getPresetIcons())
         {
            _loc2_.push(_loc3_);
         }
         this.gd_icons.dataProvider = _loc2_;
      }
      
      public function unload() : void
      {
         this.uiApi.unloadUi(this._popupName);
      }
      
      private function displayPreset(param1:int = -2) : void
      {
         var _loc2_:int = 0;
         if(param1 == -2)
         {
            this.ctr_bottom.visible = false;
            this.lbl_explanation.visible = true;
            this._currentPreset = null;
            this._newItems = true;
            this.gd_presets.selectedIndex = -1;
         }
         else
         {
            this.ctr_bottom.visible = true;
            this.lbl_explanation.visible = false;
            if(param1 == -1)
            {
               this._currentPreset = null;
               this._newItems = true;
               this.fillItemsGrid(this.getEquipment());
               this.btn_delete.visible = false;
               this.btn_update.visible = false;
               this.btn_save.disabled = false;
               this.lbl_title.text = this.uiApi.getText("ui.preset.new");
               this.btn_lbl_btn_save.text = this.uiApi.getText("ui.charcrea.create");
               this.gd_icons.selectedIndex = 0;
               this.gd_presets.selectedIndex = -1;
               if(this.gd_presets.dataProvider.length >= this._maxPresetCount)
               {
                  this.btn_new.disabled = true;
               }
               else
               {
                  this.btn_new.disabled = false;
               }
            }
            else
            {
               this._newItems = false;
               this._currentPreset = this._presets[param1];
               this.fillItemsGrid(this._currentPreset.objects);
               this.btn_delete.visible = true;
               this.btn_update.visible = true;
               this.btn_save.disabled = true;
               this.lbl_title.text = this.uiApi.getText("ui.preset.show");
               this.btn_lbl_btn_save.text = this.uiApi.getText("ui.common.save");
               if(this._currentPreset && this._currentPreset.gfxId > -1 && this.dataApi.getPresetIcon(this._currentPreset.gfxId))
               {
                  _loc2_ = this.dataApi.getPresetIcon(this._currentPreset.gfxId).order;
                  this.gd_icons.selectedIndex = _loc2_;
               }
            }
         }
      }
      
      private function fillItemsGrid(param1:Object) : void
      {
         if(param1 && param1.length)
         {
            this.gd_items.dataProvider = param1;
         }
      }
      
      private function getEquipment() : Array
      {
         var _loc2_:* = undefined;
         var _loc1_:Array = new Array();
         for each(_loc2_ in this.inventoryApi.getEquipementForPreset())
         {
            _loc1_.push(_loc2_);
         }
         return _loc1_;
      }
      
      public function updateItems(param1:*, param2:*, param3:Boolean) : void
      {
         if(!this._componentsList[param2.btn_deleteItem.name])
         {
            this.uiApi.addComponentHook(param2.btn_deleteItem,ComponentHookList.ON_RELEASE);
            this.uiApi.addComponentHook(param2.btn_deleteItem,ComponentHookList.ON_ROLL_OVER);
            this.uiApi.addComponentHook(param2.btn_deleteItem,ComponentHookList.ON_ROLL_OUT);
         }
         this._componentsList[param2.btn_deleteItem.name] = param1;
         if(param1)
         {
            if(param1.iconUri)
            {
               param2.tx_item.uri = param1.iconUri;
            }
            if(param1 is SimpleTextureWrapper || this._currentPreset == null || param1 is MountWrapper)
            {
               param2.btn_deleteItem.visible = false;
            }
            else
            {
               param2.btn_deleteItem.visible = true;
            }
         }
      }
      
      public function updateIcon(param1:*, param2:*, param3:Boolean) : void
      {
         param2.btn_icon.selected = false;
         if(param1)
         {
            param2.tx_icon.uri = this.uiApi.createUri(this.uiApi.me().getConstant("iconsUri") + "small_" + param1.id);
            param2.tx_bg.visible = true;
            param2.btn_icon.selected = param3;
         }
         else
         {
            param2.tx_icon.uri = null;
            param2.tx_bg.visible = false;
         }
      }
      
      private function dropValidatorFunction(param1:Object, param2:Object, param3:Object) : Boolean
      {
         return false;
      }
      
      private function processDrop(param1:Object, param2:Object, param3:Object) : void
      {
      }
      
      private function removeDropSourceFunction(param1:Object) : void
      {
      }
      
      public function onRelease(param1:Object) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:uint = 0;
         var _loc5_:int = 0;
         var _loc6_:Vector.<uint> = null;
         var _loc7_:Vector.<uint> = null;
         var _loc8_:* = undefined;
         var _loc9_:int = 0;
         switch(param1)
         {
            case this.btn_new:
               this.displayPreset(-1);
               break;
            case this.btn_save:
               this.btn_save.disabled = true;
               _loc2_ = -1;
               _loc3_ = 0;
               while(_loc3_ < this._maxPresetCount)
               {
                  if(!this.gd_presets.dataProvider[_loc3_] || this.gd_presets.dataProvider[_loc3_] == null)
                  {
                     _loc2_ = _loc3_;
                     break;
                  }
                  _loc3_++;
               }
               if(this._currentPreset)
               {
                  _loc2_ = this._currentPreset.id;
               }
               if(_loc2_ != -1)
               {
                  _loc4_ = this.gd_icons.selectedIndex > -1?uint(this.gd_icons.dataProvider[this.gd_icons.selectedIndex].id):uint(0);
                  if(!this._itemsAltered)
                  {
                     this.sysApi.sendAction(new InventoryPresetSave(_loc2_,_loc4_,this._newItems));
                  }
                  else
                  {
                     _loc6_ = new Vector.<uint>();
                     _loc7_ = new Vector.<uint>();
                     _loc5_ = 0;
                     while(_loc5_ < 16)
                     {
                        if(this.gd_items.dataProvider[_loc5_] && this.gd_items.dataProvider[_loc5_] is ItemWrapper)
                        {
                           _loc6_.push(this.gd_items.dataProvider[_loc5_].objectUID);
                           _loc7_.push(_loc5_);
                        }
                        _loc5_++;
                     }
                     this.sysApi.sendAction(new InventoryPresetSaveCustom(_loc2_,_loc4_,_loc6_,_loc7_));
                     this._itemsAltered = false;
                  }
                  this.gd_icons.selectedIndex = -1;
                  if(this._newItems)
                  {
                     this._newItems = false;
                  }
               }
               else
               {
                  this.sysApi.log(2,"plus de place !");
               }
               break;
            case this.btn_delete:
               this._popupName = this.modCommon.openPopup(this.uiApi.getText("ui.popup.warning"),this.uiApi.getText("ui.preset.warningDelete",this._currentPreset.id + 1),[this.uiApi.getText("ui.common.yes"),this.uiApi.getText("ui.common.no")],[this.onConfirmDelete,this.onCancelDelete],this.onConfirmDelete,this.onCancelDelete);
               break;
            case this.btn_update:
               this.btn_save.disabled = false;
               this._newItems = true;
               this.fillItemsGrid(this.getEquipment());
         }
         if(param1.name.indexOf("btn_deleteItem") != -1)
         {
            _loc8_ = this._componentsList[param1.name];
            if(_loc8_.hasOwnProperty("objectGID") && _loc8_.objectGID && this.dataApi.getItem(_loc8_.objectGID).id != 666)
            {
               _loc9_ = this.gd_items.selectedIndex;
               this._itemToDeleteIndex = _loc9_;
               this._popupName = this.modCommon.openPopup(this.uiApi.getText("ui.popup.warning"),this.uiApi.getText("ui.preset.warningItemDelete",this.dataApi.getItem(_loc8_.objectGID).name,this._currentPreset.id + 1),[this.uiApi.getText("ui.common.yes"),this.uiApi.getText("ui.common.no")],[this.onConfirmItemDelete,this.onCancelDelete],this.onConfirmItemDelete,this.onCancelDelete);
            }
         }
      }
      
      public function onRollOver(param1:Object) : void
      {
         var _loc2_:String = null;
         switch(param1)
         {
            case this.btn_delete:
               _loc2_ = this.uiApi.getText("ui.preset.delete");
               break;
            case this.btn_update:
               _loc2_ = this.uiApi.getText("ui.preset.importCurrentStuff");
         }
         if(param1.name.indexOf("btn_deleteItem") != -1)
         {
            _loc2_ = this.uiApi.getText("ui.preset.deleteItem");
         }
         if(_loc2_)
         {
            this.uiApi.showTooltip(this.uiApi.textTooltipInfo(_loc2_),param1,false,"standard",LocationEnum.POINT_BOTTOM,LocationEnum.POINT_TOP,3,null,null,null,"TextInfo");
         }
      }
      
      public function onRollOut(param1:Object) : void
      {
         this.uiApi.hideTooltip();
      }
      
      public function onSelectItem(param1:Object, param2:uint, param3:Boolean) : void
      {
         if(param2 != GridItemSelectMethodEnum.AUTO)
         {
            switch(param1)
            {
               case this.gd_presets:
                  if(this.gd_presets.selectedItem != null)
                  {
                     if(param2 == GridItemSelectMethodEnum.DOUBLE_CLICK)
                     {
                        this.sysApi.sendAction(new InventoryPresetUse(this.gd_presets.selectedItem.id));
                     }
                     else
                     {
                        this._currentIndex = this.gd_presets.selectedItem.id;
                        this.displayPreset(this.gd_presets.selectedItem.id);
                     }
                  }
                  break;
               case this.gd_items:
                  if(this.gd_items.selectedItem && this.gd_items.selectedItem is ItemWrapper && this.gd_items.selectedItem.objectUID)
                  {
                     this.sysApi.dispatchHook(ObjectSelected,{"data":this.gd_items.selectedItem});
                  }
                  else if(this.gd_items.selectedItem && this.gd_items.selectedItem is MountWrapper && this.playerApi.getMount())
                  {
                     this.sysApi.dispatchHook(ObjectSelected,{"data":this.gd_items.selectedItem});
                  }
                  else
                  {
                     this.sysApi.dispatchHook(ObjectSelected,{"data":null});
                  }
                  break;
               case this.gd_icons:
                  if(this._currentPreset)
                  {
                     if(this.dataApi.getPresetIcon(this._currentPreset.gfxId).order != this.gd_icons.selectedIndex)
                     {
                        this.btn_save.disabled = false;
                     }
                     else
                     {
                        this.btn_save.disabled = true;
                     }
                  }
            }
         }
      }
      
      public function onItemRollOver(param1:Object, param2:Object) : void
      {
         var _loc3_:String = null;
         var _loc4_:Object = null;
         var _loc5_:EquipmentUi = null;
         if(param1 == this.gd_items && param2.data && param2.data is ItemWrapper && param2.data.name)
         {
            if(param2.data is MountWrapper)
            {
               _loc3_ = param2.data.name;
               if(_loc3_)
               {
                  this.uiApi.showTooltip(this.uiApi.textTooltipInfo(_loc3_),param2.container,false,"standard",8,0,0,null,null,null,"TextInfo");
               }
            }
            else
            {
               _loc4_ = this.uiApi.getUi(UIEnum.STORAGE_UI);
               if(!(_loc4_.uiClass is EquipmentUi))
               {
                  throw new Error("equipment UI Class is not a EquipmentUi");
               }
               _loc5_ = _loc4_.uiClass as EquipmentUi;
               this.uiApi.showTooltip(param2.data,param2.container,false,"standard",8,0,0,"itemName",null,{
                  "showEffects":true,
                  "header":true
               },"ItemInfo");
            }
         }
      }
      
      public function onItemRollOut(param1:Object, param2:Object) : void
      {
         this.uiApi.hideTooltip();
      }
      
      public function onConfirmDelete() : void
      {
         this.sysApi.sendAction(new InventoryPresetDelete(this._currentPreset.id));
      }
      
      public function onConfirmItemDelete() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Array = new Array();
         _loc1_ = 0;
         while(_loc1_ < 16)
         {
            _loc2_[_loc1_] = this.gd_items.dataProvider[_loc1_];
            _loc1_++;
         }
         var _loc3_:int = this._itemToDeleteIndex;
         this._itemToDeleteIndex = -1;
         if(_loc2_[_loc3_] && _loc2_[_loc3_] is ItemWrapper)
         {
            _loc2_[_loc3_] = this.inventoryApi.getVoidItemForPreset(_loc3_);
            this.fillItemsGrid(_loc2_);
            this.btn_save.disabled = false;
            this._itemsAltered = true;
         }
      }
      
      public function onCancelDelete() : void
      {
         this._itemToDeleteIndex = -1;
      }
      
      public function onPresetsUpdate() : void
      {
         var _loc2_:Object = null;
         this._presets = new Array();
         var _loc1_:uint = 0;
         for each(_loc2_ in this.inventoryApi.getPresets())
         {
            if(_loc2_ && _loc2_ is PresetWrapper)
            {
               this._presets[_loc2_.id] = _loc2_;
               _loc1_++;
            }
         }
         this.gd_presets.dataProvider = this._presets;
         if(_loc1_ >= this._maxPresetCount)
         {
            this.btn_new.disabled = true;
         }
         else
         {
            this.btn_new.disabled = false;
         }
         if(this._currentIndex != -1)
         {
            this.gd_presets.selectedIndex = this._currentIndex;
         }
      }
      
      public function onPresetSelected(param1:int) : void
      {
         if(param1 > -1)
         {
            this._currentIndex = param1;
         }
         else
         {
            this.displayPreset(-2);
         }
      }
      
      public function onPresetError(param1:String, param2:Object = null) : void
      {
         var _loc3_:String = null;
         if(param1 == "unknown")
         {
            _loc3_ = this.uiApi.getText("ui.common.unknownFail");
         }
         else
         {
            _loc3_ = this.uiApi.getText("ui.preset.error." + param1);
         }
         this._popupName = this.modCommon.openPopup(this.uiApi.getText("ui.common.error"),_loc3_,[this.uiApi.getText("ui.common.ok")],null,null,null,null,false,true);
      }
   }
}
