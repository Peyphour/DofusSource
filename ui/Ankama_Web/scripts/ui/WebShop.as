package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.EntityDisplayer;
   import com.ankamagames.berilia.components.Grid;
   import com.ankamagames.berilia.components.Input;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.TextArea;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.components.TextureBitmap;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.datacenter.communication.Emoticon;
   import com.ankamagames.dofus.datacenter.effects.EffectInstance;
   import com.ankamagames.dofus.datacenter.items.Incarnation;
   import com.ankamagames.dofus.datacenter.monsters.Companion;
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import com.ankamagames.dofus.logic.game.common.types.DofusShopArticle;
   import com.ankamagames.dofus.logic.game.common.types.DofusShopArticleReference;
   import com.ankamagames.dofus.logic.game.common.types.DofusShopCategory;
   import com.ankamagames.dofus.logic.game.common.types.DofusShopHighlight;
   import com.ankamagames.dofus.uiApi.ContextMenuApi;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.PlayedCharacterApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofus.uiApi.UtilApi;
   import com.ankamagames.dofusModuleLibrary.enum.components.GridItemSelectMethodEnum;
   import d2actions.AccessoryPreviewRequest;
   import d2actions.ShopArticlesListRequest;
   import d2actions.ShopAuthentificationRequest;
   import d2actions.ShopBuyRequest;
   import d2actions.ShopFrontPageRequest;
   import d2actions.ShopSearchRequest;
   import d2enums.ComponentHookList;
   import d2enums.DirectionsEnum;
   import d2enums.DofusShopEnum;
   import d2enums.LocationEnum;
   import d2enums.ShortcutHookListEnum;
   import d2hooks.AccessoryPreview;
   import d2hooks.DofusShopArticlesList;
   import d2hooks.DofusShopError;
   import d2hooks.DofusShopHome;
   import d2hooks.DofusShopMoney;
   import d2hooks.DofusShopSuccessfulPurchase;
   import d2hooks.KeyUp;
   import d2hooks.OpenSet;
   import d2hooks.UiLoaded;
   import flash.geom.ColorTransform;
   import flash.geom.Point;
   import flash.ui.MouseCursor;
   import flash.utils.Dictionary;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   
   public class WebShop
   {
      
      private static var CTR_CAT_TYPE_CAT:String = "ctr_cat";
      
      private static var CTR_CAT_TYPE_SUBCAT:String = "ctr_subCat";
      
      private static var CTR_CAT_TYPE_SUBSUBCAT:String = "ctr_subSubCat";
      
      private static var CURRENCY_OGRINES:int = 0;
      
      private static var CURRENCY_KROZS:int = 1;
      
      private static var REAL_CURRENCIES:Dictionary = new Dictionary();
      
      private static var ARTICLE_TYPE_ITEM:int = 0;
      
      private static var ARTICLE_TYPE_PACK:int = 1;
      
      private static var ARTICLE_TYPE_ITEM_FROM_PACK:int = 2;
      
      public static const RING_TYPE_ID:uint = 9;
      
      public static const AMULET_TYPE_ID:uint = 1;
      
      public static const BOOTS_TYPE_ID:uint = 11;
      
      public static const BELT_TYPE_ID:uint = 10;
      
      public static const SHIELD_TYPE_ID:uint = 82;
      
      public static const CLOAK_TYPE_ID:uint = 17;
      
      public static const BACKPACK_TYPE_ID:uint = 81;
      
      public static const HAT_TYPE_ID:uint = 16;
      
      public static const PET_TYPE_ID:uint = 18;
      
      public static const PETSMOUNT_TYPE_ID:uint = 121;
      
      public static const LIVINGITEM_TYPE_ID:uint = 113;
      
      {
         REAL_CURRENCIES[2] = "USD";
         REAL_CURRENCIES[3] = "EUR";
         REAL_CURRENCIES[4] = "GBP";
         REAL_CURRENCIES[5] = "BRL";
         REAL_CURRENCIES[6] = "RUB";
         REAL_CURRENCIES[7] = "AUD";
         REAL_CURRENCIES[8] = "CAD";
         REAL_CURRENCIES[9] = "IDR";
         REAL_CURRENCIES[10] = "JPY";
         REAL_CURRENCIES[11] = "MYR";
         REAL_CURRENCIES[12] = "MXN";
         REAL_CURRENCIES[13] = "NZD";
         REAL_CURRENCIES[14] = "NOK";
         REAL_CURRENCIES[15] = "PHP";
         REAL_CURRENCIES[16] = "SGD";
         REAL_CURRENCIES[17] = "KRW";
         REAL_CURRENCIES[18] = "THB";
         REAL_CURRENCIES[19] = "TRY";
         REAL_CURRENCIES[20] = "UAH";
      }
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      public var utilApi:UtilApi;
      
      public var dataApi:DataApi;
      
      public var playerApi:PlayedCharacterApi;
      
      public var menuApi:ContextMenuApi;
      
      [Module(name="Ankama_Common")]
      public var modCommon:Object;
      
      [Module(name="Ankama_ContextMenu")]
      public var modContextMenu:Object;
      
      private var _defaultCategoryId:int;
      
      private var _compHookData:Dictionary;
      
      private var _moneyOgr:int;
      
      private var _moneyKro:int;
      
      private var _currentCurrency:int = 0;
      
      private var _searchCriteria:String;
      
      private var _isOnSearch:Boolean = false;
      
      private var _categories:Array;
      
      private var _categoriesOpened:Array;
      
      private var _currentSelectedCatId:int;
      
      private var _highlightCarousels:Array;
      
      private var _currentCarouselArticleIndex:int;
      
      private var _carouselInterval:Number;
      
      private var _highlightImages:Array;
      
      private var _isOnFrontPage:Boolean = true;
      
      private var _currentPage:uint = 1;
      
      private var _maxPage:uint = 1;
      
      private var _selectedArticle:DofusShopArticle;
      
      private var _articleType:int;
      
      private var _direction:int = 3;
      
      private var _nbDirectionMax:int = 8;
      
      private var _animation:String;
      
      private var _currentGIDsPreview:Vector.<uint>;
      
      private var _currentPreviewLook:Object;
      
      private var _currentItemBuyName:String;
      
      private var _currencyUriOgr:Object;
      
      private var _currencyUriOgrBig:Object;
      
      private var _currencyUriKro:Object;
      
      private var _currencyUriKroBig:Object;
      
      private var _goToArticleParams:Object;
      
      private var _goToCategoryId:uint;
      
      private var INPUT_SEARCH_DEFAULT_TEXT:String;
      
      private var tx_ogr_size_front:Object;
      
      private var tx_ogr_size:Object;
      
      private var tx_kro_size_front:Object;
      
      private var tx_kro_size:Object;
      
      private var _shopArticle:Object;
      
      private var _rollOverTarget:Object;
      
      private var _steamBuyLockPopupName:String;
      
      public var ctr_shop:GraphicContainer;
      
      public var ctr_money:GraphicContainer;
      
      public var btn_buyOgrins:ButtonContainer;
      
      public var iconTexturebtn_buyOgrins:TextureBitmap;
      
      public var lbl_money:Label;
      
      public var tx_money:Texture;
      
      public var tx_border_btn_buy:TextureBitmap;
      
      public var gd_categories:Grid;
      
      public var inp_search:Input;
      
      public var btn_resetSearch:ButtonContainer;
      
      public var lbl_noResult:Label;
      
      public var ctr_frontDisplay:GraphicContainer;
      
      public var ctr_shopLoader:GraphicContainer;
      
      public var ctr_carousel:GraphicContainer;
      
      public var tx_carousel:Texture;
      
      public var lbl_carouselTitle:Label;
      
      public var lbl_carouselDesc:Label;
      
      public var lbl_carouselPrice:Label;
      
      public var btn_carouselBuy:ButtonContainer;
      
      public var tx_carouselCurrency:Texture;
      
      public var lbl_carouselCurrency:Label;
      
      public var tx_carouselLeft:Texture;
      
      public var btn_carouselPrevPage:ButtonContainer;
      
      public var tx_carouselRight:Texture;
      
      public var btn_carouselNextPage:ButtonContainer;
      
      public var tx_btn:TextureBitmap;
      
      public var gd_frontDisplayArticles:Grid;
      
      public var ctr_articlesDisplay:GraphicContainer;
      
      public var gd_articles:Grid;
      
      public var btn_prevPage:Object;
      
      public var btn_nextPage:Object;
      
      public var lbl_page:Object;
      
      public var ctr_articlesLoader:GraphicContainer;
      
      public var ctr_popupArticle:GraphicContainer;
      
      public var tx_popupBackground:Texture;
      
      public var btn_popupClose:ButtonContainer;
      
      public var ctr_popupWindow:GraphicContainer;
      
      public var ctr_popupWindowTitle:Label;
      
      public var ctr_popupItemWrapper:GraphicContainer;
      
      public var ctr_popupItemPack:GraphicContainer;
      
      public var lbl_popupPackLevel:Label;
      
      public var lbl_popupPackDescription:TextArea;
      
      public var tx_popupPackImage:Texture;
      
      public var ctr_popupPackSetDetails:GraphicContainer;
      
      public var entityCtr:GraphicContainer;
      
      public var ed_popupChar:EntityDisplayer;
      
      public var tx_bg_btn_popupReplay:Texture;
      
      public var btn_popupReplay:ButtonContainer;
      
      public var btn_popupRightArrow:ButtonContainer;
      
      public var btn_popupLeftArrow:ButtonContainer;
      
      public var ctr_popupSetItems:GraphicContainer;
      
      public var gd_setItems:Grid;
      
      public var ctr_popupPrice:GraphicContainer;
      
      public var ctr_popupOldPrice:GraphicContainer;
      
      public var lbl_popupOldPrice:Label;
      
      public var ctr_crossprice:GraphicContainer;
      
      public var lbl_popupPrice:Label;
      
      public var tx_popupCurrency:Texture;
      
      public var lbl_popupCurrency:Label;
      
      public var btn_popupBuy:ButtonContainer;
      
      public var lbl_title_popup:Label;
      
      public function WebShop()
      {
         this._compHookData = new Dictionary(true);
         this._categories = new Array();
         this._categoriesOpened = new Array();
         this._highlightCarousels = new Array();
         this._highlightImages = new Array();
         this._currentGIDsPreview = new Vector.<uint>();
         super();
      }
      
      public function main(param1:Object = null) : void
      {
         this.sysApi.addHook(DofusShopHome,this.onDofusShopHome);
         this.sysApi.addHook(DofusShopMoney,this.onDofusShopMoney);
         this.sysApi.addHook(DofusShopArticlesList,this.onDofusShopArticlesList);
         this.sysApi.addHook(DofusShopSuccessfulPurchase,this.onDofusShopSuccessfulPurchase);
         this.sysApi.addHook(DofusShopError,this.onDofusShopError);
         this.sysApi.addHook(AccessoryPreview,this.onAccessoryPreview);
         this.sysApi.addHook(KeyUp,this.onKeyUp);
         this.sysApi.addHook(UiLoaded,this.onUiLoaded);
         this.sysApi.addEventListener(this.onEnterFrame,"shopEF");
         this.uiApi.addComponentHook(this.gd_categories,ComponentHookList.ON_SELECT_ITEM);
         this.uiApi.addComponentHook(this.gd_articles,ComponentHookList.ON_SELECT_ITEM);
         this.uiApi.addComponentHook(this.gd_frontDisplayArticles,ComponentHookList.ON_SELECT_ITEM);
         this.uiApi.addComponentHook(this.btn_buyOgrins,ComponentHookList.ON_RELEASE);
         this.uiApi.addComponentHook(this.btn_buyOgrins,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.btn_buyOgrins,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.inp_search,ComponentHookList.ON_RELEASE);
         this.uiApi.addComponentHook(this.btn_resetSearch,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.btn_resetSearch,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.ctr_carousel,ComponentHookList.ON_RELEASE);
         this.uiApi.addComponentHook(this.tx_carouselLeft,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.tx_carouselLeft,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.tx_carouselLeft,ComponentHookList.ON_RELEASE);
         this.uiApi.addComponentHook(this.tx_carouselRight,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.tx_carouselRight,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.tx_carouselRight,ComponentHookList.ON_RELEASE);
         this.uiApi.addComponentHook(this.btn_carouselNextPage,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.btn_carouselNextPage,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.btn_carouselPrevPage,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.btn_carouselPrevPage,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.btn_popupReplay,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.btn_popupReplay,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.gd_setItems,ComponentHookList.ON_SELECT_ITEM);
         this.uiApi.addComponentHook(this.gd_setItems,ComponentHookList.ON_ITEM_ROLL_OVER);
         this.uiApi.addComponentHook(this.gd_setItems,ComponentHookList.ON_ITEM_ROLL_OUT);
         this.uiApi.addComponentHook(this.tx_popupPackImage,ComponentHookList.ON_RELEASE);
         this.uiApi.addComponentHook(this.ctr_popupPackSetDetails,ComponentHookList.ON_RELEASE);
         this.uiApi.addComponentHook(this.btn_popupBuy,ComponentHookList.ON_RELEASE);
         this.uiApi.addShortcutHook(ShortcutHookListEnum.VALID_UI,this.onShortcut);
         this.uiApi.addShortcutHook(ShortcutHookListEnum.CLOSE_UI,this.onShortcut);
         this.tx_ogr_size_front = this.utilApi.decodeJson(this.uiApi.me().getConstant("tx_ogr_size_front"));
         this.tx_ogr_size = this.utilApi.decodeJson(this.uiApi.me().getConstant("tx_ogr_size"));
         this.tx_kro_size_front = this.utilApi.decodeJson(this.uiApi.me().getConstant("tx_kro_size_front"));
         this.tx_kro_size = this.utilApi.decodeJson(this.uiApi.me().getConstant("tx_kro_size"));
         this.btn_buyOgrins.transform.colorTransform = new ColorTransform(1,1,1,1,-112,-15,253);
         this.iconTexturebtn_buyOgrins.transform.colorTransform = new ColorTransform(1,1,1,1,112,15,-253);
         this.ctr_frontDisplay.visible = true;
         this.ctr_articlesDisplay.visible = false;
         this.tx_carouselLeft.handCursor = true;
         this.tx_carouselRight.handCursor = true;
         this._currencyUriOgr = this.uiApi.createUri(this.uiApi.me().getConstant("ogr_uri"));
         this._currencyUriOgrBig = this.uiApi.createUri(this.uiApi.me().getConstant("ogr_uri_big"));
         this._currencyUriKro = this.uiApi.createUri(this.uiApi.me().getConstant("kro_uri"));
         this._currencyUriKroBig = this.uiApi.createUri(this.uiApi.me().getConstant("kro_uri_big"));
         if(this.sysApi.isSteamEmbed())
         {
            this.ctr_money.visible = false;
            this.tx_carouselCurrency.visible = false;
            this._defaultCategoryId = 535;
         }
         else
         {
            this._defaultCategoryId = 327;
         }
         if(param1)
         {
            if(param1.hasOwnProperty("articleId"))
            {
               this._goToArticleParams = {
                  "categoryId":param1.categoryId,
                  "page":param1.page,
                  "articleId":param1.articleId
               };
            }
            else if(param1.hasOwnProperty("categoryId"))
            {
               this._goToCategoryId = param1.categoryId;
            }
         }
         if(param1 && param1.hasOwnProperty("frontDisplayMains"))
         {
            this._moneyOgr = param1.ogrins;
            this._moneyKro = param1.krozs;
            this.refreshMoney();
            this.onDofusShopHome(param1.categories,param1.frontDisplayArticles,param1.frontDisplayMains,param1.highlightCarousels,param1.highlightImages);
         }
         else
         {
            this.sysApi.sendAction(new ShopAuthentificationRequest());
         }
         this.INPUT_SEARCH_DEFAULT_TEXT = this.uiApi.getText("ui.search.shop");
         this.inp_search.text = this.INPUT_SEARCH_DEFAULT_TEXT;
         this.btn_resetSearch.visible = false;
      }
      
      public function unload() : void
      {
         clearInterval(this._carouselInterval);
         this.uiApi.unloadUi("shopItemBoxPop");
         this.sysApi.removeEventListener(this.onEnterFrame);
      }
      
      public function updateCategory(param1:*, param2:*, param3:Boolean, param4:uint) : void
      {
         switch(this.getCatLineType(param1,param4))
         {
            case CTR_CAT_TYPE_CAT:
            case CTR_CAT_TYPE_SUBCAT:
            case CTR_CAT_TYPE_SUBSUBCAT:
               param2.lbl_catName.text = param1.name;
               param2.btn_cat.selected = param3;
         }
      }
      
      public function getCatLineType(param1:*, param2:uint) : String
      {
         if(!param1)
         {
            return "";
         }
         switch(param2)
         {
            case 0:
               if(param1 && param1.level == 0)
               {
                  return CTR_CAT_TYPE_CAT;
               }
               if(param1 && param1.level == 1)
               {
                  return CTR_CAT_TYPE_SUBCAT;
               }
               return CTR_CAT_TYPE_SUBSUBCAT;
            default:
               return CTR_CAT_TYPE_SUBCAT;
         }
      }
      
      public function getCatDataLength(param1:*, param2:Boolean) : *
      {
         if(!param2)
         {
         }
         return 2 + (!!param2?param1.subcats.length:0);
      }
      
      public function updateArticle(param1:*, param2:*, param3:Boolean) : void
      {
         var _loc4_:Object = null;
         if(!this._compHookData[param2.btn_buy.name])
         {
            this.uiApi.addComponentHook(param2.btn_buy,ComponentHookList.ON_RELEASE);
            this.uiApi.addComponentHook(param2.btn_buy,ComponentHookList.ON_ROLL_OVER);
            this.uiApi.addComponentHook(param2.btn_buy,ComponentHookList.ON_ROLL_OUT);
         }
         this._compHookData[param2.btn_buy.name] = param1;
         if(!this._compHookData[param2.btn_article.name])
         {
            this.uiApi.addComponentHook(param2.btn_article,ComponentHookList.ON_RELEASE);
         }
         this._compHookData[param2.btn_article.name] = param1;
         if(!this._compHookData[param2.ctr_article.name])
         {
            this.uiApi.addComponentHook(param2.ctr_article,ComponentHookList.ON_ROLL_OVER);
            this.uiApi.addComponentHook(param2.ctr_article,ComponentHookList.ON_ROLL_OUT);
         }
         this._compHookData[param2.ctr_article.name] = param1;
         if(param1)
         {
            param2.tx_slot.visible = true;
            param2.lbl_name.text = param1.name;
            param2.lbl_price.text = this.utilApi.kamasToString(param1.price,"");
            if(param1.imageSwf)
            {
               param2.tx_picto.uri = param1.imageSwf;
            }
            else if(param1.imageNormal && param1.imageNormal.length > 0)
            {
               param2.tx_picto.uri = this.uiApi.createUri(param1.imageNormal);
            }
            else if(param1.imageSmall && param1.imageSmall.length > 0)
            {
               param2.tx_picto.uri = this.uiApi.createUri(param1.imageSmall);
            }
            if(param1.isNew || param1.originalPrice > 0 || param1.stock == 0)
            {
               param2.tx_banner.visible = true;
               if(param1.stock == 0)
               {
                  param2.lbl_banner.text = this.uiApi.getText("ui.shop.soldOut");
                  param2.tx_banner.gotoAndStop = 3;
                  param2.btn_article.disabled = true;
                  param2.btn_buy.disabled = true;
               }
               else
               {
                  param2.btn_article.disabled = false;
                  param2.btn_buy.disabled = false;
                  if(param1.originalPrice > 0)
                  {
                     param2.lbl_banner.text = this.uiApi.getText("ui.shop.sales");
                     param2.tx_banner.gotoAndStop = 2;
                  }
                  else if(param1.isNew)
                  {
                     param2.lbl_banner.text = this.uiApi.getText("ui.common.new");
                     param2.tx_banner.gotoAndStop = 1;
                  }
               }
            }
            else
            {
               param2.tx_banner.visible = false;
               param2.lbl_banner.text = "";
               param2.btn_article.disabled = false;
               param2.btn_buy.disabled = false;
            }
            param2.btn_buy.visible = true;
            param2.ctr_article.alpha = 1;
            if(param1)
            {
               _loc4_ = this["tx_" + (param1.currency == DofusShopEnum.CURRENCY_OGRINES?"ogr":"kro") + "_size" + (!!this._isOnFrontPage?"_front":"")];
               param2.tx_currency.x = _loc4_.x;
               param2.tx_currency.y = _loc4_.y;
               param2.tx_currency.width = _loc4_.width;
               param2.tx_currency.height = _loc4_.height;
            }
            if(param1.currency == DofusShopEnum.CURRENCY_OGRINES)
            {
               param2.tx_currency.visible = true;
               param2.lbl_currency.visible = false;
               param2.tx_currency.uri = this._currencyUriOgr;
               if(param1.price > this._moneyOgr)
               {
                  param2.btn_buy.disabled = true;
               }
               else
               {
                  param2.btn_buy.disabled = false;
               }
            }
            else if(param1.currency == DofusShopEnum.CURRENCY_KROZ)
            {
               param2.tx_currency.visible = true;
               param2.lbl_currency.visible = false;
               param2.tx_currency.uri = this._currencyUriKro;
               if(param1.price > this._moneyKro)
               {
                  param2.btn_buy.disabled = true;
               }
               else
               {
                  param2.btn_buy.disabled = false;
               }
            }
            else
            {
               param2.tx_currency.visible = false;
               param2.lbl_currency.visible = true;
               param2.lbl_currency.text = param1.currency;
            }
         }
         else
         {
            param2.lbl_name.text = "";
            param2.lbl_price.text = "";
            param2.tx_picto.uri = null;
            param2.tx_currency.uri = null;
            param2.tx_banner.visible = false;
            param2.lbl_banner.text = "";
            param2.btn_article.disabled = false;
            param2.btn_buy.visible = false;
            param2.ctr_article.alpha = 0.5;
            param2.lbl_currency.visible = false;
            param2.tx_slot.visible = false;
         }
      }
      
      public function onPopupClose() : void
      {
         this._currentItemBuyName = null;
      }
      
      private function refreshMoney() : void
      {
         if(this.sysApi.isSteamEmbed())
         {
            this.ctr_money.visible = false;
         }
         else if(this._currentCurrency == CURRENCY_OGRINES)
         {
            this.lbl_money.text = this.utilApi.kamasToString(this._moneyOgr,"");
            this.tx_border_btn_buy.visible = this.btn_buyOgrins.visible = true;
            this.tx_money.uri = this._currencyUriOgrBig;
            this.ctr_money.visible = true;
         }
         else
         {
            this.lbl_money.text = this.utilApi.kamasToString(this._moneyKro,"");
            this.tx_border_btn_buy.visible = this.btn_buyOgrins.visible = false;
            this.tx_money.uri = this._currencyUriKroBig;
            this.ctr_money.visible = true;
         }
      }
      
      private function displayCategories(param1:Object = null, param2:Boolean = false) : void
      {
         var _loc3_:int = 0;
         var _loc8_:Object = null;
         var _loc9_:int = 0;
         var _loc10_:Object = null;
         var _loc11_:Object = null;
         var _loc12_:Object = null;
         if(!param1)
         {
            param1 = this.gd_categories.selectedItem;
         }
         if(param1.id == 342 && this._currentSelectedCatId != 342)
         {
            this._currentCurrency = CURRENCY_KROZS;
            this.refreshMoney();
         }
         if(param1.id != 342 && this._currentSelectedCatId == 342)
         {
            this._currentCurrency = CURRENCY_OGRINES;
            this.refreshMoney();
         }
         var _loc4_:Boolean = false;
         if(this._categoriesOpened.indexOf(param1.id) == -1)
         {
            _loc4_ = true;
         }
         if(param1.parentIds.length > 0 && this._categoriesOpened.length > 0)
         {
            for each(_loc9_ in param1.parentIds)
            {
               if(this._categoriesOpened.indexOf(_loc9_) == -1)
               {
                  _loc4_ = true;
                  break;
               }
            }
         }
         if(!_loc4_)
         {
            this._currentSelectedCatId = param1.id;
            for each(_loc10_ in this.gd_categories.dataProvider)
            {
               if(_loc10_.id == this._currentSelectedCatId)
               {
                  break;
               }
               _loc3_++;
            }
            if(this.gd_categories.selectedIndex != _loc3_)
            {
               this.gd_categories.silent = true;
               this.gd_categories.selectedIndex = _loc3_;
               this.gd_categories.silent = false;
            }
            if(this._currentSelectedCatId != this._defaultCategoryId)
            {
               this._currentPage = !!this._goToArticleParams?uint(this._goToArticleParams.page):uint(1);
               this.sysApi.sendAction(new ShopArticlesListRequest(this._currentSelectedCatId,this._currentPage));
               this.manageWaiting();
            }
            if(this._categoriesOpened.indexOf(param1.id) == -1)
            {
               return;
            }
         }
         var _loc5_:int = -1;
         var _loc6_:Array = new Array();
         var _loc7_:Array = new Array();
         for each(_loc8_ in this._categories)
         {
            _loc6_.push(_loc8_);
            _loc5_++;
            if(param1.parentIds.indexOf(_loc8_.id) != -1 || param1.id == _loc8_.id || _loc8_.id == this._defaultCategoryId)
            {
               _loc3_ = _loc5_;
               if(_loc7_.indexOf(_loc8_.id) == -1 || _loc8_.id == this._defaultCategoryId)
               {
                  _loc7_.push(_loc8_.id);
                  for each(_loc11_ in _loc8_.subcats)
                  {
                     _loc6_.push(_loc11_);
                     _loc5_++;
                     if(param1.parentIds.indexOf(_loc11_.id) != -1 || param1.id == _loc11_.id)
                     {
                        _loc3_ = _loc5_;
                        if(this._categoriesOpened.indexOf(_loc11_.id) == -1)
                        {
                           _loc7_.push(_loc8_.id);
                           for each(_loc12_ in _loc11_.subcats)
                           {
                              _loc6_.push(_loc12_);
                              _loc5_++;
                              if(_loc12_.id == param1.id)
                              {
                                 _loc3_ = _loc5_;
                              }
                           }
                        }
                     }
                  }
               }
            }
         }
         if(_loc7_.length > 0)
         {
            this._categoriesOpened = _loc7_;
         }
         else
         {
            this._categoriesOpened = new Array();
         }
         this._currentSelectedCatId = param1.id;
         this.gd_categories.dataProvider = _loc6_;
         if(this.gd_categories.selectedIndex != _loc3_)
         {
            this.gd_categories.silent = true;
            this.gd_categories.selectedIndex = _loc3_;
            this.gd_categories.silent = false;
         }
         if(this._currentSelectedCatId == this._defaultCategoryId)
         {
            if(!this._isOnFrontPage)
            {
               this.sysApi.sendAction(new ShopFrontPageRequest());
               this._isOnSearch = false;
            }
         }
         else
         {
            this._currentPage = !!this._goToArticleParams?uint(this._goToArticleParams.page):uint(1);
            this.sysApi.sendAction(new ShopArticlesListRequest(this._currentSelectedCatId,this._currentPage));
            this.manageWaiting();
         }
      }
      
      private function showHighlightCarouselArticle(param1:Boolean = true) : void
      {
         var _loc3_:DofusShopArticle = null;
         if(!this._isOnFrontPage || !this.lbl_carouselTitle)
         {
            return;
         }
         if(param1)
         {
            this._currentCarouselArticleIndex++;
         }
         else
         {
            this._currentCarouselArticleIndex = --this._currentCarouselArticleIndex + this._highlightCarousels.length;
         }
         if(this._currentCarouselArticleIndex >= this._highlightCarousels.length || this._currentCarouselArticleIndex < 0)
         {
            this._currentCarouselArticleIndex = this._currentCarouselArticleIndex % this._highlightCarousels.length;
         }
         var _loc2_:DofusShopHighlight = this._highlightCarousels[this._currentCarouselArticleIndex];
         if(!_loc2_)
         {
            return;
         }
         if(_loc2_.image)
         {
            this.tx_carousel.uri = this.uiApi.createUri(_loc2_.image);
         }
         this.lbl_carouselTitle.text = _loc2_.name.toUpperCase();
         this.lbl_carouselDesc.text = _loc2_.description;
         if(_loc2_.type == DofusShopEnum.HIGHLIGHT_TYPE_ARTICLE)
         {
            _loc3_ = _loc2_.external as DofusShopArticle;
            if(_loc3_)
            {
               this.lbl_carouselPrice.text = this.utilApi.kamasToString(_loc3_.price,"");
               this.tx_btn.visible = true;
               this.btn_carouselBuy.visible = true;
               if(!this.sysApi.isSteamEmbed())
               {
                  this.tx_carouselCurrency.visible = true;
               }
               else
               {
                  this.lbl_carouselCurrency.visible = true;
                  this.lbl_carouselCurrency.text = _loc3_.currency;
               }
               if(_loc3_.currency == DofusShopEnum.CURRENCY_OGRINES)
               {
                  this.tx_carouselCurrency.uri = this._currencyUriOgr;
               }
               else
               {
                  this.tx_carouselCurrency.uri = this._currencyUriKro;
               }
            }
         }
         else
         {
            this.lbl_carouselPrice.text = "";
            this.btn_carouselBuy.visible = false;
            this.tx_carouselCurrency.visible = false;
            this.lbl_carouselCurrency.visible = false;
            this.tx_btn.visible = false;
         }
      }
      
      private function showHighlightImage(param1:DofusShopHighlight, param2:int) : void
      {
         if(!this._isOnFrontPage)
         {
            return;
         }
         if(this["tx_highlightImage" + param2] && param1)
         {
            this["tx_highlightImage" + param2].uri = this.uiApi.createUri(param1.image);
         }
      }
      
      private function releaseOnHighlight(param1:DofusShopHighlight) : void
      {
         var _loc2_:DofusShopCategory = null;
         var _loc3_:Object = null;
         var _loc4_:Object = null;
         var _loc5_:Object = null;
         if(!this._isOnFrontPage || !param1)
         {
            return;
         }
         if(param1.link && param1.link != "")
         {
            this.sysApi.goToUrl(param1.link);
         }
         else if(param1.type == DofusShopEnum.HIGHLIGHT_TYPE_CATEGORY)
         {
            _loc2_ = param1.external as DofusShopCategory;
            for each(_loc4_ in this._categories)
            {
               if(_loc4_.id == _loc2_.id)
               {
                  _loc3_ = _loc4_;
               }
               else
               {
                  for each(_loc5_ in _loc4_.subcats)
                  {
                     if(_loc5_.id == _loc2_.id)
                     {
                        _loc3_ = _loc5_;
                     }
                  }
               }
            }
            this.displayCategories(_loc3_,true);
         }
         else if(param1.type == DofusShopEnum.HIGHLIGHT_TYPE_ARTICLE)
         {
            this._selectedArticle = param1.external as DofusShopArticle;
            this.displayArticle();
         }
      }
      
      private function refreshPageNumber() : void
      {
         if(this._currentPage <= 1)
         {
            this.btn_prevPage.disabled = true;
         }
         else
         {
            this.btn_prevPage.disabled = false;
         }
         if(this._currentPage >= this._maxPage)
         {
            this.btn_nextPage.disabled = true;
         }
         else
         {
            this.btn_nextPage.disabled = false;
         }
         this.lbl_page.text = this._currentPage + "/" + this._maxPage;
      }
      
      private function displayArticle(param1:ItemWrapper = null) : void
      {
         var _loc3_:ItemWrapper = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:EffectInstance = null;
         var _loc13_:Incarnation = null;
         var _loc14_:Companion = null;
         var _loc15_:Emoticon = null;
         var _loc16_:* = null;
         var _loc17_:Array = null;
         var _loc18_:Object = null;
         var _loc19_:Object = null;
         var _loc20_:ItemWrapper = null;
         var _loc21_:* = null;
         var _loc22_:Boolean = false;
         var _loc23_:int = 0;
         var _loc24_:int = 0;
         var _loc25_:* = undefined;
         var _loc26_:ItemWrapper = null;
         var _loc27_:EffectInstance = null;
         var _loc28_:Incarnation = null;
         var _loc29_:Boolean = false;
         var _loc30_:* = undefined;
         var _loc31_:uint = 0;
         if(!this._selectedArticle && !param1)
         {
            this.sysApi.log(32," Aucun objet selectionné !");
            return;
         }
         var _loc2_:Vector.<uint> = new Vector.<uint>();
         this._animation = "";
         this._nbDirectionMax = 8;
         if(param1)
         {
            _loc3_ = param1;
            this.lbl_title_popup.text = _loc3_.name + (!!this.sysApi.getPlayerManager().hasRights?" (" + _loc3_.id + ")":"");
            this.modCommon.createItemBox("shopItemBoxPop",this.ctr_popupItemWrapper,_loc3_);
            this.ctr_popupItemWrapper.visible = true;
            this.ctr_popupItemPack.visible = false;
            this._articleType = ARTICLE_TYPE_ITEM_FROM_PACK;
         }
         else if(this._selectedArticle.gids && this._selectedArticle.gids.length == 1 && this._selectedArticle.gids[0] != 7805)
         {
            _loc3_ = this.dataApi.getItemWrapper(this._selectedArticle.gids[0],0,0,1);
            if(_loc3_)
            {
               this.lbl_title_popup.text = _loc3_.name + (!!this.sysApi.getPlayerManager().hasRights?" (" + _loc3_.id + ")":"");
               this.modCommon.createItemBox("shopItemBoxPop",this.ctr_popupItemWrapper,_loc3_);
            }
            else
            {
               this.sysApi.log(32,"L\'item " + this._selectedArticle.gids[0] + " ne semble pas exister !");
            }
            this.ctr_popupItemWrapper.visible = true;
            this.ctr_popupItemPack.visible = false;
            this._articleType = ARTICLE_TYPE_ITEM;
         }
         else
         {
            this.lbl_title_popup.text = this._selectedArticle.name;
            this.lbl_popupPackDescription.text = this._selectedArticle.description;
            this.tx_popupPackImage.uri = this.uiApi.createUri(this._selectedArticle.imageNormal);
            this.ctr_popupItemWrapper.visible = false;
            this.ctr_popupItemPack.visible = true;
            this._articleType = ARTICLE_TYPE_PACK;
         }
         var _loc4_:* = this.uiApi.getUi("shopItemBoxPop");
         if(_loc4_ && _loc4_.uiClass)
         {
            _loc4_.uiClass.lbl_name.text = "";
            _loc4_.uiClass.lbl_level.cssClass = "left";
            _loc4_.uiClass.lbl_level.css = this.uiApi.createUri(this.sysApi.getConfigEntry("config.ui.skin") + "css/normal2.css");
            _loc4_.uiClass.lbl_level.x = parseInt(this.uiApi.me().getConstant("popup_level_x"));
            _loc4_.uiClass.lbl_level.y = parseInt(this.uiApi.me().getConstant("popup_level_y"));
         }
         var _loc5_:Object = this.utilApi.getRealTiphonEntityLook(this.playerApi.getPlayedCharacterInfo().id,true);
         if(_loc5_.getBone() == 2)
         {
            _loc5_.setBone(1);
         }
         if((this._articleType == ARTICLE_TYPE_ITEM || this._articleType == ARTICLE_TYPE_ITEM_FROM_PACK) && _loc3_)
         {
            _loc9_ = -1;
            _loc10_ = -1;
            _loc11_ = -1;
            for each(_loc12_ in _loc3_.possibleEffects)
            {
               if(_loc12_.effectId == 669)
               {
                  _loc9_ = int(_loc12_.parameter0);
                  break;
               }
               if(_loc12_.effectId == 10)
               {
                  _loc10_ = int(_loc12_.parameter0);
                  break;
               }
               if(_loc12_.effectId == 1161)
               {
                  _loc11_ = int(_loc12_.parameter2);
                  break;
               }
            }
            if(_loc9_ > -1)
            {
               _loc13_ = this.dataApi.getIncarnation(_loc9_);
               if(_loc13_)
               {
                  if(this.playerApi.getPlayedCharacterInfo().sex == 1)
                  {
                     _loc5_ = _loc13_.lookFemale;
                  }
                  else
                  {
                     _loc5_ = _loc13_.lookMale;
                  }
                  this._nbDirectionMax = 4;
               }
            }
            else if(_loc11_ > -1)
            {
               _loc14_ = this.dataApi.getCompanion(_loc11_);
               if(_loc14_)
               {
                  _loc5_ = _loc14_.look;
                  this._nbDirectionMax = 4;
               }
            }
            else if(_loc10_ > -1)
            {
               _loc15_ = this.dataApi.getEmoticon(_loc10_);
               if(_loc15_)
               {
                  _loc16_ = "AnimEmote" + _loc15_.defaultAnim.charAt(0).toUpperCase() + _loc15_.defaultAnim.substr(1).toLowerCase() + "_0";
                  this._animation = _loc16_;
               }
            }
            if(_loc3_.isWeapon && _loc9_ == -1)
            {
               _loc2_.push(_loc3_.objectGID);
               this._animation = "AnimEmoteWeap_0";
            }
            else
            {
               switch(_loc3_.typeId)
               {
                  case HAT_TYPE_ID:
                  case CLOAK_TYPE_ID:
                  case BACKPACK_TYPE_ID:
                  case SHIELD_TYPE_ID:
                  case PET_TYPE_ID:
                  case PETSMOUNT_TYPE_ID:
                     _loc2_.push(_loc3_.objectGID);
               }
            }
         }
         if(this._selectedArticle.references && this._selectedArticle.references.length > 0 && (this._articleType == ARTICLE_TYPE_ITEM_FROM_PACK || this._articleType == ARTICLE_TYPE_PACK))
         {
            _loc17_ = new Array();
            for each(_loc18_ in this._selectedArticle.references)
            {
               if(_loc18_)
               {
                  if(!(_loc18_ is DofusShopArticleReference) && _loc18_.content)
                  {
                     for each(_loc19_ in _loc18_.content)
                     {
                        if(_loc19_ && typeof _loc19_ == "object" && _loc19_.hasOwnProperty("id"))
                        {
                           _loc20_ = this.dataApi.getItemWrapper(parseInt(_loc19_.id),0,0,_loc18_.quantity);
                           _loc17_.push(_loc20_);
                           if(_loc20_.category == 0 && this._articleType == ARTICLE_TYPE_PACK)
                           {
                              _loc2_.push(_loc20_.objectGID);
                              _loc9_ = -1;
                              for each(_loc12_ in _loc20_.possibleEffects)
                              {
                                 if(_loc12_.effectId == 669)
                                 {
                                    _loc9_ = int(_loc12_.parameter0);
                                    break;
                                 }
                              }
                              if(_loc20_.isWeapon && _loc9_ == -1)
                              {
                                 this._animation = "AnimEmoteWeap_0";
                              }
                           }
                           else if(_loc20_.objectGID == 7805)
                           {
                              _loc21_ = _loc5_.toString();
                              if(_loc21_.indexOf("@") > -1)
                              {
                                 _loc21_ = _loc21_.split("@")[0] + "}";
                              }
                              _loc5_ = _loc21_.replace("{1|","{639||1=" + _loc5_.getColor(3).color + ",2=" + _loc5_.getColor(4).color + ",3=" + _loc5_.getColor(5).color + "|120|2@0={2|");
                              _loc5_ = _loc5_ + "}";
                           }
                        }
                     }
                  }
                  else if(_loc18_ is DofusShopArticleReference)
                  {
                     _loc17_.push(_loc18_);
                  }
               }
            }
            if(this._articleType == ARTICLE_TYPE_PACK)
            {
               _loc22_ = true;
               _loc23_ = 0;
               _loc24_ = -1;
               if(!_loc17_ || _loc17_.length == 0)
               {
                  _loc22_ = false;
               }
               for each(_loc25_ in _loc17_)
               {
                  _loc26_ = _loc25_ as ItemWrapper;
                  if(!_loc26_)
                  {
                     _loc22_ = false;
                  }
                  else
                  {
                     if(_loc26_.level > _loc23_)
                     {
                        _loc23_ = _loc26_.level;
                     }
                     if(!_loc26_.belongsToSet || _loc26_.itemSetId != _loc24_ && _loc24_ > -1)
                     {
                        _loc22_ = false;
                     }
                     else
                     {
                        _loc24_ = _loc26_.itemSetId;
                     }
                     for each(_loc27_ in _loc26_.possibleEffects)
                     {
                        if(_loc27_.effectId == 669)
                        {
                           _loc28_ = this.dataApi.getIncarnation(int(_loc27_.parameter0));
                           if(_loc28_)
                           {
                              _loc2_ = new Vector.<uint>();
                              if(this.playerApi.getPlayedCharacterInfo().sex == 1)
                              {
                                 _loc5_ = _loc28_.lookFemale;
                              }
                              else
                              {
                                 _loc5_ = _loc28_.lookMale;
                              }
                              this._nbDirectionMax = 4;
                           }
                        }
                     }
                  }
               }
               this.lbl_popupPackLevel.text = !!_loc22_?this.uiApi.getText("ui.common.short.level") + " " + _loc23_:"";
               if(_loc22_)
               {
                  this.ctr_popupPackSetDetails.visible = true;
               }
               else
               {
                  this.ctr_popupPackSetDetails.visible = false;
               }
            }
            this.ctr_popupSetItems.visible = true;
            this.gd_setItems.dataProvider = _loc17_;
            this.ctr_popupWindow.height = this.ctr_popupArticle.height = 288 + this.ctr_popupSetItems.height;
            this.ctr_popupArticle.y = parseInt(this.uiApi.me().getConstant("popup_y_pack"));
         }
         else
         {
            this.ctr_popupPackSetDetails.visible = false;
            this.ctr_popupSetItems.visible = false;
            this.ctr_popupWindow.height = this.ctr_popupArticle.height = 460;
            this.ctr_popupArticle.y = parseInt(this.uiApi.me().getConstant("popup_y"));
         }
         this.uiApi.me().render();
         var _loc6_:Number = this.ed_popupChar.y;
         var _loc7_:Number = this.ed_popupChar.width;
         var _loc8_:Number = this.ed_popupChar.height;
         this.uiApi.removeComponentHook(this.ed_popupChar,"onEntityReady");
         this.ed_popupChar.removeFromParent();
         this.ed_popupChar.remove();
         this.ed_popupChar = this.uiApi.createComponent("EntityDisplayer") as EntityDisplayer;
         this.ed_popupChar.visible = false;
         this.ed_popupChar.useFade = false;
         this.ed_popupChar.clearSubEntities = false;
         this.ed_popupChar.x = parseInt(this.uiApi.me().getConstant("entity_x"));
         this.ed_popupChar.y = _loc6_;
         this.ed_popupChar.width = _loc7_;
         this.ed_popupChar.height = _loc8_;
         this.uiApi.addChild(this.entityCtr,this.ed_popupChar);
         this.btn_popupReplay.visible = this.tx_bg_btn_popupReplay.visible = false;
         if(this._animation)
         {
            if(this._direction == DirectionsEnum.DIRECTION_EAST || this._direction == DirectionsEnum.DIRECTION_NORTH || this._direction == DirectionsEnum.DIRECTION_SOUTH || this._direction == DirectionsEnum.DIRECTION_WEST)
            {
               this._direction = (this._direction + 1) % 8;
            }
         }
         this.uiApi.addComponentHook(this.ed_popupChar,"onEntityReady");
         this.ed_popupChar.direction = this._direction;
         if(_loc2_ && _loc2_.length > 0)
         {
            _loc29_ = false;
            if(this._currentGIDsPreview.length == _loc2_.length)
            {
               for(_loc30_ in _loc2_)
               {
                  if(this._currentGIDsPreview[_loc30_] != _loc2_[_loc30_])
                  {
                     _loc29_ = true;
                     break;
                  }
               }
            }
            else
            {
               _loc29_ = true;
            }
            if(_loc29_)
            {
               this._currentGIDsPreview = new Vector.<uint>();
               for each(_loc31_ in _loc2_)
               {
                  this._currentGIDsPreview.push(_loc31_);
               }
               this.sysApi.sendAction(new AccessoryPreviewRequest(_loc2_));
            }
            else
            {
               this.onAccessoryPreview(this._currentPreviewLook);
            }
         }
         else
         {
            this.ed_popupChar.look = _loc5_;
            if(this._animation)
            {
               this.btn_popupReplay.visible = this.tx_bg_btn_popupReplay.visible = true;
            }
         }
         this.lbl_popupPrice.text = this.utilApi.kamasToString(this._selectedArticle.price,"");
         if(this._selectedArticle.originalPrice == 0)
         {
            this.ctr_popupOldPrice.visible = false;
         }
         else
         {
            this.lbl_popupOldPrice.text = this.utilApi.kamasToString(this._selectedArticle.originalPrice,"");
            this.ctr_crossprice.width = this.lbl_popupOldPrice.textWidth;
            this.ctr_popupOldPrice.visible = true;
         }
         if(this._selectedArticle.currency == DofusShopEnum.CURRENCY_OGRINES)
         {
            this.tx_popupCurrency.visible = true;
            this.tx_popupCurrency.uri = this._currencyUriOgr;
            if(this._selectedArticle.price > this._moneyOgr)
            {
               this.btn_popupBuy.disabled = true;
            }
            else
            {
               this.btn_popupBuy.disabled = false;
            }
         }
         else if(this._selectedArticle.currency == DofusShopEnum.CURRENCY_KROZ)
         {
            this.tx_popupCurrency.visible = true;
            this.tx_popupCurrency.uri = this._currencyUriKro;
            if(this._selectedArticle.price > this._moneyKro)
            {
               this.btn_popupBuy.disabled = true;
            }
            else
            {
               this.btn_popupBuy.disabled = false;
            }
         }
         else
         {
            this.tx_popupCurrency.visible = false;
            if(this.sysApi.isSteamEmbed())
            {
               this.lbl_popupCurrency.visible = true;
               this.lbl_popupCurrency.text = this._selectedArticle.currency;
            }
         }
         this.uiApi.me().render();
         this.ctr_popupArticle.visible = true;
      }
      
      public function onEntityReady(param1:*) : void
      {
         if(this._animation)
         {
            this.uiApi.removeComponentHook(this.ed_popupChar,"onEntityReady");
            this.ed_popupChar.setAnimationAndDirection(this._animation,this._direction);
         }
         var _loc2_:Object = this.ed_popupChar.getEntityBounds();
         var _loc3_:Object = this.ed_popupChar["getEntityOrigin"]();
         var _loc4_:Point = this.entityCtr["globalToLocal"](_loc3_);
         var _loc5_:int = parseInt(this.uiApi.me().getConstant("entity_center")) - _loc4_.x;
         this.ed_popupChar.x = parseInt(this.uiApi.me().getConstant("entity_x")) + _loc5_;
         this.ed_popupChar.visible = true;
      }
      
      private function manageWaiting(param1:Boolean = true) : void
      {
         this.ctr_articlesLoader.visible = param1;
         this.ctr_articlesLoader.mouseEnabled = param1;
      }
      
      private function wheelChara(param1:int) : void
      {
         this._direction = (this._direction + param1 + 8) % 8;
         if(this._nbDirectionMax == 4 && this._direction % 2 == 0)
         {
            this._direction = (this._direction + param1 + 8) % 8;
         }
         this.ed_popupChar.direction = this._direction;
      }
      
      public function onRelease(param1:Object) : void
      {
         var _loc2_:DofusShopHighlight = null;
         var _loc3_:Object = null;
         var _loc4_:Object = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:Object = null;
         var _loc8_:Object = null;
         switch(param1)
         {
            case this.inp_search:
               if(this.inp_search.text == this.INPUT_SEARCH_DEFAULT_TEXT)
               {
                  this.inp_search.text = "";
               }
               break;
            case this.btn_resetSearch:
               this._searchCriteria = null;
               this.inp_search.text = this.INPUT_SEARCH_DEFAULT_TEXT;
               this._isOnSearch = false;
               this.btn_resetSearch.visible = false;
               break;
            case this.btn_nextPage:
               if(this._currentPage + 1 <= this._maxPage)
               {
                  if(this._isOnSearch)
                  {
                     this.sysApi.sendAction(new ShopSearchRequest(this._searchCriteria,++this._currentPage));
                  }
                  else
                  {
                     this.sysApi.sendAction(new ShopArticlesListRequest(this._currentSelectedCatId,++this._currentPage));
                  }
                  this.manageWaiting();
                  this.refreshPageNumber();
               }
               break;
            case this.btn_prevPage:
               if(this._currentPage - 1 >= 0)
               {
                  if(this._isOnSearch)
                  {
                     this.sysApi.sendAction(new ShopSearchRequest(this._searchCriteria,--this._currentPage));
                  }
                  else
                  {
                     this.sysApi.sendAction(new ShopArticlesListRequest(this._currentSelectedCatId,--this._currentPage));
                  }
                  this.manageWaiting();
                  this.refreshPageNumber();
               }
               break;
            case this.btn_buyOgrins:
               this.sysApi.goToUrl(this.uiApi.getText("ui.link.buyOgrine"));
               break;
            case this.ctr_carousel:
               _loc2_ = this._highlightCarousels[this._currentCarouselArticleIndex];
               this.releaseOnHighlight(_loc2_);
               break;
            case this.btn_carouselBuy:
               this._selectedArticle = this._highlightCarousels[this._currentCarouselArticleIndex].external;
               this.displayArticle();
               break;
            case this.btn_carouselNextPage:
            case this.tx_carouselRight:
               this.showHighlightCarouselArticle();
               clearInterval(this._carouselInterval);
               this._carouselInterval = setInterval(this.showHighlightCarouselArticle,10000);
               break;
            case this.btn_carouselPrevPage:
            case this.tx_carouselLeft:
               this.showHighlightCarouselArticle(false);
               clearInterval(this._carouselInterval);
               this._carouselInterval = setInterval(this.showHighlightCarouselArticle,10000);
               break;
            case this.btn_popupBuy:
               if(!this._currentItemBuyName)
               {
                  this._currentItemBuyName = this._selectedArticle.name;
                  _loc5_ = this.uiApi.getText("ui.shop.buyConfirm",this._selectedArticle.name,this.utilApi.kamasToString(this._selectedArticle.price,this._selectedArticle.currency));
                  this.modCommon.openPopup(this.uiApi.getText("ui.popup.warning"),_loc5_,[this.uiApi.getText("ui.common.ok"),this.uiApi.getText("ui.common.cancel")],[this.onPopupBuy,this.onPopupClose],this.onPopupBuy,this.onPopupClose);
               }
               break;
            case this.btn_popupClose:
               this._selectedArticle = null;
               this.ctr_popupArticle.visible = false;
               break;
            case this.btn_popupReplay:
               if(this._animation != "")
               {
                  if(this._direction == DirectionsEnum.DIRECTION_EAST || this._direction == DirectionsEnum.DIRECTION_NORTH || this._direction == DirectionsEnum.DIRECTION_SOUTH || this._direction == DirectionsEnum.DIRECTION_WEST)
                  {
                     this._direction = (this._direction + 1) % 8;
                     this.ed_popupChar.direction = this._direction;
                  }
                  this.ed_popupChar.setAnimationAndDirection(this._animation,this._direction);
               }
               break;
            case this.btn_popupLeftArrow:
               this.wheelChara(1);
               break;
            case this.btn_popupRightArrow:
               this.wheelChara(-1);
               break;
            case this.tx_popupPackImage:
               this.displayArticle();
               break;
            case this.ctr_popupPackSetDetails:
               if(this._articleType != ARTICLE_TYPE_PACK)
               {
                  break;
               }
               _loc3_ = this.dataApi.getItemWrapper(this._selectedArticle.gids[0],0,0,1);
               this.sysApi.dispatchHook(OpenSet,_loc3_);
               break;
            default:
               if(param1.name.indexOf("btn_buy") != -1)
               {
                  _loc4_ = this._compHookData[param1.name];
                  if(!this._currentItemBuyName)
                  {
                     this._currentItemBuyName = _loc4_.name;
                     this._selectedArticle = _loc4_ as DofusShopArticle;
                     _loc6_ = this.uiApi.getText("ui.shop.buyConfirm",_loc4_.name,this.utilApi.kamasToString(_loc4_.price,_loc4_.currency));
                     this.modCommon.openPopup(this.uiApi.getText("ui.popup.warning"),_loc6_,[this.uiApi.getText("ui.common.ok"),this.uiApi.getText("ui.common.cancel")],[this.onPopupBuy,this.onPopupClose],this.onPopupBuy,this.onPopupClose);
                  }
               }
               else if(param1.name.indexOf("btn_article") != -1)
               {
                  if(this._shopArticle && (this._shopArticle.data.currency == DofusShopEnum.CURRENCY_OGRINES && this._shopArticle.data.price > this._moneyOgr || this._shopArticle.data.currency == DofusShopEnum.CURRENCY_KROZ && this._shopArticle.data.price > this._moneyKro))
                  {
                     _loc7_ = this.utilApi.getObjectsUnderPoint();
                     for each(_loc8_ in _loc7_)
                     {
                        if(_loc8_.hasOwnProperty("customUnicName") && _loc8_.customUnicName.indexOf("tx_btn") != -1)
                        {
                           return;
                        }
                     }
                  }
                  if(this._selectedArticle == this._compHookData[param1.name] && this.ctr_popupArticle.visible)
                  {
                     this._selectedArticle = null;
                     this.ctr_popupArticle.visible = false;
                  }
                  else
                  {
                     this._selectedArticle = this._compHookData[param1.name];
                     this.displayArticle();
                  }
               }
         }
      }
      
      public function onRollOver(param1:Object) : void
      {
         var _loc2_:String = null;
         this._rollOverTarget = param1;
         var _loc3_:Object = {
            "point":LocationEnum.POINT_BOTTOM,
            "relativePoint":LocationEnum.POINT_TOP
         };
         var _loc4_:int = 3;
         switch(param1)
         {
            case this.btn_buyOgrins:
               _loc2_ = this.uiApi.getText("ui.shop.buyOgrines");
               break;
            case this.btn_resetSearch:
               _loc2_ = this.uiApi.getText("ui.search.clear");
               break;
            case this.btn_popupReplay:
               _loc2_ = this.uiApi.getText("ui.shop.replayEmote");
               break;
            case this.tx_carouselRight:
            case this.tx_carouselLeft:
            case this.btn_carouselPrevPage:
            case this.btn_carouselNextPage:
               this.tx_carouselRight.alpha = 1;
               this.tx_carouselLeft.alpha = 1;
               this.btn_carouselNextPage.visible = true;
               this.btn_carouselPrevPage.visible = true;
               break;
            case this.lbl_money:
               if(this._currentCurrency == CURRENCY_OGRINES)
               {
                  _loc3_ = {
                     "point":LocationEnum.POINT_BOTTOMRIGHT,
                     "relativePoint":LocationEnum.POINT_TOPRIGHT
                  };
                  _loc4_ = 0;
                  _loc2_ = this.uiApi.getText("ui.shop.ownedOgrines");
               }
               break;
            default:
               if(param1.name.indexOf("btn_buy") != -1)
               {
                  _loc2_ = this.uiApi.getText("ui.common.buy");
               }
         }
         if(_loc2_)
         {
            this.uiApi.showTooltip(this.uiApi.textTooltipInfo(_loc2_),param1,false,"standard",_loc3_.point,_loc3_.relativePoint,_loc4_,null,null,null,"TextInfo");
         }
      }
      
      public function onRollOut(param1:Object) : void
      {
         if((param1 == this.tx_carouselRight || param1 == this.tx_carouselLeft) && (param1 != this.btn_carouselNextPage && param1 != this.btn_carouselPrevPage))
         {
            this.tx_carouselRight.alpha = 0;
            this.tx_carouselLeft.alpha = 0;
            this.btn_carouselNextPage.visible = false;
            this.btn_carouselPrevPage.visible = false;
         }
         else
         {
            this.uiApi.hideTooltip();
         }
      }
      
      public function onSelectItem(param1:Object, param2:uint, param3:Boolean) : void
      {
         if(param2 != GridItemSelectMethodEnum.AUTO)
         {
            if(param1 == this.gd_categories)
            {
               this._searchCriteria = null;
               this.inp_search.text = this.INPUT_SEARCH_DEFAULT_TEXT;
               this._isOnSearch = false;
               this.btn_resetSearch.visible = false;
               this.displayCategories(param1.selectedItem);
            }
         }
      }
      
      public function onItemRollOver(param1:Object, param2:Object) : void
      {
         var _loc3_:String = null;
         if(param2)
         {
            if(param2.data is DofusShopArticleReference)
            {
               param2.container.buttonMode = false;
               param2.container.useHandCursor = false;
               _loc3_ = "";
               if(param2.data.name)
               {
                  _loc3_ = _loc3_ + ("<b>" + param2.data.name + "</b>\n");
               }
               if(param2.data.description)
               {
                  _loc3_ = _loc3_ + param2.data.description;
               }
               if(_loc3_)
               {
                  this.uiApi.showTooltip(this.uiApi.textTooltipInfo(_loc3_),param2.container,false,"standard",LocationEnum.POINT_BOTTOM,LocationEnum.POINT_TOP,3,null,null,null,"TextInfo");
               }
            }
            else if(param2.data is ItemWrapper)
            {
               this.uiApi.showTooltip(param2.data,param2.container,false,"standard",LocationEnum.POINT_BOTTOMLEFT,LocationEnum.POINT_BOTTOMRIGHT,3,null,null,{
                  "showEffects":true,
                  "header":true
               });
            }
            else if(param2.data is DofusShopArticle)
            {
               this._shopArticle = param2;
            }
            else
            {
               param2.container.buttonMode = true;
               param2.container.useHandCursor = true;
            }
         }
      }
      
      public function onItemRollOut(param1:Object, param2:Object) : void
      {
         if(!this._rollOverTarget || !param1.contains(this._rollOverTarget))
         {
            this.uiApi.hideTooltip();
         }
         this._shopArticle = null;
      }
      
      public function onItemRightClick(param1:Object, param2:Object) : void
      {
         if(param2.data)
         {
            this.modContextMenu.createContextMenu(this.menuApi.create(param2.data,"item"));
         }
      }
      
      private function onEnterFrame() : void
      {
         var _loc1_:Object = null;
         var _loc2_:Object = null;
         var _loc3_:* = false;
         if(this._shopArticle)
         {
            _loc1_ = this.utilApi.getObjectsUnderPoint();
            for each(_loc2_ in _loc1_)
            {
               if(_loc2_.hasOwnProperty("customUnicName") && _loc2_.customUnicName.indexOf("tx_btn") != -1)
               {
                  _loc3_ = false;
                  if(this._shopArticle.data.currency == DofusShopEnum.CURRENCY_OGRINES)
                  {
                     _loc3_ = this._shopArticle.data.price > this._moneyOgr;
                  }
                  else if(this._shopArticle.data.currency == DofusShopEnum.CURRENCY_KROZ)
                  {
                     _loc3_ = this._shopArticle.data.price > this._moneyKro;
                  }
                  if(_loc3_)
                  {
                     this.sysApi.setMouseCursor(MouseCursor.ARROW);
                  }
                  return;
               }
            }
            this.sysApi.setMouseCursor(MouseCursor.AUTO);
         }
      }
      
      public function onShortcut(param1:String) : Boolean
      {
         if(param1 == ShortcutHookListEnum.VALID_UI && this.inp_search.haveFocus)
         {
            if(this._searchCriteria != this.inp_search.text && this.inp_search.text.length > 0 || this._currentPage != 1)
            {
               this._currentPage = 1;
               this._searchCriteria = this.inp_search.text;
               this.sysApi.sendAction(new ShopSearchRequest(this._searchCriteria,1));
               this.manageWaiting();
               this._isOnSearch = true;
            }
            return true;
         }
         if(param1 == ShortcutHookListEnum.CLOSE_UI && this.ctr_popupArticle.visible)
         {
            this.ctr_popupArticle.visible = false;
            return true;
         }
         return false;
      }
      
      private function onPopupBuy() : void
      {
         if(this.sysApi.isSteamEmbed())
         {
            this._steamBuyLockPopupName = this.modCommon.openNoButtonPopup(this.uiApi.getText("ui.shop.purchaseInProgress"),this.uiApi.getText("ui.shop.processingPurchase"));
         }
         this.sysApi.sendAction(new ShopBuyRequest(this._selectedArticle.id,1));
      }
      
      private function onAccessoryPreview(param1:Object) : void
      {
         if(param1)
         {
            this._currentPreviewLook = param1;
            if(this._animation != "")
            {
               this.btn_popupReplay.visible = this.tx_bg_btn_popupReplay.visible = true;
            }
         }
         else
         {
            param1 = this.utilApi.getRealTiphonEntityLook(this.playerApi.getPlayedCharacterInfo().id,true);
            if(param1.getBone() == 2)
            {
               param1.setBone(1);
            }
         }
         this.ed_popupChar.look = param1;
      }
      
      private function onKeyUp(param1:Object, param2:uint) : void
      {
         if(this.inp_search.haveFocus && this.inp_search.text != this.INPUT_SEARCH_DEFAULT_TEXT)
         {
            if(this.inp_search.text.length)
            {
               this._currentPage = 1;
               this._searchCriteria = this.inp_search.text;
               this.sysApi.sendAction(new ShopSearchRequest(this._searchCriteria,1));
               this.manageWaiting();
               this._isOnSearch = true;
               this.btn_resetSearch.visible = true;
            }
            else if(this._searchCriteria)
            {
               this._searchCriteria = null;
               this.btn_resetSearch.visible = false;
            }
         }
      }
      
      private function onUiLoaded(param1:String) : void
      {
         var _loc2_:* = undefined;
         if(param1 == "shopItemBoxPop")
         {
            _loc2_ = this.uiApi.getUi("shopItemBoxPop");
            if(_loc2_)
            {
               _loc2_.uiClass.lbl_name.text = "";
               _loc2_.uiClass.lbl_level.cssClass = "left";
               _loc2_.uiClass.lbl_level.css = this.uiApi.createUri(this.sysApi.getConfigEntry("config.ui.skin") + "css/normal2.css");
               _loc2_.uiClass.lbl_level.x = parseInt(this.uiApi.me().getConstant("popup_level_x"));
               _loc2_.uiClass.lbl_level.y = parseInt(this.uiApi.me().getConstant("popup_level_y"));
            }
         }
      }
      
      private function onDofusShopArticlesList(param1:Object, param2:uint) : void
      {
         var _loc3_:Array = null;
         var _loc4_:DofusShopArticle = null;
         var _loc5_:* = undefined;
         clearInterval(this._carouselInterval);
         this._isOnFrontPage = false;
         this._maxPage = param2;
         if(param1.length == 0)
         {
            this.lbl_page.text = "";
            this.gd_articles.visible = false;
            this.lbl_noResult.visible = true;
            this.btn_nextPage.disabled = true;
            this.btn_prevPage.disabled = true;
         }
         else
         {
            this.refreshPageNumber();
            _loc3_ = new Array();
            for each(_loc4_ in param1)
            {
               _loc3_.push(_loc4_);
            }
            this.gd_articles.dataProvider = _loc3_;
            this.gd_articles.visible = true;
            this.lbl_noResult.visible = false;
         }
         this.ctr_frontDisplay.visible = false;
         this.ctr_articlesDisplay.visible = true;
         this.manageWaiting(false);
         if(this._goToArticleParams && this._goToArticleParams.articleId != 0)
         {
            for each(_loc5_ in param1)
            {
               if(_loc5_.id == this._goToArticleParams.articleId)
               {
                  this._selectedArticle = _loc5_;
                  this.displayArticle();
                  this._goToArticleParams = null;
                  break;
               }
            }
         }
      }
      
      private function onDofusShopSuccessfulPurchase(param1:int) : void
      {
         if(this._steamBuyLockPopupName != "")
         {
            this.uiApi.unloadUi(this._steamBuyLockPopupName);
            this._steamBuyLockPopupName = "";
         }
         this.modCommon.openPopup(this.uiApi.getText("ui.popup.information"),this.uiApi.getText("ui.shop.successfulPurchase",this._currentItemBuyName),[this.uiApi.getText("ui.common.ok")]);
         this._currentItemBuyName = null;
      }
      
      private function onDofusShopError(param1:String) : void
      {
         var _loc2_:String = null;
         switch(param1)
         {
            case DofusShopEnum.ERROR_PURCHASE_FAILED:
               _loc2_ = this.uiApi.getText("ui.shop.purchaseFailed");
               this._currentItemBuyName = null;
               break;
            case DofusShopEnum.ERROR_PURCHASE_NO_MONEY:
               _loc2_ = this.uiApi.getText("ui.shop.purchaseNoMoney");
               this._currentItemBuyName = null;
               break;
            case DofusShopEnum.ERROR_PURCHASE_NO_STOCK:
               _loc2_ = this.uiApi.getText("ui.shop.purchaseNoStock");
               this._currentItemBuyName = null;
               break;
            case DofusShopEnum.ERROR_PURCHASE_REQUEST_TIMED_OUT:
               _loc2_ = this.uiApi.getText("ui.shop.purchaseTimedOut");
               this._currentItemBuyName = null;
               break;
            case DofusShopEnum.ERROR_REQUEST_TIMED_OUT:
               _loc2_ = this.uiApi.getText("ui.shop.errorTimedOut");
               break;
            case DofusShopEnum.ERROR_AUTHENTICATION_FAILED:
               _loc2_ = this.uiApi.getText("ui.shop.errorAuthentication");
               this.modCommon.openPopup(this.uiApi.getText("ui.common.error"),_loc2_,[this.uiApi.getText("ui.common.ok")]);
               this.uiApi.unloadUi("webBase");
               return;
            case DofusShopEnum.ERROR_STEAM_NOT_TRUSTED_USER:
               _loc2_ = this.uiApi.getText("ui.shop.errorNotSteamTrusted");
               this._currentItemBuyName = null;
               break;
            case DofusShopEnum.ERROR_PURCHASE_CANCELED:
               _loc2_ = "";
               this._currentItemBuyName = null;
               break;
            default:
               _loc2_ = this.uiApi.getText("ui.shop.error");
         }
         if(this._steamBuyLockPopupName != "")
         {
            this.uiApi.unloadUi(this._steamBuyLockPopupName);
            this._steamBuyLockPopupName = "";
         }
         if(_loc2_ != "")
         {
            this.modCommon.openPopup(this.uiApi.getText("ui.common.error"),_loc2_,[this.uiApi.getText("ui.common.ok")]);
         }
      }
      
      private function onDofusShopMoney(param1:int, param2:int) : void
      {
         this._moneyOgr = param1;
         this._moneyKro = param2;
         this.refreshMoney();
      }
      
      private function onDofusShopHome(param1:Object, param2:Object, param3:Object, param4:Object, param5:Object) : void
      {
         var _loc8_:DofusShopCategory = null;
         var _loc9_:Array = null;
         var _loc10_:DofusShopArticle = null;
         var _loc11_:DofusShopHighlight = null;
         var _loc12_:DofusShopHighlight = null;
         var _loc13_:int = 0;
         var _loc14_:DofusShopCategory = null;
         var _loc15_:DofusShopCategory = null;
         var _loc16_:int = 0;
         var _loc17_:Object = null;
         var _loc18_:* = undefined;
         var _loc19_:* = undefined;
         var _loc20_:* = undefined;
         this._isOnFrontPage = true;
         this._categories = new Array();
         var _loc6_:Array = new Array();
         var _loc7_:Array = new Array();
         for each(_loc8_ in param1)
         {
            _loc6_[_loc8_.id] = new Array();
            for each(_loc14_ in _loc8_.children)
            {
               _loc7_[_loc14_.id] = new Array();
               for each(_loc15_ in _loc14_.children)
               {
                  _loc7_[_loc14_.id].push({
                     "id":_loc15_.id,
                     "name":_loc15_.name,
                     "desc":_loc15_.description,
                     "img":_loc15_.image,
                     "parentIds":[_loc14_.id,_loc8_.id],
                     "subcats":new Array()
                  });
               }
               _loc6_[_loc8_.id].push({
                  "id":_loc14_.id,
                  "name":_loc14_.name,
                  "desc":_loc14_.description,
                  "img":_loc14_.image,
                  "parentIds":[_loc8_.id],
                  "level":1,
                  "subcats":_loc7_[_loc14_.id]
               });
            }
            this._categories.push({
               "id":_loc8_.id,
               "name":_loc8_.name,
               "desc":_loc8_.description,
               "img":_loc8_.image,
               "parentIds":new Array(),
               "level":0,
               "subcats":_loc6_[_loc8_.id]
            });
         }
         this.gd_categories.dataProvider = this._categories;
         this.gd_categories.selectedIndex = 0;
         _loc9_ = new Array();
         for each(_loc10_ in param2)
         {
            _loc9_.push(_loc10_);
         }
         this.gd_frontDisplayArticles.dataProvider = _loc9_;
         this._highlightCarousels = new Array();
         for each(_loc11_ in param4)
         {
            this._highlightCarousels.push(_loc11_);
         }
         this._currentCarouselArticleIndex = int(Math.random() * this._highlightCarousels.length) - 1;
         this.showHighlightCarouselArticle();
         this._carouselInterval = setInterval(this.showHighlightCarouselArticle,10000);
         this._highlightImages = new Array();
         for each(_loc12_ in param5)
         {
            this._highlightImages.push(_loc12_);
         }
         while(_loc13_ < this._highlightImages.length)
         {
            this.showHighlightImage(this._highlightImages[_loc13_],_loc13_);
            _loc13_++;
         }
         this.ctr_frontDisplay.visible = true;
         this.ctr_articlesDisplay.visible = false;
         this.ctr_shopLoader.visible = false;
         this.ctr_shopLoader.mouseEnabled = false;
         if(this._goToArticleParams || this._goToCategoryId)
         {
            _loc16_ = !!this._goToArticleParams?int(this._goToArticleParams.categoryId):int(this._goToCategoryId);
            for each(_loc18_ in this._categories)
            {
               if(_loc18_.id == _loc16_)
               {
                  _loc17_ = _loc18_;
               }
               if(_loc17_)
               {
                  break;
               }
               for each(_loc19_ in _loc18_.subcats)
               {
                  if(_loc19_.id == _loc16_)
                  {
                     _loc17_ = _loc19_;
                  }
                  if(_loc17_)
                  {
                     break;
                  }
                  for each(_loc20_ in _loc19_.subcats)
                  {
                     if(_loc20_.id == _loc16_)
                     {
                        _loc17_ = _loc20_;
                     }
                     if(_loc17_)
                     {
                        break;
                     }
                  }
               }
            }
            this._goToCategoryId = 0;
            this.displayCategories(_loc17_);
         }
      }
   }
}
