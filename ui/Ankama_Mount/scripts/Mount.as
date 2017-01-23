package
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.dofus.uiApi.PlayedCharacterApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofus.uiApi.UtilApi;
   import com.ankamagames.dofusModuleLibrary.enum.interfaces.UIEnum;
   import d2enums.StrataEnum;
   import d2hooks.CertificateMountData;
   import d2hooks.CurrentMap;
   import d2hooks.ExchangeStartOkMount;
   import d2hooks.GameFightStarting;
   import d2hooks.OpenMount;
   import d2hooks.PaddockBuyResult;
   import d2hooks.PaddockSellBuyDialog;
   import d2hooks.PaddockedMountData;
   import flash.display.Sprite;
   import ui.MountAncestors;
   import ui.MountInfo;
   import ui.MountPaddock;
   import ui.PaddockSellBuy;
   
   public class Mount extends Sprite
   {
       
      
      private var include_mountInfo:MountInfo;
      
      private var include_mountAncestors:MountAncestors;
      
      private var include_mountPaddock:MountPaddock;
      
      private var include_paddockSellBuy:PaddockSellBuy;
      
      public var uiApi:UiApi;
      
      public var sysApi:SystemApi;
      
      [Module(name="Ankama_Common")]
      public var modCommon:Object;
      
      public var playerApi:PlayedCharacterApi;
      
      public var utilApi:UtilApi;
      
      public function Mount()
      {
         super();
      }
      
      public function main() : void
      {
         this.sysApi.addHook(OpenMount,this.onOpenMount);
         this.sysApi.addHook(ExchangeStartOkMount,this.onExchangeStartOkMount);
         this.sysApi.addHook(CertificateMountData,this.onCertificateMountData);
         this.sysApi.addHook(PaddockedMountData,this.onCertificateMountData);
         this.sysApi.addHook(PaddockBuyResult,this.paddockBuyResult);
         this.sysApi.addHook(CurrentMap,this.onCurrentMap);
         this.sysApi.addHook(GameFightStarting,this.onGameFightStarting);
         this.sysApi.addHook(PaddockSellBuyDialog,this.onPaddockSellBuyDialog);
      }
      
      private function onExchangeStartOkMount(param1:Object, param2:Object) : void
      {
         this.uiApi.unloadUi(UIEnum.MOUNT_INFO);
         var _loc3_:Object = this.uiApi.getUi("mountPaddock");
         if(_loc3_)
         {
            _loc3_.uiClass.showUi(param1,param2);
         }
         else
         {
            this.uiApi.loadUi("mountPaddock","mountPaddock",{
               "stabledList":param1,
               "paddockedList":param2
            },StrataEnum.STRATA_TOP);
         }
      }
      
      private function onCurrentMap(param1:int) : void
      {
         this.uiApi.unloadUi("mountPaddock");
      }
      
      private function onGameFightStarting(param1:uint) : void
      {
         this.uiApi.unloadUi("mountPaddock");
      }
      
      private function onOpenMount() : void
      {
         var _loc2_:Object = null;
         var _loc1_:Object = this.uiApi.getUi(UIEnum.MOUNT_INFO);
         if(_loc1_)
         {
            _loc2_ = this.uiApi.getUi("mountPaddock");
            if(!_loc2_ || _loc2_.uiClass.visible == false)
            {
               if(_loc1_.visible == false)
               {
                  _loc1_.visible = true;
               }
               else
               {
                  this.uiApi.unloadUi(UIEnum.MOUNT_INFO);
               }
               this.uiApi.unloadUi(UIEnum.MOUNT_ANCESTORS);
            }
            else if(_loc1_.visible == false)
            {
               _loc2_.uiClass.showCurrentMountInfo();
               _loc1_.visible = true;
            }
         }
         else
         {
            if(this.uiApi.getUi(UIEnum.MOUNT_INFO))
            {
               this.uiApi.unloadUi(UIEnum.MOUNT_INFO);
            }
            if(this.playerApi.getMount())
            {
               this.uiApi.loadUi(UIEnum.MOUNT_INFO,UIEnum.MOUNT_INFO,{
                  "paddockMode":false,
                  "posX":890,
                  "posY":150,
                  "mountData":this.playerApi.getMount()
               });
            }
         }
      }
      
      private function onPaddockSellBuyDialog(param1:Boolean, param2:Number, param3:uint, ... rest) : void
      {
         this.uiApi.loadUi("paddockSellBuy","paddockSellBuy",{
            "sellMode":param1,
            "id":param2,
            "price":param3
         });
      }
      
      private function paddockBuyResult(param1:uint, param2:Boolean, param3:uint) : void
      {
         if(param2)
         {
            this.modCommon.openPopup(this.uiApi.getText("ui.login.news"),this.uiApi.getText("ui.common.houseBuy",this.uiApi.getText("ui.common.mountPark"),this.utilApi.kamasToString(param3,"")),[this.uiApi.getText("ui.common.ok")]);
         }
         else
         {
            this.modCommon.openPopup(this.uiApi.getText("ui.login.news"),this.uiApi.getText("ui.common.cantBuyPaddock",this.utilApi.kamasToString(param3,"")),[this.uiApi.getText("ui.common.ok")]);
         }
      }
      
      private function onCertificateMountData(param1:Object) : void
      {
         var _loc2_:Object = this.uiApi.getUi("mountPaddock");
         if(!_loc2_ || !_loc2_.uiClass.visible)
         {
            if(this.uiApi.getUi(UIEnum.MOUNT_INFO))
            {
               this.uiApi.unloadUi(UIEnum.MOUNT_INFO);
            }
            this.uiApi.loadUi(UIEnum.MOUNT_INFO,UIEnum.MOUNT_INFO,{
               "centeredMode":true,
               "posX":550,
               "posY":150,
               "mountData":param1
            });
         }
      }
      
      private function onPaddockedMountData(param1:Object) : void
      {
         if(this.uiApi.getUi(UIEnum.MOUNT_INFO))
         {
            this.uiApi.unloadUi(UIEnum.MOUNT_INFO);
         }
         this.uiApi.loadUi(UIEnum.MOUNT_INFO,UIEnum.MOUNT_INFO,{
            "centeredMode":true,
            "posX":452,
            "posY":152,
            "mountData":param1
         });
      }
   }
}
