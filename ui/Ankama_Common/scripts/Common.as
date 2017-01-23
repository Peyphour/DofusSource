package
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.modules.utils.ItemTooltipSettings;
   import com.ankamagames.dofus.uiApi.ConfigApi;
   import com.ankamagames.dofus.uiApi.SecurityApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofus.uiApi.TooltipApi;
   import com.ankamagames.dofusModuleLibrary.enum.interfaces.UIEnum;
   import d2enums.BuildTypeEnum;
   import d2enums.DataStoreEnum;
   import d2enums.StrataEnum;
   import d2hooks.AllDownloadTerminated;
   import d2hooks.AuthenticationTicketAccepted;
   import d2hooks.ClosePopup;
   import d2hooks.ErrorPopup;
   import d2hooks.GameStart;
   import d2hooks.LoginQueueStatus;
   import d2hooks.OpenComic;
   import d2hooks.OpenFeed;
   import d2hooks.OpenMountFeed;
   import d2hooks.OpenRecipe;
   import d2hooks.OpenSet;
   import d2hooks.OpenWebPortal;
   import d2hooks.PartInfo;
   import d2hooks.QueueStatus;
   import d2hooks.SecureModeChange;
   import d2hooks.ShowObjectLinked;
   import flash.display.Sprite;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   import options.OptionItem;
   import options.OptionManager;
   import ui.BetaMenu;
   import ui.CheckboxPopup;
   import ui.DelayedClosurePopup;
   import ui.DownloadUi;
   import ui.FeedUi;
   import ui.FlashComicReaderUi;
   import ui.GameMenu;
   import ui.IllustratedPopup;
   import ui.IllustratedWithLinkPopup;
   import ui.ImagePopup;
   import ui.InputComboBoxPopup;
   import ui.InputPopup;
   import ui.ItemBox;
   import ui.ItemBoxPopup;
   import ui.ItemRecipes;
   import ui.ItemsSet;
   import ui.LargePopup;
   import ui.LockedPopup;
   import ui.OptionContainer;
   import ui.PasswordMenu;
   import ui.Payment;
   import ui.PollPopup;
   import ui.Popup;
   import ui.QuantityPopup;
   import ui.QueuePopup;
   import ui.Recipes;
   import ui.SecureMode;
   import ui.SecureModeIcon;
   import ui.WebPortal;
   import ui.items.RecipeItem;
   import ui.items.RecipesFilterWrapper;
   
   public class Common extends Sprite
   {
      
      private static var _self:Common;
      
      private static const VIP_IDS:Array = [3003078,3003178,65611403,3031421,3029727,3029948,3030024];
       
      
      private var include_Popup:Popup = null;
      
      private var include_InputPopup:InputPopup = null;
      
      private var include_InputComboBoxPopup:InputComboBoxPopup = null;
      
      private var include_CheckboxPopup:CheckboxPopup = null;
      
      private var include_PollPopup:PollPopup = null;
      
      private var include_ImagePopup:ImagePopup = null;
      
      private var include_LargePopup:LargePopup = null;
      
      private var include_DelayedClosurePopup:DelayedClosurePopup = null;
      
      private var include_QuantityPopup:QuantityPopup = null;
      
      private var include_OptionContainer:OptionContainer = null;
      
      private var include_PasswordMenu:PasswordMenu = null;
      
      private var include_Payment:Payment = null;
      
      private var include_ItemRecipes:ItemRecipes = null;
      
      private var include_ItemsSet:ItemsSet = null;
      
      private var include_RecipeItem:RecipeItem = null;
      
      private var include_BetaMenu:BetaMenu = null;
      
      private var include_GameMenu:GameMenu = null;
      
      private var include_QueuePopup:QueuePopup = null;
      
      private var include_Recipes:Recipes = null;
      
      private var include_FeedUi:FeedUi = null;
      
      private var include_LockedPopup:LockedPopup = null;
      
      private var include_ItemBox:ItemBox = null;
      
      private var include_WebPortal:WebPortal = null;
      
      private var include_ItemBoxPopup:ItemBoxPopup = null;
      
      private var include_SecureMode:SecureMode = null;
      
      private var include_SecureModeIcon:SecureModeIcon = null;
      
      private var include_downloadUi:DownloadUi = null;
      
      private var include_FlashComicReaderUi:FlashComicReaderUi = null;
      
      private var include_illustratedPopup:IllustratedPopup = null;
      
      private var include_illustratedWithLinkPopup:IllustratedWithLinkPopup = null;
      
      private var _secureModeNeedReboot:Object;
      
      private var _lastPage:int = -1;
      
      private var _popupId:uint = 0;
      
      private var _isFullScreen:Boolean = false;
      
      private var _lastFoodQuantity:int = 1;
      
      private var _recipeSlotsNumber:int;
      
      private var _jobSearchOptions:Dictionary;
      
      public var uiApi:UiApi;
      
      public var configApi:ConfigApi;
      
      public var sysApi:SystemApi;
      
      public var secureApi:SecurityApi;
      
      public var tooltipApi:TooltipApi;
      
      [Module(name="Ankama_ContextMenu")]
      public var modMenu:Object = null;
      
      private var _currentPopupNumber:int = 0;
      
      public function Common()
      {
         this._secureModeNeedReboot = {"reboot":false};
         this._jobSearchOptions = new Dictionary();
         super();
      }
      
      public static function getInstance() : Common
      {
         return _self;
      }
      
      public function main() : void
      {
         Api.ui = this.uiApi;
         Api.system = this.sysApi;
         Api.tooltip = this.tooltipApi;
         this.uiApi.initDefaultBinds();
         this.uiApi.addShortcutHook("toggleFullscreen",this.onToggleFullScreen);
         this.sysApi.addHook(OpenRecipe,this.onOpenItemRecipes);
         this.sysApi.addHook(OpenSet,this.onOpenItemSet);
         this.sysApi.addHook(OpenFeed,this.onOpenFeed);
         this.sysApi.addHook(OpenMountFeed,this.onOpenMountFeed);
         this.sysApi.addHook(LoginQueueStatus,this.onLoginQueueStatus);
         this.sysApi.addHook(QueueStatus,this.onQueueStatus);
         this.sysApi.addHook(OpenWebPortal,this.onOpenWebPortal);
         this.sysApi.addHook(ShowObjectLinked,this.onShowObjectLinked);
         this.sysApi.addHook(SecureModeChange,this.onSecureModeChange);
         this.sysApi.addHook(PartInfo,this.onPartInfo);
         this.sysApi.addHook(AllDownloadTerminated,this.onAllDownloadTerminated);
         this.sysApi.addHook(ErrorPopup,this.onErrorPopup);
         this.sysApi.addHook(ClosePopup,this.onClosePopup);
         this.sysApi.addHook(OpenComic,this.onOpenComic);
         this.sysApi.addHook(AuthenticationTicketAccepted,this.onConnectionStart);
         this.sysApi.addHook(GameStart,this.onGameStart);
         var _loc1_:uint = this.sysApi.getPlayerManager().accountId;
         var _loc2_:Boolean = this.sysApi.getBuildType() == BuildTypeEnum.BETA && (!this.sysApi.getConfigKey("eventMode") || this.sysApi.getConfigKey("eventMode") == "false");
         var _loc3_:Boolean = this.sysApi.getBuildType() >= BuildTypeEnum.INTERNAL && VIP_IDS.indexOf(_loc1_) != -1;
         if(_loc2_ || _loc3_)
         {
            this.uiApi.loadUi("betaMenu","betaMenu",{
               "visibleBugReportBtn":_loc2_,
               "visiblePartyTimeBtn":_loc3_
            },StrataEnum.STRATA_TOP);
         }
         this.uiApi.loadUi("gameMenu","gameMenu",null,StrataEnum.STRATA_TOP);
         _self = this;
      }
      
      public function get lastFoodQuantity() : int
      {
         return this._lastFoodQuantity;
      }
      
      public function set lastFoodQuantity(param1:int) : void
      {
         this._lastFoodQuantity = param1;
      }
      
      public function get recipeSlotsNumber() : int
      {
         return this._recipeSlotsNumber;
      }
      
      public function set recipeSlotsNumber(param1:int) : void
      {
         this._recipeSlotsNumber = param1;
      }
      
      public function addOptionItem(param1:String, param2:String, param3:String, param4:String = null, param5:Array = null) : void
      {
         OptionManager.getInstance().addItem(new OptionItem(param1,param2,param3,param4,param5));
      }
      
      public function getJobSearchOptionsByJobId(param1:int) : RecipesFilterWrapper
      {
         return this._jobSearchOptions[param1];
      }
      
      public function setJobSearchOptionsByJobId(param1:RecipesFilterWrapper) : void
      {
         this._jobSearchOptions[param1.jobId] = param1;
      }
      
      public function onAllDownloadTerminated() : void
      {
         this.openPopup(this.uiApi.getText("ui.popup.warning"),this.uiApi.getText("ui.split.rebootConfirm",[]),[this.uiApi.getText("ui.common.yes"),this.uiApi.getText("ui.common.no")],[this.onConfirmRestart,null],this.onConfirmRestart);
      }
      
      private function onConfirmRestart() : void
      {
         this.sysApi.reset();
      }
      
      private function onErrorPopup(param1:String) : void
      {
         this.openPopup(this.uiApi.getText("ui.common.error"),param1,[this.uiApi.getText("ui.common.ok")]);
      }
      
      private function onClosePopup() : void
      {
         this._currentPopupNumber--;
      }
      
      public function openPopup(param1:String, param2:String, param3:Array, param4:Array = null, param5:Function = null, param6:Function = null, param7:Object = null, param8:Boolean = false, param9:Boolean = false) : String
      {
         this._currentPopupNumber++;
         var _loc10_:Object = new Object();
         _loc10_.title = param1;
         _loc10_.content = param2;
         _loc10_.buttonText = param3;
         _loc10_.buttonCallback = !!param4?param4:new Array();
         _loc10_.onEnterKey = param5;
         _loc10_.onCancel = param6;
         _loc10_.image = param7;
         _loc10_.useHyperLink = param9;
         _loc10_.hideModalContainer = this._currentPopupNumber > 1;
         var _loc11_:String = "popup" + ++this._popupId;
         if(param7 == null)
         {
            if(param8)
            {
               this.uiApi.loadUi("largePopup",_loc11_,_loc10_,3);
            }
            else
            {
               this.uiApi.loadUi("popup",_loc11_,_loc10_,3);
            }
         }
         else
         {
            this.uiApi.loadUi("imagepopup",_loc11_,_loc10_,3);
         }
         return _loc11_;
      }
      
      public function openIllustratedPopup(param1:String, param2:String, param3:Function = null) : String
      {
         this._currentPopupNumber++;
         var _loc4_:Object = new Object();
         _loc4_.content = param1;
         _loc4_.illustrationFileName = param2;
         _loc4_.onClose = param3;
         var _loc5_:String = "popup" + ++this._popupId;
         this.uiApi.loadUi("illustratedPopup",_loc5_,_loc4_,3);
         return _loc5_;
      }
      
      public function openIllustratedWithLinkPopup(param1:String, param2:String, param3:String, param4:String, param5:Function = null) : String
      {
         this._currentPopupNumber++;
         var _loc6_:Object = new Object();
         _loc6_.title = param1;
         _loc6_.content = param2;
         _loc6_.link = param3;
         _loc6_.illustrationFileName = param4;
         _loc6_.onClose = param5;
         var _loc7_:String = "popup" + ++this._popupId;
         this.uiApi.loadUi("illustratedWithLinkPopup",_loc7_,_loc6_,3);
         return _loc7_;
      }
      
      public function openNoButtonPopup(param1:String, param2:String) : String
      {
         this._currentPopupNumber++;
         var _loc3_:Object = new Object();
         _loc3_.title = param1;
         _loc3_.content = param2;
         _loc3_.noButton = true;
         _loc3_.hideModalContainer = this._currentPopupNumber > 1;
         var _loc4_:String = "popup" + ++this._popupId;
         this.uiApi.loadUi("popup",_loc4_,_loc3_,3);
         return _loc4_;
      }
      
      public function openTextPopup(param1:String, param2:String, param3:Array, param4:Array = null, param5:Function = null, param6:Function = null) : String
      {
         this._currentPopupNumber++;
         var _loc7_:Object = new Object();
         _loc7_.title = param1;
         _loc7_.content = param2;
         _loc7_.buttonText = param3;
         _loc7_.buttonCallback = !!param4?param4:new Array();
         _loc7_.onEnterKey = param5;
         _loc7_.onCancel = param6;
         _loc7_.noHtml = true;
         _loc7_.hideModalContainer = this._currentPopupNumber > 1;
         var _loc8_:String = "popup" + ++this._popupId;
         this.uiApi.loadUi("popup",_loc8_,_loc7_,3);
         return _loc8_;
      }
      
      public function openDelayedClosurePopup(param1:String, param2:int, param3:int = 0) : void
      {
         var _loc4_:Object = new Object();
         _loc4_.content = param1;
         _loc4_.delay = param2 * 1000;
         _loc4_.marginTop = param3;
         if(this.uiApi.getUi("delayedclosurepopup"))
         {
            this.uiApi.unloadUi("delayedclosurepopup");
         }
         this.uiApi.loadUi("delayedclosurepopup",null,_loc4_,3);
      }
      
      public function openLockedPopup(param1:String, param2:String, param3:Function = null, param4:Boolean = false, param5:Array = null, param6:Boolean = false, param7:Boolean = false) : String
      {
         this._currentPopupNumber++;
         var _loc8_:Object = new Object();
         _loc8_.title = param1;
         _loc8_.content = param2;
         _loc8_.onCancel = param3;
         _loc8_.closeAtHook = param4;
         _loc8_.closeParam = param5 != null?param5:["5000"];
         _loc8_.autoClose = param6;
         _loc8_.useHyperLink = param7;
         _loc8_.hideModalContainer = this._currentPopupNumber > 1;
         var _loc9_:String = "popup" + ++this._popupId;
         this.uiApi.loadUi("lockedPopup",_loc9_,_loc8_,3);
         return _loc9_;
      }
      
      public function openQuantityPopup(param1:Number, param2:Number, param3:Number, param4:Function, param5:Function = null, param6:Boolean = false) : void
      {
         var _loc7_:Object = new Object();
         _loc7_.min = param1;
         _loc7_.max = param2;
         _loc7_.defaultValue = param3;
         _loc7_.validCallback = param4;
         _loc7_.cancelCallback = param5;
         _loc7_.lockValue = param6;
         if(this.uiApi.getUi("quantityPopup"))
         {
            this.uiApi.unloadUi("quantityPopup");
         }
         this.uiApi.loadUi("quantityPopup",null,_loc7_,3);
      }
      
      public function openInputPopup(param1:String, param2:String, param3:Function, param4:Function, param5:String = "", param6:String = null, param7:int = 0) : void
      {
         this._currentPopupNumber++;
         var _loc8_:Object = new Object();
         _loc8_.title = param1;
         _loc8_.content = param2;
         _loc8_.validCallBack = param3;
         _loc8_.cancelCallback = param4;
         _loc8_.defaultValue = param5;
         _loc8_.restric = param6;
         _loc8_.maxChars = param7;
         _loc8_.hideModalContainer = this._currentPopupNumber > 1;
         this.uiApi.loadUi("inputPopup","inputPopup" + this._popupId++,_loc8_,3);
      }
      
      public function openInputComboBoxPopup(param1:String, param2:String, param3:String, param4:Function, param5:Function, param6:Function, param7:String = "", param8:String = null, param9:int = 0, param10:* = null) : void
      {
         this._currentPopupNumber++;
         var _loc11_:Object = new Object();
         _loc11_.title = param1;
         _loc11_.content = param2;
         _loc11_.resetButtonTooltip = param3;
         _loc11_.validCallBack = param4;
         _loc11_.cancelCallback = param5;
         _loc11_.resetCallback = param6;
         _loc11_.defaultValue = param7;
         _loc11_.restric = param8;
         _loc11_.maxChars = param9;
         _loc11_.hideModalContainer = this._currentPopupNumber > 1;
         _loc11_.dataProvider = param10;
         this.uiApi.loadUi("inputComboBoxPopup","inputComboBoxPopup" + this._popupId++,_loc11_,3);
      }
      
      public function openCheckboxPopup(param1:String, param2:String, param3:Function, param4:Function, param5:String, param6:Boolean = false) : void
      {
         this._currentPopupNumber++;
         var _loc7_:Object = new Object();
         _loc7_.title = param1;
         _loc7_.content = param2;
         _loc7_.validCallBack = param3;
         _loc7_.cancelCallback = param4;
         _loc7_.checkboxText = param5;
         _loc7_.defaultSelect = param6;
         _loc7_.hideModalContainer = this._currentPopupNumber > 1;
         this.uiApi.loadUi("checkboxPopup","checkboxPopup" + this._popupId++,_loc7_,3);
      }
      
      public function openPollPopup(param1:String, param2:String, param3:Array, param4:Boolean, param5:Function, param6:Function) : void
      {
         this._currentPopupNumber++;
         var _loc7_:Object = new Object();
         _loc7_.title = param1;
         _loc7_.content = param2;
         _loc7_.validCallBack = param5;
         _loc7_.cancelCallback = param6;
         _loc7_.answers = param3;
         _loc7_.onlyOneAnswer = param4;
         _loc7_.hideModalContainer = this._currentPopupNumber > 1;
         this.uiApi.loadUi("pollPopup","pollPopup" + this._popupId++,_loc7_,3);
      }
      
      public function closeAllMenu() : void
      {
         this.modMenu.closeAllMenu();
      }
      
      public function createContextMenu(param1:Array) : void
      {
         this.modMenu.createContextMenu(param1);
      }
      
      public function createContextMenuTitleObject(param1:String) : Object
      {
         return this.modMenu.createContextMenuTitleObject(param1);
      }
      
      public function createContextMenuItemObject(param1:String, param2:Function = null, param3:Array = null, param4:Boolean = false, param5:Array = null, param6:Boolean = false, param7:Boolean = true, param8:String = null, param9:Boolean = false) : Object
      {
         return this.modMenu.createContextMenuItemObject(param1,param2,param3,param4,param5,param6,param7,param8,param9);
      }
      
      public function createContextMenuSeparatorObject() : Object
      {
         return this.modMenu.createContextMenuSeparatorObject();
      }
      
      public function openOptionMenu(param1:Boolean = false, param2:String = null) : void
      {
         if(!param1 && !this.uiApi.getUi("optionContainer"))
         {
            this.uiApi.loadUi("optionContainer",null,param2,3);
         }
         if(param1)
         {
            this.uiApi.unloadUi("optionContainer");
         }
      }
      
      private function onToggleFullScreen(param1:String) : Boolean
      {
         if(param1 != "toggleFullscreen")
         {
            return true;
         }
         var _loc2_:Boolean = this.configApi.getConfigProperty("dofus","fullScreen");
         if(this.sysApi.isStreaming() && _loc2_)
         {
            this.uiApi.setShortcutUsedToExitFullScreen(true);
         }
         this.configApi.setConfigProperty("dofus","fullScreen",!_loc2_);
         return false;
      }
      
      private function onOpenWebPortal(param1:uint, param2:Boolean = false, param3:Object = null) : void
      {
         if(this.uiApi.getUi(UIEnum.WEB_PORTAL))
         {
            if(param1 == this._lastPage)
            {
               Api.ui.unloadUi(UIEnum.WEB_PORTAL);
            }
            else
            {
               Api.ui.getUi(UIEnum.WEB_PORTAL).uiClass.goTo(param1,param2,param3);
            }
         }
         else
         {
            Api.ui.loadUi(UIEnum.WEB_PORTAL,UIEnum.WEB_PORTAL,[param1,param2,param3],2);
         }
         this._lastPage = param1;
      }
      
      private function onOpenItemRecipes(param1:Object) : void
      {
         Api.ui.unloadUi("itemRecipes");
         Api.ui.loadUi("itemRecipes","itemRecipes",{"item":param1},2);
      }
      
      private function onOpenItemSet(param1:Object) : void
      {
         Api.ui.unloadUi("itemsSet");
         Api.ui.loadUi("itemsSet","itemsSet",{"item":param1},2);
      }
      
      private function onOpenFeed(param1:Object) : void
      {
         Api.ui.unloadUi("feedUi");
         Api.ui.loadUi("feedUi","feedUi",{
            "item":param1,
            "type":1
         },2);
      }
      
      private function onOpenMountFeed(param1:int, param2:int, param3:Object) : void
      {
         Api.ui.unloadUi("feedUi");
         Api.ui.loadUi("feedUi","feedUi",{
            "type":3,
            "mountId":param1,
            "mountLocation":param2,
            "foodList":param3
         },StrataEnum.STRATA_TOP);
      }
      
      private function onShowObjectLinked(param1:Object = null) : void
      {
         var _loc4_:String = null;
         var _loc2_:* = new Object();
         var _loc3_:* = Api.system.getData("itemTooltipSettings",DataStoreEnum.BIND_ACCOUNT) as ItemTooltipSettings;
         if(_loc3_ == null)
         {
            _loc3_ = Api.tooltip.createItemSettings();
            Api.system.setData("itemTooltipSettings",_loc3_,DataStoreEnum.BIND_ACCOUNT);
         }
         var _loc5_:* = Api.system.getObjectVariables(_loc3_);
         for each(_loc4_ in _loc5_)
         {
            _loc2_[_loc4_] = _loc3_[_loc4_];
         }
         _loc2_.pinnable = true;
         if(!param1.objectUID)
         {
            _loc2_.showEffects = true;
         }
         Api.ui.showTooltip(param1,new Rectangle(420,220,0,0),false,"standard",0,0,0,null,null,_loc2_,null,true,4,1,"common");
      }
      
      public function createItemBox(param1:String, param2:GraphicContainer, param3:Object, param4:Boolean = false, param5:Boolean = false) : Object
      {
         if(!param3 || param3 == null)
         {
            Api.ui.unloadUi(param1);
         }
         else
         {
            if(!this.uiApi.getUi(param1))
            {
               return this.uiApi.loadUiInside("itemBox",param2,param1,{
                  "item":param3,
                  "showTheoretical":param4,
                  "ownedItem":param5
               });
            }
            if(this.uiApi.getUi(param1).uiClass)
            {
               this.uiApi.getUi(param1).uiClass.onItemSelected(param3,param4);
            }
         }
         return null;
      }
      
      public function openPasswordMenu(param1:int, param2:Boolean, param3:Function, param4:Function = null) : void
      {
         if(!this.uiApi.getUi("passwordMenu"))
         {
            this.uiApi.loadUi("passwordMenu","passwordMenu",{
               "size":param1,
               "changeOrUse":param2,
               "confirmCallBack":param3,
               "cancelCallBack":param4
            });
         }
      }
      
      public function createPaymentObject(param1:Object = null, param2:Boolean = false, param3:Boolean = true) : Object
      {
         if(!this.uiApi.getUi("payment"))
         {
            return this.uiApi.loadUi("payment","payment",{
               "paymentData":param1,
               "disabled":param2,
               "bonusNeeded":param3
            },3);
         }
         return null;
      }
      
      public function createRecipesObject(param1:String, param2:GraphicContainer, param3:Object, param4:int, param5:int = 0, param6:Boolean = false, param7:String = "", param8:int = 0) : Object
      {
         if(!this.uiApi.getUi(param1))
         {
            return this.uiApi.loadUiInside("recipes",param2,param1,{
               "subRecipesCtr":param3,
               "jobId":param4,
               "skillId":param5,
               "matsCountMode":param6,
               "storage":param7,
               "jobLevel":param8
            });
         }
         param2.addContent(this.uiApi.getUi(param1));
         return this.uiApi.getUi(param1);
      }
      
      public function onLoginQueueStatus(param1:uint, param2:uint) : void
      {
         if(!this.uiApi.getUi("queuePopup") && param1 > 0)
         {
            this.uiApi.loadUi("queuePopup","queuePopup",[param1,param2,true],3);
         }
      }
      
      public function onQueueStatus(param1:uint, param2:uint) : void
      {
         if(!this.uiApi.getUi("queuePopup") && param1 > 0)
         {
            this.uiApi.loadUi("queuePopup","queuePopup",[param1,param2,false],3);
         }
      }
      
      private function onSecureModeChange(param1:Boolean) : void
      {
         if(param1 && !this.uiApi.getUi("secureModeIcon"))
         {
            this.uiApi.loadUi("secureModeIcon","secureModeIcon",this._secureModeNeedReboot,StrataEnum.STRATA_HIGH);
            this.uiApi.loadUi("secureMode","secureMode",this._secureModeNeedReboot,StrataEnum.STRATA_HIGH);
         }
         if(!param1 && this.uiApi.getUi("secureModeIcon"))
         {
            this.uiApi.unloadUi("secureModeIcon");
         }
      }
      
      public function unload() : void
      {
         Api.system = null;
         Api.ui = null;
         Api.tooltip = null;
         Api.data = null;
      }
      
      public function openDownload(param1:int) : void
      {
         if(!this.uiApi.getUi("downloadUi"))
         {
            this.uiApi.loadUi("downloadUi","downloadUi",{"partId":param1},2);
         }
      }
      
      public function onPartInfo(param1:Object, param2:Number) : void
      {
         if(param1.state == 1)
         {
            this.openDownload(param1.id);
         }
      }
      
      public function onConnectionStart() : void
      {
         if(this.sysApi.isDownloadFinished() && !this.uiApi.getUi("downloadUi"))
         {
            this.uiApi.loadUi("downloadUi","downloadUi",{"state":1},3);
         }
      }
      
      public function onGameStart() : void
      {
         if(this.sysApi.isDownloadFinished() && !this.uiApi.getUi("downloadUi"))
         {
            this.uiApi.loadUi("downloadUi","downloadUi",{"state":1},3);
         }
         if(this.secureApi.SecureModeisActive())
         {
            this.uiApi.loadUi("secureModeIcon","secureModeIcon",null,StrataEnum.STRATA_HIGH);
         }
      }
      
      private function onOpenComic(param1:String, param2:String) : void
      {
         var _loc3_:* = this.uiApi.getUi("flashComicReader");
         var _loc4_:Object = {
            "remoteId":param1,
            "language":param2
         };
         if(_loc3_)
         {
            _loc3_.uiClass.main(_loc4_);
         }
         else
         {
            this.uiApi.loadUi("flashComicReader","flashComicReader",_loc4_,StrataEnum.STRATA_TOP);
         }
      }
   }
}
