package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.ComboBox;
   import com.ankamagames.berilia.components.EntityDisplayer;
   import com.ankamagames.berilia.components.Grid;
   import com.ankamagames.berilia.components.Input;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.TextureBitmap;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.internalDatacenter.mount.MountData;
   import com.ankamagames.dofus.modules.utils.ItemTooltipSettings;
   import com.ankamagames.dofus.uiApi.BindsApi;
   import com.ankamagames.dofus.uiApi.ContextMenuApi;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.MountApi;
   import com.ankamagames.dofus.uiApi.PlayedCharacterApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofus.uiApi.TooltipApi;
   import com.ankamagames.dofus.uiApi.UtilApi;
   import com.ankamagames.dofusModuleLibrary.enum.interfaces.UIEnum;
   import com.ankamagames.dofusModuleLibrary.enum.interfaces.tooltip.LocationEnum;
   import d2actions.ExchangeHandleMountStable;
   import d2actions.LeaveExchangeMount;
   import d2actions.MountInfoRequest;
   import d2enums.ComponentHookList;
   import d2enums.DataStoreEnum;
   import d2enums.ExchangeHandleMountStableTypeEnum;
   import d2enums.SelectMethodEnum;
   import d2enums.ShortcutHookListEnum;
   import d2hooks.CertificateMountData;
   import d2hooks.KeyUp;
   import d2hooks.MountReleased;
   import d2hooks.MountRenamed;
   import d2hooks.MountSet;
   import d2hooks.MountStableUpdate;
   import d2hooks.MountUnSet;
   import d2hooks.UiLoaded;
   import enums.MountFilterEnum;
   import enums.MountFilterGroupEnum;
   import flash.utils.Dictionary;
   
   public class MountPaddock
   {
      
      public static const SOURCE_EQUIP:int = 0;
      
      public static const SOURCE_INVENTORY:int = 1;
      
      public static const SOURCE_BARN:int = 2;
      
      public static const SOURCE_PADDOCK:int = 3;
      
      public static const SORT_TYPE_TYPE:int = 0;
      
      public static const SORT_TYPE_GENDER:int = 1;
      
      public static const SORT_TYPE_NAME:int = 2;
      
      public static const SORT_TYPE_LEVEL:int = 3;
      
      public static const SHORTCUT_STOCK:String = "s1";
      
      public static const SHORTCUT_PARK:String = "s2";
      
      public static const SHORTCUT_EXCHANGE:String = "s4";
      
      public static const SHORTCUT_EQUIP:String = "s3";
      
      public static const STABLE_SIZE:int = 250;
      
      public static var _currentSource:int = -2;
       
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      public var playerApi:PlayedCharacterApi;
      
      public var mountApi:MountApi;
      
      public var bindsApi:BindsApi;
      
      public var dataApi:DataApi;
      
      public var utilApi:UtilApi;
      
      public var tooltipApi:TooltipApi;
      
      public var menuApi:ContextMenuApi;
      
      [Module(name="Ankama_Common")]
      public var modCommon:Object;
      
      [Module(name="Ankama_ContextMenu")]
      public var modContextMenu:Object;
      
      private var _mountInfoUi:Object;
      
      private var _mountInfoUiLoaded:Boolean = false;
      
      private var _mount:Object;
      
      private var _nameless:String;
      
      private var _lastSource:int = -2;
      
      private var _maxOutdoorMount:int;
      
      private var _barnList:Array;
      
      private var _paddockList:Array;
      
      private var _inventoryList:Object;
      
      private var _hookedComponents:Dictionary;
      
      private var _assetsUri:String;
      
      private var _mountsUri:String;
      
      private var _fullDataProvider:Array;
      
      private var _stableFilters:Array;
      
      private var _stableFilter2:Array;
      
      private var _stableFilter3:Array;
      
      private var _paddockFilters:Array;
      
      private var _barnSortOrder:Array;
      
      private var _paddockSortOrder:Array;
      
      private var _lastSortOptions:Array;
      
      public var mainCtr:GraphicContainer;
      
      public var ctr_mountEquiped:GraphicContainer;
      
      public var ed_mount:EntityDisplayer;
      
      public var lbl_mountEquiped:Label;
      
      public var lbl_mountName:Label;
      
      public var lbl_mountDescription:Label;
      
      public var lbl_mountLevel:Label;
      
      public var lbl_park:Label;
      
      public var lbl_certificates:Label;
      
      public var lbl_stock:Label;
      
      public var lbl_noMountEquipped:Label;
      
      public var btn_exchange:ButtonContainer;
      
      public var btn_stock:ButtonContainer;
      
      public var btn_park:ButtonContainer;
      
      public var btn_equip:ButtonContainer;
      
      public var btn_barnCloseSearch:ButtonContainer;
      
      public var btn_paddockCloseSearch:ButtonContainer;
      
      public var btn_inventoryCloseSearch:ButtonContainer;
      
      public var ctr_btnExchange:GraphicContainer;
      
      public var ctr_btnStock:GraphicContainer;
      
      public var ctr_btnPark:GraphicContainer;
      
      public var ctr_btnEquip:GraphicContainer;
      
      public var btn_lbl_btn_exchange:Label;
      
      public var btn_lbl_btn_stock:Label;
      
      public var btn_lbl_btn_park:Label;
      
      public var btn_lbl_btn_equip:Label;
      
      public var btn_close:ButtonContainer;
      
      public var ctr_bgbtntop:GraphicContainer;
      
      public var ctr_bgbtnbottom:GraphicContainer;
      
      public var ctr_mountInfo:GraphicContainer;
      
      public var cb_barn:ComboBox;
      
      public var cb_barn2:ComboBox;
      
      public var cb_barn3:ComboBox;
      
      public var cb_paddock:ComboBox;
      
      public var cb_inventory:ComboBox;
      
      public var bgcb_barn2:TextureBitmap;
      
      public var bgcb_barn3:TextureBitmap;
      
      public var tx_equipedMountSeparator:TextureBitmap;
      
      public var gd_barn:Grid;
      
      public var gd_paddock:Grid;
      
      public var gd_inventory:Grid;
      
      public var ctr_barn:GraphicContainer;
      
      public var ctr_searchBarn:GraphicContainer;
      
      public var ctr_searchPaddock:GraphicContainer;
      
      public var ctr_searchInventory:GraphicContainer;
      
      public var btn_searchBarn:ButtonContainer;
      
      public var btn_searchPaddock:ButtonContainer;
      
      public var btn_searchInventory:ButtonContainer;
      
      public var lbl_searchBarn:Input;
      
      public var lbl_searchPaddock:Input;
      
      public var lbl_searchInventory:Input;
      
      public var btn_barnType:ButtonContainer;
      
      public var btn_barnGender:ButtonContainer;
      
      public var btn_barnName:ButtonContainer;
      
      public var btn_barnLevel:ButtonContainer;
      
      public var btn_paddockType:ButtonContainer;
      
      public var btn_paddockGender:ButtonContainer;
      
      public var btn_paddockName:ButtonContainer;
      
      public var btn_paddockLevel:ButtonContainer;
      
      public var btn_addFilter:ButtonContainer;
      
      public var btn_removeFilter1:ButtonContainer;
      
      public var btn_removeFilter2:ButtonContainer;
      
      public var btn_removeFilter3:ButtonContainer;
      
      public var btn_moveAllFromBarn:ButtonContainer;
      
      public var btn_moveAllFromPark:ButtonContainer;
      
      public var btn_moveAllFromInventory:ButtonContainer;
      
      public function MountPaddock()
      {
         this._hookedComponents = new Dictionary(true);
         this._barnSortOrder = [{
            "type":SORT_TYPE_TYPE,
            "asc":true
         },{
            "type":SORT_TYPE_GENDER,
            "asc":true
         },{
            "type":SORT_TYPE_NAME,
            "asc":true
         },{
            "type":SORT_TYPE_LEVEL,
            "asc":true
         }];
         this._paddockSortOrder = [{
            "type":SORT_TYPE_TYPE,
            "asc":true
         },{
            "type":SORT_TYPE_GENDER,
            "asc":true
         },{
            "type":SORT_TYPE_NAME,
            "asc":true
         },{
            "type":SORT_TYPE_LEVEL,
            "asc":true
         }];
         super();
      }
      
      private static function switchSort(param1:Array, param2:int) : void
      {
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         if(param1[0].type == param2)
         {
            param1[0].asc = !param1[0].asc;
         }
         else
         {
            _loc3_ = 0;
            while(_loc3_ < param1.length)
            {
               _loc4_ = param1[_loc3_];
               if(_loc4_.type == param2)
               {
                  param1.splice(_loc3_,1);
                  break;
               }
               _loc3_++;
            }
            _loc4_ = {
               "type":param2,
               "asc":true
            };
            param1.unshift(_loc4_);
         }
      }
      
      public function main(param1:Object) : void
      {
         var _loc2_:String = null;
         this._stableFilters = [{
            "label":this.uiApi.getText("ui.common.allTypes"),
            "type":MountFilterEnum.MOUNT_ALL,
            "filterGroup":MountFilterGroupEnum.NO_GROUP
         },{
            "label":this.uiApi.getText("ui.mount.filterCapacity"),
            "type":MountFilterEnum.MOUNT_SPECIAL,
            "filterGroup":MountFilterGroupEnum.NO_GROUP
         },{
            "label":this.uiApi.getText("ui.mount.filterNoName"),
            "type":MountFilterEnum.MOUNT_NAMELESS,
            "filterGroup":MountFilterGroupEnum.NO_GROUP
         },{
            "label":this.uiApi.getText("ui.mount.filterMustXP"),
            "type":MountFilterEnum.MOUNT_TRAINABLE,
            "filterGroup":MountFilterGroupEnum.NO_GROUP
         },{
            "label":this.uiApi.getText("ui.mount.filterMan"),
            "type":MountFilterEnum.MOUNT_MALE,
            "filterGroup":MountFilterGroupEnum.GENDER
         },{
            "label":this.uiApi.getText("ui.mount.filterWoman"),
            "type":MountFilterEnum.MOUNT_FEMALE,
            "filterGroup":MountFilterGroupEnum.GENDER
         },{
            "label":this.uiApi.getText("ui.mount.filterFecondable"),
            "type":MountFilterEnum.MOUNT_FRUITFUL,
            "filterGroup":MountFilterGroupEnum.FERTILITY
         },{
            "label":this.uiApi.getText("ui.mount.filterNoFecondable"),
            "type":MountFilterEnum.MOUNT_NOFRUITFUL,
            "filterGroup":MountFilterGroupEnum.FERTILITY
         },{
            "label":this.uiApi.getText("ui.mount.filterSterilized"),
            "type":MountFilterEnum.MOUNT_STERILIZED,
            "filterGroup":MountFilterGroupEnum.FERTILITY
         },{
            "label":this.uiApi.getText("ui.mount.filterFecondee"),
            "type":MountFilterEnum.MOUNT_FERTILIZED,
            "filterGroup":MountFilterGroupEnum.FERTILITY
         },{
            "label":this.uiApi.getText("ui.mount.filterPositiveSerenity"),
            "type":MountFilterEnum.MOUNT_POSITIVE_SERENITY,
            "filterGroup":MountFilterGroupEnum.SERENITY
         },{
            "label":this.uiApi.getText("ui.mount.filterNegativeSerenity"),
            "type":MountFilterEnum.MOUNT_NEGATIVE_SERENITY,
            "filterGroup":MountFilterGroupEnum.SERENITY
         },{
            "label":this.uiApi.getText("ui.mount.filterAverageSerenity"),
            "type":MountFilterEnum.MOUNT_AVERAGE_SERENITY,
            "filterGroup":MountFilterGroupEnum.SERENITY
         },{
            "label":this.uiApi.getText("ui.mount.filterNeedLove"),
            "type":MountFilterEnum.MOUNT_NEED_LOVE,
            "filterGroup":MountFilterGroupEnum.LOVE
         },{
            "label":this.uiApi.getText("ui.mount.filterFullLove"),
            "type":MountFilterEnum.MOUNT_FULL_LOVE,
            "filterGroup":MountFilterGroupEnum.LOVE
         },{
            "label":this.uiApi.getText("ui.mount.filterNeedStamina"),
            "type":MountFilterEnum.MOUNT_NEED_STAMINA,
            "filterGroup":MountFilterGroupEnum.STAMINA
         },{
            "label":this.uiApi.getText("ui.mount.filterFullStamina"),
            "type":MountFilterEnum.MOUNT_FULL_STAMINA,
            "filterGroup":MountFilterGroupEnum.STAMINA
         },{
            "label":this.uiApi.getText("ui.mount.filterNeedEnergy"),
            "type":MountFilterEnum.MOUNT_NEED_ENERGY,
            "filterGroup":MountFilterGroupEnum.ENERGY
         },{
            "label":this.uiApi.getText("ui.mount.filterFullEnergy"),
            "type":MountFilterEnum.MOUNT_FULL_ENERGY,
            "filterGroup":MountFilterGroupEnum.ENERGY
         },{
            "label":this.uiApi.getText("ui.mount.filterImmature"),
            "type":MountFilterEnum.MOUNT_IMMATURE,
            "filterGroup":MountFilterGroupEnum.AGE
         },{
            "label":this.uiApi.getText("ui.mount.filterBorn"),
            "type":MountFilterEnum.MOUNT_BABY,
            "filterGroup":MountFilterGroupEnum.AGE
         },{
            "label":this.uiApi.getText("ui.mount.filterMountable"),
            "type":MountFilterEnum.MOUNT_MOUNTABLE,
            "filterGroup":MountFilterGroupEnum.AGE
         },{
            "label":this.uiApi.getText("ui.mount.filterNoTired"),
            "type":MountFilterEnum.MOUNT_NOTIRED,
            "filterGroup":MountFilterGroupEnum.TIREDNESS
         },{
            "label":this.uiApi.getText("ui.mount.filterTired","100%"),
            "type":MountFilterEnum.MOUNT_100_TIRED,
            "filterGroup":MountFilterGroupEnum.TIREDNESS
         },{
            "label":this.uiApi.getText("ui.mount.filterTired","&lt;50%"),
            "type":MountFilterEnum.MOUNT_LESS50_TIRED,
            "filterGroup":MountFilterGroupEnum.TIREDNESS
         },{
            "label":this.uiApi.getText("ui.mount.filterTired",">50%"),
            "type":MountFilterEnum.MOUNT_MORE50_TIRED,
            "filterGroup":MountFilterGroupEnum.TIREDNESS
         }];
         this._paddockFilters = [{
            "label":this.uiApi.getText("ui.common.allTypes"),
            "type":MountFilterEnum.MOUNT_ALL,
            "filterGroup":MountFilterGroupEnum.NO_GROUP
         },{
            "label":this.uiApi.getText("ui.mount.filterNoName"),
            "type":MountFilterEnum.MOUNT_NAMELESS,
            "filterGroup":MountFilterGroupEnum.NO_GROUP
         },{
            "label":this.uiApi.getText("ui.mount.filterMustXP"),
            "type":MountFilterEnum.MOUNT_TRAINABLE,
            "filterGroup":MountFilterGroupEnum.NO_GROUP
         },{
            "label":this.uiApi.getText("ui.mount.filterCapacity"),
            "type":MountFilterEnum.MOUNT_SPECIAL,
            "filterGroup":MountFilterGroupEnum.NO_GROUP
         },{
            "label":this.uiApi.getText("ui.mount.filterOwner"),
            "type":MountFilterEnum.MOUNT_OWNER,
            "filterGroup":MountFilterGroupEnum.NO_GROUP
         },{
            "label":this.uiApi.getText("ui.mount.filterMan"),
            "type":MountFilterEnum.MOUNT_MALE,
            "filterGroup":MountFilterGroupEnum.GENDER
         },{
            "label":this.uiApi.getText("ui.mount.filterWoman"),
            "type":MountFilterEnum.MOUNT_FEMALE,
            "filterGroup":MountFilterGroupEnum.GENDER
         },{
            "label":this.uiApi.getText("ui.mount.filterFecondable"),
            "type":MountFilterEnum.MOUNT_FRUITFUL,
            "filterGroup":MountFilterGroupEnum.FERTILITY
         },{
            "label":this.uiApi.getText("ui.mount.filterNoFecondable"),
            "type":MountFilterEnum.MOUNT_NOFRUITFUL,
            "filterGroup":MountFilterGroupEnum.FERTILITY
         },{
            "label":this.uiApi.getText("ui.mount.filterSterilized"),
            "type":MountFilterEnum.MOUNT_STERILIZED,
            "filterGroup":MountFilterGroupEnum.FERTILITY
         },{
            "label":this.uiApi.getText("ui.mount.filterImmature"),
            "type":MountFilterEnum.MOUNT_IMMATURE,
            "filterGroup":MountFilterGroupEnum.FERTILITY
         },{
            "label":this.uiApi.getText("ui.mount.filterFecondee"),
            "type":MountFilterEnum.MOUNT_FERTILIZED,
            "filterGroup":MountFilterGroupEnum.FERTILITY
         },{
            "label":this.uiApi.getText("ui.mount.filterPositiveSerenity"),
            "type":MountFilterEnum.MOUNT_POSITIVE_SERENITY,
            "filterGroup":MountFilterGroupEnum.SERENITY
         },{
            "label":this.uiApi.getText("ui.mount.filterNegativeSerenity"),
            "type":MountFilterEnum.MOUNT_NEGATIVE_SERENITY,
            "filterGroup":MountFilterGroupEnum.SERENITY
         },{
            "label":this.uiApi.getText("ui.mount.filterAverageSerenity"),
            "type":MountFilterEnum.MOUNT_AVERAGE_SERENITY,
            "filterGroup":MountFilterGroupEnum.SERENITY
         },{
            "label":this.uiApi.getText("ui.mount.filterNeedLove"),
            "type":MountFilterEnum.MOUNT_NEED_LOVE,
            "filterGroup":MountFilterGroupEnum.LOVE
         },{
            "label":this.uiApi.getText("ui.mount.filterFullLove"),
            "type":MountFilterEnum.MOUNT_FULL_LOVE,
            "filterGroup":MountFilterGroupEnum.LOVE
         },{
            "label":this.uiApi.getText("ui.mount.filterNeedStamina"),
            "type":MountFilterEnum.MOUNT_NEED_STAMINA,
            "filterGroup":MountFilterGroupEnum.STAMINA
         },{
            "label":this.uiApi.getText("ui.mount.filterFullStamina"),
            "type":MountFilterEnum.MOUNT_FULL_STAMINA,
            "filterGroup":MountFilterGroupEnum.STAMINA
         },{
            "label":this.uiApi.getText("ui.mount.filterNeedEnergy"),
            "type":MountFilterEnum.MOUNT_NEED_ENERGY,
            "filterGroup":MountFilterGroupEnum.ENERGY
         },{
            "label":this.uiApi.getText("ui.mount.filterFullEnergy"),
            "type":MountFilterEnum.MOUNT_FULL_ENERGY,
            "filterGroup":MountFilterGroupEnum.ENERGY
         },{
            "label":this.uiApi.getText("ui.mount.filterBorn"),
            "type":MountFilterEnum.MOUNT_BABY,
            "filterGroup":MountFilterGroupEnum.AGE
         },{
            "label":this.uiApi.getText("ui.mount.filterMountable"),
            "type":MountFilterEnum.MOUNT_MOUNTABLE,
            "filterGroup":MountFilterGroupEnum.AGE
         },{
            "label":this.uiApi.getText("ui.mount.filterNoTired"),
            "type":MountFilterEnum.MOUNT_NOTIRED,
            "filterGroup":MountFilterGroupEnum.TIREDNESS
         },{
            "label":this.uiApi.getText("ui.mount.filterTired","100%"),
            "type":MountFilterEnum.MOUNT_100_TIRED,
            "filterGroup":MountFilterGroupEnum.TIREDNESS
         },{
            "label":this.uiApi.getText("ui.mount.filterTired","&lt;50%"),
            "type":MountFilterEnum.MOUNT_LESS50_TIRED,
            "filterGroup":MountFilterGroupEnum.TIREDNESS
         },{
            "label":this.uiApi.getText("ui.mount.filterTired",">50%"),
            "type":MountFilterEnum.MOUNT_MORE50_TIRED,
            "filterGroup":MountFilterGroupEnum.TIREDNESS
         }];
         this.sysApi.addHook(MountStableUpdate,this.onMountStableUpdate);
         this.sysApi.addHook(KeyUp,this.onKeyUp);
         this.sysApi.addHook(MountSet,this.showPlayerMountInfo);
         this.sysApi.addHook(MountUnSet,this.showPlayerMountInfo);
         this.sysApi.addHook(CertificateMountData,this.onCertificateMountData);
         this.sysApi.addHook(MountRenamed,this.onMountRenamed);
         this.sysApi.addHook(MountReleased,this.onMountReleased);
         this.uiApi.addComponentHook(this.btn_exchange,"onRelease");
         this.uiApi.addComponentHook(this.btn_close,"onRelease");
         this.uiApi.addComponentHook(this.btn_stock,"onRelease");
         this.uiApi.addComponentHook(this.btn_park,"onRelease");
         this.uiApi.addComponentHook(this.btn_equip,"onRelease");
         this.uiApi.addComponentHook(this.gd_barn,"onSelectItem");
         this.uiApi.addComponentHook(this.gd_paddock,"onSelectItem");
         this.uiApi.addComponentHook(this.gd_inventory,"onSelectItem");
         this.uiApi.addComponentHook(this.cb_barn,"onSelectItem");
         this.uiApi.addComponentHook(this.cb_barn2,"onSelectItem");
         this.uiApi.addComponentHook(this.cb_barn3,"onSelectItem");
         this.uiApi.addComponentHook(this.cb_paddock,"onSelectItem");
         this.uiApi.addComponentHook(this.cb_inventory,"onSelectItem");
         this.uiApi.addComponentHook(this.btn_searchBarn,"onRelease");
         this.uiApi.addComponentHook(this.btn_searchPaddock,"onRelease");
         this.uiApi.addComponentHook(this.btn_searchInventory,"onRelease");
         this.uiApi.addComponentHook(this.ctr_mountEquiped,"onRelease");
         this.uiApi.addShortcutHook(ShortcutHookListEnum.CLOSE_UI,this.onShortCut);
         this.uiApi.addShortcutHook(SHORTCUT_EQUIP,this.onShortCut);
         this.uiApi.addShortcutHook(SHORTCUT_EXCHANGE,this.onShortCut);
         this.uiApi.addShortcutHook(SHORTCUT_PARK,this.onShortCut);
         this.uiApi.addShortcutHook(SHORTCUT_STOCK,this.onShortCut);
         this.uiApi.hideTooltip();
         this._assetsUri = this.uiApi.me().getConstant("assets");
         this._mountsUri = this.uiApi.me().getConstant("mounts");
         _loc2_ = this.bindsApi.getShortcutBindStr(SHORTCUT_EQUIP);
         if(_loc2_)
         {
            this.btn_lbl_btn_equip.text = this.btn_lbl_btn_equip.text + (" (" + _loc2_ + ")");
         }
         _loc2_ = this.bindsApi.getShortcutBindStr(SHORTCUT_EXCHANGE);
         if(_loc2_)
         {
            this.btn_lbl_btn_exchange.text = this.btn_lbl_btn_exchange.text + (" (" + _loc2_ + ")");
         }
         _loc2_ = this.bindsApi.getShortcutBindStr(SHORTCUT_PARK);
         if(_loc2_)
         {
            this.btn_lbl_btn_park.text = this.btn_lbl_btn_park.text + (" (" + _loc2_ + ")");
         }
         _loc2_ = this.bindsApi.getShortcutBindStr(SHORTCUT_STOCK);
         if(_loc2_)
         {
            this.btn_lbl_btn_stock.text = this.btn_lbl_btn_stock.text + (" (" + _loc2_ + ")");
         }
         this._nameless = this.uiApi.getText("ui.common.noName");
         this.cb_barn.visible = true;
         this.cb_barn2.visible = false;
         this.bgcb_barn2.visible = false;
         this.cb_barn3.visible = false;
         this.btn_removeFilter1.visible = false;
         this.btn_removeFilter2.visible = false;
         this.btn_removeFilter3.visible = false;
         this.ctr_searchBarn.visible = false;
         this.ctr_searchInventory.visible = false;
         this.ctr_searchPaddock.visible = false;
         this.showUi(param1.stabledList,param1.paddockedList);
      }
      
      public function get visible() : Boolean
      {
         return this.mainCtr.visible;
      }
      
      public function hideUi() : void
      {
         this.sysApi.enableWorldInteraction();
         this.mainCtr.visible = false;
         this._mountInfoUi.visible = false;
         this.uiApi.unloadUi(UIEnum.MOUNT_INFO);
         this._mountInfoUiLoaded = false;
         this.sysApi.sendAction(new LeaveExchangeMount());
      }
      
      public function showUi(param1:Object, param2:Object) : void
      {
         var _loc3_:MountData = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         this.sysApi.disableWorldInteraction();
         this.mainCtr.visible = true;
         this.sysApi.addHook(UiLoaded,this.onUiLoaded);
         this._mountInfoUi = this.uiApi.loadUiInside(UIEnum.MOUNT_INFO,this.ctr_mountInfo,UIEnum.MOUNT_INFO,{
            "mount":null,
            "paddockMode":true,
            "posX":0,
            "posY":0
         });
         this._mountInfoUi.visible = false;
         this.showPlayerMountInfo();
         this.sourceSelected(-1);
         this.lbl_searchBarn.text = "";
         this.lbl_searchPaddock.text = "";
         this.lbl_searchInventory.text = "";
         this._barnList = new Array();
         for each(_loc3_ in param1)
         {
            this._barnList.push(_loc3_);
         }
         this._paddockList = new Array();
         for each(_loc3_ in param2)
         {
            this._paddockList.push(_loc3_);
         }
         this._inventoryList = this.mountApi.getInventoryList();
         this.updateBarnFilter();
         _loc4_ = MountFilterEnum.MOUNT_ALL;
         _loc5_ = MountFilterEnum.MOUNT_ALL;
         _loc6_ = MountFilterEnum.MOUNT_ALL;
         if(this.cb_barn.value)
         {
            _loc4_ = this.cb_barn.value.type;
         }
         if(this.cb_barn.value)
         {
            _loc5_ = this.cb_barn2.value.type;
         }
         if(this.cb_barn.value)
         {
            _loc6_ = this.cb_barn3.value.type;
         }
         this.updateBarn(_loc4_,_loc5_,_loc6_);
         this.updatePaddockFilter();
         var _loc7_:int = MountFilterEnum.MOUNT_ALL;
         if(this.cb_paddock.value)
         {
            _loc7_ = this.cb_paddock.value.type;
         }
         this.updatePaddock(_loc7_);
         this.updateInventoryFilter();
         var _loc8_:String = "";
         if(this.cb_inventory.value)
         {
            _loc8_ = this.cb_inventory.value;
         }
         this.updateInventory(_loc8_);
         this._maxOutdoorMount = this.mountApi.getCurrentPaddock().maxOutdoorMount;
      }
      
      public function showMountInfo(param1:Object, param2:int) : void
      {
         if(param1)
         {
            this._mount = param1;
            _currentSource = param2;
            this._mountInfoUi.visible = true;
            if(this._mount && this._mountInfoUiLoaded && this._mountInfoUi)
            {
               this._mountInfoUi.uiClass.showMountInformation(param1,param2);
            }
         }
      }
      
      public function showPlayerMountInfo() : void
      {
         var _loc1_:Object = this.playerApi.getMount();
         if(_loc1_)
         {
            this.tx_equipedMountSeparator.visible = true;
            this.lbl_mountEquiped.text = this.uiApi.getText("ui.mount.playerMount");
            this.lbl_mountName.text = _loc1_.name;
            this.lbl_mountDescription.text = _loc1_.description;
            this.lbl_mountLevel.text = this.uiApi.getText("ui.common.level") + this.uiApi.getText("ui.common.colon") + _loc1_.level;
            this.ed_mount.look = _loc1_.entityLook;
            this.lbl_noMountEquipped.visible = false;
         }
         else
         {
            this.tx_equipedMountSeparator.visible = false;
            this.lbl_noMountEquipped.visible = true;
            this.lbl_mountEquiped.text = this.uiApi.getText("ui.mount.noPlayerMount");
            this.lbl_mountName.text = "";
            this.lbl_mountDescription.text = "";
            this.lbl_mountLevel.text = "";
            this.ed_mount.look = null;
         }
      }
      
      public function showCurrentMountInfo() : void
      {
         if(this.playerApi.getMount())
         {
            this.gd_paddock.selectedIndex = -1;
            this.gd_barn.selectedIndex = -1;
            this.gd_inventory.selectedIndex = -1;
            this.showMountInfo(this.playerApi.getMount(),0);
            this.sourceSelected(SOURCE_EQUIP);
         }
      }
      
      public function unload() : void
      {
         if(this.uiApi.getUi(UIEnum.MOUNT_INFO))
         {
            this.uiApi.unloadUi(UIEnum.MOUNT_INFO);
         }
      }
      
      private function getAllMountIdsInGrid(param1:*) : Array
      {
         var _loc2_:* = undefined;
         var _loc3_:Array = new Array();
         for each(_loc2_ in param1)
         {
            _loc3_.push(_loc2_.id);
         }
         return _loc3_;
      }
      
      public function updateMountLine(param1:*, param2:*, param3:Boolean) : void
      {
         if(!this._hookedComponents[param2.btn_mountItem.name])
         {
            this.uiApi.addComponentHook(param2.btn_mountItem,ComponentHookList.ON_ROLL_OVER);
            this.uiApi.addComponentHook(param2.btn_mountItem,ComponentHookList.ON_ROLL_OUT);
         }
         this._hookedComponents[param2.btn_mountItem.name] = param1;
         if(param1)
         {
            param2.btn_mountItem.selected = param3;
            param2.btn_mountItem.mouseEnabled = true;
            if(param1.modelId == 88 || param1.modelId == 89)
            {
               param2.tx_icon.visible = false;
               param2.tx_icon_back.visible = false;
               param2.tx_icon_up.visible = false;
               param2.tx_iconSpecialMount.visible = true;
               param2.tx_iconSpecialMount.uri = this.uiApi.createUri(this._mountsUri + "head_" + param1.modelId + ".swf",true);
            }
            else if(param1.colors)
            {
               param2.tx_icon.uri = this.uiApi.createUri(this._assetsUri + param1.familyHeadUri + "_trait");
               param2.tx_icon_back.uri = this.uiApi.createUri(this._assetsUri + param1.familyHeadUri + "_color1");
               param2.tx_icon_up.uri = this.uiApi.createUri(this._assetsUri + param1.familyHeadUri + "_color2");
               this.utilApi.changeColor(param2.tx_icon_back,param1.colors[1],1);
               this.utilApi.changeColor(param2.tx_icon_up,param1.colors[2],0);
               param2.tx_icon.visible = true;
               param2.tx_icon_back.visible = true;
               param2.tx_icon_up.visible = true;
               param2.tx_iconSpecialMount.visible = false;
            }
            if(param1.sex)
            {
               param2.tx_sex.themeDataId = "tx_mount_female";
            }
            else
            {
               param2.tx_sex.themeDataId = "tx_mount_male";
            }
            param2.lbl_name.text = param1.name;
            param2.lbl_level.text = param1.level;
         }
         else
         {
            param2.btn_mountItem.mouseEnabled = false;
            param2.btn_mountItem.selected = false;
            param2.tx_icon.visible = false;
            param2.tx_icon_back.visible = false;
            param2.tx_icon_up.visible = false;
            param2.tx_iconSpecialMount.visible = false;
            param2.tx_sex.uri = null;
            param2.lbl_name.text = "";
            param2.lbl_level.text = "";
         }
      }
      
      public function updateInventoryMountLine(param1:*, param2:*, param3:Boolean) : void
      {
         if(!this._hookedComponents[param2.btn_certificateMountItem.name])
         {
            this.uiApi.addComponentHook(param2.btn_certificateMountItem,ComponentHookList.ON_ROLL_OVER);
            this.uiApi.addComponentHook(param2.btn_certificateMountItem,ComponentHookList.ON_ROLL_OUT);
            this.uiApi.addComponentHook(param2.btn_certificateMountItem,ComponentHookList.ON_RIGHT_CLICK);
         }
         this._hookedComponents[param2.btn_certificateMountItem.name] = param1;
         if(param1)
         {
            param2.btn_certificateMountItem.selected = param3;
            param2.btn_certificateMountItem.mouseEnabled = true;
            param2.slot_icon.data = param1;
            param2.slot_icon.visible = true;
            if(this.mountApi.isCertificateValid(param1))
            {
               param2.lbl_name.cssClass = "p";
            }
            else
            {
               param2.lbl_name.cssClass = "malus";
            }
            param2.lbl_name.text = param1.name;
         }
         else
         {
            param2.btn_certificateMountItem.mouseEnabled = false;
            param2.btn_certificateMountItem.selected = false;
            param2.lbl_name.text = "";
            param2.slot_icon.visible = false;
         }
      }
      
      private function sourceSelected(param1:int) : void
      {
         if(this._lastSource != param1)
         {
            this._lastSource = param1;
            _currentSource = param1;
            if(param1 == SOURCE_BARN)
            {
               this.gd_barn.autoSelectMode = 1;
               this.gd_inventory.autoSelectMode = 0;
               this.gd_paddock.autoSelectMode = 0;
            }
            else if(param1 == SOURCE_INVENTORY)
            {
               this.gd_barn.autoSelectMode = 0;
               this.gd_inventory.autoSelectMode = 1;
               this.gd_paddock.autoSelectMode = 0;
            }
            else if(param1 == SOURCE_PADDOCK)
            {
               this.gd_barn.autoSelectMode = 0;
               this.gd_inventory.autoSelectMode = 0;
               this.gd_paddock.autoSelectMode = 1;
            }
            if(param1 == -1)
            {
               this._mount = null;
               this.ctr_btnExchange.visible = false;
               this.ctr_btnStock.visible = false;
               this.ctr_btnPark.visible = false;
               this.ctr_btnEquip.visible = false;
               this.ctr_bgbtntop.visible = false;
               this.ctr_bgbtnbottom.visible = false;
               this._mountInfoUi.visible = false;
            }
            else
            {
               this._mountInfoUi.visible = true;
               this.ctr_btnExchange.visible = true;
               this.ctr_btnStock.visible = true;
               this.ctr_btnPark.visible = true;
               this.ctr_btnEquip.visible = true;
               this.ctr_bgbtntop.visible = true;
               this.ctr_bgbtnbottom.visible = true;
               if(param1 == 0)
               {
                  this.btn_exchange.disabled = false;
                  this.btn_stock.disabled = false;
                  this.btn_park.disabled = false;
                  this.btn_equip.disabled = true;
               }
               else if(param1 == 1)
               {
                  this.btn_exchange.disabled = true;
                  this.btn_stock.disabled = false;
                  this.btn_park.disabled = false;
                  this.btn_equip.disabled = false;
               }
               else if(param1 == 2)
               {
                  this.btn_exchange.disabled = false;
                  this.btn_stock.disabled = true;
                  this.btn_park.disabled = false;
                  this.btn_equip.disabled = false;
               }
               else if(param1 == 3)
               {
                  this.btn_exchange.disabled = false;
                  this.btn_stock.disabled = false;
                  this.btn_park.disabled = true;
                  this.btn_equip.disabled = false;
               }
            }
         }
      }
      
      private function updateBarnFilter() : void
      {
         var _loc3_:int = 0;
         var _loc5_:* = undefined;
         var _loc1_:Array = this._stableFilters.slice();
         var _loc2_:int = this._barnList.length;
         _loc1_ = this.getPertinentFilter(_loc1_);
         var _loc4_:Array = this.getCapacityAndModelFilterInBarn(this._barnList);
         _loc1_ = _loc1_.concat(_loc4_);
         if(this.cb_barn.value)
         {
            _loc5_ = this.cb_barn.value;
            this.cb_barn.dataProvider = _loc1_;
            _loc2_ = _loc1_.length;
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               if(_loc1_[_loc3_].label == _loc5_.label)
               {
                  this.cb_barn.selectedIndex = _loc3_;
                  break;
               }
               _loc3_++;
            }
         }
         else
         {
            this.cb_barn.dataProvider = _loc1_;
         }
         if(this.cb_barn2.value)
         {
            _loc5_ = this.cb_barn2.value;
            this._stableFilter2 = this.createBarnCb(this.cb_barn.value.filterGroup,this._fullDataProvider,this.cb_barn2);
            this.cb_barn2.dataProvider = this._stableFilter2;
            if(_loc5_.filterGroup != -1 && (_loc5_ == this.cb_barn.value || _loc5_.filterGroup == this.cb_barn.value.filterGroup))
            {
               this.cb_barn2.selectedIndex = 0;
            }
            else
            {
               _loc2_ = this._stableFilter2.length;
               _loc3_ = 0;
               while(_loc3_ < _loc2_)
               {
                  if(this._stableFilter2[_loc3_].label == _loc5_.label)
                  {
                     this.cb_barn2.selectedIndex = _loc3_;
                     break;
                  }
                  _loc3_++;
               }
            }
         }
         else
         {
            this.cb_barn2.dataProvider = _loc1_;
            this.cb_barn2.selectedIndex = 0;
         }
         if(this.cb_barn3.value)
         {
            _loc5_ = this.cb_barn3.value;
            this._stableFilter3 = this.createBarnCb(this.cb_barn2.value.filterGroup,this._stableFilter2,this.cb_barn3);
            this.cb_barn3.dataProvider = this._stableFilter3;
            if(_loc5_.filterGroup != -1 && (_loc5_ == this.cb_barn.value || _loc5_.filterGroup == this.cb_barn.value.filterGroup || _loc5_ == this.cb_barn2.value || _loc5_.filterGroup == this.cb_barn2.value.filterGroup))
            {
               this.cb_barn3.selectedIndex = 0;
            }
            else
            {
               _loc2_ = this._stableFilter3.length;
               _loc3_ = 0;
               while(_loc3_ < _loc2_)
               {
                  if(this._stableFilter3[_loc3_].label == _loc5_.label)
                  {
                     this.cb_barn3.selectedIndex = _loc3_;
                     break;
                  }
                  _loc3_++;
               }
            }
         }
         else
         {
            this.cb_barn3.dataProvider = _loc1_;
            this.cb_barn3.selectedIndex = 0;
         }
         this._fullDataProvider = _loc1_;
      }
      
      private function getPertinentFilter(param1:Array, param2:* = null, param3:ComboBox = null) : Array
      {
         var _loc5_:Object = null;
         var _loc6_:Object = null;
         var _loc4_:Array = new Array();
         if(!param3)
         {
            param2 = this._barnList.concat();
         }
         if(param2 <= 0)
         {
            _loc4_.push(this._stableFilters[0]);
            return _loc4_;
         }
         for each(_loc6_ in param1)
         {
            if(param3 && _loc6_.type == param3.value.type)
            {
               _loc4_.push(_loc6_);
            }
            else
            {
               for each(_loc5_ in param2)
               {
                  if(this.mountFilteredBy(_loc5_,_loc6_.type))
                  {
                     _loc4_.push(_loc6_);
                     break;
                  }
               }
            }
         }
         return _loc4_;
      }
      
      private function createBarnCb(param1:int, param2:Array, param3:ComboBox) : Array
      {
         var _loc6_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:* = false;
         var _loc4_:* = this.gd_barn.dataProvider;
         var _loc5_:Array = new Array();
         _loc4_ = new Array();
         if(param3 == this.cb_barn2)
         {
            for each(_loc6_ in this._barnList)
            {
               if(this.mountFilteredBy(_loc6_,this.cb_barn.value.type))
               {
                  _loc4_.push(_loc6_);
               }
            }
         }
         else if(param3 == this.cb_barn3)
         {
            for each(_loc6_ in this._barnList)
            {
               if(this.mountFilter(_loc6_,this.cb_barn.value.type,this.cb_barn2.value.type,MountFilterEnum.MOUNT_ALL,null))
               {
                  _loc4_.push(_loc6_);
               }
            }
         }
         var _loc7_:Array = new Array();
         for each(_loc8_ in param2)
         {
            if(_loc8_.filterGroup == -1 || _loc8_.filterGroup as int != param1 && _loc8_.filterGroup as int != MountFilterGroupEnum.MODEL && _loc8_.filterGroup as int != MountFilterGroupEnum.CAPACITY && _loc8_.filterGroup as int != MountFilterGroupEnum.FAMILY)
            {
               _loc7_.push(_loc8_);
            }
         }
         param2 = _loc7_;
         if(param3)
         {
            _loc9_ = param3 != this.cb_barn;
            _loc5_ = this.getCapacityAndModelFilterInBarn(_loc4_,_loc9_,param3);
         }
         param2 = this.getPertinentFilter(param2,_loc4_,param3);
         param2 = param2.concat(_loc5_);
         return param2;
      }
      
      private function getCapacityAndModelFilterInBarn(param1:*, param2:Boolean = false, param3:ComboBox = null) : Array
      {
         var _loc5_:int = 0;
         var _loc12_:Object = null;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         var _loc4_:int = param1.length;
         var _loc6_:Array = new Array();
         var _loc7_:Array = new Array();
         var _loc8_:Array = new Array();
         if(param2)
         {
            if(this.cb_barn.value.filterGroup == MountFilterGroupEnum.CAPACITY)
            {
               _loc7_.push(this.cb_barn.value.type);
            }
            else if(this.cb_barn.value.filterGroup == MountFilterGroupEnum.MODEL)
            {
               _loc6_.push(this.cb_barn.value.type);
            }
            else if(this.cb_barn.value.filterGroup == MountFilterGroupEnum.FAMILY)
            {
               _loc8_.push(this.cb_barn.value.type);
            }
            if(this.cb_barn2)
            {
               if(this.cb_barn2.value.filterGroup == MountFilterGroupEnum.CAPACITY)
               {
                  _loc7_.push(this.cb_barn2.value.type);
               }
               else if(this.cb_barn2.value.filterGroup == MountFilterGroupEnum.MODEL)
               {
                  _loc6_.push(this.cb_barn2.value.type);
               }
               else if(this.cb_barn2.value.filterGroup == MountFilterGroupEnum.FAMILY)
               {
                  _loc8_.push(this.cb_barn2.value.type);
               }
            }
         }
         var _loc9_:Array = new Array();
         var _loc10_:Array = new Array();
         var _loc11_:Array = new Array();
         if(param3)
         {
            if(param3.value.filterGroup == MountFilterGroupEnum.CAPACITY)
            {
               _loc7_.push(param3.value.type);
               _loc10_.push(param3.value);
            }
            else if(param3.value.filterGroup == MountFilterGroupEnum.MODEL)
            {
               _loc6_.push(param3.value.type);
               _loc9_.push(param3.value);
            }
            else if(param3.value.filterGroup == MountFilterGroupEnum.FAMILY)
            {
               _loc8_.push(param3.value.type);
               _loc11_.push(param3.value);
            }
         }
         _loc5_ = 0;
         while(_loc5_ < _loc4_)
         {
            _loc12_ = param1[_loc5_];
            if(_loc6_.indexOf(-_loc12_.modelId) == -1)
            {
               _loc6_.push(-_loc12_.modelId);
               _loc9_.push({
                  "label":_loc12_.description,
                  "type":-_loc12_.modelId,
                  "filterGroup":MountFilterGroupEnum.MODEL
               });
            }
            if(_loc8_.indexOf(9000 + _loc12_.model.familyId) == -1)
            {
               _loc14_ = _loc12_.model.familyId;
               _loc8_.push(9000 + _loc14_);
               _loc11_.push({
                  "label":this.dataApi.getMountFamilyNameById(_loc14_),
                  "type":9000 + _loc12_.model.familyId,
                  "filterGroup":MountFilterGroupEnum.FAMILY
               });
            }
            _loc13_ = _loc12_.ability.length;
            if(_loc13_)
            {
               _loc15_ = 0;
               while(_loc15_ < _loc13_)
               {
                  if(_loc7_.indexOf(100 + _loc12_.ability[_loc15_].id) == -1)
                  {
                     _loc7_.push(100 + _loc12_.ability[_loc15_].id);
                     _loc10_.push({
                        "label":_loc12_.ability[_loc15_].name,
                        "type":100 + _loc12_.ability[_loc15_].id,
                        "filterGroup":MountFilterGroupEnum.CAPACITY
                     });
                  }
                  _loc15_++;
               }
            }
            _loc5_++;
         }
         if(!param2 || _loc11_.length > 1)
         {
            _loc11_.sort(this.sortLabelAlphabetically);
         }
         else
         {
            _loc11_ = new Array();
         }
         if(!param2 || _loc10_.length > 1)
         {
            _loc10_.sort(this.sortLabelAlphabetically);
         }
         else
         {
            _loc10_ = new Array();
         }
         if(!param2 || _loc9_.length > 1)
         {
            _loc9_.sort(this.sortLabelAlphabetically);
         }
         else
         {
            _loc9_ = new Array();
         }
         return _loc11_.concat(_loc10_.concat(_loc9_));
      }
      
      private function sortLabelAlphabetically(param1:Object, param2:Object) : int
      {
         if(param1.label < param2.label)
         {
            return -1;
         }
         if(param1.label > param2.label)
         {
            return 1;
         }
         return 0;
      }
      
      private function updateBarn(param1:int, param2:int, param3:int) : void
      {
         var _loc8_:MountData = null;
         var _loc4_:String = this.lbl_searchBarn.text;
         var _loc5_:Array = new Array();
         if(this._barnList.length == 0 && _currentSource == SOURCE_BARN)
         {
            this.sourceSelected(-1);
         }
         var _loc6_:int = this._barnList.length;
         var _loc7_:int = 0;
         while(_loc7_ < _loc6_)
         {
            _loc8_ = this._barnList[_loc7_];
            if(this.mountFilter(_loc8_,param1,param2,param3,_loc4_))
            {
               _loc5_.push(_loc8_);
            }
            _loc7_++;
         }
         this.applySort(_loc5_,this._barnSortOrder);
         this.gd_barn.dataProvider = _loc5_;
         this.updateBarnFilter();
         this.lbl_stock.text = this.uiApi.getText("ui.mount.numMountBarn",_loc5_.length + "/" + STABLE_SIZE);
      }
      
      private function updatePaddockFilter() : void
      {
         var _loc10_:MountData = null;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:String = null;
         var _loc15_:int = 0;
         var _loc1_:Array = new Array();
         var _loc2_:Array = new Array();
         var _loc3_:Array = new Array();
         var _loc4_:Array = new Array();
         var _loc5_:Array = new Array();
         var _loc6_:Array = new Array();
         var _loc7_:Array = this._paddockFilters.slice();
         var _loc8_:int = this._paddockList.length;
         var _loc9_:int = 0;
         while(_loc9_ < _loc8_)
         {
            _loc10_ = this._paddockList[_loc9_];
            if(_loc1_.indexOf(_loc10_.modelId) == -1)
            {
               _loc1_.push(_loc10_.modelId);
               _loc4_.push({
                  "label":_loc10_.description,
                  "type":-_loc10_.modelId,
                  "filterGroup":MountFilterGroupEnum.MODEL
               });
            }
            if(_loc3_.indexOf(9000 + _loc10_.model.familyId) == -1)
            {
               _loc12_ = _loc10_.model.familyId;
               _loc3_.push(9000 + _loc12_);
               _loc6_.push({
                  "label":this.dataApi.getMountFamilyNameById(_loc12_),
                  "type":9000 + _loc10_.model.familyId,
                  "filterGroup":MountFilterGroupEnum.FAMILY
               });
            }
            _loc11_ = _loc10_.ability.length;
            if(_loc11_)
            {
               _loc13_ = 0;
               while(_loc13_ < _loc11_)
               {
                  if(_loc2_.indexOf(_loc10_.ability[_loc13_].id) == -1)
                  {
                     _loc2_.push(_loc10_.ability[_loc13_].id);
                     _loc5_.push({
                        "label":_loc10_.ability[_loc13_].name,
                        "type":100 + _loc10_.ability[_loc13_].id,
                        "filterGroup":MountFilterGroupEnum.CAPACITY
                     });
                  }
                  _loc13_++;
               }
            }
            _loc9_++;
         }
         _loc6_.sort(this.sortLabelAlphabetically);
         _loc5_.sort(this.sortLabelAlphabetically);
         _loc4_.sort(this.sortLabelAlphabetically);
         _loc7_ = _loc7_.concat(_loc6_.concat(_loc5_.concat(_loc4_)));
         if(this.cb_paddock.value)
         {
            _loc14_ = this.cb_paddock.value.label;
            _loc8_ = _loc7_.length;
            _loc15_ = 0;
            while(_loc15_ < _loc8_)
            {
               if(_loc7_[_loc15_].label == _loc14_)
               {
                  break;
               }
               _loc15_++;
            }
            this.cb_paddock.dataProvider = _loc7_;
         }
         else
         {
            this.cb_paddock.dataProvider = _loc7_;
         }
      }
      
      private function updatePaddock(param1:int) : void
      {
         var _loc6_:MountData = null;
         var _loc2_:String = this.lbl_searchPaddock.text;
         var _loc3_:Array = new Array();
         if(this._paddockList.length == 0 && _currentSource == SOURCE_PADDOCK)
         {
            this.sourceSelected(-1);
         }
         var _loc4_:int = this._paddockList.length;
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc6_ = this._paddockList[_loc5_];
            if(this.mountFilter(_loc6_,param1,MountFilterEnum.MOUNT_ALL,MountFilterEnum.MOUNT_ALL,_loc2_))
            {
               _loc3_.push(_loc6_);
            }
            _loc5_++;
         }
         this.applySort(_loc3_,this._paddockSortOrder);
         this.gd_paddock.dataProvider = _loc3_;
         this.lbl_park.text = this.uiApi.getText("ui.mount.numMountPaddock",_loc3_.length + "/" + this._maxOutdoorMount);
      }
      
      private function updateInventoryFilter() : void
      {
         var _loc5_:Object = null;
         var _loc6_:String = null;
         var _loc7_:int = 0;
         var _loc1_:Array = new Array();
         var _loc2_:Array = new Array({
            "label":this.uiApi.getText("ui.common.allTypes"),
            "type":""
         });
         var _loc3_:int = this._inventoryList.length;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = this._inventoryList[_loc4_];
            if(_loc1_.indexOf(_loc5_.name) == -1)
            {
               _loc1_.push(_loc5_.name);
               _loc2_.push({
                  "label":_loc5_.name,
                  "type":_loc5_.name
               });
            }
            _loc4_++;
         }
         if(this.cb_inventory.value)
         {
            _loc6_ = this.cb_inventory.value.label;
            _loc3_ = _loc2_.length;
            _loc7_ = 0;
            while(_loc7_ < _loc3_)
            {
               if(_loc2_[_loc7_].label == _loc6_)
               {
                  this.cb_inventory.dataProvider = _loc2_;
                  this.cb_inventory.selectedIndex = _loc7_;
                  break;
               }
               _loc7_++;
            }
         }
         else
         {
            this.cb_inventory.dataProvider = _loc2_;
         }
      }
      
      private function updateInventory(param1:String) : void
      {
         var _loc7_:Object = null;
         var _loc2_:String = this.lbl_searchInventory.text;
         var _loc3_:Array = new Array();
         if(this._inventoryList.length == 0 && _currentSource == SOURCE_INVENTORY)
         {
            this.sourceSelected(-1);
         }
         var _loc4_:int = 0;
         var _loc5_:int = this._inventoryList.length;
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            _loc7_ = this._inventoryList[_loc6_];
            if(param1 == "" || _loc7_.name == param1)
            {
               if(_loc2_ == "" || _loc7_.name.toLowerCase().indexOf(_loc2_.toLowerCase()) != -1)
               {
                  _loc3_.push(_loc7_);
                  _loc4_++;
               }
            }
            _loc6_++;
         }
         this.gd_inventory.dataProvider = _loc3_;
         this.lbl_certificates.text = this.uiApi.getText("ui.mount.numCertificates",_loc4_);
      }
      
      private function mountFilter(param1:Object, param2:int, param3:int, param4:int, param5:String) : Boolean
      {
         if(!this.mountFilteredBy(param1,param2))
         {
            return false;
         }
         if(!this.mountFilteredBy(param1,param3))
         {
            return false;
         }
         if(!this.mountFilteredBy(param1,param4))
         {
            return false;
         }
         if(param5)
         {
            return param1.name.toLowerCase().indexOf(param5.toLowerCase()) != -1;
         }
         return true;
      }
      
      private function mountFilteredBy(param1:Object, param2:int) : Boolean
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         switch(param2)
         {
            case MountFilterEnum.MOUNT_ALL:
               return true;
            case MountFilterEnum.MOUNT_MALE:
               return !param1.sex;
            case MountFilterEnum.MOUNT_FEMALE:
               return param1.sex;
            case MountFilterEnum.MOUNT_FRUITFUL:
               return param1.isFecondationReady;
            case MountFilterEnum.MOUNT_NOFRUITFUL:
               return !param1.isFecondationReady && param1.reproductionCount != -1 && param1.reproductionCount != 20 && param1.level >= 5;
            case MountFilterEnum.MOUNT_FERTILIZED:
               return param1.fecondationTime > 0;
            case MountFilterEnum.MOUNT_BABY:
               return param1.borning;
            case MountFilterEnum.MOUNT_MOUNTABLE:
               return param1.isRideable;
            case MountFilterEnum.MOUNT_NAMELESS:
               return param1.name == this._nameless;
            case MountFilterEnum.MOUNT_SPECIAL:
               return param1.ability.length;
            case MountFilterEnum.MOUNT_TRAINABLE:
               return param1.maturityForAdult && param1.level < 5;
            case MountFilterEnum.MOUNT_100_TIRED:
               return param1.boostLimiter == param1.boostMax;
            case MountFilterEnum.MOUNT_MORE50_TIRED:
               return param1.boostLimiter >= param1.boostMax / 2 && param1.boostLimiter != param1.boostMax;
            case MountFilterEnum.MOUNT_LESS50_TIRED:
               return param1.boostLimiter < param1.boostMax / 2 && param1.boostLimiter != 0;
            case MountFilterEnum.MOUNT_NOTIRED:
               return param1.boostLimiter == 0;
            case MountFilterEnum.MOUNT_STERILIZED:
               return param1.reproductionCount == -1 || param1.reproductionCount == 20;
            case MountFilterEnum.MOUNT_POSITIVE_SERENITY:
               return param1.serenity >= 0;
            case MountFilterEnum.MOUNT_NEGATIVE_SERENITY:
               return param1.serenity < 0;
            case MountFilterEnum.MOUNT_AVERAGE_SERENITY:
               return param1.serenity > -2000 && param1.serenity < 2000;
            case MountFilterEnum.MOUNT_NEED_LOVE:
               return param1.love < 7500;
            case MountFilterEnum.MOUNT_FULL_LOVE:
               return param1.love >= 7500;
            case MountFilterEnum.MOUNT_NEED_STAMINA:
               return param1.stamina < 7500;
            case MountFilterEnum.MOUNT_FULL_STAMINA:
               return param1.stamina >= 7500;
            case MountFilterEnum.MOUNT_IMMATURE:
               return param1.maturity < param1.maturityForAdult;
            case MountFilterEnum.MOUNT_OWNER:
               return param1.ownerId == this.playerApi.id();
            case MountFilterEnum.MOUNT_NEED_ENERGY:
               return param1.isRideable && param1.energy < param1.energyMax;
            case MountFilterEnum.MOUNT_FULL_ENERGY:
               return param1.isRideable && param1.energy >= param1.energyMax;
            default:
               if(param2 < 0)
               {
                  return param1.modelId == -param2;
               }
               if(param2 > 9000)
               {
                  return param1.model.familyId == param2 - 9000;
               }
               if(param2 > 100)
               {
                  _loc3_ = param1.ability.length;
                  if(_loc3_)
                  {
                     _loc4_ = 0;
                     while(_loc4_ < _loc3_)
                     {
                        if(param1.ability[_loc4_].id == param2 - 100)
                        {
                           return true;
                        }
                        _loc4_++;
                     }
                  }
               }
               return false;
         }
      }
      
      private function searchSource(param1:int) : uint
      {
         var _loc2_:Object = null;
         var _loc3_:Object = null;
         if(this.playerApi.getMount() && this.playerApi.getMount().id == param1)
         {
            return SOURCE_EQUIP;
         }
         for each(_loc2_ in this.gd_paddock.dataProvider)
         {
            if(_loc2_.id == param1)
            {
               return SOURCE_PADDOCK;
            }
         }
         for each(_loc3_ in this.gd_barn.dataProvider)
         {
            if(_loc3_.id == param1)
            {
               return SOURCE_BARN;
            }
         }
         return SOURCE_INVENTORY;
      }
      
      private function moveMount(param1:int, param2:int) : void
      {
         switch(param2)
         {
            case SOURCE_PADDOCK:
               switch(param1)
               {
                  case SOURCE_EQUIP:
                     this.sysApi.sendAction(new ExchangeHandleMountStable(ExchangeHandleMountStableTypeEnum.EXCHANGE_EQUIPED_MOUNTPADDOCK_PUT,[this._mount.id]));
                     this.sourceSelected(-1);
                     break;
                  case SOURCE_INVENTORY:
                     this.sysApi.sendAction(new ExchangeHandleMountStable(ExchangeHandleMountStableTypeEnum.EXCHANGE_UNCERTIF_TO_PADDOCK,[this.gd_inventory.selectedItem.objectUID]));
                     this.sourceSelected(-1);
                     break;
                  case SOURCE_BARN:
                     this.sysApi.sendAction(new ExchangeHandleMountStable(ExchangeHandleMountStableTypeEnum.EXCHANGE_MOUNTPADDOCK_PUT,[this._mount.id]));
                     this.sourceSelected(-1);
               }
               break;
            case SOURCE_BARN:
               switch(param1)
               {
                  case SOURCE_PADDOCK:
                     this.sysApi.sendAction(new ExchangeHandleMountStable(ExchangeHandleMountStableTypeEnum.EXCHANGE_MOUNTPADDOCK_GET,[this._mount.id]));
                     this.sourceSelected(-1);
                     break;
                  case SOURCE_EQUIP:
                     this.sysApi.sendAction(new ExchangeHandleMountStable(ExchangeHandleMountStableTypeEnum.EXCHANGE_MOUNTSTABLES_PUT,[this._mount.id]));
                     this.sourceSelected(-1);
                     break;
                  case SOURCE_INVENTORY:
                     this.sysApi.sendAction(new ExchangeHandleMountStable(ExchangeHandleMountStableTypeEnum.EXCHANGE_MOUNTSTABLES_UNCERTIF,[this.gd_inventory.selectedItem.objectUID]));
                     this.sourceSelected(-1);
               }
               break;
            case SOURCE_INVENTORY:
               switch(param1)
               {
                  case SOURCE_PADDOCK:
                     this.sysApi.sendAction(new ExchangeHandleMountStable(ExchangeHandleMountStableTypeEnum.EXCHANGE_MOUNTPADDOCK_CERTIF,[this._mount.id]));
                     this.sourceSelected(-1);
                     break;
                  case SOURCE_BARN:
                     this.sysApi.sendAction(new ExchangeHandleMountStable(ExchangeHandleMountStableTypeEnum.EXCHANGE_MOUNTSTABLES_CERTIF,[this._mount.id]));
                     this.sourceSelected(-1);
                     break;
                  case SOURCE_EQUIP:
                     if(this._mount)
                     {
                        this.sysApi.sendAction(new ExchangeHandleMountStable(ExchangeHandleMountStableTypeEnum.EXCHANGE_EQUIPED_CERTIF,[this._mount.id]));
                        this.sourceSelected(-1);
                     }
               }
               break;
            case SOURCE_EQUIP:
               switch(param1)
               {
                  case SOURCE_PADDOCK:
                     this.sysApi.sendAction(new ExchangeHandleMountStable(ExchangeHandleMountStableTypeEnum.EXCHANGE_EQUIPED_MOUNTPADDOCK_GET,[this._mount.id]));
                     this.sourceSelected(-1);
                     break;
                  case SOURCE_BARN:
                     this.sysApi.sendAction(new ExchangeHandleMountStable(ExchangeHandleMountStableTypeEnum.EXCHANGE_MOUNTSTABLES_GET,[this._mount.id]));
                     this.sourceSelected(-1);
                     break;
                  case SOURCE_INVENTORY:
                     this.sysApi.sendAction(new ExchangeHandleMountStable(ExchangeHandleMountStableTypeEnum.EXCHANGE_UNCERTIF_TO_EQUIPED,[this.gd_inventory.selectedItem.objectUID]));
                     this.sourceSelected(-1);
               }
         }
      }
      
      private function addAndRemoveFilter(param1:Boolean, param2:String) : void
      {
         if(param1)
         {
            if(!this.cb_barn2.visible)
            {
               this.cb_barn2.visible = true;
               this.bgcb_barn2.visible = true;
               this.gd_barn.height = 270;
               this.gd_barn.dataProvider = this.gd_barn.dataProvider;
               this.ctr_barn.y = this.uiApi.me().getConstant("ctr_barn2FilterY");
               this.btn_addFilter.visible = true;
               this.btn_removeFilter2.visible = true;
               this.btn_removeFilter1.visible = true;
            }
            else if(!this.cb_barn3.visible)
            {
               this.cb_barn3.visible = true;
               this.bgcb_barn3.visible = true;
               this.gd_barn.height = 240;
               this.gd_barn.dataProvider = this.gd_barn.dataProvider;
               this.btn_addFilter.visible = false;
               this.btn_removeFilter3.visible = true;
               this.btn_removeFilter1.visible = true;
               this.ctr_barn.y = this.uiApi.me().getConstant("ctr_barn3FilterY");
            }
         }
         else if(param2 == "btn_removeFilter1")
         {
            if(this.cb_barn3.visible && this.cb_barn2.visible)
            {
               this.cb_barn.selectedIndex = this.findFilterIndex(this.cb_barn,this.cb_barn2.selectedItem.label);
               this.cb_barn2.selectedIndex = this.findFilterIndex(this.cb_barn2,this.cb_barn3.selectedItem.label);
               this.cb_barn3.visible = false;
               this.bgcb_barn3.visible = false;
               this.cb_barn3.selectedIndex = 0;
               this.gd_barn.height = 270;
               this.ctr_barn.y = this.uiApi.me().getConstant("ctr_barn2FilterY");
               this.gd_barn.dataProvider = this.gd_barn.dataProvider;
               this.btn_addFilter.visible = true;
               this.btn_removeFilter3.visible = false;
            }
            else if(this.cb_barn2.visible)
            {
               this.cb_barn2.visible = false;
               this.bgcb_barn2.visible = false;
               this.cb_barn.selectedIndex = this.findFilterIndex(this.cb_barn,this.cb_barn2.selectedItem.label);
               this.cb_barn2.selectedIndex = 0;
               this.gd_barn.height = 300;
               this.gd_barn.dataProvider = this.gd_barn.dataProvider;
               this.ctr_barn.y = this.uiApi.me().getConstant("ctr_barn1FilterY");
               this.btn_addFilter.visible = true;
               this.btn_removeFilter2.visible = false;
               this.btn_removeFilter1.visible = false;
            }
         }
         else if(param2 == "btn_removeFilter2")
         {
            if(this.cb_barn3.visible)
            {
               this.cb_barn2.selectedIndex = this.findFilterIndex(this.cb_barn2,this.cb_barn3.selectedItem.label);
               this.cb_barn3.visible = false;
               this.bgcb_barn3.visible = false;
               this.cb_barn3.selectedIndex = 0;
               this.gd_barn.height = 270;
               this.gd_barn.dataProvider = this.gd_barn.dataProvider;
               this.ctr_barn.y = this.uiApi.me().getConstant("ctr_barn2FilterY");
               this.btn_addFilter.visible = true;
               this.btn_removeFilter3.visible = false;
            }
            else
            {
               this.cb_barn2.visible = false;
               this.bgcb_barn2.visible = false;
               this.cb_barn2.selectedIndex = 0;
               this.gd_barn.height = 300;
               this.gd_barn.dataProvider = this.gd_barn.dataProvider;
               this.ctr_barn.y = this.uiApi.me().getConstant("ctr_barn1FilterY");
               this.btn_addFilter.visible = true;
               this.btn_removeFilter2.visible = false;
               this.btn_removeFilter1.visible = false;
            }
         }
         else if(param2 == "btn_removeFilter3")
         {
            this.cb_barn3.visible = false;
            this.bgcb_barn3.visible = false;
            this.cb_barn3.selectedIndex = 0;
            this.gd_barn.height = 270;
            this.gd_barn.dataProvider = this.gd_barn.dataProvider;
            this.ctr_barn.y = this.uiApi.me().getConstant("ctr_barn2FilterY");
            this.btn_addFilter.visible = true;
            this.btn_removeFilter3.visible = false;
         }
         if(this.cb_barn3.visible)
         {
            this.ctr_barn.height = this.uiApi.me().getConstant("ctr_barn3FilterHeight");
         }
         else if(this.cb_barn2.visible)
         {
            this.ctr_barn.height = this.uiApi.me().getConstant("ctr_barn2FilterHeight");
         }
         else
         {
            this.ctr_barn.height = this.uiApi.me().getConstant("ctr_barn1FilterHeight");
         }
         this.uiApi.me().render();
      }
      
      private function findFilterIndex(param1:ComboBox, param2:String) : int
      {
         var _loc3_:int = 0;
         _loc3_ = 0;
         while(_loc3_ < param1.dataProvider.length)
         {
            if(param1.dataProvider[_loc3_].label == param2)
            {
               break;
            }
            _loc3_++;
         }
         return _loc3_;
      }
      
      private function onCertificateMountData(param1:Object) : void
      {
         var _loc2_:int = this.searchSource(param1.id);
         this.showMountInfo(param1,_loc2_);
         this.sourceSelected(_loc2_);
      }
      
      private function onMountStableUpdate(param1:Object, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:MountData = null;
         var _loc8_:String = null;
         var _loc9_:int = 0;
         if(param1)
         {
            this._barnList = new Array();
            for each(_loc7_ in param1)
            {
               this._barnList.push(_loc7_);
            }
            _loc4_ = this.cb_barn.value.type;
            _loc5_ = this.cb_barn2.value.type;
            _loc6_ = this.cb_barn3.value.type;
            this.updateBarnFilter();
            this.updateBarn(_loc4_,_loc5_,_loc6_);
         }
         if(param2)
         {
            this._paddockList = new Array();
            for each(_loc7_ in param2)
            {
               this._paddockList.push(_loc7_);
            }
            _loc4_ = this.cb_paddock.value.type;
            this.updatePaddockFilter();
            this.updatePaddock(_loc4_);
         }
         if(param3)
         {
            this._inventoryList = param3;
            _loc8_ = this.cb_inventory.value.type;
            this.updateInventoryFilter();
            this.updateInventory(_loc8_);
         }
         if(this._mount)
         {
            _loc9_ = this.searchSource(this._mount.id);
            if(_loc9_ == SOURCE_PADDOCK)
            {
               this.gd_paddock.selectedItem = this._mount;
            }
            else if(_loc9_ == SOURCE_BARN)
            {
               this.gd_barn.selectedItem = this._mount;
            }
            this.showMountInfo(this._mount,_loc9_);
         }
      }
      
      public function onUiLoaded(param1:String) : void
      {
         if(param1 == UIEnum.MOUNT_INFO)
         {
            this._mountInfoUiLoaded = true;
            this.sysApi.removeHook(UiLoaded);
            this._mountInfoUi = this.uiApi.getUi(UIEnum.MOUNT_INFO);
            this.showMountInfo(this._mount,_currentSource);
         }
      }
      
      public function onSelectItem(param1:Object, param2:uint, param3:Boolean) : void
      {
         switch(param1)
         {
            case this.gd_barn:
               if(this.gd_barn.selectedIndex != -1)
               {
                  if(this.gd_paddock.selectedIndex != -1)
                  {
                     this.gd_paddock.selectedIndex = -1;
                  }
                  if(this.gd_inventory.selectedIndex != -1)
                  {
                     this.gd_inventory.selectedIndex = -1;
                  }
                  if(param2 == 1)
                  {
                     this.sysApi.sendAction(new ExchangeHandleMountStable(6,[this.gd_barn.selectedItem.id]));
                  }
                  else if(this.gd_barn.selectedItem)
                  {
                     this.showMountInfo(this.gd_barn.selectedItem,2);
                     this.sourceSelected(2);
                  }
                  else
                  {
                     this.sourceSelected(-1);
                  }
               }
               break;
            case this.gd_paddock:
               if(this.gd_paddock.selectedIndex != -1)
               {
                  if(this.gd_barn.selectedIndex != -1)
                  {
                     this.gd_barn.selectedIndex = -1;
                  }
                  if(this.gd_inventory.selectedIndex != -1)
                  {
                     this.gd_inventory.selectedIndex = -1;
                  }
                  if(param2 == 1)
                  {
                     this.sysApi.sendAction(new ExchangeHandleMountStable(7,[this.gd_paddock.selectedItem.id]));
                  }
                  else if(this.gd_paddock.selectedItem)
                  {
                     this.showMountInfo(this.gd_paddock.selectedItem,3);
                     this.sourceSelected(3);
                  }
                  else
                  {
                     this.sourceSelected(-1);
                  }
               }
               break;
            case this.gd_inventory:
               if(this.gd_inventory.selectedIndex != -1)
               {
                  if(this.gd_barn.selectedIndex != -1)
                  {
                     this.gd_barn.selectedIndex = -1;
                  }
                  if(this.gd_paddock.selectedIndex != -1)
                  {
                     this.gd_paddock.selectedIndex = -1;
                  }
                  if(param2 == 1)
                  {
                     this.sysApi.sendAction(new ExchangeHandleMountStable(5,[this.gd_inventory.selectedItem.objectUID]));
                     this.gd_inventory.selectedIndex = this.gd_inventory.getIndex() - 1;
                  }
                  else if(this.mountApi.isCertificateValid(this.gd_inventory.selectedItem))
                  {
                     this.sysApi.sendAction(new MountInfoRequest(this.gd_inventory.selectedItem));
                  }
                  else if(param2 != SelectMethodEnum.AUTO)
                  {
                     this.sourceSelected(-1);
                     this.modCommon.openPopup(this.uiApi.getText("ui.popup.warning"),this.uiApi.getText("ui.mount.invalidCertificate"),[this.uiApi.getText("ui.common.ok")]);
                  }
               }
               break;
            case this.cb_barn:
               if(!param3)
               {
                  break;
               }
               this.updateBarn(this.cb_barn.value.type,this.cb_barn2.value.type,this.cb_barn3.value.type);
               break;
            case this.cb_barn2:
               if(!param3)
               {
                  break;
               }
               this.updateBarn(this.cb_barn.value.type,this.cb_barn2.value.type,this.cb_barn3.value.type);
               break;
            case this.cb_barn3:
               if(!param3)
               {
                  break;
               }
               this.updateBarn(this.cb_barn.value.type,this.cb_barn2.value.type,this.cb_barn3.value.type);
               break;
            case this.cb_paddock:
               this.updatePaddock(param1.value.type);
               break;
            case this.cb_inventory:
               this.updateInventory(param1.value.type);
         }
      }
      
      public function onRollOver(param1:Object) : void
      {
         var _loc2_:* = null;
         var _loc4_:Object = null;
         var _loc5_:ItemTooltipSettings = null;
         var _loc6_:Object = null;
         var _loc7_:* = null;
         var _loc3_:String = "p";
         if(param1 == this.btn_moveAllFromBarn || param1 == this.btn_moveAllFromInventory || param1 == this.btn_moveAllFromPark)
         {
            _loc2_ = this.uiApi.getText("ui.storage.advancedTransferts");
         }
         else
         {
            if(param1.name.indexOf("btn_mountItem") != -1)
            {
               _loc4_ = this._hookedComponents[param1.name];
               if(!_loc4_)
               {
                  return;
               }
               if(_loc4_.reproductionCount == -1)
               {
                  _loc3_ = "red";
                  _loc2_ = this.uiApi.getText("ui.mount.castrated");
               }
               else if(_loc4_.reproductionCount == 20)
               {
                  _loc3_ = "red";
                  _loc2_ = this.uiApi.getText("ui.mount.sterilized");
               }
               else if(_loc4_.fecondationTime > 0)
               {
                  _loc3_ = "exotic";
                  _loc2_ = this.uiApi.getText("ui.mount.fecondee") + " (" + _loc4_.fecondationTime + " " + this.uiApi.processText(this.uiApi.getText("ui.time.hours"),"m",_loc4_.fecondationTime == 1) + ")";
               }
               else if(_loc4_.isFecondationReady)
               {
                  _loc3_ = "bonus";
                  _loc2_ = this.uiApi.getText("ui.mount.fecondable");
               }
               if(_loc2_)
               {
                  this.uiApi.showTooltip(_loc2_,param1,false,"standard",6,0,3,"text",null,{
                     "css":"[local.css]normal2.css",
                     "classCss":_loc3_
                  });
               }
               return;
            }
            if(param1.name.indexOf("btn_certificateMountItem") != -1)
            {
               _loc4_ = this._hookedComponents[param1.name];
               if(!_loc4_)
               {
                  return;
               }
               _loc5_ = this.sysApi.getData("itemTooltipSettings",DataStoreEnum.BIND_ACCOUNT) as ItemTooltipSettings;
               if(!_loc5_)
               {
                  _loc5_ = this.tooltipApi.createItemSettings();
                  this.sysApi.setData("itemTooltipSettings",_loc5_,DataStoreEnum.BIND_ACCOUNT);
               }
               _loc6_ = new Object();
               for(_loc7_ in _loc5_)
               {
                  if(!_loc6_.hasOwnProperty(_loc7_))
                  {
                     _loc6_[_loc7_] = _loc5_[_loc7_];
                  }
               }
               this.uiApi.showTooltip(_loc4_,param1,false,"standard",6,0,0,"itemName",null,_loc6_,"ItemInfo");
               return;
            }
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
      
      public function onRelease(param1:Object) : void
      {
         var _loc2_:Array = null;
         var _loc4_:Array = null;
         var _loc5_:Array = null;
         var _loc6_:* = undefined;
         var _loc7_:Array = null;
         var _loc3_:* = false;
         switch(param1)
         {
            case this.ctr_mountEquiped:
               this.showCurrentMountInfo();
               break;
            case this.btn_stock:
               this.moveMount(_currentSource,SOURCE_BARN);
               break;
            case this.btn_park:
               this.moveMount(_currentSource,SOURCE_PADDOCK);
               break;
            case this.btn_equip:
               this.moveMount(_currentSource,SOURCE_EQUIP);
               break;
            case this.btn_exchange:
               this.moveMount(_currentSource,SOURCE_INVENTORY);
               break;
            case this.btn_close:
               this.hideUi();
               break;
            case this.btn_searchBarn:
               if(this.ctr_searchBarn.visible)
               {
                  this.ctr_searchBarn.visible = false;
                  this.cb_barn.visible = true;
                  this.lbl_searchBarn.text = "";
               }
               else
               {
                  this.ctr_searchBarn.visible = true;
                  this.cb_barn.visible = false;
                  this.lbl_searchBarn.text = "";
                  this.lbl_searchBarn.focus();
               }
               this.updateBarn(this.cb_barn.value.type,this.cb_barn2.value.type,this.cb_barn3.value.type);
               break;
            case this.btn_searchPaddock:
               if(this.ctr_searchPaddock.visible)
               {
                  this.ctr_searchPaddock.visible = false;
                  this.cb_paddock.visible = true;
                  this.lbl_searchPaddock.text = "";
               }
               else
               {
                  this.ctr_searchPaddock.visible = true;
                  this.cb_paddock.visible = false;
                  this.lbl_searchPaddock.text = "";
                  this.lbl_searchPaddock.focus();
               }
               this.updatePaddock(this.cb_paddock.value.type);
               break;
            case this.btn_searchInventory:
               if(this.ctr_searchInventory.visible)
               {
                  this.ctr_searchInventory.visible = false;
                  this.cb_inventory.visible = true;
                  this.lbl_searchInventory.text = "";
               }
               else
               {
                  this.ctr_searchInventory.visible = true;
                  this.cb_inventory.visible = false;
                  this.lbl_searchInventory.text = "";
                  this.lbl_searchInventory.focus();
               }
               this.updateInventory(this.cb_inventory.value.type);
               break;
            case this.btn_barnType:
               switchSort(this._barnSortOrder,SORT_TYPE_TYPE);
               this.updateBarn(this.cb_barn.value.type,this.cb_barn2.value.type,this.cb_barn3.value.type);
               break;
            case this.btn_barnGender:
               switchSort(this._barnSortOrder,SORT_TYPE_GENDER);
               this.updateBarn(this.cb_barn.value.type,this.cb_barn2.value.type,this.cb_barn3.value.type);
               break;
            case this.btn_barnName:
               switchSort(this._barnSortOrder,SORT_TYPE_NAME);
               this.updateBarn(this.cb_barn.value.type,this.cb_barn2.value.type,this.cb_barn3.value.type);
               break;
            case this.btn_barnLevel:
               switchSort(this._barnSortOrder,SORT_TYPE_LEVEL);
               this.updateBarn(this.cb_barn.value.type,this.cb_barn2.value.type,this.cb_barn3.value.type);
               break;
            case this.btn_paddockType:
               switchSort(this._paddockSortOrder,SORT_TYPE_TYPE);
               this.updatePaddock(this.cb_paddock.value.type);
               break;
            case this.btn_paddockGender:
               switchSort(this._paddockSortOrder,SORT_TYPE_GENDER);
               this.updatePaddock(this.cb_paddock.value.type);
               break;
            case this.btn_paddockName:
               switchSort(this._paddockSortOrder,SORT_TYPE_NAME);
               this.updatePaddock(this.cb_paddock.value.type);
               break;
            case this.btn_paddockLevel:
               switchSort(this._paddockSortOrder,SORT_TYPE_LEVEL);
               this.updatePaddock(this.cb_paddock.value.type);
               break;
            case this.btn_addFilter:
               this.addAndRemoveFilter(true,param1.name);
               break;
            case this.btn_removeFilter1:
            case this.btn_removeFilter2:
            case this.btn_removeFilter3:
               this.addAndRemoveFilter(false,param1.name);
               break;
            case this.btn_moveAllFromBarn:
               _loc2_ = new Array();
               _loc4_ = this.getAllMountIdsInGrid(this.gd_barn.dataProvider);
               _loc3_ = _loc4_.length <= 0;
               _loc2_.push(this.modContextMenu.createContextMenuItemObject(this.uiApi.getText("ui.mount.transfertAllToPaddock"),this.sysApi.sendAction,[new ExchangeHandleMountStable(ExchangeHandleMountStableTypeEnum.EXCHANGE_MOUNTPADDOCK_PUT,_loc4_)],_loc3_,null,false,true));
               _loc2_.push(this.modContextMenu.createContextMenuItemObject(this.uiApi.getText("ui.mount.transfertAllToInventory"),this.sysApi.sendAction,[new ExchangeHandleMountStable(ExchangeHandleMountStableTypeEnum.EXCHANGE_MOUNTSTABLES_CERTIF,_loc4_)],_loc3_,null,false,true));
               this.modContextMenu.createContextMenu(_loc2_);
               break;
            case this.btn_moveAllFromPark:
               _loc2_ = new Array();
               _loc5_ = this.getAllMountIdsInGrid(this.gd_paddock.dataProvider);
               _loc3_ = _loc5_.length <= 0;
               _loc2_.push(this.modContextMenu.createContextMenuItemObject(this.uiApi.getText("ui.mount.transfertAllToBarn"),this.sysApi.sendAction,[new ExchangeHandleMountStable(ExchangeHandleMountStableTypeEnum.EXCHANGE_MOUNTPADDOCK_GET,_loc5_)],_loc3_,null,false,true));
               _loc2_.push(this.modContextMenu.createContextMenuItemObject(this.uiApi.getText("ui.mount.transfertAllToInventory"),this.sysApi.sendAction,[new ExchangeHandleMountStable(ExchangeHandleMountStableTypeEnum.EXCHANGE_MOUNTPADDOCK_CERTIF,_loc5_)],_loc3_,null,false,true));
               this.modContextMenu.createContextMenu(_loc2_);
               break;
            case this.btn_moveAllFromInventory:
               _loc2_ = new Array();
               _loc7_ = new Array();
               for each(_loc6_ in this.gd_inventory.dataProvider)
               {
                  if(this.mountApi.isCertificateValid(_loc6_))
                  {
                     _loc7_.push(_loc6_.objectUID);
                  }
               }
               _loc3_ = _loc7_.length <= 0;
               _loc2_.push(this.modContextMenu.createContextMenuItemObject(this.uiApi.getText("ui.mount.transfertAllToBarn"),this.sysApi.sendAction,[new ExchangeHandleMountStable(ExchangeHandleMountStableTypeEnum.EXCHANGE_MOUNTSTABLES_UNCERTIF,_loc7_)],_loc3_,null,false,true));
               _loc2_.push(this.modContextMenu.createContextMenuItemObject(this.uiApi.getText("ui.mount.transfertAllToPaddock"),this.sysApi.sendAction,[new ExchangeHandleMountStable(ExchangeHandleMountStableTypeEnum.EXCHANGE_UNCERTIF_TO_PADDOCK,_loc7_)],_loc3_,null,false,true));
               this.modContextMenu.createContextMenu(_loc2_);
               break;
            case this.btn_barnCloseSearch:
               this.lbl_searchBarn.text = "";
               this.updateBarn(this.cb_barn.value.type,this.cb_barn2.value.type,this.cb_barn3.value.type);
               break;
            case this.btn_paddockCloseSearch:
               this.lbl_searchPaddock.text = "";
               this.updatePaddock(this.cb_paddock.value.type);
               break;
            case this.btn_inventoryCloseSearch:
               this.lbl_searchInventory.text = "";
               this.updateInventory(this.cb_inventory.value.type);
         }
      }
      
      public function onRightClick(param1:Object) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Object = null;
         if(param1.name.indexOf("btn_certificateMountItem") != -1)
         {
            _loc2_ = this._hookedComponents[param1.name];
            _loc3_ = this.menuApi.create(_loc2_);
            if(_loc3_.content.length > 0)
            {
               this.modContextMenu.createContextMenu(_loc3_);
            }
         }
      }
      
      public function onKeyUp(param1:Object, param2:uint) : void
      {
         if(this.lbl_searchBarn.haveFocus)
         {
            this.updateBarn(this.cb_barn.value.type,this.cb_barn2.value.type,this.cb_barn3.value.type);
         }
         else if(this.lbl_searchPaddock.haveFocus)
         {
            this.updatePaddock(this.cb_paddock.value.type);
         }
         else if(this.lbl_searchInventory.haveFocus)
         {
            this.updateInventory(this.cb_inventory.value.type);
         }
      }
      
      public function updateFilterLine(param1:*, param2:*, param3:Boolean) : void
      {
         if(param1)
         {
            param2.lbl_filterName.text = param1.label;
            switch(param1.filterGroup)
            {
               case MountFilterGroupEnum.MODEL:
                  param2.lbl_filterName.cssClass = "exotic";
                  break;
               case MountFilterGroupEnum.CAPACITY:
                  param2.lbl_filterName.cssClass = "bonus";
                  break;
               case MountFilterGroupEnum.FAMILY:
                  param2.lbl_filterName.cssClass = "orange";
                  break;
               default:
                  param2.lbl_filterName.cssClass = "p";
            }
         }
      }
      
      private function onShortCut(param1:String) : Boolean
      {
         if(!this.mainCtr.visible)
         {
            return false;
         }
         switch(param1)
         {
            case ShortcutHookListEnum.CLOSE_UI:
               this.hideUi();
               return true;
            case SHORTCUT_STOCK:
               this.moveMount(_currentSource,SOURCE_BARN);
               return true;
            case SHORTCUT_PARK:
               this.moveMount(_currentSource,SOURCE_PADDOCK);
               return true;
            case SHORTCUT_EQUIP:
               this.moveMount(_currentSource,SOURCE_EQUIP);
               return true;
            case SHORTCUT_EXCHANGE:
               this.moveMount(_currentSource,SOURCE_INVENTORY);
               return true;
            default:
               return false;
         }
      }
      
      private function onMountRenamed(param1:int, param2:String) : void
      {
         if(this.playerApi.getMount() && this.playerApi.getMount().id == param1)
         {
            this.showPlayerMountInfo();
         }
      }
      
      private function onMountReleased(param1:Number) : void
      {
         if(this._mount && this._mount.id == param1)
         {
            this.sourceSelected(-1);
         }
      }
      
      private function applySort(param1:Array, param2:Array) : void
      {
         this._lastSortOptions = param2;
         param1.sort(this.sortFunction);
      }
      
      public function sortFunction(param1:Object, param2:Object) : int
      {
         var _loc3_:Object = null;
         for each(_loc3_ in this._lastSortOptions)
         {
            switch(_loc3_.type)
            {
               case SORT_TYPE_TYPE:
                  if(param1.description < param2.description)
                  {
                     return !!_loc3_.asc?-1:1;
                  }
                  if(param1.description > param2.description)
                  {
                     return !!_loc3_.asc?1:-1;
                  }
                  continue;
               case SORT_TYPE_GENDER:
                  if(param1.sex < param2.sex)
                  {
                     return !!_loc3_.asc?-1:1;
                  }
                  if(param1.sex > param2.sex)
                  {
                     return !!_loc3_.asc?1:-1;
                  }
                  continue;
               case SORT_TYPE_NAME:
                  if(param1.name < param2.name)
                  {
                     return !!_loc3_.asc?-1:1;
                  }
                  if(param1.name > param2.name)
                  {
                     return !!_loc3_.asc?1:-1;
                  }
                  continue;
               case SORT_TYPE_LEVEL:
                  if(param1.level < param2.level)
                  {
                     return !!_loc3_.asc?-1:1;
                  }
                  if(param1.level > param2.level)
                  {
                     return !!_loc3_.asc?1:-1;
                  }
                  continue;
               default:
                  continue;
            }
         }
         return 0;
      }
   }
}
