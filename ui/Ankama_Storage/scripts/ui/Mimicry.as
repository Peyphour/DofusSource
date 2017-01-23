package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.Slot;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import com.ankamagames.dofus.uiApi.ContextMenuApi;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.InventoryApi;
   import com.ankamagames.dofus.uiApi.StorageApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import d2actions.CloseInventory;
   import d2actions.LeaveDialogRequest;
   import d2actions.MimicryObjectFeedAndAssociateRequest;
   import d2enums.ComponentHookList;
   import d2enums.LocationEnum;
   import d2enums.ShortcutHookListEnum;
   import d2hooks.DoubleClickItemInventory;
   import d2hooks.MimicryObjectAssociated;
   import d2hooks.MimicryObjectPreview;
   import d2hooks.ObjectSelected;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class Mimicry
   {
       
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      public var storageApi:StorageApi;
      
      [Module(name="Ankama_Common")]
      public var modCommon:Object;
      
      public var dataApi:DataApi;
      
      [Module(name="Ankama_ContextMenu")]
      public var modContextMenu:Object;
      
      public var menuApi:ContextMenuApi;
      
      public var inventoryApi:InventoryApi;
      
      private var _itemMimicry:ItemWrapper;
      
      private var _itemHost:ItemWrapper;
      
      private var _itemFood:ItemWrapper;
      
      private var _itemResult:ItemWrapper;
      
      private var _waitingSlot:Object;
      
      private var _slotsIngredients:Array;
      
      private var _okButtonDisabled:Boolean;
      
      private var _updateTimer:Timer;
      
      public var tx_ingredients_selected:Texture;
      
      public var tx_ingredients_content:Texture;
      
      public var lbl_previewItem:Label;
      
      public var slot_ingredient_1:Slot;
      
      public var slot_ingredient_2:Slot;
      
      public var slot_ingredient_3:Slot;
      
      public var slot_item_preview:Slot;
      
      public var ctr_slot1:GraphicContainer;
      
      public var ctr_slot2:GraphicContainer;
      
      public var ctr_slot3:GraphicContainer;
      
      public var ctr_slot4:GraphicContainer;
      
      public var btn_close:ButtonContainer;
      
      public var btn_ok:ButtonContainer;
      
      public function Mimicry()
      {
         super();
      }
      
      public function main(param1:Object) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:ItemWrapper = null;
         var _loc4_:ItemWrapper = null;
         this.sysApi.disableWorldInteraction();
         this.sysApi.addHook(MimicryObjectPreview,this.onMimicryObjectPreview);
         this.sysApi.addHook(MimicryObjectAssociated,this.onMimicryObjectAssociated);
         this.sysApi.addHook(DoubleClickItemInventory,this.onDoubleClickItemInventory);
         this.sysApi.addHook(ObjectSelected,this.onObjectSelected);
         this.uiApi.addShortcutHook(ShortcutHookListEnum.CLOSE_UI,this.onShortCut);
         this.uiApi.addComponentHook(this.btn_ok,ComponentHookList.ON_RELEASE);
         this.uiApi.addComponentHook(this.btn_close,ComponentHookList.ON_RELEASE);
         this.uiApi.addComponentHook(this.slot_item_preview,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.slot_item_preview,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.slot_item_preview,ComponentHookList.ON_ITEM_RIGHT_CLICK);
         this.uiApi.addComponentHook(this.slot_item_preview,ComponentHookList.ON_RELEASE);
         this.uiApi.addComponentHook(this.ctr_slot1,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.ctr_slot1,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.ctr_slot2,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.ctr_slot2,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.ctr_slot3,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.ctr_slot3,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.ctr_slot4,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.ctr_slot4,ComponentHookList.ON_ROLL_OUT);
         this._updateTimer = new Timer(300,1);
         this._updateTimer.addEventListener(TimerEvent.TIMER,this.onTimerEvent);
         this._slotsIngredients = new Array(this.slot_ingredient_1,this.slot_ingredient_2,this.slot_ingredient_3);
         for each(_loc2_ in this._slotsIngredients)
         {
            this.registerSlot(_loc2_);
         }
         this.btn_ok.disabled = true;
         if(param1)
         {
            _loc3_ = this.inventoryApi.getItem(int(param1));
            if(_loc3_)
            {
               this._itemMimicry = _loc3_;
               _loc4_ = this.dataApi.getItemWrapper(_loc3_.objectGID,_loc3_.position,_loc3_.objectUID,1,_loc3_.effectsList);
               this.fillSlot(this.slot_ingredient_1,_loc4_);
            }
         }
      }
      
      public function unload() : void
      {
         this.uiApi.unloadUi("itemBoxMimicry");
         this._updateTimer.stop();
         this._updateTimer.removeEventListener(TimerEvent.TIMER,this.onTimerEvent);
         this._updateTimer = null;
         this.storageApi.releaseHooks();
         this.sysApi.sendAction(new LeaveDialogRequest());
         this.sysApi.sendAction(new CloseInventory());
         this.sysApi.enableWorldInteraction();
      }
      
      public function processDropToInventory(param1:Object, param2:Object, param3:Object) : void
      {
         this.unfillSlot(this._waitingSlot);
      }
      
      public function fillAutoSlot(param1:Object, param2:Boolean = false) : void
      {
         var _loc3_:Object = null;
         for each(_loc3_ in this._slotsIngredients)
         {
            if(_loc3_.data && _loc3_.data.objectGID == param1.objectGID)
            {
               this.fillSlot(_loc3_,param1);
               return;
            }
            if(_loc3_.data == null)
            {
               this.fillSlot(_loc3_,param1);
               return;
            }
         }
         if(param2)
         {
            this.fillSlot(null,param1);
         }
      }
      
      protected function registerSlot(param1:Slot) : void
      {
         param1.dropValidator = this.dropValidatorFunction as Function;
         param1.processDrop = this.processDropFunction as Function;
         this.uiApi.addComponentHook(param1,"onRollOver");
         this.uiApi.addComponentHook(param1,"onRollOut");
         this.uiApi.addComponentHook(param1,"onDoubleClick");
         this.uiApi.addComponentHook(param1,"onRightClick");
         this.uiApi.addComponentHook(param1,"onRelease");
      }
      
      protected function switchOkButtonState() : void
      {
         var _loc1_:Object = null;
         this._okButtonDisabled = false;
         for each(_loc1_ in this._slotsIngredients)
         {
            if(_loc1_.data == null)
            {
               this._okButtonDisabled = true;
            }
         }
         this.btn_ok.disabled = this._okButtonDisabled;
      }
      
      private function fillSlot(param1:Object, param2:Object) : void
      {
         this._updateTimer.reset();
         this._updateTimer.start();
         if(param1 != null && param1.data != null && param2 && param1.data.objectUID == param2.objectUID)
         {
            this.unfillSlot(param1);
         }
         else
         {
            param1.data = param2;
            if(param1 == this.slot_ingredient_1)
            {
               this._itemMimicry = param2 as ItemWrapper;
            }
            else if(param1 == this.slot_ingredient_2)
            {
               this._itemHost = param2 as ItemWrapper;
            }
            else if(param1 == this.slot_ingredient_3)
            {
               this._itemFood = param2 as ItemWrapper;
            }
         }
      }
      
      private function unfillSlot(param1:Object) : void
      {
         this._updateTimer.reset();
         this._updateTimer.start();
         if(param1 == null || param1.data == null)
         {
            return;
         }
         param1.data = null;
         if(param1 == this.slot_ingredient_1)
         {
            this._itemMimicry = null;
         }
         else if(param1 == this.slot_ingredient_2)
         {
            this._itemHost = null;
         }
         else if(param1 == this.slot_ingredient_3)
         {
            this._itemFood = null;
         }
      }
      
      private function dropValidatorFunction(param1:Object, param2:Object, param3:Object) : Boolean
      {
         if(!param2)
         {
            return false;
         }
         switch(param1)
         {
            case this.slot_ingredient_1:
               if(param2.typeId == 166)
               {
                  return true;
               }
               break;
            case this.slot_ingredient_2:
            case this.slot_ingredient_3:
               if(param2.category == 0 && param2.typeId != 166)
               {
                  return true;
               }
               break;
         }
         return false;
      }
      
      private function processDropFunction(param1:Object, param2:Object, param3:Object) : void
      {
         var _loc4_:ItemWrapper = null;
         var _loc5_:ItemWrapper = null;
         if(this.dropValidatorFunction(param1,param2,param3))
         {
            _loc4_ = this.dataApi.getItemWrapper(param2.objectGID,param2.position,param2.objectUID,1,param2.effectsList);
            _loc5_ = param1.data;
            this.fillSlot(param1,_loc4_);
            if(param3 == this.slot_ingredient_1 || param3 == this.slot_ingredient_2 || param3 == this.slot_ingredient_3)
            {
               this.fillSlot(param3,_loc5_);
            }
         }
      }
      
      private function validAssociation() : void
      {
         if(this._itemMimicry && this._itemHost && this._itemFood && this._itemResult && this.btn_ok.disabled == false)
         {
            this.modCommon.openPopup(this.uiApi.getText("ui.popup.warning"),this.uiApi.getText("ui.mimicry.confirmPopup",this._itemHost.name,this._itemMimicry.name,this._itemFood.name),[this.uiApi.getText("ui.common.yes"),this.uiApi.getText("ui.common.no")],[this.onConfirmAssociate,this.onCancelAssociate],this.onConfirmAssociate,this.onCancelAssociate);
         }
      }
      
      private function onMimicryObjectPreview(param1:ItemWrapper, param2:String) : void
      {
         this._itemResult = param1;
         if(this._itemResult)
         {
            this.lbl_previewItem.visible = false;
            this.btn_ok.disabled = false;
         }
         else
         {
            this.lbl_previewItem.visible = true;
            if(param2 != "")
            {
               this.lbl_previewItem.text = param2;
            }
            this.btn_ok.disabled = true;
         }
         this.slot_item_preview.data = this._itemResult;
      }
      
      private function onMimicryObjectAssociated(param1:ItemWrapper) : void
      {
         this.uiApi.unloadUi(this.uiApi.me().name);
      }
      
      protected function onConfirmAssociate() : void
      {
         this.sysApi.sendAction(new MimicryObjectFeedAndAssociateRequest(this._itemMimicry.objectUID,this._itemMimicry.position,this._itemFood.objectUID,this._itemFood.position,this._itemHost.objectUID,this._itemHost.position,false));
      }
      
      protected function onCancelAssociate() : void
      {
      }
      
      public function onDoubleClickItemInventory(param1:Object, param2:int = 1) : void
      {
      }
      
      public function onRelease(param1:Object) : void
      {
         switch(param1)
         {
            case this.btn_close:
               this.uiApi.unloadUi(this.uiApi.me().name);
               break;
            case this.btn_ok:
               this.validAssociation();
               break;
            default:
               if(param1.name.indexOf("slot") != -1 && param1.data)
               {
                  this.onObjectSelected(param1);
               }
         }
      }
      
      public function onRollOver(param1:Object) : void
      {
         var _loc2_:String = null;
         if(param1 is Slot && param1.data)
         {
            this.uiApi.showTooltip(param1.data,param1,false,"standard",8,0,0,"itemName",null,{
               "showEffects":true,
               "header":true
            },"ItemInfo");
         }
         else
         {
            switch(param1)
            {
               case this.ctr_slot1:
                  _loc2_ = this.uiApi.getText("ui.mimicry.mimicry") + " " + this.uiApi.getText("ui.mimicry.toBeDestroyed");
                  break;
               case this.ctr_slot2:
                  _loc2_ = this.uiApi.getText("ui.mimicry.host");
                  break;
               case this.ctr_slot3:
                  _loc2_ = this.uiApi.getText("ui.mimicry.food") + " " + this.uiApi.getText("ui.mimicry.toBeDestroyed");
                  break;
               case this.ctr_slot4:
                  _loc2_ = this.uiApi.getText("ui.craft.itemCreated");
            }
            if(_loc2_)
            {
               this.uiApi.showTooltip(this.uiApi.textTooltipInfo(_loc2_),param1,false,"standard",LocationEnum.POINT_BOTTOM,LocationEnum.POINT_TOP,3,null,null,null,"TextInfo");
            }
         }
      }
      
      public function onRollOut(param1:Object) : void
      {
         this.uiApi.hideTooltip();
      }
      
      public function onDoubleClick(param1:Object) : void
      {
         if(param1.data && param1.data != this.slot_ingredient_1.data)
         {
            this.unfillSlot(param1);
         }
      }
      
      private function onShortCut(param1:String) : Boolean
      {
         if(param1 == ShortcutHookListEnum.CLOSE_UI)
         {
            this.uiApi.unloadUi(this.uiApi.me().name);
            return true;
         }
         if(param1 == ShortcutHookListEnum.VALID_UI)
         {
            this.validAssociation();
            return true;
         }
         return false;
      }
      
      public function onObjectSelected(param1:Object) : void
      {
         if(!this.sysApi.getOption("displayTooltips","dofus"))
         {
            this.lbl_previewItem.visible = false;
         }
      }
      
      public function onRightClick(param1:Object) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Object = null;
         if(param1.data)
         {
            _loc2_ = param1.data;
            _loc3_ = this.menuApi.create(_loc2_);
            if(_loc3_.content.length > 0)
            {
               this.modContextMenu.createContextMenu(_loc3_);
            }
         }
      }
      
      private function onDropStart(param1:Object) : void
      {
         var _loc2_:Object = null;
         this._waitingSlot = param1;
         for each(_loc2_ in this._slotsIngredients)
         {
            if(this.dropValidatorFunction(_loc2_,param1.data,null))
            {
               _loc2_.selected = true;
            }
         }
      }
      
      private function onDropEnd(param1:Object) : void
      {
         var _loc2_:Object = null;
         for each(_loc2_ in this._slotsIngredients)
         {
            _loc2_.selected = false;
         }
      }
      
      protected function onTimerEvent(param1:TimerEvent) : void
      {
         if(this.slot_ingredient_1.data != null && this.slot_ingredient_2.data != null && this.slot_ingredient_3.data != null)
         {
            this.sysApi.sendAction(new MimicryObjectFeedAndAssociateRequest(this._itemMimicry.objectUID,this._itemMimicry.position,this._itemFood.objectUID,this._itemFood.position,this._itemHost.objectUID,this._itemHost.position,true));
         }
      }
      
      public function set slotsIngredients(param1:Array) : void
      {
         this._slotsIngredients = param1;
      }
   }
}
