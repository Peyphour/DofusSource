package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.ComboBox;
   import com.ankamagames.berilia.components.Grid;
   import com.ankamagames.berilia.components.Input;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofus.uiApi.UtilApi;
   import com.ankamagames.dofusModuleLibrary.enum.components.GridItemSelectMethodEnum;
   import d2actions.OpenInventory;
   import d2enums.ComponentHookList;
   import d2enums.DataStoreEnum;
   import flash.events.TimerEvent;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   
   public class AdminSelectItem
   {
      
      private static const RESOURCE_ITEM:uint = 0;
      
      private static const RESOURCE_MONSTER:uint = 1;
      
      private static const RESOURCE_LOOK:uint = 2;
      
      private static const RESOURCE_FIREWORKS:uint = 3;
      
      private static const RESOURCE_SPELL:uint = 4;
      
      private static var _itemsCached:Array = [];
      
      private static var _typesCached:Array = [];
      
      private static var _iconUri:Dictionary = new Dictionary();
       
      
      public var uiApi:UiApi;
      
      public var dataApi:DataApi;
      
      public var sysApi:SystemApi;
      
      public var utilApi:UtilApi;
      
      public var btnClose:ButtonContainer;
      
      public var btnSearch:ButtonContainer;
      
      public var searchCtr:GraphicContainer;
      
      public var lblTitle:Label;
      
      public var searchInput:Input;
      
      public var cbFilter:ComboBox;
      
      public var grid:Grid;
      
      private var _items:Array;
      
      private var _types:Array;
      
      private var _searchTimer:Timer;
      
      private var _nonFilteredDataProvider:Array;
      
      private var _callback:Function;
      
      private var _tmp:Object;
      
      private var _tmpTypes:Array;
      
      private var _parsedItems:uint;
      
      private var _title:String;
      
      private var _resourceType:uint;
      
      private var _iconBaseUri:String;
      
      private var _iconType:String = ".png";
      
      private var _openInventory:Boolean;
      
      private var _providerFct:Function;
      
      public function AdminSelectItem()
      {
         this._searchTimer = new Timer(200,1);
         super();
      }
      
      public function main(param1:Array) : void
      {
         this._callback = param1[0];
         this.lblTitle.text = param1[1];
         this._title = param1[1];
         this._openInventory = param1[2];
         if(param1[1].indexOf("#monster") != -1)
         {
            this._resourceType = RESOURCE_MONSTER;
         }
         else if(param1[1].indexOf("#item") != -1)
         {
            this._resourceType = RESOURCE_ITEM;
         }
         else if(param1[1].indexOf("#fireworks") != -1)
         {
            this._resourceType = RESOURCE_FIREWORKS;
         }
         else if(param1[1].indexOf("#look") != -1)
         {
            this._resourceType = RESOURCE_LOOK;
         }
         else if(param1[1].indexOf("#spell") != -1)
         {
            this._resourceType = RESOURCE_SPELL;
         }
         switch(this._resourceType)
         {
            case RESOURCE_ITEM:
            case RESOURCE_FIREWORKS:
               this._iconBaseUri = this.sysApi.getConfigKey("gfx.path.item.bitmap");
               this._providerFct = this.dataApi.getItems;
               break;
            case RESOURCE_SPELL:
               this._iconBaseUri = this.sysApi.getConfigKey("content.path").concat("gfx/spells/all.swf|sort_");
               this._providerFct = this.dataApi.getSpells;
               this._iconType = "";
               break;
            case RESOURCE_LOOK:
            case RESOURCE_MONSTER:
               this._iconBaseUri = "pak://ui/Ankama_Admin/resources/monsterIcons.d2p|";
               this._providerFct = this.dataApi.getMonsters;
         }
         if(!_iconUri[this._resourceType])
         {
            _iconUri[this._resourceType] = new Dictionary();
         }
         this._items = _itemsCached[this._resourceType];
         this._types = _typesCached[this._resourceType];
         if(!this._items)
         {
            this._types = _typesCached[this._resourceType] = new Array();
            this._items = _itemsCached[this._resourceType] = new Array();
            this._tmp = this._providerFct();
            this._tmpTypes = [];
            this.sysApi.addEventListener(this.parseItems,"parseItems");
            this.parseItems();
         }
         else
         {
            this.init();
         }
      }
      
      public function updateItemLine(param1:*, param2:*, param3:Boolean) : void
      {
         if(param1)
         {
            if(!_iconUri[this._resourceType][param1.id])
            {
               _iconUri[this._resourceType][param1.id] = this.uiApi.createUri(this._iconBaseUri + param1.iconId + this._iconType);
            }
            param2.itemIcon.uri = _iconUri[this._resourceType][param1.id];
            param2.itemName.text = param1.name;
         }
         else
         {
            param2.itemIcon.uri = null;
            param2.itemName.text = "";
         }
      }
      
      private function init() : void
      {
         this.cbFilter.dataProvider = this._types;
         this.cbFilter.selectedIndex = 0;
         this.grid.dataProvider = this._items;
         this._nonFilteredDataProvider = this._items;
         this._searchTimer.addEventListener(TimerEvent.TIMER,this.onTick);
         this.uiApi.addComponentHook(this.grid,ComponentHookList.ON_SELECT_ITEM);
         this.uiApi.addComponentHook(this.cbFilter,ComponentHookList.ON_SELECT_ITEM);
         this.uiApi.addComponentHook(this.btnSearch,ComponentHookList.ON_RELEASE);
         this.uiApi.addComponentHook(this.searchInput,ComponentHookList.ON_CHANGE);
         if(this._openInventory)
         {
            this.sysApi.sendAction(new OpenInventory());
         }
      }
      
      private function parseItems(param1:* = null) : void
      {
         var _loc2_:Object = null;
         var _loc5_:* = false;
         var _loc6_:String = null;
         var _loc7_:Object = null;
         var _loc8_:Object = null;
         var _loc3_:uint = this._parsedItems + 200;
         var _loc4_:uint = this._tmp.length;
         while(this._parsedItems < _loc3_ && this._parsedItems < _loc4_)
         {
            _loc6_ = "name";
            _loc5_ = false;
            _loc8_ = this._tmp[this._parsedItems];
            _loc2_ = new Object();
            _loc2_.id = _loc8_.id;
            _loc2_.name = _loc8_.name + " - " + _loc2_.id;
            _loc2_.lowerName = String(_loc2_.name).toLowerCase();
            _loc2_.typeId = _loc8_.type.id;
            switch(this._resourceType)
            {
               case RESOURCE_FIREWORKS:
                  _loc5_ = _loc2_.typeId != 74;
                  _loc2_.iconId = _loc8_.iconId;
                  _loc2_.sortData = _loc8_.id;
                  _loc2_.returnData = _loc2_.id;
                  break;
               case RESOURCE_ITEM:
                  _loc2_.iconId = _loc8_.iconId;
                  _loc2_.sortData = _loc8_.id;
                  _loc2_.returnData = _loc2_.id;
                  break;
               case RESOURCE_MONSTER:
                  _loc2_.iconId = _loc8_.id;
                  _loc2_.sortData = _loc2_.lowerName;
                  _loc2_.returnData = _loc2_.id;
                  break;
               case RESOURCE_LOOK:
                  _loc2_.iconId = _loc8_.id;
                  _loc2_.sortData = _loc2_.lowerName;
                  _loc2_.returnData = _loc8_.look;
                  break;
               case RESOURCE_SPELL:
                  _loc2_.iconId = _loc8_.iconId;
                  _loc2_.sortData = _loc2_.lowerName;
                  _loc2_.returnData = _loc8_.id;
                  _loc6_ = "longName";
            }
            if(!_loc5_)
            {
               this._items.push(_loc2_);
               if(!this._tmpTypes[_loc2_.typeId])
               {
                  this._tmpTypes[_loc2_.typeId] = _loc8_.type;
               }
            }
            this._parsedItems++;
         }
         this.lblTitle.text = Math.ceil(this._parsedItems / _loc4_ * 100) + " %";
         if(_loc4_ != this._parsedItems)
         {
            return;
         }
         this.lblTitle.text = this._title;
         this.sysApi.removeEventListener(this.parseItems);
         for each(_loc7_ in this._tmpTypes)
         {
            this._types.push({
               "typeId":_loc7_.id,
               "label":_loc7_[_loc6_]
            });
         }
         this._types.sortOn("label");
         this._types.unshift({
            "typeId":null,
            "label":"Tous"
         });
         this._items.sortOn("sortData",_loc2_.sortData is String?0:Array.NUMERIC);
         this.sysApi.setData("AdminCachedItemsList",this._items,DataStoreEnum.BIND_ACCOUNT);
         this.sysApi.setData("AdminCachedItemTypesList",this._types,DataStoreEnum.BIND_ACCOUNT);
         this.init();
      }
      
      public function onRelease(param1:Object) : void
      {
         switch(param1)
         {
            case this.btnClose:
               this.uiApi.unloadUi(this.uiApi.me().name);
               break;
            case this.btnSearch:
               this.searchCtr.visible = !this.searchCtr.visible;
               this.cbFilter.visible = !this.cbFilter.visible;
               if(this.searchCtr.visible)
               {
                  this.searchInput.focus();
               }
               else
               {
                  this.searchInput.blur();
               }
         }
      }
      
      public function onChange(param1:Object) : void
      {
         this._searchTimer.reset();
         this._searchTimer.start();
      }
      
      private function onTick(param1:TimerEvent) : void
      {
         var _loc3_:Array = null;
         var _loc4_:Object = null;
         var _loc2_:String = this.searchInput.text.toLowerCase();
         if(_loc2_.length)
         {
            _loc3_ = [];
            for each(_loc4_ in this._nonFilteredDataProvider)
            {
               if(this.utilApi.noAccent(_loc4_.lowerName).indexOf(this.utilApi.noAccent(_loc2_)) != -1)
               {
                  _loc3_.push(_loc4_);
               }
            }
            this.grid.dataProvider = _loc3_;
         }
         else
         {
            this.grid.dataProvider = this._nonFilteredDataProvider;
         }
      }
      
      public function onSelectItem(param1:Object, param2:uint, param3:Boolean) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:Object = null;
         switch(param1)
         {
            case this.cbFilter:
               if(param1.value.typeId === null)
               {
                  this.grid.dataProvider = this._items;
                  this._nonFilteredDataProvider = this._items;
               }
               else
               {
                  this._nonFilteredDataProvider = [];
                  _loc4_ = param1.value.typeId;
                  for each(_loc5_ in this._items)
                  {
                     if(_loc5_.typeId == _loc4_)
                     {
                        this._nonFilteredDataProvider.push(_loc5_);
                     }
                  }
                  this.grid.dataProvider = this._nonFilteredDataProvider;
               }
               break;
            case this.grid:
               if(param2 == GridItemSelectMethodEnum.DOUBLE_CLICK)
               {
                  this._callback(this.grid.selectedItem.returnData,this._title);
               }
         }
      }
   }
}
