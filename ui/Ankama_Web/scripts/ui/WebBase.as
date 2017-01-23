package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.datacenter.misc.OptionalFeature;
   import com.ankamagames.dofus.uiApi.ConfigApi;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.SecurityApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofusModuleLibrary.enum.SoundEnum;
   import d2enums.ShortcutHookListEnum;
   import enum.WebTabEnum;
   import flash.external.ExternalInterface;
   import flash.filters.BlurFilter;
   import flash.geom.Point;
   
   public class WebBase
   {
      
      public static var currentTabUi:String;
      
      public static var isShopAvailable:Boolean = false;
      
      public static var isVetRewardsAvailable:Boolean = true;
      
      public static var isLibraryAvailable:Boolean = false;
      
      public static const blurFilter:BlurFilter = new BlurFilter(10,10);
       
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      public var configApi:ConfigApi;
      
      public var dataApi:DataApi;
      
      public var securityApi:SecurityApi;
      
      public var uiCtr:GraphicContainer;
      
      public var btn_close:ButtonContainer;
      
      public var btn_tabShop:ButtonContainer;
      
      public var btn_tabOgrines:ButtonContainer;
      
      public var btn_tabVeteranRewards:ButtonContainer;
      
      public var btn_tabLibrary:ButtonContainer;
      
      public var tx_line:Texture;
      
      public var ctr_linemask:GraphicContainer;
      
      public function WebBase()
      {
         super();
      }
      
      public function main(param1:* = null) : void
      {
         var _loc3_:String = null;
         this.uiApi.me().restoreSnapshotAfterLoading = false;
         this.tx_line.mask = this.ctr_linemask;
         this.uiApi.addShortcutHook("closeUi",this.onShortcut);
         this.uiApi.addComponentHook(this.btn_tabOgrines,"onRelease");
         this.uiApi.addComponentHook(this.btn_tabVeteranRewards,"onRelease");
         this.uiApi.addComponentHook(this.btn_tabShop,"onRelease");
         this.btn_close.soundId = SoundEnum.CANCEL_BUTTON;
         var _loc2_:OptionalFeature = this.dataApi.getOptionalFeatureByKeyword("biz.shopInClient");
         if(_loc2_ && this.configApi.isOptionalFeatureActive(_loc2_.id))
         {
            isShopAvailable = true;
         }
         currentTabUi = null;
         if(this.sysApi.isSteamEmbed())
         {
            this.btn_tabOgrines.visible = false;
         }
         if(isShopAvailable)
         {
            this.btn_tabShop.visible = true;
         }
         if(isVetRewardsAvailable)
         {
            this.btn_tabVeteranRewards.visible = true;
         }
         if(isLibraryAvailable)
         {
            this.btn_tabLibrary.visible = true;
         }
         if(param1 && param1 is Array && param1[0])
         {
            this.openTab(param1[0],param1[1]);
         }
         else
         {
            _loc3_ = this.sysApi.getSetData("shopLastOpenedTab",WebTabEnum.SHOP_TAB);
            if(this.sysApi.isSteamEmbed() && _loc3_ == WebTabEnum.BAK_TAB)
            {
               _loc3_ = WebTabEnum.SHOP_TAB;
            }
            if(!isShopAvailable && _loc3_ == WebTabEnum.SHOP_TAB || !isVetRewardsAvailable && _loc3_ == WebTabEnum.VET_RWDS_TAB)
            {
               _loc3_ = WebTabEnum.BAK_TAB;
            }
            this.openTab(_loc3_);
         }
      }
      
      public function unload() : void
      {
         if(currentTabUi == WebTabEnum.BAK_TAB)
         {
            this.closeWebModalWindow();
         }
         if(currentTabUi)
         {
            this.uiApi.unloadUi(currentTabUi);
         }
         if(this.uiApi.getUi("secureMode"))
         {
            this.uiApi.unloadUi("secureMode");
         }
         currentTabUi = null;
      }
      
      public function onShortcut(param1:String) : Boolean
      {
         switch(param1)
         {
            case ShortcutHookListEnum.CLOSE_UI:
               this.uiApi.unloadUi(this.uiApi.me().name);
               return true;
            default:
               return false;
         }
      }
      
      public function onRelease(param1:Object) : void
      {
         switch(param1)
         {
            case this.btn_tabShop:
               this.openTab(WebTabEnum.SHOP_TAB);
               break;
            case this.btn_tabOgrines:
               this.openTab(WebTabEnum.BAK_TAB);
               break;
            case this.btn_tabVeteranRewards:
               this.openTab(WebTabEnum.VET_RWDS_TAB);
               break;
            case this.btn_tabLibrary:
               this.openTab(WebTabEnum.LIBRARY_TAB);
               break;
            case this.btn_close:
               this.uiApi.unloadUi(this.uiApi.me().name);
         }
      }
      
      public function openTab(param1:String = null, param2:Object = null) : void
      {
         var _loc3_:* = this.uiApi.getUi("secureModeIcon") == null;
         if(!_loc3_ && (param1 == WebTabEnum.BAK_TAB || !this.sysApi.isSteamEmbed() && param1 == WebTabEnum.SHOP_TAB))
         {
            if(!this.uiApi.getUi("secureMode"))
            {
               if(currentTabUi)
               {
                  this.uiApi.getUi(currentTabUi).filters = [blurFilter];
                  this.uiApi.getUi(currentTabUi).disabled = true;
               }
               this.uiApi.loadUiInside("Ankama_Common::secureMode",this.uiCtr,"secureMode",{
                  "reboot":false,
                  "callBackOnSecured":this.onSecureConfirmed,
                  "callBackOnSecuredParams":[param1,param2],
                  "callBackOnCancelled":this.onSecureRequestCancelled,
                  "offset":new Point(-80,-100),
                  "step":100
               });
               this.updateSelectedTab(param1);
            }
            return;
         }
         if(param1 == currentTabUi)
         {
            return;
         }
         if(this.uiApi.getUi("secureMode"))
         {
            this.uiApi.unloadUi("secureMode");
         }
         if(currentTabUi == WebTabEnum.BAK_TAB)
         {
            this.closeWebModalWindow();
         }
         if(currentTabUi)
         {
            this.uiApi.unloadUi(currentTabUi);
         }
         currentTabUi = param1;
         this.sysApi.setData("shopLastOpenedTab",currentTabUi);
         this.updateSelectedTab();
         this.uiApi.loadUiInside(currentTabUi,this.uiCtr,currentTabUi,param2);
      }
      
      private function onSecureConfirmed(param1:Array) : void
      {
         this.openTab(param1[0],param1[1]);
      }
      
      private function onSecureRequestCancelled() : void
      {
         if(currentTabUi)
         {
            this.uiApi.getUi(currentTabUi).filters = null;
            this.uiApi.getUi(currentTabUi).disabled = false;
            this.updateSelectedTab();
         }
      }
      
      private function updateSelectedTab(param1:String = "") : void
      {
         if(!param1)
         {
            param1 = currentTabUi;
         }
         switch(param1)
         {
            case WebTabEnum.SHOP_TAB:
               this.btn_tabShop.selected = true;
               break;
            case WebTabEnum.BAK_TAB:
               this.btn_tabOgrines.selected = true;
               break;
            case WebTabEnum.VET_RWDS_TAB:
               this.btn_tabVeteranRewards.selected = true;
               break;
            case WebTabEnum.LIBRARY_TAB:
               this.btn_tabLibrary.selected = true;
         }
      }
      
      private function closeWebModalWindow() : void
      {
         if(ExternalInterface.available)
         {
            ExternalInterface.call("closeModal");
         }
      }
   }
}
