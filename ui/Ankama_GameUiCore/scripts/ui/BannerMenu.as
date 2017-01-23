package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Grid;
   import com.ankamagames.berilia.components.Slot;
   import com.ankamagames.berilia.components.TextureBitmap;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.datacenter.misc.OptionalFeature;
   import com.ankamagames.dofus.internalDatacenter.arena.ArenaRankInfosWrapper;
   import com.ankamagames.dofus.internalDatacenter.userInterface.ButtonWrapper;
   import com.ankamagames.dofus.uiApi.BindsApi;
   import com.ankamagames.dofus.uiApi.ConfigApi;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.HighlightApi;
   import com.ankamagames.dofus.uiApi.PlayedCharacterApi;
   import com.ankamagames.dofus.uiApi.RoleplayApi;
   import com.ankamagames.dofus.uiApi.SocialApi;
   import com.ankamagames.dofus.uiApi.TimeApi;
   import com.ankamagames.dofusModuleLibrary.enum.interfaces.UIEnum;
   import d2actions.CloseInventory;
   import d2actions.ExchangeRequestOnMountStock;
   import d2actions.ExchangeRequestOnShopStock;
   import d2actions.HavenbagEnter;
   import d2actions.MountToggleRidingRequest;
   import d2actions.OpenArena;
   import d2actions.OpenBook;
   import d2actions.OpenIdols;
   import d2actions.OpenInventory;
   import d2actions.OpenMap;
   import d2actions.OpenMount;
   import d2actions.OpenSocial;
   import d2actions.OpenStats;
   import d2actions.OpenWebService;
   import d2enums.AlignmentSideEnum;
   import d2enums.LocationEnum;
   import d2enums.ProtocolConstantsEnum;
   import d2enums.PvpArenaStepEnum;
   import d2enums.SelectMethodEnum;
   import d2enums.ShortcutHookListEnum;
   import d2hooks.AddBannerButton;
   import d2hooks.AllianceMembershipUpdated;
   import d2hooks.ArenaRegistrationStatusUpdate;
   import d2hooks.ArenaUpdateRank;
   import d2hooks.CharacterLevelUp;
   import d2hooks.CharacterStatsList;
   import d2hooks.ConfigPropertyChange;
   import d2hooks.DisplayUiArrow;
   import d2hooks.GuildMembershipUpdated;
   import d2hooks.KeyDown;
   import d2hooks.KeyUp;
   import d2hooks.MountSet;
   import d2hooks.MountUnSet;
   import d2hooks.MouseClick;
   import d2hooks.SecureModeChange;
   import d2hooks.SpouseUpdated;
   import d2hooks.TextInformation;
   import d2hooks.UiUnloaded;
   import flash.geom.Point;
   import flash.ui.Keyboard;
   import flash.utils.getTimer;
   import ui.enums.ContextEnum;
   
   public class BannerMenu extends ContextAwareUi
   {
      
      private static var _shortcutColor:String;
      
      private static const SHORTCUT_DISABLE_DURATION:Number = 500;
       
      
      public const ID_BTN_CARAC:int = 1;
      
      public const ID_BTN_SPELL:int = 2;
      
      public const ID_BTN_BAG:int = 3;
      
      public const ID_BTN_BOOK:int = 4;
      
      public const ID_BTN_MAP:int = 5;
      
      public const ID_BTN_FRIEND:int = 6;
      
      public const ID_BTN_GUILD:int = 7;
      
      public const ID_BTN_CONQUEST:int = 8;
      
      public const ID_BTN_OGRINE:int = 9;
      
      public const ID_BTN_JOB:int = 10;
      
      public const ID_BTN_ALLIANCE:int = 11;
      
      public const ID_BTN_MOUNT:int = 12;
      
      public const ID_BTN_SHOP:int = 13;
      
      public const ID_BTN_SPOUSE:int = 14;
      
      public const ID_BTN_KROZ:int = 15;
      
      public const ID_BTN_ALMANAX:int = 16;
      
      public const ID_BTN_ACHIEVEMENT:int = 17;
      
      public const ID_BTN_TITLE:int = 18;
      
      public const ID_BTN_BESTIARY:int = 19;
      
      public const ID_BTN_ALIGNMENT:int = 20;
      
      public const ID_BTN_DIRECTORY:int = 21;
      
      public const ID_BTN_COMPANION:int = 22;
      
      public const ID_BTN_IDOLS:int = 23;
      
      public const ID_BTN_HAVENBAG:int = 24;
      
      public const ID_BTN_DARE:int = 25;
      
      public const ID_BTN_MORE:int = 2147483647;
      
      [Module(name="Ankama_Common")]
      public var modCommon:Object;
      
      public var uiApi:UiApi;
      
      public var dataApi:DataApi;
      
      public var playerApi:PlayedCharacterApi;
      
      public var configApi:ConfigApi;
      
      public var bindsApi:BindsApi;
      
      public var highlightApi:HighlightApi;
      
      public var timeApi:TimeApi;
      
      public var rpApi:RoleplayApi;
      
      public var socialApi:SocialApi;
      
      public var mainCtr:GraphicContainer;
      
      public var gd_btnUis:Grid;
      
      public var ctr_moreBtn:GraphicContainer;
      
      public var gd_additionalBtns:Grid;
      
      public var tx_separator:TextureBitmap;
      
      public var btn_more_slot:Slot;
      
      private var _dataProviderButtons:Array;
      
      private var _aBtnOrderForCache:Array;
      
      private var _uiBtnHeight:int;
      
      private var _uiBtnOffset:int;
      
      private var _openAdditionalBtns:Boolean;
      
      private var _secureMode:Boolean = false;
      
      private var _bArenaRegistered:Boolean;
      
      private var _btn_more:ButtonWrapper;
      
      private var _isDragging:Boolean = false;
      
      private var _shortcutTimerDuration:Number = 0;
      
      private var _big:Boolean = false;
      
      private var _allowDrag:Boolean;
      
      private var _lastTotalVisibleBtns:uint;
      
      private var _havenbagPopupId:String;
      
      public function BannerMenu()
      {
         super();
      }
      
      override public function main(param1:Array) : void
      {
         var _loc2_:Boolean = false;
         var _loc6_:Object = null;
         super.main(param1);
         sysApi.addHook(DisplayUiArrow,this.onDisplayUiArrow);
         sysApi.addHook(ArenaUpdateRank,this.onArenaUpdateRank);
         sysApi.addHook(MouseClick,this.onGenericMouseClick);
         sysApi.addHook(AddBannerButton,this.onAddBannerButton);
         sysApi.addHook(SpouseUpdated,this.onSpouseUpdated);
         sysApi.addHook(GuildMembershipUpdated,this.onGuildMembershipUpdated);
         sysApi.addHook(AllianceMembershipUpdated,this.onAllianceMembershipUpdated);
         sysApi.addHook(ArenaRegistrationStatusUpdate,this.onArenaRegistrationStatusUpdate);
         sysApi.addHook(SecureModeChange,this.onSecureModeChange);
         sysApi.addHook(MountSet,this.onMountSet);
         sysApi.addHook(MountUnSet,this.onMountUnSet);
         sysApi.addHook(CharacterStatsList,this.onCharacterStatsList);
         sysApi.addHook(ConfigPropertyChange,this.onConfigChange);
         sysApi.addHook(KeyUp,this.onKeyUp);
         sysApi.addHook(KeyDown,this.onKeyDown);
         if(this.playerApi.getPlayedCharacterInfo().level < ProtocolConstantsEnum.MIN_LEVEL_HAVENBAG)
         {
            sysApi.addHook(UiUnloaded,this.onUiUnloaded);
         }
         if(this.playerApi.getPlayedCharacterInfo().level < ProtocolConstantsEnum.CHAR_MIN_LEVEL_ARENA)
         {
            sysApi.addHook(CharacterLevelUp,this.onCharacterLevelUp);
         }
         this.uiApi.addComponentHook(this.gd_additionalBtns,"onSelectItem");
         this.uiApi.addComponentHook(this.gd_additionalBtns,"onItemRollOver");
         this.uiApi.addComponentHook(this.gd_additionalBtns,"onItemRollOut");
         this.uiApi.addComponentHook(this.gd_btnUis,"onSelectItem");
         this.uiApi.addComponentHook(this.gd_btnUis,"onItemRollOver");
         this.uiApi.addComponentHook(this.gd_btnUis,"onItemRollOut");
         this.uiApi.addShortcutHook("openCharacterSheet",this.onShortcut);
         this.uiApi.addShortcutHook("openInventory",this.onShortcut);
         this.uiApi.addShortcutHook("openBookSpell",this.onShortcut);
         this.uiApi.addShortcutHook("openBookQuest",this.onShortcut);
         this.uiApi.addShortcutHook("openBookAlignment",this.onShortcut);
         this.uiApi.addShortcutHook("openBookJob",this.onShortcut);
         this.uiApi.addShortcutHook("openWorldMap",this.onShortcut);
         this.uiApi.addShortcutHook("openSocialFriends",this.onShortcut);
         this.uiApi.addShortcutHook("openSocialGuild",this.onShortcut);
         this.uiApi.addShortcutHook("openSocialAlliance",this.onShortcut);
         this.uiApi.addShortcutHook("openSocialSpouse",this.onShortcut);
         this.uiApi.addShortcutHook("openPvpArena",this.onShortcut);
         this.uiApi.addShortcutHook("openSell",this.onShortcut);
         this.uiApi.addShortcutHook("openMount",this.onShortcut);
         this.uiApi.addShortcutHook("openAlmanax",this.onShortcut);
         this.uiApi.addShortcutHook("openAchievement",this.onShortcut);
         this.uiApi.addShortcutHook("openTitle",this.onShortcut);
         this.uiApi.addShortcutHook("openBestiary",this.onShortcut);
         this.uiApi.addShortcutHook("openMountStorage",this.onShortcut);
         this.uiApi.addShortcutHook("openHavenbag",this.onShortcut);
         this.uiApi.addShortcutHook("openWebBrowser",this.onShortcut);
         this.uiApi.addShortcutHook("openDare",this.onShortcut);
         this.uiApi.addShortcutHook(ShortcutHookListEnum.OPEN_IDOLS,this.onShortcut);
         this.uiApi.addShortcutHook(ShortcutHookListEnum.TOGGLE_RIDE,this.onShortcut);
         this._big = sysApi.getOption("bigMenuButton","dofus");
         this._uiBtnHeight = this.uiApi.me().getConstant("ui_btn_height");
         this.gd_btnUis.slotHeight = this._uiBtnHeight * (!!this._big?1.5:1);
         this.gd_btnUis.slotWidth = this._uiBtnHeight * (!!this._big?1.5:1);
         this._uiBtnOffset = this.uiApi.me().getConstant("ui_btn_offset");
         this._dataProviderButtons = new Array();
         this._aBtnOrderForCache = sysApi.getData("uiBtnOrder2");
         if(this._aBtnOrderForCache == null)
         {
            _loc2_ = true;
            this._aBtnOrderForCache = new Array();
         }
         this.gd_btnUis.autoSelectMode = 0;
         this.gd_additionalBtns.autoSelectMode = 0;
         this.onAddBannerButton(this.ID_BTN_CARAC,"btn_carac",this.onCharacterAction,this.uiApi.getText("ui.banner.character"),this.bindsApi.getShortcutBindStr("openCharacterSheet"));
         this.onAddBannerButton(this.ID_BTN_SPELL,"btn_spell",this.onSpellsAction,this.uiApi.getText("ui.grimoire.mySpell"),this.bindsApi.getShortcutBindStr("openBookSpell"));
         this.onAddBannerButton(this.ID_BTN_BAG,"btn_bag",this.onItemsAction,this.uiApi.getText("ui.banner.inventory"),this.bindsApi.getShortcutBindStr("openInventory"));
         this.onAddBannerButton(this.ID_BTN_BOOK,"btn_book",this.onQuestsAction,this.uiApi.getText("ui.common.quests"),this.bindsApi.getShortcutBindStr("openBookQuest"));
         this.onAddBannerButton(this.ID_BTN_MAP,"btn_map",this.onMapAction,this.uiApi.getText("ui.banner.map"),this.bindsApi.getShortcutBindStr("openWorldMap"));
         this.onAddBannerButton(this.ID_BTN_FRIEND,"btn_friend",this.onFriendsAction,this.uiApi.getText("ui.banner.friends"),this.bindsApi.getShortcutBindStr("openSocialFriends"));
         this.onAddBannerButton(this.ID_BTN_IDOLS,"btn_idols",this.onIdolsAction,this.uiApi.getText("ui.idol.idols"),this.bindsApi.getShortcutBindStr("openIdols"));
         this.onAddBannerButton(this.ID_BTN_OGRINE,"btn_veteran",this.onWebAction,this.uiApi.getText("ui.banner.shopGifts"),this.bindsApi.getShortcutBindStr("openWebBrowser"),this.uiApi.getText("ui.banner.lockBtn.secureMode"));
         this.onAddBannerButton(this.ID_BTN_CONQUEST,"btn_conquest",this.onConquestAction,this.uiApi.getText("ui.common.koliseum"),this.bindsApi.getShortcutBindStr("openPvpArena"),this.uiApi.getText("ui.banner.lockBtn.lvl",ProtocolConstantsEnum.CHAR_MIN_LEVEL_ARENA));
         this.onAddBannerButton(this.ID_BTN_GUILD,"btn_guild",this.onGuildAction,this.uiApi.getText("ui.common.guild"),this.bindsApi.getShortcutBindStr("openSocialGuild"),this.uiApi.getText("ui.banner.lockBtn.guild"));
         this.onAddBannerButton(this.ID_BTN_JOB,"btn_job",this.onJobAction,this.uiApi.getText("ui.common.myJobs"),this.bindsApi.getShortcutBindStr("openBookJob"));
         this.onAddBannerButton(this.ID_BTN_HAVENBAG,"btn_havenbag",this.onHavenBagAction,this.uiApi.getText("ui.havenbag.havenbag"),this.bindsApi.getShortcutBindStr("openHavenbag"),this.uiApi.getText("ui.banner.lockBtn.lvl",ProtocolConstantsEnum.MIN_LEVEL_HAVENBAG));
         this.onAddBannerButton(this.ID_BTN_MOUNT,"btn_mount",this.onMountAction,this.uiApi.getText("ui.banner.mount"),this.bindsApi.getShortcutBindStr("openMount"),this.uiApi.getText("ui.banner.lockBtn.mount"));
         this.onAddBannerButton(this.ID_BTN_SHOP,"btn_shop",this.onShopAction,this.uiApi.getText("ui.common.shop"),this.bindsApi.getShortcutBindStr("openSell"));
         this.onAddBannerButton(this.ID_BTN_SPOUSE,"btn_spouse",this.onSpouseAction,this.uiApi.processText(this.uiApi.getText("ui.common.spouse"),"m",true),this.bindsApi.getShortcutBindStr("openSocialSpouse"),this.uiApi.getText("ui.banner.lockBtn.wed"));
         this.onAddBannerButton(this.ID_BTN_ALMANAX,"btn_almanax",this.onAlmanaxAction,this.uiApi.getText("ui.almanax.almanax"),this.bindsApi.getShortcutBindStr("openAlmanax"));
         this.onAddBannerButton(this.ID_BTN_ACHIEVEMENT,"btn_achievement",this.onAchievementAction,this.uiApi.getText("ui.achievement.achievement"),this.bindsApi.getShortcutBindStr("openAchievement"));
         this.onAddBannerButton(this.ID_BTN_TITLE,"btn_title",this.onTitleAction,this.uiApi.getText("ui.common.titles"),this.bindsApi.getShortcutBindStr("openTitle"),this.uiApi.getText("ui.banner.lockBtn.inRP"));
         this.onAddBannerButton(this.ID_BTN_BESTIARY,"btn_bestiary",this.onBestiaryAction,this.uiApi.getText("ui.common.bestiary"),this.bindsApi.getShortcutBindStr("openBestiary"));
         this.onAddBannerButton(this.ID_BTN_ALIGNMENT,"btn_alignment",this.onAlignmentAction,this.uiApi.getText("ui.common.alignment"),this.bindsApi.getShortcutBindStr("openBookAlignment"),this.uiApi.getText("ui.banner.lockBtn.alignment"));
         this.onAddBannerButton(this.ID_BTN_DIRECTORY,"btn_directory",this.onDirectoryAction,this.uiApi.getText("ui.common.directory"),this.bindsApi.getShortcutBindStr("openSocialDirectory"));
         this.onAddBannerButton(this.ID_BTN_ALLIANCE,"btn_alliance",this.onAllianceAction,this.uiApi.getText("ui.common.alliance"),this.bindsApi.getShortcutBindStr("openSocialAlliance"),this.uiApi.getText("ui.banner.lockBtn.alliance"));
         var _loc3_:OptionalFeature = this.dataApi.getOptionalFeatureByKeyword("dares");
         if(_loc3_ && this.configApi.isOptionalFeatureActive(_loc3_.id))
         {
            this.onAddBannerButton(this.ID_BTN_DARE,"btn_dare",this.onDareAction,this.uiApi.getText("ui.dare.dare"),this.bindsApi.getShortcutBindStr("openDare"));
         }
         this._btn_more = this.dataApi.getButtonWrapper(this.ID_BTN_MORE,int.MAX_VALUE,"btn_bannerBtnsPlus",this.toggleAllButtonsVisibility,this.uiApi.getText("ui.common.moreButtons"));
         this.checkAllBtnActivationState(true);
         this.updateButtonGrids();
         var _loc4_:Object = this.uiApi.createUri(this.uiApi.me().getConstant("acceptDrop_uri"));
         var _loc5_:Object = this.uiApi.createUri(this.uiApi.me().getConstant("refuseDrop_uri"));
         this.gd_btnUis.renderer.dropValidatorFunction = this.dropValidatorBtn;
         this.gd_btnUis.renderer.processDropFunction = this.processDropBtn;
         this.gd_btnUis.renderer.removeDropSourceFunction = this.emptyFct;
         this.gd_btnUis.renderer.acceptDragTexture = _loc4_;
         this.gd_btnUis.renderer.refuseDragTexture = _loc5_;
         this.gd_additionalBtns.renderer.dropValidatorFunction = this.dropValidatorBtn;
         this.gd_additionalBtns.renderer.processDropFunction = this.processDropBtn;
         this.gd_additionalBtns.renderer.removeDropSourceFunction = this.emptyFct;
         this.gd_additionalBtns.renderer.acceptDragTexture = _loc4_;
         this.gd_additionalBtns.renderer.refuseDragTexture = _loc5_;
         for each(_loc6_ in this.gd_btnUis.slots)
         {
            _loc6_.allowDrag = false;
         }
      }
      
      public function renderUpdate() : void
      {
         this.updateButtonGrids();
      }
      
      override protected function onContextChanged(param1:String, param2:String = "", param3:Boolean = false) : void
      {
         var _loc4_:* = undefined;
         switch(param1)
         {
            case ContextEnum.SPECTATOR:
            case ContextEnum.PREFIGHT:
            case ContextEnum.FIGHT:
               this.checkTitle(false,false);
               _loc4_ = this.uiApi.getUi("banner");
               if(_loc4_ && _loc4_.uiClass && !_loc4_.uiClass.mainCtr.getSavedPosition() && !_loc4_.uiClass.mainCtr.getSavedDimension() && !this.mainCtr.getSavedPosition() && !this.mainCtr.getSavedDimension())
               {
                  this.mainCtr.x = parseInt(this.uiApi.me().getConstant("defaultFightX"));
               }
               break;
            case ContextEnum.ROLEPLAY:
               this.checkTitle(false,true);
               _loc4_ = this.uiApi.getUi("banner");
               if(_loc4_ && _loc4_.uiClass && !_loc4_.uiClass.mainCtr.getSavedPosition() && !_loc4_.uiClass.mainCtr.getSavedDimension() && !this.mainCtr.getSavedPosition() && !this.mainCtr.getSavedDimension())
               {
                  this.mainCtr.x = parseInt(this.uiApi.me().getConstant("defaultRpX"));
               }
         }
      }
      
      private function toggleAllButtonsVisibility() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         if(this.ctr_moreBtn.visible)
         {
            this.ctr_moreBtn.visible = false;
            for each(_loc1_ in this.gd_btnUis.slots)
            {
               _loc1_.allowDrag = false;
            }
         }
         else
         {
            this.ctr_moreBtn.visible = true;
            for each(_loc1_ in this.gd_btnUis.slots)
            {
               if(_loc1_.data && _loc1_.data.position == this.ID_BTN_MORE)
               {
                  _loc2_ = _loc1_;
               }
               else
               {
                  _loc1_.allowDrag = true;
               }
            }
            _loc3_ = this.uiApi.getVisibleStageBounds();
            _loc4_ = (this.mainCtr as Object).localToGlobal(new Point(this.mainCtr.x,this.mainCtr.y));
            if(_loc4_.x + this.mainCtr.width + 35 - _loc3_.x > _loc3_.width)
            {
               if(this.ctr_moreBtn.height < this.mainCtr.y)
               {
                  this.ctr_moreBtn.x = this.mainCtr.width - this.ctr_moreBtn.width;
                  this.ctr_moreBtn.y = -this.ctr_moreBtn.height;
               }
               else
               {
                  this.ctr_moreBtn.x = -this.ctr_moreBtn.width;
                  this.ctr_moreBtn.y = Math.max(-this.ctr_moreBtn.height + this.mainCtr.height,-this.mainCtr.y);
               }
            }
            else
            {
               this.ctr_moreBtn.x = this.mainCtr.width - 6;
               this.ctr_moreBtn.y = Math.max(-this.ctr_moreBtn.height + this.mainCtr.height,-this.mainCtr.y);
            }
         }
      }
      
      private function onKeyUp(param1:Object, param2:uint) : void
      {
         var _loc3_:* = undefined;
         if(param2 != Keyboard.CONTROL)
         {
            return;
         }
         if(this.ctr_moreBtn.visible || !this._allowDrag)
         {
            return;
         }
         this._allowDrag = false;
         for each(_loc3_ in this.gd_btnUis.slots)
         {
            _loc3_.allowDrag = false;
         }
      }
      
      private function onKeyDown(param1:Object, param2:uint) : void
      {
         var _loc3_:* = undefined;
         if(param2 != Keyboard.CONTROL)
         {
            return;
         }
         if(this.ctr_moreBtn.visible || this._allowDrag)
         {
            return;
         }
         this._allowDrag = true;
         for each(_loc3_ in this.gd_btnUis.slots)
         {
            if(!(_loc3_.data && _loc3_.data.position == this.ID_BTN_MORE))
            {
               _loc3_.allowDrag = true;
            }
         }
      }
      
      public function onSelectItem(param1:Object, param2:uint, param3:Boolean) : void
      {
         var _loc4_:ButtonWrapper = null;
         switch(param1)
         {
            case this.gd_additionalBtns:
            case this.gd_btnUis:
               if(param2 != SelectMethodEnum.AUTO)
               {
                  _loc4_ = param1.selectedItem as ButtonWrapper;
                  if(_loc4_ && _loc4_.active)
                  {
                     _loc4_.callback.call();
                  }
               }
         }
      }
      
      public function onItemRollOver(param1:Object, param2:Object) : void
      {
         var _loc4_:Object = null;
         var _loc8_:String = null;
         var _loc3_:Object = this.uiApi.getUi(UIEnum.BANNER).getElement(!!sysApi.isFightContext()?"tooltipFightPlacer":"tooltipRoleplayPlacer");
         var _loc5_:String = "banner::gd_spellitemotes::item";
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
         if(param1 == this.gd_btnUis || param1 == this.gd_additionalBtns)
         {
            _loc8_ = param2.data.name;
            if(param2.data.shortcut)
            {
               if(!_shortcutColor)
               {
                  _shortcutColor = sysApi.getConfigEntry("colors.shortcut");
                  _shortcutColor = _shortcutColor.replace("0x","#");
               }
               _loc8_ = _loc8_ + (" <font color=\'" + _shortcutColor + "\'>(" + param2.data.shortcut + ")</font>");
            }
            if(!param2.data.active && param2.data.description)
            {
               _loc8_ = _loc8_ + ("\n<i>" + param2.data.description + "</i>");
            }
            this.uiApi.showTooltip(this.uiApi.textTooltipInfo(_loc8_),param2.container,false,"standard",LocationEnum.POINT_BOTTOMRIGHT,LocationEnum.POINT_TOPRIGHT,0,null,null,null,"TextInfo");
         }
      }
      
      public function onItemRollOut(param1:Object, param2:Object) : void
      {
         this.uiApi.hideTooltip();
      }
      
      public function onShortcut(param1:String) : Boolean
      {
         var _loc2_:OptionalFeature = null;
         var _loc3_:Object = null;
         switch(param1)
         {
            case "openCharacterSheet":
               if(this.shortcutTimerReady())
               {
                  sysApi.sendAction(new OpenStats());
               }
               return true;
            case "openInventory":
               if(this.shortcutTimerReady())
               {
                  this.openInventory();
               }
               return true;
            case "openBookSpell":
               this.onSpellsAction();
               return true;
            case "openBookAlignment":
               this.onAlignmentAction();
               return true;
            case "openBookJob":
               if(this.shortcutTimerReady())
               {
                  sysApi.sendAction(new OpenBook("jobTab"));
               }
               return true;
            case "openWorldMap":
               if(this.shortcutTimerReady())
               {
                  sysApi.sendAction(new OpenMap(false,true,false));
               }
               return true;
            case "openSocialAlliance":
               this.onAllianceAction();
               return true;
            case "openTitle":
               this.onTitleAction();
               return true;
            case "openBestiary":
               if(this.shortcutTimerReady())
               {
                  sysApi.sendAction(new OpenBook("bestiaryTab"));
               }
               return true;
            case "openHavenbag":
               this.onHavenBagAction();
               return true;
            case "openWebBrowser":
               this.onWebAction();
               return true;
            case "openBookQuest":
               if(this.shortcutTimerReady())
               {
                  sysApi.sendAction(new OpenBook("questTab"));
               }
               return true;
            case "openAchievement":
               if(this.shortcutTimerReady())
               {
                  sysApi.sendAction(new OpenBook("achievementTab"));
               }
               return true;
            case "openAlmanax":
               if(this.shortcutTimerReady())
               {
                  sysApi.sendAction(new OpenBook("calendarTab"));
               }
               return true;
            case "openSocialFriends":
               if(this.shortcutTimerReady())
               {
                  sysApi.sendAction(new OpenSocial("0"));
               }
               return true;
            case "openSocialGuild":
               this.onGuildAction();
               return true;
            case "openSocialSpouse":
               this.onSpouseAction();
               return true;
            case "openPvpArena":
               this.onConquestAction();
               return true;
            case "openSell":
               if(this.shortcutTimerReady())
               {
                  if(!this.uiApi.getUi("stockMyselfVendor"))
                  {
                     Api.system.sendAction(new ExchangeRequestOnShopStock());
                  }
                  else
                  {
                     this.uiApi.unloadUi("stockMyselfVendor");
                  }
               }
               return true;
            case "openMount":
               this.onMountAction();
               return true;
            case "openMountStorage":
               if(this.shortcutTimerReady() && this.playerApi.getMount())
               {
                  if(this.playerApi.isInFight())
                  {
                     sysApi.dispatchHook(TextInformation,this.uiApi.getText("ui.error.cantDoInFight"),666,this.timeApi.getTimestamp());
                  }
                  else
                  {
                     _loc3_ = this.uiApi.getUi(UIEnum.STORAGE_UI);
                     if(_loc3_)
                     {
                        if(_loc3_.uiClass.currentStorageBehavior.getName() == "mount")
                        {
                           sysApi.sendAction(new CloseInventory());
                        }
                        else
                        {
                           sysApi.sendAction(new ExchangeRequestOnMountStock());
                        }
                     }
                     else
                     {
                        sysApi.sendAction(new ExchangeRequestOnMountStock());
                     }
                  }
               }
               return true;
            case "openDare":
               _loc2_ = this.dataApi.getOptionalFeatureByKeyword("dares");
               if(_loc2_ && this.configApi.isOptionalFeatureActive(_loc2_.id))
               {
                  this.onDareAction();
               }
               return true;
            case ShortcutHookListEnum.TOGGLE_RIDE:
               if(this.shortcutTimerReady() && this.playerApi.getMount())
               {
                  sysApi.sendAction(new MountToggleRidingRequest());
               }
               return true;
            case ShortcutHookListEnum.OPEN_IDOLS:
               if(this.shortcutTimerReady())
               {
                  if(!this.uiApi.getUi("idolsTab"))
                  {
                     sysApi.sendAction(new OpenIdols());
                  }
                  else
                  {
                     sysApi.sendAction(new OpenBook("idolsTab"));
                  }
               }
               return true;
            default:
               return false;
         }
      }
      
      private function updateButtonGrids() : void
      {
         var _loc4_:Object = null;
         var _loc5_:Array = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         if(!this._dataProviderButtons)
         {
            return;
         }
         var _loc1_:uint = this.totalNumberOfVisibleButtons;
         this._lastTotalVisibleBtns = _loc1_;
         if(_loc1_ < this._dataProviderButtons.length)
         {
            _loc1_--;
         }
         this._dataProviderButtons.sortOn("position",Array.NUMERIC);
         var _loc2_:Array = this._dataProviderButtons.slice(0,_loc1_);
         var _loc3_:Boolean = false;
         if(_loc1_ + 1 < this._dataProviderButtons.length)
         {
            _loc2_.push(this._btn_more);
            _loc3_ = true;
         }
         if(_loc1_ > _loc2_.length)
         {
            _loc1_ = _loc2_.length;
         }
         this.gd_btnUis.dataProvider = _loc2_;
         if(_loc3_)
         {
            this.gd_btnUis.slots[_loc1_].allowDrag = false;
            this.btn_more_slot = this.gd_btnUis.slots[_loc1_];
            _loc5_ = this._dataProviderButtons.slice(_loc1_);
            _loc6_ = _loc5_.length;
            _loc7_ = _loc6_ * this._uiBtnHeight;
            _loc8_ = _loc6_ * this._uiBtnOffset;
            if(_loc8_ >= this._uiBtnHeight)
            {
               _loc8_ = this._uiBtnHeight - 1;
            }
            this.ctr_moreBtn.height = _loc7_ + _loc8_ + this._uiBtnOffset;
            this.gd_additionalBtns.height = _loc7_ + _loc8_;
            this.gd_additionalBtns.dataProvider = _loc5_;
         }
         else
         {
            this.gd_additionalBtns.dataProvider = false;
            this.btn_more_slot = null;
         }
         for each(_loc4_ in this.gd_btnUis.slots)
         {
            _loc4_.allowDrag = this.ctr_moreBtn.visible || this._allowDrag;
         }
      }
      
      private function get totalNumberOfVisibleButtons() : uint
      {
         var _loc1_:Number = this._uiBtnHeight * (!!this._big?1.5:1);
         return Math.floor(this.gd_btnUis.width / _loc1_) * Math.floor(this.gd_btnUis.height / _loc1_);
      }
      
      private function dropValidatorBtn(param1:Object, param2:Object, param3:Object) : Boolean
      {
         if(!param2 || param1 && param1.data && param1.data.id == int.MAX_VALUE || param3 && param3.data && param3.data.id == int.MAX_VALUE)
         {
            return false;
         }
         return param2 is ButtonWrapper;
      }
      
      private function processDropBtn(param1:Object, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:Slot = null;
         var _loc6_:Boolean = false;
         var _loc7_:Boolean = false;
         var _loc8_:Object = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:ButtonWrapper = null;
         var _loc14_:int = 0;
         var _loc15_:Boolean = false;
         var _loc16_:Boolean = false;
         var _loc17_:Array = null;
         if(this.dropValidatorBtn(param1,param2,param3))
         {
            _loc4_ = param2.id;
            _loc5_ = this.getSlotByBtnId(_loc4_);
            _loc6_ = _loc5_.selected;
            _loc7_ = _loc5_.disabled;
            if(param1 && !param1.data)
            {
               _loc9_ = -1;
               _loc10_ = 0;
               while(_loc10_ < this._dataProviderButtons.length)
               {
                  if(_loc9_ > -1)
                  {
                     _loc11_ = (this._dataProviderButtons[_loc10_ - 1] as ButtonWrapper).position;
                     _loc12_ = (this._dataProviderButtons[_loc10_] as ButtonWrapper).position;
                     this._aBtnOrderForCache[(this._dataProviderButtons[_loc10_ - 1] as ButtonWrapper).id] = _loc12_;
                     this._aBtnOrderForCache[(this._dataProviderButtons[_loc10_] as ButtonWrapper).id] = _loc11_;
                     this.rpApi.switchButtonWrappers(this._dataProviderButtons[_loc10_ - 1],this._dataProviderButtons[_loc10_]);
                     _loc13_ = this._dataProviderButtons[_loc10_ - 1];
                     this._dataProviderButtons[_loc10_ - 1] = this._dataProviderButtons[_loc10_];
                     this._dataProviderButtons[_loc10_] = _loc13_;
                  }
                  if(this._dataProviderButtons[_loc10_].id == _loc4_ && _loc9_ == -1)
                  {
                     _loc9_ = _loc10_;
                  }
                  _loc10_++;
               }
               if(_loc9_ == -1)
               {
                  return;
               }
            }
            else
            {
               _loc14_ = param1.data.id;
               _loc5_ = this.getSlotByBtnId(_loc14_);
               _loc15_ = _loc5_.selected;
               _loc16_ = _loc5_.disabled;
               this._aBtnOrderForCache[_loc4_] = param1.data.position;
               this._aBtnOrderForCache[_loc14_] = param2.position;
               this.rpApi.switchButtonWrappers(param2,param1.data);
               _loc5_ = this.getSlotByBtnId(_loc14_);
               _loc5_.selected = _loc15_;
               _loc5_.disabled = _loc16_;
               this.refreshButtonAtIndex(this.getBtnById(_loc14_).position);
            }
            sysApi.setData("uiBtnOrder2",this._aBtnOrderForCache);
            this.updateButtonGrids();
            this.uiApi.hideTooltip();
            _loc5_ = this.getSlotByBtnId(_loc4_);
            _loc5_.selected = _loc6_;
            _loc5_.disabled = _loc7_;
            this.refreshButtonAtIndex(this.getBtnById(_loc4_).position);
            _loc8_ = this.highlightApi.getArrowUiProperties();
            if(_loc8_ && _loc8_.uiName == UIEnum.BANNER && (_loc8_.componentName.indexOf("gd_btnUis") != -1 || _loc8_.componentName.indexOf("gd_additionalBtns") != -1))
            {
               _loc17_ = _loc8_.componentName.split("|");
               _loc17_[0] = this.getBtnById(_loc4_).position > this.totalNumberOfVisibleButtons?"gd_additionalBtns":"gd_btnUis";
               this.highlightApi.highlightUi(UIEnum.BANNER,_loc17_.join("|"),_loc8_.pos,_loc8_.reverse,_loc8_.strata,_loc8_.loop);
            }
         }
      }
      
      private function emptyFct(... rest) : void
      {
      }
      
      public function onAddBannerButton(param1:int, param2:String, param3:Function = null, param4:String = "", param5:String = "", param6:String = "") : void
      {
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         if(!this._aBtnOrderForCache[param1])
         {
            _loc7_ = 0;
            for each(_loc8_ in this._aBtnOrderForCache)
            {
               if(_loc8_ > _loc7_)
               {
                  _loc7_ = _loc8_;
               }
            }
            this._aBtnOrderForCache[param1] = _loc7_ + 1;
         }
         this._dataProviderButtons.push(this.dataApi.getButtonWrapper(param1,this._aBtnOrderForCache[param1],param2,param3,param4,param5,param6));
      }
      
      private function onGenericMouseClick(param1:Object) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Object = null;
         if(param1 is Slot && param1.data is ButtonWrapper && param1.data.position == this.ID_BTN_MORE)
         {
            return;
         }
         if(param1 != this.ctr_moreBtn && !this._isDragging && this.ctr_moreBtn.visible && !this._openAdditionalBtns)
         {
            this.ctr_moreBtn.visible = false;
            for each(_loc2_ in this.gd_btnUis.slots)
            {
               _loc2_.allowDrag = false;
            }
            _loc3_ = this.highlightApi.getArrowUiProperties();
            if(_loc3_ && _loc3_.uiName == UIEnum.BANNER && _loc3_.componentName.indexOf("gd_additionalBtns") != -1)
            {
               this.highlightApi.stop();
            }
         }
         this._openAdditionalBtns = false;
      }
      
      private function onArenaUpdateRank(param1:ArenaRankInfosWrapper, param2:ArenaRankInfosWrapper = null) : void
      {
         if(!this.getBtnById(this.ID_BTN_CONQUEST).active && this.playerApi.getPlayedCharacterInfo().level >= 50)
         {
            this.checkConquest();
         }
      }
      
      private function onDisplayUiArrow(param1:Object) : void
      {
         var _loc2_:Array = null;
         var _loc3_:ButtonWrapper = null;
         if(param1.uiName == UIEnum.BANNER)
         {
            _loc2_ = param1.componentName.split("|");
            if(_loc2_[0] == "gd_btnUis")
            {
               for each(_loc3_ in this._dataProviderButtons)
               {
                  if(_loc3_.hasOwnProperty(_loc2_[1]) && _loc3_[_loc2_[1]] == _loc2_[2])
                  {
                     if(_loc3_.position > this.totalNumberOfVisibleButtons)
                     {
                        if(!this.ctr_moreBtn.visible)
                        {
                           this.toggleAllButtonsVisibility();
                        }
                        this.highlightApi.highlightUi(UIEnum.BANNER,param1.componentName.replace("gd_btnUis","gd_additionalBtns"),param1.pos,param1.reverse,param1.strata,param1.loop);
                        this._openAdditionalBtns = true;
                     }
                     break;
                  }
               }
            }
         }
      }
      
      private function onCharacterAction() : void
      {
         if(this.shortcutTimerReady() && this.getBtnById(this.ID_BTN_CARAC).active)
         {
            sysApi.sendAction(new OpenStats());
         }
      }
      
      private function onSpellsAction() : void
      {
         if(this.shortcutTimerReady() && this.getBtnById(this.ID_BTN_SPELL).active)
         {
            sysApi.sendAction(new OpenBook("spellTab"));
         }
      }
      
      private function onItemsAction() : void
      {
         if(this.shortcutTimerReady() && this.getBtnById(this.ID_BTN_BAG).active)
         {
            this.openInventory();
         }
      }
      
      private function onQuestsAction() : void
      {
         if(this.shortcutTimerReady() && this.getBtnById(this.ID_BTN_BOOK).active)
         {
            sysApi.sendAction(new OpenBook("questTab"));
         }
      }
      
      private function onMapAction() : void
      {
         if(this.shortcutTimerReady() && this.getBtnById(this.ID_BTN_MAP).active)
         {
            sysApi.sendAction(new OpenMap());
         }
      }
      
      private function onFriendsAction() : void
      {
         if(this.shortcutTimerReady() && this.getBtnById(this.ID_BTN_FRIEND).active)
         {
            sysApi.sendAction(new OpenSocial("0"));
         }
      }
      
      private function onGuildAction() : void
      {
         if(this.shortcutTimerReady())
         {
            if(this.getBtnById(this.ID_BTN_GUILD).active)
            {
               sysApi.sendAction(new OpenSocial("1"));
            }
            else
            {
               sysApi.dispatchHook(TextInformation,this.uiApi.getText("ui.error.onlyForGuild"),666,this.timeApi.getTimestamp());
            }
         }
      }
      
      private function onConquestAction() : void
      {
         if(this.shortcutTimerReady())
         {
            if(this.getBtnById(this.ID_BTN_CONQUEST).active)
            {
               this.getSlotByBtnId(this.ID_BTN_CONQUEST).selected = this._bArenaRegistered;
               sysApi.sendAction(new OpenArena());
            }
            else
            {
               sysApi.dispatchHook(TextInformation,this.uiApi.getText("ui.error.arenaLock",ProtocolConstantsEnum.CHAR_MIN_LEVEL_ARENA),666,this.timeApi.getTimestamp());
            }
         }
      }
      
      private function onWebAction() : void
      {
         var _loc1_:String = null;
         if(this.shortcutTimerReady())
         {
            if(this.getBtnById(this.ID_BTN_OGRINE).active)
            {
               _loc1_ = null;
               if(sysApi.isSteamEmbed())
               {
                  _loc1_ = "webShop";
               }
               sysApi.sendAction(new OpenWebService(_loc1_));
            }
            else
            {
               sysApi.dispatchHook(TextInformation,this.uiApi.getText("ui.error.onlyIfModeSecured"),666,this.timeApi.getTimestamp());
            }
         }
      }
      
      private function onAlignmentAction() : void
      {
         if(this.shortcutTimerReady())
         {
            if(this.getBtnById(this.ID_BTN_ALIGNMENT).active)
            {
               sysApi.sendAction(new OpenBook("alignmentTab"));
            }
            else
            {
               sysApi.dispatchHook(TextInformation,this.uiApi.getText("ui.error.onlyForAligned"),666,this.timeApi.getTimestamp());
            }
         }
      }
      
      private function onAllianceAction() : void
      {
         if(this.shortcutTimerReady())
         {
            if(this.getBtnById(this.ID_BTN_ALLIANCE).active)
            {
               sysApi.sendAction(new OpenSocial("2"));
            }
            else
            {
               sysApi.dispatchHook(TextInformation,this.uiApi.getText("ui.error.onlyForAlliance"),666,this.timeApi.getTimestamp());
            }
         }
      }
      
      private function onDareAction() : void
      {
         if(this.shortcutTimerReady())
         {
            sysApi.sendAction(new OpenSocial("5"));
         }
      }
      
      private function onJobAction() : void
      {
         if(this.shortcutTimerReady() && this.getBtnById(this.ID_BTN_JOB).active)
         {
            sysApi.sendAction(new OpenBook("jobTab"));
         }
      }
      
      private function onMountAction() : void
      {
         if(this.shortcutTimerReady())
         {
            if(this.getBtnById(this.ID_BTN_MOUNT).active)
            {
               sysApi.sendAction(new OpenMount());
            }
            else if(!this.playerApi.getMount())
            {
               sysApi.dispatchHook(TextInformation,this.uiApi.getText("ui.error.onlyForMount"),666,this.timeApi.getTimestamp());
            }
         }
      }
      
      private function onSpouseAction() : void
      {
         if(this.shortcutTimerReady())
         {
            if(this.getBtnById(this.ID_BTN_SPOUSE).active)
            {
               sysApi.sendAction(new OpenSocial("3"));
            }
            else
            {
               sysApi.dispatchHook(TextInformation,this.uiApi.getText("ui.error.wedLock"),666,this.timeApi.getTimestamp());
            }
         }
      }
      
      private function onAlmanaxAction() : void
      {
         if(this.shortcutTimerReady() && this.getBtnById(this.ID_BTN_ALMANAX).active)
         {
            sysApi.sendAction(new OpenBook("calendarTab"));
         }
      }
      
      private function onAchievementAction() : void
      {
         if(this.shortcutTimerReady() && this.getBtnById(this.ID_BTN_ACHIEVEMENT).active)
         {
            sysApi.sendAction(new OpenBook("achievementTab"));
         }
      }
      
      private function onTitleAction() : void
      {
         if(this.shortcutTimerReady())
         {
            if(this.getBtnById(this.ID_BTN_TITLE).active)
            {
               sysApi.sendAction(new OpenBook("titleTab"));
            }
            else
            {
               sysApi.dispatchHook(TextInformation,this.uiApi.getText("ui.error.onlyOutsideCombat"),666,this.timeApi.getTimestamp());
            }
         }
      }
      
      private function onBestiaryAction() : void
      {
         if(this.shortcutTimerReady() && this.getBtnById(this.ID_BTN_BESTIARY).active)
         {
            sysApi.sendAction(new OpenBook("bestiaryTab"));
         }
      }
      
      private function onShopAction() : void
      {
         if(this.shortcutTimerReady() && this.getBtnById(this.ID_BTN_SHOP).active)
         {
            if(!this.uiApi.getUi("stockMyselfVendor"))
            {
               Api.system.sendAction(new ExchangeRequestOnShopStock());
            }
            else
            {
               this.uiApi.unloadUi("stockMyselfVendor");
            }
         }
      }
      
      private function onDirectoryAction() : void
      {
         if(this.shortcutTimerReady() && this.getBtnById(this.ID_BTN_DIRECTORY).active)
         {
            sysApi.sendAction(new OpenSocial("4"));
         }
      }
      
      private function onIdolsAction() : void
      {
         if(this.shortcutTimerReady() && this.getBtnById(this.ID_BTN_IDOLS).active)
         {
            if(!this.uiApi.getUi("idolsTab"))
            {
               sysApi.sendAction(new OpenIdols());
            }
            else
            {
               sysApi.sendAction(new OpenBook("idolsTab"));
            }
         }
      }
      
      private function onHavenBagAction() : void
      {
         if(this.shortcutTimerReady())
         {
            if(this.getBtnById(this.ID_BTN_HAVENBAG).active)
            {
               if(this._havenbagPopupId)
               {
                  this.uiApi.unloadUi(this._havenbagPopupId);
                  this._havenbagPopupId = null;
               }
               sysApi.sendAction(new HavenbagEnter());
            }
            else
            {
               sysApi.dispatchHook(TextInformation,this.uiApi.getText("ui.error.havenbagLock",ProtocolConstantsEnum.MIN_LEVEL_HAVENBAG),666,this.timeApi.getTimestamp());
            }
         }
      }
      
      public function checkMount(param1:Boolean = false) : void
      {
         var _loc2_:ButtonWrapper = this.getBtnById(this.ID_BTN_MOUNT);
         if(this.playerApi.getMount() != null)
         {
            this.rpApi.setButtonWrapperActivation(_loc2_,true);
         }
         else
         {
            this.rpApi.setButtonWrapperActivation(_loc2_,false);
         }
         if(!param1)
         {
            this.refreshButtonAtIndex(_loc2_.position);
         }
      }
      
      public function checkSpouse(param1:Boolean = false) : void
      {
         var _loc2_:ButtonWrapper = this.getBtnById(this.ID_BTN_SPOUSE);
         if(this.socialApi.hasSpouse())
         {
            this.rpApi.setButtonWrapperActivation(_loc2_,true);
         }
         else
         {
            this.rpApi.setButtonWrapperActivation(_loc2_,false);
         }
         if(!param1)
         {
            this.refreshButtonAtIndex(_loc2_.position);
         }
      }
      
      public function checkAlliance(param1:Boolean = false) : void
      {
         var _loc2_:ButtonWrapper = this.getBtnById(this.ID_BTN_ALLIANCE);
         if(this.socialApi.hasAlliance())
         {
            this.rpApi.setButtonWrapperActivation(_loc2_,true);
         }
         else
         {
            this.rpApi.setButtonWrapperActivation(_loc2_,false);
         }
         if(!param1)
         {
            this.refreshButtonAtIndex(_loc2_.position);
         }
      }
      
      public function checkGuild(param1:Boolean = false) : void
      {
         var _loc2_:ButtonWrapper = this.getBtnById(this.ID_BTN_GUILD);
         if(this.socialApi.hasGuild())
         {
            this.rpApi.setButtonWrapperActivation(_loc2_,true);
         }
         else
         {
            this.rpApi.setButtonWrapperActivation(_loc2_,false);
         }
         if(!param1)
         {
            this.refreshButtonAtIndex(_loc2_.position);
         }
      }
      
      public function checkConquest(param1:Boolean = false) : void
      {
         var _loc2_:ButtonWrapper = this.getBtnById(this.ID_BTN_CONQUEST);
         var _loc3_:OptionalFeature = this.dataApi.getOptionalFeatureByKeyword("pvp.arena");
         if(this.playerApi.getPlayedCharacterInfo().level >= ProtocolConstantsEnum.CHAR_MIN_LEVEL_ARENA && _loc3_ && this.configApi.isOptionalFeatureActive(_loc3_.id))
         {
            this.rpApi.setButtonWrapperActivation(_loc2_,true);
         }
         else
         {
            this.rpApi.setButtonWrapperActivation(_loc2_,false);
         }
         if(!param1)
         {
            this.refreshButtonAtIndex(_loc2_.position);
         }
      }
      
      public function checkWeb(param1:Boolean = false) : void
      {
         var _loc2_:ButtonWrapper = this.getBtnById(this.ID_BTN_OGRINE);
         if(!this._secureMode)
         {
            this.rpApi.setButtonWrapperActivation(_loc2_,true);
         }
         else
         {
            this.rpApi.setButtonWrapperActivation(_loc2_,false);
         }
         if(!param1)
         {
            this.refreshButtonAtIndex(_loc2_.position);
         }
      }
      
      public function checkTitle(param1:Boolean = false, param2:Boolean = true) : void
      {
         var _loc3_:ButtonWrapper = this.getBtnById(this.ID_BTN_TITLE);
         this.rpApi.setButtonWrapperActivation(_loc3_,param2);
         if(!param1)
         {
            this.refreshButtonAtIndex(_loc3_.position);
         }
      }
      
      public function checkHavenbag(param1:Boolean = false) : void
      {
         var _loc2_:ButtonWrapper = this.getBtnById(this.ID_BTN_HAVENBAG);
         if(this.playerApi.getPlayedCharacterInfo().level >= ProtocolConstantsEnum.MIN_LEVEL_HAVENBAG)
         {
            this.rpApi.setButtonWrapperActivation(_loc2_,true);
         }
         else
         {
            this.rpApi.setButtonWrapperActivation(_loc2_,false);
         }
         if(!param1)
         {
            this.refreshButtonAtIndex(_loc2_.position);
         }
      }
      
      public function checkAlignement(param1:Boolean = false) : void
      {
         var _loc2_:ButtonWrapper = this.getBtnById(this.ID_BTN_ALIGNMENT);
         if(this.playerApi.getAlignmentSide() != AlignmentSideEnum.ALIGNMENT_NEUTRAL)
         {
            this.rpApi.setButtonWrapperActivation(_loc2_,true);
         }
         else
         {
            this.rpApi.setButtonWrapperActivation(_loc2_,false);
         }
         if(!param1)
         {
            this.refreshButtonAtIndex(_loc2_.position);
         }
      }
      
      private function onSpouseUpdated() : void
      {
         this.checkSpouse();
      }
      
      private function onGuildMembershipUpdated(param1:Boolean) : void
      {
         this.checkGuild();
         this.checkAlliance();
      }
      
      private function onAllianceMembershipUpdated(param1:Boolean) : void
      {
         this.checkAlliance();
      }
      
      private function onSecureModeChange(param1:Boolean) : void
      {
         this._secureMode = param1;
         this.checkWeb();
      }
      
      public function checkAllBtnActivationState(param1:Boolean = false) : void
      {
         this.checkMount(param1);
         this.checkSpouse(param1);
         this.checkGuild(param1);
         this.checkAlliance(param1);
         this.checkConquest(param1);
         this.checkWeb(param1);
         this.checkHavenbag(param1);
         this.checkAlignement(param1);
      }
      
      public function getBtnById(param1:int) : ButtonWrapper
      {
         var _loc2_:ButtonWrapper = null;
         for each(_loc2_ in this._dataProviderButtons)
         {
            if(_loc2_.id == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function setDisabledBtn(param1:int, param2:Boolean) : void
      {
         var _loc3_:ButtonWrapper = this.getBtnById(param1);
         this.rpApi.setButtonWrapperActivation(_loc3_,!param2);
         this.refreshButtonAtIndex(_loc3_.position);
      }
      
      public function setDisabledBtns(param1:Boolean) : void
      {
         var _loc2_:ButtonWrapper = null;
         for each(_loc2_ in this._dataProviderButtons)
         {
            this.rpApi.setButtonWrapperActivation(_loc2_,!param1);
            this.refreshButtonAtIndex(_loc2_.position);
         }
      }
      
      public function getSlotByBtnId(param1:int) : Slot
      {
         var _loc2_:int = this.getBtnById(param1).position;
         if(_loc2_ < this.totalNumberOfVisibleButtons || _loc2_ == this.totalNumberOfVisibleButtons && this.gd_additionalBtns.slots.length == 0)
         {
            return this.gd_btnUis.slots[_loc2_ - 1];
         }
         return this.gd_additionalBtns.slots[_loc2_ - this.totalNumberOfVisibleButtons];
      }
      
      public function refreshButtonAtIndex(param1:uint) : void
      {
         var _loc2_:int = this.gd_btnUis.dataProvider.length;
         if(this.gd_additionalBtns.dataProvider.length)
         {
            _loc2_--;
         }
         if(param1 <= _loc2_)
         {
            this.gd_btnUis.updateItem(param1 - 1);
         }
         else
         {
            this.gd_additionalBtns.updateItem(param1 - _loc2_ - 1);
         }
      }
      
      private function onCharacterLevelUp(param1:uint, param2:uint, param3:uint, param4:uint, param5:Object, param6:Boolean, param7:int) : void
      {
         var _loc8_:* = null;
         if(this.playerApi)
         {
            _loc8_ = this.playerApi.getPlayedCharacterInfo();
         }
         if(_loc8_)
         {
            if(_loc8_.level >= ProtocolConstantsEnum.CHAR_MIN_LEVEL_ARENA)
            {
               this.checkConquest();
               sysApi.removeHook(CharacterLevelUp);
            }
         }
      }
      
      private function onUiUnloaded(param1:String) : void
      {
         var _loc2_:uint = 0;
         if(param1 && param1.indexOf("levelUp") == 0 && this.playerApi && this.playerApi.getPlayedCharacterInfo() && this.playerApi.getPlayedCharacterInfo().level >= ProtocolConstantsEnum.MIN_LEVEL_HAVENBAG)
         {
            this.checkHavenbag();
            _loc2_ = this.getBtnById(this.ID_BTN_HAVENBAG).position;
            if(_loc2_ > this.totalNumberOfVisibleButtons && !this.ctr_moreBtn.visible)
            {
               this.toggleAllButtonsVisibility();
               Api.highlight.highlightUi("bannerMenu","gd_additionalBtns|id|" + this.ID_BTN_HAVENBAG,3,0,5,true);
            }
            else
            {
               Api.highlight.highlightUi("bannerMenu","gd_btnUis|id|" + this.ID_BTN_HAVENBAG,0,0,5,true);
            }
            this._havenbagPopupId = this.modCommon.openIllustratedPopup(this.uiApi.getText("ui.havenbag.unlockPopup"),"tx_illu_HavenbagUnlocked.JPG",this.onHavenbagPopupClose);
            sysApi.removeHook(UiUnloaded);
         }
      }
      
      private function onHavenbagPopupClose() : void
      {
         this._havenbagPopupId = null;
         Api.highlight.stop();
      }
      
      private function onArenaRegistrationStatusUpdate(param1:Boolean, param2:int) : void
      {
         var _loc3_:Object = null;
         if(param1 != this._bArenaRegistered)
         {
            if(param1)
            {
               this.getSlotByBtnId(this.ID_BTN_CONQUEST).selected = true;
            }
            else
            {
               this.getSlotByBtnId(this.ID_BTN_CONQUEST).selected = false;
               if(param2 != PvpArenaStepEnum.ARENA_STEP_STARTING_FIGHT)
               {
                  _loc3_ = this.uiApi.textTooltipInfo(this.uiApi.getText("ui.party.arenaNotAnymoreIn"));
                  this.uiApi.showTooltip(_loc3_,this.getSlotByBtnId(this.ID_BTN_CONQUEST),true,"standard",7,1,3,null,null,null,"TextInfo");
               }
            }
            this._bArenaRegistered = param1;
         }
      }
      
      private function onMountSet() : void
      {
         this.checkMount();
      }
      
      private function onMountUnSet() : void
      {
         this.checkMount();
      }
      
      public function onCharacterStatsList(param1:Boolean = false, param2:Object = null) : void
      {
         this.checkAlignement(false);
      }
      
      public function onConfigChange(param1:String, param2:String, param3:*, param4:*) : void
      {
         this._big = sysApi.getOption("bigMenuButton","dofus");
         this._uiBtnHeight = this.uiApi.me().getConstant("ui_btn_height");
         this.gd_btnUis.slotHeight = this._uiBtnHeight * (!!this._big?1.5:1);
         this.gd_btnUis.slotWidth = this._uiBtnHeight * (!!this._big?1.5:1);
         this.updateButtonGrids();
      }
      
      private function shortcutTimerReady() : Boolean
      {
         var _loc1_:int = getTimer();
         var _loc2_:* = _loc1_ - this._shortcutTimerDuration > SHORTCUT_DISABLE_DURATION;
         this._shortcutTimerDuration = _loc1_;
         if(_loc2_)
         {
         }
         return _loc2_;
      }
      
      private function onDropStart(param1:Object) : void
      {
         this._isDragging = true;
      }
      
      private function onDropEnd(param1:Object) : void
      {
         this._isDragging = false;
      }
      
      private function openInventory() : void
      {
         var _loc1_:Object = null;
         if(this.uiApi.getUi(UIEnum.STORAGE_UI))
         {
            _loc1_ = this.uiApi.getUi(UIEnum.STORAGE_UI);
            if(!_loc1_ || _loc1_.uiClass.currentStorageBehavior.getName() == "bag")
            {
               sysApi.sendAction(new CloseInventory());
            }
         }
         else
         {
            sysApi.sendAction(new OpenInventory());
         }
      }
   }
}
