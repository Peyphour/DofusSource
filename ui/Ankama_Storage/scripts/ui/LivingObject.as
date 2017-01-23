package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Grid;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.ProgressBar;
   import com.ankamagames.berilia.components.Slot;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.StorageApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import d2actions.LivingObjectChangeSkinRequest;
   import d2enums.ShortcutHookListEnum;
   import d2hooks.EquipmentObjectMove;
   import d2hooks.LivingObjectAssociate;
   import d2hooks.LivingObjectDissociate;
   import d2hooks.LivingObjectFeed;
   import d2hooks.LivingObjectUpdate;
   import d2hooks.OpenFeed;
   
   public class LivingObject
   {
       
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      public var storageApi:StorageApi;
      
      [Module(name="Ankama_Common")]
      public var modCommon:Object;
      
      public var dataApi:DataApi;
      
      private var _item:ItemWrapper;
      
      public var mainCtr:GraphicContainer;
      
      public var ctr_menu:GraphicContainer;
      
      public var ctr_look:GraphicContainer;
      
      public var btn_closeLook:ButtonContainer;
      
      public var btn_lookOk:ButtonContainer;
      
      public var grid_look:Grid;
      
      public var btn_close:ButtonContainer;
      
      public var btn_look:ButtonContainer;
      
      public var btn_destroy:ButtonContainer;
      
      public var btn_feed:ButtonContainer;
      
      public var slot_icon:Slot;
      
      public var pb_xp:ProgressBar;
      
      public var lbl_level:Label;
      
      public var lbl_mood:Label;
      
      public var lbl_date:Label;
      
      public function LivingObject()
      {
         super();
      }
      
      public function main(param1:Object) : void
      {
         this.uiApi.addComponentHook(this.btn_lookOk,"onRelease");
         this.uiApi.addComponentHook(this.btn_closeLook,"onRelease");
         this.uiApi.addComponentHook(this.btn_close,"onRelease");
         this.uiApi.addComponentHook(this.btn_look,"onRelease");
         this.uiApi.addComponentHook(this.btn_destroy,"onRelease");
         this.uiApi.addComponentHook(this.btn_feed,"onRelease");
         this.uiApi.addComponentHook(this.pb_xp,"onRollOver");
         this.uiApi.addComponentHook(this.pb_xp,"onRollOut");
         this.uiApi.addShortcutHook(ShortcutHookListEnum.CLOSE_UI,this.onShortCut);
         this.sysApi.addHook(EquipmentObjectMove,this.onEquipmentObjectMove);
         this.sysApi.addHook(LivingObjectUpdate,this.onLivingObjectUpdate);
         this.sysApi.addHook(LivingObjectFeed,this.onLivingObjectFeed);
         this.sysApi.addHook(d2hooks.LivingObjectDissociate,this.onLivingObjectDissociate);
         this.sysApi.addHook(LivingObjectAssociate,this.onLivingObjectAssociate);
         this._item = param1.item;
         this.updateLivingObjectInfos();
      }
      
      private function updateLivingObjectInfos() : void
      {
         var _loc1_:int = this._item.livingObjectMaxXp;
         if(_loc1_ == -1)
         {
            this.pb_xp.value = 1;
         }
         else
         {
            this.pb_xp.value = this._item.livingObjectXp / _loc1_;
         }
         if(this._item.type.id == 113)
         {
            this.btn_destroy.disabled = true;
            this.btn_feed.disabled = true;
         }
         else
         {
            this.btn_destroy.disabled = false;
            this.btn_feed.disabled = false;
         }
         this.lbl_level.text = this._item.livingObjectLevel.toString();
         this.lbl_date.text = this._item.livingObjectFoodDate;
         this.slot_icon.data = this._item;
         this._item.iconUri;
         var _loc2_:uint = this._item.livingObjectMood;
         if(_loc2_ == 0)
         {
            this.lbl_mood.text = this.uiApi.getText("ui.common.lean");
         }
         else if(_loc2_ == 1)
         {
            this.lbl_mood.text = this.uiApi.getText("ui.common.satisfied");
         }
         else if(_loc2_ == 2)
         {
            this.lbl_mood.text = this.uiApi.getText("ui.common.fat");
         }
         else
         {
            this.lbl_mood.text = "Error";
         }
      }
      
      public function unload() : void
      {
      }
      
      private function onEquipmentObjectMove(param1:ItemWrapper, param2:uint) : void
      {
         if(param1 && param1.objectUID == this._item.objectUID)
         {
            this._item = param1;
            this.updateLivingObjectInfos();
         }
      }
      
      private function onLivingObjectUpdate(param1:ItemWrapper) : void
      {
         this._item = param1;
         this.updateLivingObjectInfos();
      }
      
      private function onLivingObjectFeed(param1:ItemWrapper) : void
      {
         this._item = param1;
         this.updateLivingObjectInfos();
      }
      
      private function onLivingObjectDissociate(param1:Object) : void
      {
         this.uiApi.unloadUi("livingObject");
      }
      
      private function onLivingObjectAssociate(param1:ItemWrapper) : void
      {
         this._item = param1;
         this.updateLivingObjectInfos();
      }
      
      private function initLook(param1:Boolean) : void
      {
         var _loc2_:Object = null;
         if(param1)
         {
            this.ctr_look.visible = true;
            _loc2_ = this.dataApi.getLivingObjectSkins(this._item);
            this.grid_look.dataProvider = _loc2_;
            this.grid_look.selectedIndex = this._item.livingObjectSkin - 1;
         }
         else
         {
            this.ctr_look.visible = false;
         }
      }
      
      public function onRelease(param1:Object) : void
      {
         if(param1 == this.btn_close)
         {
            this.uiApi.unloadUi("livingObject");
         }
         else if(param1 == this.btn_look)
         {
            this.initLook(true);
         }
         else if(param1 == this.btn_lookOk)
         {
            this.sysApi.sendAction(new LivingObjectChangeSkinRequest(this._item.objectUID,this._item.position,this.grid_look.selectedIndex + 1));
            this.initLook(false);
         }
         else if(param1 == this.btn_closeLook)
         {
            this.initLook(false);
         }
         else if(param1 == this.btn_destroy)
         {
            this.sysApi.sendAction(new d2actions.LivingObjectDissociate(this._item.objectUID,this._item.position));
         }
         else if(param1 == this.btn_feed)
         {
            this.ctr_look.visible = false;
            this.sysApi.dispatchHook(OpenFeed,this._item);
         }
      }
      
      public function onRollOver(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc6_:int = 0;
         var _loc3_:int = 7;
         var _loc4_:int = 1;
         var _loc5_:int = 0;
         if(param1 == this.pb_xp)
         {
            _loc6_ = this._item.livingObjectMaxXp;
            if(_loc6_ == -1)
            {
               _loc2_ = String(this._item.livingObjectXp);
            }
            else
            {
               _loc2_ = this._item.livingObjectXp + " / " + _loc6_;
            }
         }
         this.uiApi.showTooltip(this.uiApi.textTooltipInfo(_loc2_),param1,false,"standard",_loc3_,_loc4_,_loc5_,null,null,null,"TextInfo");
      }
      
      public function onRollOut(param1:Object) : void
      {
         this.uiApi.hideTooltip();
      }
      
      private function onShortCut(param1:String) : Boolean
      {
         if(param1 == ShortcutHookListEnum.CLOSE_UI)
         {
            this.uiApi.unloadUi(this.uiApi.me().name);
            return true;
         }
         return false;
      }
   }
}
