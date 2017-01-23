package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Grid;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.internalDatacenter.communication.EmoteWrapper;
   import com.ankamagames.dofus.internalDatacenter.communication.SmileyWrapper;
   import com.ankamagames.dofus.internalDatacenter.items.IdolsPresetWrapper;
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import com.ankamagames.dofus.internalDatacenter.items.PresetWrapper;
   import com.ankamagames.dofus.internalDatacenter.items.ShortcutWrapper;
   import com.ankamagames.dofus.internalDatacenter.spells.SpellWrapper;
   import com.ankamagames.dofus.modules.utils.ItemTooltipSettings;
   import com.ankamagames.dofus.modules.utils.SpellTooltipSettings;
   import com.ankamagames.dofus.uiApi.BindsApi;
   import com.ankamagames.dofus.uiApi.ContextMenuApi;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.FightApi;
   import com.ankamagames.dofus.uiApi.InventoryApi;
   import com.ankamagames.dofus.uiApi.PlayedCharacterApi;
   import com.ankamagames.dofus.uiApi.StorageApi;
   import com.ankamagames.dofus.uiApi.TimeApi;
   import com.ankamagames.dofus.uiApi.TooltipApi;
   import com.ankamagames.dofusModuleLibrary.enum.SoundEnum;
   import com.ankamagames.dofusModuleLibrary.enum.components.GridItemSelectMethodEnum;
   import com.ankamagames.dofusModuleLibrary.enum.interfaces.UIEnum;
   import d2actions.BannerEmptySlotClick;
   import d2actions.ChatSmileyRequest;
   import d2actions.ChatTextOutput;
   import d2actions.EmotePlayRequest;
   import d2actions.GameFightSpellCast;
   import d2actions.IdolsPresetUse;
   import d2actions.InventoryPresetUse;
   import d2actions.MountInfoRequest;
   import d2actions.ObjectSetPosition;
   import d2actions.ObjectUse;
   import d2actions.OpenIdols;
   import d2actions.ShortcutBarAddRequest;
   import d2actions.ShortcutBarRemoveRequest;
   import d2actions.ShortcutBarSwapRequest;
   import d2enums.CharacterInventoryPositionEnum;
   import d2enums.ChatActivableChannelsEnum;
   import d2enums.DataStoreEnum;
   import d2enums.LocationEnum;
   import d2enums.ShortcutHookListEnum;
   import d2enums.StrataEnum;
   import d2hooks.CancelCastSpell;
   import d2hooks.CastSpellMode;
   import d2hooks.DropEnd;
   import d2hooks.DropStart;
   import d2hooks.IdolsPresetDelete;
   import d2hooks.ObjectSelected;
   import d2hooks.OpenInventory;
   import d2hooks.OpenSpellInterface;
   import d2hooks.PresetsUpdate;
   import d2hooks.ShortcutBarViewContent;
   import d2hooks.ShortcutsMovementAllowed;
   import d2hooks.SlaveStatsList;
   import d2hooks.SpellMovementAllowed;
   import d2hooks.SwitchBannerTab;
   import d2hooks.UiLoaded;
   import d2hooks.UiUnloaded;
   import d2hooks.WeaponUpdate;
   import flash.events.TimerEvent;
   import flash.ui.Keyboard;
   import flash.utils.Timer;
   import ui.enums.ContextEnum;
   import ui.params.ActionBarParameters;
   
   public class ActionBar extends ContextAwareUi
   {
      
      protected static var externalActionBars:Vector.<ActionBar> = new Vector.<ActionBar>(4,true);
      
      protected static var mainBar:ActionBar;
      
      private static const TYPE_ITEM_WRAPPER:int = 0;
      
      private static const TYPE_PRESET_WRAPPER:int = 1;
      
      private static const TYPE_SPELL_WRAPPER:int = 2;
      
      private static const TYPE_SMILEY_WRAPPER:int = 3;
      
      private static const TYPE_EMOTE_WRAPPER:int = 4;
      
      private static const TYPE_IDOLS_PRESET_WRAPPER:int = 5;
      
      protected static const NUM_PAGES:uint = 5;
      
      private static const NUM_ITEMS_PER_PAGE:uint = 20;
      
      protected static const EXTERNAL_UI_BASE_NAME:String = "externalActionBar";
      
      private static const EXTERNAL_UI_VERTICAL_NAME:String = "externalActionBarVertical";
      
      private static var _shortcutColor:String;
      
      protected static var ITEMS_TAB:String = "items";
      
      protected static var SPELLS_TAB:String = "spells";
       
      
      public var bindsApi:BindsApi;
      
      public var uiApi:UiApi;
      
      public var timeApi:TimeApi;
      
      public var dataApi:DataApi;
      
      public var playerApi:PlayedCharacterApi;
      
      public var tooltipApi:TooltipApi;
      
      public var inventoryApi:InventoryApi;
      
      public var menuApi:ContextMenuApi;
      
      public var storageApi:StorageApi;
      
      public var fightApi:FightApi;
      
      [Module(name="Ankama_ContextMenu")]
      public var modContextMenu:Object;
      
      [Module(name="Ankama_Common")]
      public var modCommon:Object;
      
      public var gd_spellitemotes:Grid;
      
      public var btn_tabSpells:ButtonContainer;
      
      public var btn_tabItems:ButtonContainer;
      
      public var ctr_changeNumber:GraphicContainer;
      
      public var btn_upArrow:ButtonContainer;
      
      public var btn_downArrow:ButtonContainer;
      
      public var btn_addActionBar:ButtonContainer;
      
      public var lbl_itemsNumber:Label;
      
      protected var _nPageItems:uint = 0;
      
      protected var _nPageSpells:uint = 0;
      
      protected var _sTabGrid:String;
      
      protected var _aSpells;
      
      private var _aItems;
      
      private var _itemToUseId:uint;
      
      private var _spellMovementAllowed:Boolean = false;
      
      private var _shortcutsMovementAllowed:Boolean = false;
      
      private var _delayUseObject:Boolean = false;
      
      private var _delayUseObjectTimer:Timer;
      
      protected var isMainBar:Boolean = true;
      
      private var _waitingObjectUID:uint;
      
      private var _waitingObjectPosition:uint;
      
      public function ActionBar()
      {
         super();
      }
      
      public function get nPageItems() : uint
      {
         return this._nPageItems;
      }
      
      public function get nPageSpells() : uint
      {
         return this._nPageSpells;
      }
      
      public function get sTabGrid() : String
      {
         return this._sTabGrid;
      }
      
      override public function main(param1:Array) : void
      {
         var _loc2_:int = 0;
         super.main(param1);
         if(param1 && param1.length && (param1[0] as ActionBarParameters).context)
         {
            currentContext = (param1[0] as ActionBarParameters).context;
         }
         sysApi.addHook(OpenInventory,this.onOpenInventory);
         sysApi.addHook(SwitchBannerTab,this.onSwitchBannerTab);
         sysApi.addHook(WeaponUpdate,this.onWeaponUpdate);
         sysApi.addHook(SpellMovementAllowed,this.onSpellMovementAllowed);
         sysApi.addHook(ShortcutsMovementAllowed,this.onShortcutsMovementAllowed);
         sysApi.addHook(PresetsUpdate,this.onPresetsUpdate);
         sysApi.addHook(IdolsPresetDelete,this.onIdolsPresetDelete);
         sysApi.addHook(SlaveStatsList,this.onSlaveStatsList);
         sysApi.addHook(ShortcutBarViewContent,this.onShortcutBarViewContent);
         sysApi.addHook(DropStart,this.onDropStart);
         sysApi.addHook(DropEnd,this.onDropEnd);
         sysApi.addHook(CancelCastSpell,this.onCancelCastSpell);
         sysApi.addHook(CastSpellMode,this.onCastSpellMode);
         this.btn_upArrow.soundId = SoundEnum.SCROLL_DOWN;
         this.btn_downArrow.soundId = SoundEnum.SCROLL_UP;
         this.btn_tabSpells.soundId = SoundEnum.BANNER_SPELL_TAB;
         this.btn_tabItems.soundId = SoundEnum.BANNER_OBJECT_TAB;
         this.uiApi.addShortcutHook("cac",this.onShortcut);
         this.uiApi.addShortcutHook("s1",this.onShortcut);
         this.uiApi.addShortcutHook("s2",this.onShortcut);
         this.uiApi.addShortcutHook("s3",this.onShortcut);
         this.uiApi.addShortcutHook("s4",this.onShortcut);
         this.uiApi.addShortcutHook("s5",this.onShortcut);
         this.uiApi.addShortcutHook("s6",this.onShortcut);
         this.uiApi.addShortcutHook("s7",this.onShortcut);
         this.uiApi.addShortcutHook("s8",this.onShortcut);
         this.uiApi.addShortcutHook("s9",this.onShortcut);
         this.uiApi.addShortcutHook("s10",this.onShortcut);
         this.uiApi.addShortcutHook("s11",this.onShortcut);
         this.uiApi.addShortcutHook("s12",this.onShortcut);
         this.uiApi.addShortcutHook("s13",this.onShortcut);
         this.uiApi.addShortcutHook("s14",this.onShortcut);
         this.uiApi.addShortcutHook("s15",this.onShortcut);
         this.uiApi.addShortcutHook("s16",this.onShortcut);
         this.uiApi.addShortcutHook("s17",this.onShortcut);
         this.uiApi.addShortcutHook("s18",this.onShortcut);
         this.uiApi.addShortcutHook("s19",this.onShortcut);
         this.uiApi.addShortcutHook("s20",this.onShortcut);
         this.uiApi.addShortcutHook("bannerSpellsTab",this.onShortcut);
         this.uiApi.addShortcutHook("bannerItemsTab",this.onShortcut);
         this.uiApi.addShortcutHook("bannerPreviousTab",this.onShortcut);
         this.uiApi.addShortcutHook("bannerNextTab",this.onShortcut);
         this.uiApi.addShortcutHook(ShortcutHookListEnum.PAGE_ITEM_1,this.onShortcut);
         this.uiApi.addShortcutHook(ShortcutHookListEnum.PAGE_ITEM_2,this.onShortcut);
         this.uiApi.addShortcutHook(ShortcutHookListEnum.PAGE_ITEM_3,this.onShortcut);
         this.uiApi.addShortcutHook(ShortcutHookListEnum.PAGE_ITEM_4,this.onShortcut);
         this.uiApi.addShortcutHook(ShortcutHookListEnum.PAGE_ITEM_5,this.onShortcut);
         this.uiApi.addShortcutHook(ShortcutHookListEnum.PAGE_ITEM_DOWN,this.onShortcut);
         this.uiApi.addShortcutHook(ShortcutHookListEnum.PAGE_ITEM_UP,this.onShortcut);
         this.uiApi.addComponentHook(this.gd_spellitemotes,"onWheel");
         this.uiApi.addComponentHook(this.gd_spellitemotes,"onPress");
         this.uiApi.addComponentHook(this.btn_downArrow,"onRollOver");
         this.uiApi.addComponentHook(this.btn_downArrow,"onRollOut");
         this.uiApi.addComponentHook(this.btn_upArrow,"onRollOver");
         this.uiApi.addComponentHook(this.btn_upArrow,"onRollOut");
         this.uiApi.addComponentHook(this.btn_tabItems,"onRollOver");
         this.uiApi.addComponentHook(this.btn_tabItems,"onRollOut");
         this.uiApi.addComponentHook(this.btn_tabSpells,"onRollOver");
         this.uiApi.addComponentHook(this.btn_tabSpells,"onRollOut");
         this.uiApi.addComponentHook(this.btn_addActionBar,"onRollOver");
         this.uiApi.addComponentHook(this.btn_addActionBar,"onRollOut");
         this.uiApi.addComponentHook(this.ctr_changeNumber,"onWheel");
         this._aSpells = new Array();
         this._aItems = new Array();
         this.btn_upArrow.disabled = true;
         this._delayUseObjectTimer = new Timer(500,1);
         this._delayUseObjectTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onDelayUseObjectTimer);
         this.gd_spellitemotes.autoSelectMode = 0;
         this.gd_spellitemotes.renderer.dropValidatorFunction = this.dropValidator;
         this.gd_spellitemotes.renderer.processDropFunction = this.processDrop;
         this.gd_spellitemotes.renderer.removeDropSourceFunction = this.emptyFct;
         this.gd_spellitemotes.keyboardIndexHandler = this.onGridKeyDown;
         if(this.isMainBar)
         {
            mainBar = this;
            _loc2_ = 0;
            while(_loc2_ < externalActionBars.length)
            {
               this.loadExternalActionBar(_loc2_);
               _loc2_++;
            }
            sysApi.addHook(UiLoaded,this.onUiLoaded);
            sysApi.addHook(UiUnloaded,this.onUiUnloaded);
            this._nPageItems = sysApi.getData("bannerItemsPageIndex");
            if(this.getPlayerId() >= 0)
            {
               this._nPageSpells = sysApi.getData("bannerSpellsPageIndex" + this.getPlayerId());
            }
            else
            {
               this._nPageSpells = 0;
            }
            this.onShortcutBarViewContent(0);
            this.onShortcutBarViewContent(1);
            this.onContextChanged(currentContext);
         }
      }
      
      override protected function onContextChanged(param1:String, param2:String = "", param3:Boolean = false) : void
      {
         switch(param1)
         {
            case ContextEnum.SPECTATOR:
               this.gd_spellitemotes.disabled = true;
               break;
            case ContextEnum.PREFIGHT:
               this.gridDisplay(ITEMS_TAB,true);
               break;
            case ContextEnum.FIGHT:
               this.gridDisplay(SPELLS_TAB,true);
               break;
            case ContextEnum.ROLEPLAY:
               this.gridDisplay(ITEMS_TAB,true);
               this.gd_spellitemotes.disabled = false;
         }
      }
      
      private function loadExternalActionBar(param1:uint, param2:Boolean = false, param3:String = null) : void
      {
         var _loc4_:String = EXTERNAL_UI_BASE_NAME;
         var _loc5_:uint = ExternalActionBar.ORIENTATION_HORIZONTAL;
         var _loc6_:* = sysApi.getData(this.dataKey,DataStoreEnum.BIND_CHARACTER);
         if(_loc6_ && _loc6_[param1] && _loc6_[param1].orientation == ExternalActionBar.ORIENTATION_VERTICAL)
         {
            _loc4_ = EXTERNAL_UI_VERTICAL_NAME;
            _loc5_ = ExternalActionBar.ORIENTATION_VERTICAL;
         }
         this.uiApi.loadUi(_loc4_,EXTERNAL_UI_BASE_NAME + "_" + param1,[new ActionBarParameters(param1,_loc5_,param2,param3)],StrataEnum.STRATA_TOP,null,true);
      }
      
      private function onUiLoaded(param1:String) : void
      {
         if(param1 && param1.indexOf(EXTERNAL_UI_BASE_NAME) == 0)
         {
            this.btn_addActionBar.disabled = !this.canAddExternalActionBar();
         }
      }
      
      private function onUiUnloaded(param1:String) : void
      {
         if(param1 && param1.indexOf(EXTERNAL_UI_BASE_NAME) == 0)
         {
            this.btn_addActionBar.disabled = !this.canAddExternalActionBar();
         }
      }
      
      private function formatShortcut(param1:String, param2:String) : String
      {
         if(param2)
         {
            if(!_shortcutColor)
            {
               _shortcutColor = sysApi.getConfigEntry("colors.shortcut");
               _shortcutColor = _shortcutColor.replace("0x","#");
            }
            return param1 + " <font color=\'" + _shortcutColor + "\'>(" + param2 + ")</font>";
         }
         return param1;
      }
      
      public function reloadExternalActionBar(param1:uint, param2:String) : void
      {
         this.loadExternalActionBar(param1,true,param2);
      }
      
      public function gridDisplay(param1:String, param2:Boolean = false) : void
      {
         var _loc5_:int = 0;
         var _loc3_:Boolean = false;
         if(currentContext == ContextEnum.ROLEPLAY)
         {
            _loc3_ = true;
         }
         if(param1 == this._sTabGrid && !param2)
         {
            return;
         }
         var _loc4_:* = param1 == this._sTabGrid;
         this._sTabGrid = param1;
         switch(param1)
         {
            case SPELLS_TAB:
               this.btn_tabSpells.visible = false;
               this.btn_tabItems.visible = true;
               this.gd_spellitemotes.renderer.allowDrop = !!_loc3_?_loc3_:this._spellMovementAllowed;
               this.updateGrid(this._aSpells,this._nPageSpells,_loc4_);
               this.lbl_itemsNumber.text = (this._nPageSpells + 1).toString();
               _loc5_ = this._nPageSpells;
               break;
            case ITEMS_TAB:
               this.btn_tabSpells.visible = true;
               this.btn_tabItems.visible = false;
               this.gd_spellitemotes.renderer.allowDrop = !!_loc3_?_loc3_:this._shortcutsMovementAllowed;
               this.updateGrid(this._aItems,this._nPageItems,_loc4_);
               this.lbl_itemsNumber.text = (this._nPageItems + 1).toString();
               _loc5_ = this._nPageItems;
         }
         this.btn_upArrow.disabled = _loc5_ == 0;
         this.btn_downArrow.disabled = _loc5_ == NUM_PAGES - 1;
      }
      
      public function onItemRollOver(param1:Object, param2:Object) : void
      {
         var _loc4_:Object = null;
         var _loc8_:String = null;
         var _loc9_:Object = null;
         var _loc10_:String = null;
         var _loc11_:* = null;
         var _loc12_:ItemWrapper = null;
         var _loc13_:String = null;
         var _loc14_:ItemTooltipSettings = null;
         var _loc15_:SpellWrapper = null;
         var _loc3_:Object = this.uiApi.getUi(UIEnum.BANNER).getElement(!!sysApi.isFightContext()?"tooltipFightPlacer":"tooltipRoleplayPlacer");
         var _loc5_:String = "bannerActionBar::gd_spellitemotes::item";
         var _loc6_:int = int(param2.container.name.substr(_loc5_.length)) + 1;
         var _loc7_:String = this.bindsApi.getShortcutBindStr("s" + _loc6_);
         if(!param2.data)
         {
            return;
         }
         if(!_shortcutColor)
         {
            _shortcutColor = sysApi.getConfigEntry("colors.shortcut");
            _shortcutColor = _shortcutColor.replace("0x","#");
         }
         if(param1 == this.gd_spellitemotes)
         {
            if(this._sTabGrid == ITEMS_TAB)
            {
               _loc10_ = "TextInfo";
               switch(param2.data.type)
               {
                  case TYPE_ITEM_WRAPPER:
                     _loc12_ = this.inventoryApi.getItem(param2.data.id);
                     if(!_loc12_)
                     {
                        _loc12_ = this.dataApi.getItemWrapper(param2.data.gid);
                     }
                     _loc4_ = this.tooltipApi.getItemTooltipInfo(_loc12_,_loc7_);
                     _loc8_ = "itemName";
                     _loc9_ = new Object();
                     _loc14_ = this.getItemTooltipSettings();
                     for each(_loc13_ in sysApi.getObjectVariables(_loc14_))
                     {
                        _loc9_[_loc13_] = _loc14_[_loc13_];
                     }
                     _loc9_.ref = _loc3_;
                     _loc10_ = "ItemInfo";
                     break;
                  case TYPE_PRESET_WRAPPER:
                     _loc11_ = this.uiApi.getText("ui.banner.preset.tooltip",param2.data.id + 1);
                     if(_loc7_ && _loc7_ != "")
                     {
                        _loc11_ = _loc11_ + (" <font color=\'" + _shortcutColor + "\'>(" + _loc7_ + ")</font>");
                     }
                     _loc4_ = this.uiApi.textTooltipInfo(_loc11_);
                     break;
                  case TYPE_SMILEY_WRAPPER:
                     _loc11_ = this.uiApi.getText("ui.banner.emote.tooltip");
                     if(_loc7_ && _loc7_ != "")
                     {
                        _loc11_ = _loc11_ + (" <font color=\'" + _shortcutColor + "\'>(" + _loc7_ + ")</font>");
                     }
                     _loc4_ = this.uiApi.textTooltipInfo(_loc11_);
                     break;
                  case TYPE_EMOTE_WRAPPER:
                     _loc11_ = param2.data.name;
                     if(_loc7_ && _loc7_ != "")
                     {
                        _loc11_ = _loc11_ + (" <font color=\'" + _shortcutColor + "\'>(" + _loc7_ + ")</font>");
                     }
                     _loc4_ = this.uiApi.textTooltipInfo(_loc11_);
                     _loc8_ = "emoteName";
                     break;
                  case TYPE_IDOLS_PRESET_WRAPPER:
                     _loc11_ = this.uiApi.getText("ui.idol.preset.tooltip",param2.data.id + 1);
                     if(_loc7_ && _loc7_ != "")
                     {
                        _loc11_ = _loc11_ + (" <font color=\'" + _shortcutColor + "\'>(" + _loc7_ + ")</font>");
                     }
                     _loc4_ = this.uiApi.textTooltipInfo(_loc11_);
                     break;
                  default:
                     if(_loc7_ && _loc7_ != "")
                     {
                        _loc11_ = " <font color=\'" + _shortcutColor + "\'>(" + _loc7_ + ")</font>";
                        _loc4_ = this.uiApi.textTooltipInfo(_loc11_);
                        break;
                     }
                     return;
               }
               this.uiApi.showTooltip(_loc4_,param2.container,false,"standard",LocationEnum.POINT_BOTTOMRIGHT,LocationEnum.POINT_TOPRIGHT,0,_loc8_,null,_loc9_,_loc10_);
            }
            else if(this._sTabGrid == SPELLS_TAB)
            {
               _loc15_ = this.playerApi.getSpell(param2.data.id);
               if(_loc15_ == null)
               {
                  return;
               }
               _loc4_ = this.tooltipApi.getSpellTooltipInfo(_loc15_,_loc7_);
               this.uiApi.showTooltip(_loc4_,param2.container,false,"standard",LocationEnum.POINT_BOTTOMRIGHT,LocationEnum.POINT_TOPRIGHT,3,null,null,null,"SpellBanner");
            }
         }
      }
      
      public function onItemRightClick(param1:Object, param2:Object) : void
      {
         var _loc3_:Object = null;
         var _loc4_:Object = null;
         var _loc5_:Object = null;
         var _loc6_:Boolean = false;
         var _loc7_:Object = null;
         var _loc8_:Array = null;
         var _loc9_:String = null;
         var _loc10_:String = null;
         var _loc11_:String = null;
         var _loc12_:String = null;
         var _loc13_:Object = null;
         switch(this._sTabGrid)
         {
            case ITEMS_TAB:
               _loc3_ = param2.data;
               if(_loc3_ == null)
               {
                  return;
               }
               _loc5_ = _loc3_.realItem;
               _loc4_ = this.menuApi.create(_loc5_,"item",[{"ownedItem":true}]);
               _loc6_ = false;
               if(_loc4_ && _loc4_.content && _loc4_.content[0])
               {
                  _loc6_ = _loc4_.content[0].disabled;
               }
               if(_loc3_.type == TYPE_ITEM_WRAPPER && _loc3_.targetable && !_loc3_.nonUsableOnAnother)
               {
                  _loc4_.content.unshift(this.modContextMenu.createContextMenuItemObject(this.uiApi.getText("ui.common.target"),this.onItemUseOnCell,[_loc3_.id],_loc6_));
               }
               if(_loc3_.usable || _loc3_.type == TYPE_PRESET_WRAPPER || _loc3_.type == TYPE_SMILEY_WRAPPER || _loc3_.type == TYPE_EMOTE_WRAPPER)
               {
                  if(_loc3_.quantity > 1 && _loc3_.isOkForMultiUse)
                  {
                     _loc4_.content.unshift(this.modContextMenu.createContextMenuItemObject(this.uiApi.getText("ui.common.multipleUse"),this.useItemQuantity,[_loc3_.id,_loc3_.quantity],_loc6_));
                  }
                  _loc4_.content.unshift(this.modContextMenu.createContextMenuItemObject(this.uiApi.getText("ui.common.use"),this.useItem,[_loc3_.id,_loc3_.type,_loc3_.slot],!_loc6_?!_loc3_.active:_loc6_));
               }
               if(_loc3_.type == TYPE_ITEM_WRAPPER && _loc3_.category == 0)
               {
                  _loc4_.content.unshift(this.modContextMenu.createContextMenuItemObject(this.uiApi.getText("ui.common.equip"),this.equipItem,[_loc5_],!_loc6_?!_loc3_.active:_loc6_));
               }
               _loc4_.content.push(this.modContextMenu.createContextMenuItemObject(this.uiApi.getText("ui.common.remove"),this.onRemoveItem,[_loc3_.slot],false));
               if(_loc4_.content.length)
               {
                  _loc4_.content.push(this.modContextMenu.createContextMenuSeparatorObject());
               }
               if(Api.system.getOption("displayTooltips","dofus"))
               {
                  _loc13_ = this.getItemTooltipSettings();
                  _loc4_.content.push(this.modContextMenu.createContextMenuItemObject(this.uiApi.getText("ui.common.tooltip"),null,null,false,[this.modContextMenu.createContextMenuItemObject(this.uiApi.getText("ui.common.name"),this.onItemTooltipDisplayOption,["header"],_loc6_,null,_loc13_.header,false),this.modContextMenu.createContextMenuItemObject(this.uiApi.processText(this.uiApi.getText("ui.common.effects"),"",false),this.onItemTooltipDisplayOption,["effects"],_loc6_,null,_loc13_.effects,false),this.modContextMenu.createContextMenuItemObject(this.uiApi.getText("ui.common.conditions"),this.onItemTooltipDisplayOption,["conditions"],_loc6_,null,_loc13_.conditions,false),this.modContextMenu.createContextMenuItemObject(this.uiApi.getText("ui.common.description"),this.onItemTooltipDisplayOption,["description"],_loc6_,null,_loc13_.description,false),this.modContextMenu.createContextMenuItemObject(this.uiApi.getText("ui.item.averageprice"),this.onItemTooltipDisplayOption,["averagePrice"],_loc6_,null,_loc13_.averagePrice,false)],_loc6_));
               }
               if(_loc4_.content.length > 0)
               {
                  this.modContextMenu.createContextMenu(_loc4_);
               }
               break;
            case SPELLS_TAB:
               _loc3_ = param2.data;
               if(_loc3_ == null)
               {
                  return;
               }
               _loc7_ = this.getSpellTooltipSettings();
               _loc8_ = new Array();
               _loc9_ = this.uiApi.getText("ui.common.name");
               _loc10_ = this.uiApi.processText(this.uiApi.getText("ui.common.effects"),"",false);
               _loc11_ = this.uiApi.getText("ui.common.description");
               _loc12_ = this.uiApi.getText("ui.common.CC_EC");
               _loc8_.push(this.modContextMenu.createContextMenuItemObject(this.uiApi.getText("ui.common.tooltip"),null,null,false,[this.modContextMenu.createContextMenuItemObject(_loc9_,this.onSpellTooltipDisplayOption,["header"],false,null,_loc7_.header,false),this.modContextMenu.createContextMenuItemObject(_loc10_,this.onSpellTooltipDisplayOption,["effects"],false,null,_loc7_.effects,false),this.modContextMenu.createContextMenuItemObject(_loc12_,this.onSpellTooltipDisplayOption,["CC_EC"],false,null,_loc7_.CC_EC,false),this.modContextMenu.createContextMenuItemObject(_loc11_,this.onSpellTooltipDisplayOption,["description"],false,null,_loc7_.description,false)],false),this.modContextMenu.createContextMenuItemObject(this.uiApi.getText("ui.common.remove"),this.onRemoveSpell,[_loc3_.slot],false));
               this.modContextMenu.createContextMenu(_loc8_);
               break;
         }
      }
      
      public function onItemUseOnCell(param1:uint) : void
      {
         if(!this._delayUseObject && param1)
         {
            sysApi.sendAction(new ObjectUse(param1,1,true));
         }
      }
      
      public function useItem(param1:uint, param2:uint = 0, param3:int = -1) : void
      {
         if(!this._delayUseObject)
         {
            if(param2 == TYPE_PRESET_WRAPPER)
            {
               sysApi.sendAction(new InventoryPresetUse(param1));
            }
            else if(param2 == TYPE_SMILEY_WRAPPER)
            {
               sysApi.sendAction(new ChatSmileyRequest(param1));
            }
            else if(param2 == TYPE_EMOTE_WRAPPER)
            {
               sysApi.sendAction(new EmotePlayRequest(param1));
            }
            else if(param2 == TYPE_IDOLS_PRESET_WRAPPER)
            {
               sysApi.sendAction(new IdolsPresetUse(param1));
            }
            else
            {
               this._delayUseObjectTimer.start();
               sysApi.sendAction(new ObjectUse(param1,1,false));
            }
         }
      }
      
      public function useItemQuantity(param1:uint, param2:uint = 1) : void
      {
         if(!this._delayUseObject)
         {
            this._itemToUseId = param1;
            this.modCommon.openQuantityPopup(1,param2,1,this.onValidItemQuantityUse);
         }
      }
      
      public function onValidItemQuantityUse(param1:Number) : void
      {
         this._delayUseObjectTimer.start();
         sysApi.sendAction(new ObjectUse(this._itemToUseId,param1,false));
         this._itemToUseId = 0;
      }
      
      public function onDelayUseObjectTimer(param1:TimerEvent) : void
      {
         this._delayUseObjectTimer.reset();
         this._delayUseObject = false;
      }
      
      public function onItemRollOut(param1:Object, param2:Object) : void
      {
         this.uiApi.hideTooltip();
         this.uiApi.hideTooltip("spellBanner");
      }
      
      public function onWheel(param1:Object, param2:int) : void
      {
         if(param2 > 0)
         {
            this.pageItemUp();
         }
         else
         {
            this.pageItemDown();
         }
      }
      
      protected function getPlayerId() : Number
      {
         if(this.playerApi.isInFight())
         {
            return this.fightApi.getCurrentPlayedFighterId();
         }
         return this.playerApi.id();
      }
      
      private function onGridKeyDown(param1:int, param2:int) : int
      {
         var _loc3_:uint = this._sTabGrid == ITEMS_TAB?uint(this._nPageItems):uint(this._nPageSpells);
         var _loc4_:int = param2;
         if(param2 < 0)
         {
            if(_loc3_ > 0)
            {
               this.pageItemUp();
               _loc4_ = param2 == -1?int(NUM_ITEMS_PER_PAGE - 1):int(param1 + this.gd_spellitemotes.slotByRow);
            }
         }
         else if(param2 > NUM_ITEMS_PER_PAGE - 1)
         {
            this.pageItemDown();
            if(_loc3_ < NUM_PAGES - 1)
            {
               _loc4_ = param2 == NUM_ITEMS_PER_PAGE?0:int(param1 - this.gd_spellitemotes.slotByRow);
            }
            else
            {
               _loc4_ = param1;
            }
         }
         return _loc4_;
      }
      
      private function getItemTooltipSettings() : ItemTooltipSettings
      {
         var _loc2_:Boolean = false;
         var _loc1_:ItemTooltipSettings = sysApi.getData("itemTooltipSettings",DataStoreEnum.BIND_ACCOUNT) as ItemTooltipSettings;
         if(_loc1_ == null)
         {
            _loc1_ = this.tooltipApi.createItemSettings();
            _loc2_ = this.setItemTooltipSettings(_loc1_);
         }
         return _loc1_;
      }
      
      private function setItemTooltipSettings(param1:ItemTooltipSettings) : Boolean
      {
         return sysApi.setData("itemTooltipSettings",param1,DataStoreEnum.BIND_ACCOUNT);
      }
      
      private function getSpellTooltipSettings() : SpellTooltipSettings
      {
         var _loc1_:SpellTooltipSettings = sysApi.getData("spellTooltipSettings",DataStoreEnum.BIND_ACCOUNT) as SpellTooltipSettings;
         if(_loc1_ == null)
         {
            _loc1_ = this.tooltipApi.createSpellSettings();
            this.setSpellTooltipSettings(_loc1_);
         }
         return _loc1_;
      }
      
      private function setSpellTooltipSettings(param1:SpellTooltipSettings) : Boolean
      {
         return sysApi.setData("spellTooltipSettings",param1,DataStoreEnum.BIND_ACCOUNT);
      }
      
      private function onIdolsPresetDelete(param1:uint) : void
      {
         var _loc2_:Object = null;
         for each(_loc2_ in this._aItems)
         {
            if(_loc2_ && _loc2_.type == TYPE_IDOLS_PRESET_WRAPPER && _loc2_.id == param1)
            {
               this.onRemoveItem(_loc2_.slot);
               break;
            }
         }
      }
      
      public function unselectSpell() : void
      {
         if(this.fightApi.isCastingSpell())
         {
            this.fightApi.cancelSpell();
         }
      }
      
      protected function displayPage() : void
      {
         var _loc1_:int = 0;
         if(this._sTabGrid == ITEMS_TAB)
         {
            _loc1_ = this._nPageItems;
            sysApi.setData("bannerItemsPageIndex",this._nPageItems);
         }
         else if(this._sTabGrid == SPELLS_TAB)
         {
            _loc1_ = this._nPageSpells;
            if(this.getPlayerId() >= 0 && !this.fightApi.isSlaveContext())
            {
               sysApi.setData("bannerSpellsPageIndex" + this.getPlayerId(),this._nPageSpells);
            }
         }
         this.lbl_itemsNumber.text = (_loc1_ + 1).toString();
         this.btn_upArrow.disabled = _loc1_ == 0;
         this.btn_downArrow.disabled = _loc1_ == NUM_PAGES - 1;
      }
      
      private function pageItem(param1:int) : void
      {
         if(param1 < NUM_PAGES && param1 >= 0)
         {
            switch(this._sTabGrid)
            {
               case ITEMS_TAB:
                  this._nPageItems = param1;
                  this.updateGrid(this._aItems,this._nPageItems,false);
                  break;
               case SPELLS_TAB:
                  this._nPageSpells = param1;
                  this.updateGrid(this._aSpells,this._nPageSpells,false);
            }
            this.displayPage();
         }
      }
      
      private function pageItemDown() : void
      {
         switch(this._sTabGrid)
         {
            case ITEMS_TAB:
               if(this._nPageItems < NUM_PAGES - 1)
               {
                  this._nPageItems++;
                  this.updateGrid(this._aItems,this._nPageItems,false);
                  this.displayPage();
               }
               break;
            case SPELLS_TAB:
               if(this._nPageSpells < NUM_PAGES - 1)
               {
                  this._nPageSpells++;
                  this.updateGrid(this._aSpells,this._nPageSpells,false);
                  this.displayPage();
               }
         }
      }
      
      private function pageItemUp() : void
      {
         switch(this._sTabGrid)
         {
            case ITEMS_TAB:
               if(this._nPageItems > 0)
               {
                  this._nPageItems--;
                  this.updateGrid(this._aItems,this._nPageItems,false);
                  this.displayPage();
               }
               break;
            case SPELLS_TAB:
               if(this._nPageSpells > 0)
               {
                  this._nPageSpells--;
                  this.updateGrid(this._aSpells,this._nPageSpells,false);
                  this.displayPage();
               }
         }
      }
      
      private function onRemoveSpell(param1:int) : void
      {
         sysApi.sendAction(new ShortcutBarRemoveRequest(1,param1));
      }
      
      private function onRemoveItem(param1:int) : void
      {
         sysApi.sendAction(new ShortcutBarRemoveRequest(0,param1));
      }
      
      private function onSpellMovementAllowed(param1:Boolean) : void
      {
         this._spellMovementAllowed = param1;
         if(this._sTabGrid == SPELLS_TAB)
         {
            this.gd_spellitemotes.renderer.allowDrop = param1;
            this.updateGrid(this._aSpells,this._nPageSpells);
         }
      }
      
      private function onShortcutsMovementAllowed(param1:Boolean) : void
      {
         this._shortcutsMovementAllowed = param1;
         if(this._sTabGrid == ITEMS_TAB)
         {
            this.gd_spellitemotes.renderer.allowDrop = param1;
            this.updateGrid(this._aItems,this._nPageItems);
         }
      }
      
      private function onPresetsUpdate() : void
      {
         if(this._sTabGrid == ITEMS_TAB)
         {
            this._aItems = this.storageApi.getShortcutBarContent(0);
            this.updateGrid(this._aItems,this._nPageItems);
         }
      }
      
      private function onWeaponUpdate() : void
      {
         if(this._sTabGrid == SPELLS_TAB)
         {
            this.gridDisplay(this._sTabGrid,true);
         }
      }
      
      protected function onSwitchBannerTab(param1:String) : void
      {
         switch(param1)
         {
            case ITEMS_TAB:
            case SPELLS_TAB:
               this.gridDisplay(param1);
            default:
               this.gridDisplay(param1);
         }
      }
      
      public function onOpenSpellBook() : void
      {
         this.gridDisplay(SPELLS_TAB);
      }
      
      public function onOpenInventory(... rest) : void
      {
         if(!this.playerApi.isInFight())
         {
            this.gridDisplay(ITEMS_TAB);
         }
      }
      
      public function onShortcut(param1:String) : Boolean
      {
         var _loc2_:uint = 0;
         switch(param1)
         {
            case "cac":
               if(sysApi.isFightContext() && this.playerApi.canCastThisSpell(0,1))
               {
                  sysApi.sendAction(new GameFightSpellCast(0));
               }
               return true;
            case "s1":
            case "s2":
            case "s3":
            case "s4":
            case "s5":
            case "s6":
            case "s7":
            case "s8":
            case "s9":
            case "s10":
            case "s11":
            case "s12":
            case "s13":
            case "s14":
            case "s15":
            case "s16":
            case "s17":
            case "s18":
            case "s19":
            case "s20":
               if(!this.uiApi.getUi("passwordMenu") && !this.inventoryApi.removeSelectedItem())
               {
                  _loc2_ = parseInt(param1.substr(1)) - 1;
                  this.gd_spellitemotes.selectedIndex = _loc2_;
               }
               return true;
            case "bannerSpellsTab":
               this.gridDisplay(SPELLS_TAB);
               return true;
            case "bannerItemsTab":
               this.gridDisplay(ITEMS_TAB);
               return true;
            case "bannerNextTab":
               switch(this._sTabGrid)
               {
                  case SPELLS_TAB:
                     this.gridDisplay(ITEMS_TAB);
                     break;
                  case ITEMS_TAB:
                     this.gridDisplay(SPELLS_TAB);
               }
               return true;
            case "bannerPreviousTab":
               switch(this._sTabGrid)
               {
                  case SPELLS_TAB:
                     this.gridDisplay(ITEMS_TAB);
                     break;
                  case ITEMS_TAB:
                     this.gridDisplay(SPELLS_TAB);
               }
               return true;
            case ShortcutHookListEnum.PAGE_ITEM_1:
               this.pageItem(0);
               return true;
            case ShortcutHookListEnum.PAGE_ITEM_2:
               this.pageItem(1);
               return true;
            case ShortcutHookListEnum.PAGE_ITEM_3:
               this.pageItem(2);
               return true;
            case ShortcutHookListEnum.PAGE_ITEM_4:
               this.pageItem(3);
               return true;
            case ShortcutHookListEnum.PAGE_ITEM_5:
               this.pageItem(4);
               return true;
            case ShortcutHookListEnum.PAGE_ITEM_DOWN:
               this.pageItemDown();
               return true;
            case ShortcutHookListEnum.PAGE_ITEM_UP:
               this.pageItemUp();
               return true;
            default:
               return false;
         }
      }
      
      private function dropValidator(param1:Object, param2:Object, param3:Object) : Boolean
      {
         if(!param2)
         {
            return false;
         }
         switch(this._sTabGrid)
         {
            case SPELLS_TAB:
               return param2 is SpellWrapper || param2 is ShortcutWrapper;
            case ITEMS_TAB:
               return param2 is ItemWrapper || param2 is PresetWrapper || param2 is IdolsPresetWrapper || param2 is EmoteWrapper || param2 is SmileyWrapper || param2 is ShortcutWrapper;
            default:
               return false;
         }
      }
      
      private function processDrop(param1:Object, param2:Object, param3:Object) : void
      {
         if(this.dropValidator(param1,param2,param3))
         {
            switch(this._sTabGrid)
            {
               case SPELLS_TAB:
                  if(param2 is ShortcutWrapper)
                  {
                     sysApi.sendAction(new ShortcutBarSwapRequest(1,param2.slot,this.gd_spellitemotes.getItemIndex(param1) + this._nPageSpells * NUM_ITEMS_PER_PAGE));
                  }
                  else
                  {
                     sysApi.sendAction(new ShortcutBarAddRequest(2,param2.id,this.gd_spellitemotes.getItemIndex(param1) + this._nPageSpells * NUM_ITEMS_PER_PAGE));
                  }
                  break;
               case ITEMS_TAB:
                  if(param2 is ShortcutWrapper)
                  {
                     sysApi.sendAction(new ShortcutBarSwapRequest(0,param2.slot,this.gd_spellitemotes.getItemIndex(param1) + this._nPageItems * NUM_ITEMS_PER_PAGE));
                  }
                  else if(param2 is IdolsPresetWrapper)
                  {
                     sysApi.sendAction(new ShortcutBarAddRequest(5,param2.id,this.gd_spellitemotes.getItemIndex(param1) + this._nPageItems * NUM_ITEMS_PER_PAGE));
                  }
                  else if(param2 is PresetWrapper)
                  {
                     sysApi.sendAction(new ShortcutBarAddRequest(1,param2.id,this.gd_spellitemotes.getItemIndex(param1) + this._nPageItems * NUM_ITEMS_PER_PAGE));
                  }
                  else if(param2 is EmoteWrapper)
                  {
                     sysApi.sendAction(new ShortcutBarAddRequest(4,param2.id,this.gd_spellitemotes.getItemIndex(param1) + this._nPageItems * NUM_ITEMS_PER_PAGE));
                  }
                  else if(param2 is SmileyWrapper)
                  {
                     sysApi.sendAction(new ShortcutBarAddRequest(3,param2.id,this.gd_spellitemotes.getItemIndex(param1) + this._nPageItems * NUM_ITEMS_PER_PAGE));
                  }
                  else
                  {
                     sysApi.sendAction(new ShortcutBarAddRequest(0,param2.objectUID,this.gd_spellitemotes.getItemIndex(param1) + this._nPageItems * NUM_ITEMS_PER_PAGE));
                  }
            }
         }
      }
      
      private function onValidQty(param1:Number) : void
      {
         if(param1 <= 0)
         {
            return;
         }
         sysApi.sendAction(new ObjectSetPosition(this._waitingObjectUID,this._waitingObjectPosition,param1));
      }
      
      protected function updateGrid(param1:*, param2:uint, param3:Boolean = true) : void
      {
         var _loc5_:Object = null;
         var _loc6_:uint = 0;
         var _loc4_:Array = new Array();
         for each(_loc5_ in param1)
         {
            if(_loc5_)
            {
               _loc4_[_loc5_.slot - param2 * NUM_ITEMS_PER_PAGE] = _loc5_;
            }
         }
         _loc6_ = 0;
         while(_loc6_ < NUM_PAGES * NUM_ITEMS_PER_PAGE)
         {
            if(!_loc4_[_loc6_])
            {
               _loc4_[_loc6_] = null;
            }
            _loc6_++;
         }
         this.gd_spellitemotes.dataProvider = _loc4_;
         if(!param3)
         {
            this.unselectSpell();
         }
      }
      
      private function emptyFct(... rest) : void
      {
      }
      
      protected function onShortcutBarViewContent(param1:int) : void
      {
         if(param1 == 0)
         {
            this._aItems = this.storageApi.getShortcutBarContent(param1);
            if(this._sTabGrid == ITEMS_TAB)
            {
               this.updateGrid(this._aItems,this._nPageItems);
            }
         }
         else if(param1 == 1 && (!this.fightApi.isSlaveContext() || this.isMainBar))
         {
            this.updateSpellShortcuts();
         }
      }
      
      protected function updateSpellShortcuts() : void
      {
         this._aSpells = this.storageApi.getShortcutBarContent(1);
         var _loc1_:int = this._nPageSpells;
         if(this.fightApi.isSlaveContext())
         {
            this._nPageSpells = 0;
         }
         else
         {
            this._nPageSpells = sysApi.getData("bannerSpellsPageIndex" + this.getPlayerId());
         }
         if(_loc1_ != this._nPageSpells)
         {
            this.displayPage();
         }
         if(this._sTabGrid == SPELLS_TAB)
         {
            this.updateGrid(this._aSpells,this._nPageSpells);
         }
      }
      
      public function onSlaveStatsList(param1:Object) : void
      {
         if(this.isMainBar)
         {
            this.gridDisplay(SPELLS_TAB);
            this.updateGrid(this._aSpells,this._nPageSpells);
         }
      }
      
      public function unload() : void
      {
         sysApi.removeHook(UiUnloaded);
         this._delayUseObjectTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onDelayUseObjectTimer);
         this._delayUseObjectTimer.stop();
         this.uiApi.setFollowCursorUri(null);
      }
      
      public function onCancelCastSpell(param1:Object) : void
      {
         this.uiApi.setFollowCursorUri(null);
      }
      
      public function onCastSpellMode(param1:Object) : void
      {
         this.uiApi.setFollowCursorUri(param1.iconUri,false,false,15,15,0.75);
      }
      
      private function onSpellTooltipDisplayOption(param1:String) : void
      {
         var _loc2_:SpellTooltipSettings = this.getSpellTooltipSettings();
         _loc2_[param1] = !_loc2_[param1];
         this.setSpellTooltipSettings(_loc2_);
         this.tooltipApi.resetSpellTooltipCache();
      }
      
      private function onItemTooltipDisplayOption(param1:String) : void
      {
         var _loc2_:ItemTooltipSettings = this.getItemTooltipSettings();
         _loc2_[param1] = !_loc2_[param1];
         var _loc3_:Boolean = this.setItemTooltipSettings(_loc2_);
      }
      
      private function onDropStart(param1:Object) : void
      {
         if(param1.getUi() == this.uiApi.me())
         {
            sysApi.disableWorldInteraction();
         }
      }
      
      private function onDropEnd(param1:Object) : void
      {
         if(param1.getUi() == this.uiApi.me() && !this.uiApi.getUi(UIEnum.GRIMOIRE))
         {
            sysApi.enableWorldInteraction();
         }
      }
      
      public function onSelectItem(param1:Object, param2:uint, param3:Boolean) : void
      {
         var _loc4_:ShortcutWrapper = null;
         var _loc5_:String = null;
         var _loc6_:Object = null;
         switch(param1)
         {
            case this.gd_spellitemotes:
               switch(this._sTabGrid)
               {
                  case SPELLS_TAB:
                     _loc4_ = param1.selectedItem;
                     if(_loc4_)
                     {
                        if(sysApi.isFightContext() && this.uiApi.keyIsDown(Keyboard.ALTERNATE) && _loc4_.realItem)
                        {
                           _loc5_ = this.playerApi.canCastThisSpellWithResult((_loc4_.realItem as SpellWrapper).spellId,(_loc4_.realItem as SpellWrapper).spellLevel);
                           sysApi.sendAction(new ChatTextOutput(_loc5_,ChatActivableChannelsEnum.CHANNEL_TEAM,null,null));
                        }
                        else if(param2 == GridItemSelectMethodEnum.DOUBLE_CLICK)
                        {
                           sysApi.dispatchHook(OpenSpellInterface,_loc4_.id);
                        }
                        else if(param1.selectedItem.active)
                        {
                           sysApi.sendAction(new GameFightSpellCast(_loc4_.id));
                        }
                     }
                     else if(sysApi.isFightContext())
                     {
                        sysApi.sendAction(new BannerEmptySlotClick());
                     }
                     break;
                  case ITEMS_TAB:
                     if(!param1.selectedItem || !param1.selectedItem.active)
                     {
                        break;
                     }
                     if(param1.selectedItem.type == TYPE_PRESET_WRAPPER || param1.selectedItem.type == TYPE_SMILEY_WRAPPER || param1.selectedItem.type == TYPE_EMOTE_WRAPPER || param1.selectedItem.type == TYPE_IDOLS_PRESET_WRAPPER)
                     {
                        if(param2 == GridItemSelectMethodEnum.DOUBLE_CLICK || param2 == GridItemSelectMethodEnum.MANUAL)
                        {
                           this.useItem(param1.selectedItem.id,param1.selectedItem.type);
                        }
                     }
                     else
                     {
                        _loc6_ = this.inventoryApi.getItem(param1.selectedItem.id);
                        if(!_loc6_)
                        {
                           break;
                        }
                        if(param2 == GridItemSelectMethodEnum.DOUBLE_CLICK)
                        {
                           if(_loc6_.usable)
                           {
                              this.useItem(param1.selectedItem.id);
                           }
                           else if(_loc6_.hasOwnProperty("isCertificate") && _loc6_.isCertificate)
                           {
                              sysApi.sendAction(new MountInfoRequest(_loc6_));
                           }
                        }
                        else if(param2 == GridItemSelectMethodEnum.CLICK)
                        {
                           if(_loc6_.targetable && !this.uiApi.keyIsDown(16))
                           {
                              this.onItemUseOnCell(param1.selectedItem.id);
                           }
                           sysApi.dispatchHook(ObjectSelected,_loc6_);
                        }
                        else if(param2 == GridItemSelectMethodEnum.MANUAL)
                        {
                           if(_loc6_.targetable)
                           {
                              this.onItemUseOnCell(param1.selectedItem.id);
                           }
                           else if(_loc6_.usable)
                           {
                              this.useItem(param1.selectedItem.id);
                           }
                        }
                        if(_loc6_.category == 0 && (param2 == GridItemSelectMethodEnum.DOUBLE_CLICK || param2 == GridItemSelectMethodEnum.MANUAL))
                        {
                           this.equipItem(_loc6_);
                        }
                        if(_loc6_.category != 0 && !_loc6_.usable && !_loc6_.targetable)
                        {
                           if(_loc6_.typeId == 178)
                           {
                              sysApi.sendAction(new OpenIdols());
                           }
                        }
                     }
                     break;
               }
         }
      }
      
      public function equipItem(param1:Object) : void
      {
         var _loc2_:int = 0;
         var _loc4_:Object = null;
         var _loc5_:Number = NaN;
         var _loc6_:Object = null;
         var _loc3_:int = param1.objectUID;
         if(param1.position <= CharacterInventoryPositionEnum.ACCESSORY_POSITION_SHIELD || param1.position == CharacterInventoryPositionEnum.INVENTORY_POSITION_COMPANION)
         {
            _loc2_ = CharacterInventoryPositionEnum.INVENTORY_POSITION_NOT_EQUIPED;
         }
         else
         {
            _loc2_ = this.storageApi.getBestEquipablePosition(param1);
            if(param1.quantity > 1)
            {
               _loc4_ = this.storageApi.getViewContent("equipment");
               for each(_loc6_ in _loc4_)
               {
                  if(_loc6_ && _loc6_.position == _loc2_ && _loc6_.objectGID == param1.objectGID)
                  {
                     _loc2_ = CharacterInventoryPositionEnum.INVENTORY_POSITION_NOT_EQUIPED;
                     _loc3_ = _loc6_.objectUID;
                  }
               }
            }
         }
         if(_loc2_ > -1)
         {
            sysApi.sendAction(new ObjectSetPosition(_loc3_,_loc2_,1));
         }
      }
      
      public function onPress(param1:Object) : void
      {
         switch(param1)
         {
            case this.gd_spellitemotes:
               this.uiApi.hideTooltip();
         }
      }
      
      public function onRelease(param1:Object) : void
      {
         switch(param1)
         {
            case this.btn_tabItems:
               this.gridDisplay(ITEMS_TAB);
               break;
            case this.btn_tabSpells:
               this.gridDisplay(SPELLS_TAB);
               break;
            case this.btn_upArrow:
               this.pageItemUp();
               break;
            case this.btn_downArrow:
               this.pageItemDown();
               break;
            case this.btn_addActionBar:
               this.addNewActionBar();
         }
      }
      
      public function onRollOver(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc6_:String = null;
         var _loc7_:Object = null;
         var _loc3_:uint = 7;
         var _loc4_:uint = 1;
         var _loc5_:String = null;
         switch(param1)
         {
            case this.btn_tabSpells:
               _loc2_ = this.uiApi.getText("ui.charcrea.spells");
               _loc5_ = this.bindsApi.getShortcutBindStr("bannerSpellsTab");
               break;
            case this.btn_tabItems:
               _loc2_ = this.uiApi.getText("ui.common.objects");
               _loc5_ = this.bindsApi.getShortcutBindStr("bannerItemsTab");
               break;
            case this.btn_upArrow:
               _loc2_ = this.uiApi.getText("ui.common.prevPage");
               _loc5_ = this.bindsApi.getShortcutBindStr("pageItemUp");
               break;
            case this.btn_downArrow:
               _loc3_ = 1;
               _loc4_ = 7;
               _loc2_ = this.uiApi.getText("ui.common.nextPage");
               _loc5_ = this.bindsApi.getShortcutBindStr("pageItemDown");
               break;
            case this.btn_addActionBar:
               _loc2_ = this.uiApi.getText("ui.banner.addActionBar");
         }
         if(_loc5_)
         {
            if(!_shortcutColor)
            {
               _shortcutColor = sysApi.getConfigEntry("colors.shortcut");
               _shortcutColor = _shortcutColor.replace("0x","#");
            }
            if(_loc2_)
            {
               _loc7_ = this.uiApi.textTooltipInfo(_loc2_ + " <font color=\'" + _shortcutColor + "\'>(" + _loc5_ + ")</font>");
            }
            else if(_loc6_)
            {
               _loc7_ = this.uiApi.textTooltipInfo(this.uiApi.getText(_loc6_,"<font color=\'" + _shortcutColor + "\'>(" + _loc5_ + ")</font>"));
            }
         }
         else
         {
            _loc7_ = this.uiApi.textTooltipInfo(_loc2_);
         }
         this.uiApi.showTooltip(_loc7_,param1,false,"standard",_loc3_,_loc4_,3,null,null,null,"TextInfo");
      }
      
      public function onRollOut(param1:Object) : void
      {
         this.uiApi.hideTooltip();
      }
      
      protected function addNewActionBar(param1:int = -1) : void
      {
         var _loc4_:* = undefined;
         var _loc2_:* = null;
         var _loc3_:uint = 0;
         for each(_loc4_ in externalActionBars)
         {
            if(!_loc4_.mainCtr.visible)
            {
               _loc3_++;
               if(!_loc2_)
               {
                  _loc2_ = _loc4_;
               }
            }
         }
         if(_loc2_)
         {
            if(_loc2_.orientation == ExternalActionBar.ORIENTATION_VERTICAL)
            {
               this.reloadExternalActionBar(_loc2_.actionBarId,currentContext);
               return;
            }
            _loc2_.show();
         }
         this.btn_addActionBar.disabled = _loc3_ < 2;
      }
      
      protected function canAddExternalActionBar() : Boolean
      {
         var _loc1_:* = undefined;
         for each(_loc1_ in externalActionBars)
         {
            if(!_loc1_ || !_loc1_.mainCtr.visible)
            {
               return true;
            }
         }
         return false;
      }
      
      protected function get dataKey() : String
      {
         var _loc1_:String = currentContext == ContextEnum.ROLEPLAY?"rp":"fight";
         return EXTERNAL_UI_BASE_NAME + "StateData_" + _loc1_ + "_" + this.playerApi.id();
      }
   }
}
