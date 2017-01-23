package
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.dofus.datacenter.world.SubArea;
   import com.ankamagames.dofus.internalDatacenter.conquest.PrismSubAreaWrapper;
   import com.ankamagames.dofus.network.types.game.character.CharacterMinimalInformations;
   import com.ankamagames.dofus.uiApi.MapApi;
   import com.ankamagames.dofus.uiApi.PlayedCharacterApi;
   import com.ankamagames.dofus.uiApi.SocialApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofus.uiApi.UtilApi;
   import d2actions.LeaveDialog;
   import d2actions.LockableChangeCode;
   import d2actions.LockableUseCode;
   import d2enums.LockableResultEnum;
   import d2hooks.CurrentMap;
   import d2hooks.HavenBagLotteryGift;
   import d2hooks.HavenbagDisplayUi;
   import d2hooks.HouseBuyResult;
   import d2hooks.HouseEntered;
   import d2hooks.HouseExit;
   import d2hooks.HouseSold;
   import d2hooks.LockableCodeResult;
   import d2hooks.LockableShowCode;
   import d2hooks.LockableStateUpdateHouseDoor;
   import d2hooks.PurchasableDialog;
   import d2hooks.UiLoaded;
   import flash.display.Sprite;
   import ui.HavenbagFurnituresTypes;
   import ui.HavenbagManager;
   import ui.HavenbagUi;
   import ui.HouseGuildManager;
   import ui.HouseManager;
   import ui.HouseSale;
   
   public class House extends Sprite
   {
      
      public static var currentHouse:Object;
       
      
      public var uiApi:UiApi;
      
      public var sysApi:SystemApi;
      
      [Module(name="Ankama_Common")]
      public var modCommon:Object;
      
      public var playerApi:PlayedCharacterApi;
      
      public var mapApi:MapApi;
      
      public var socialApi:SocialApi;
      
      public var utilApi:UtilApi;
      
      private var include_HouseManager:HouseManager = null;
      
      private var include_HouseSale:HouseSale = null;
      
      private var include_HouseGuildManager:HouseGuildManager = null;
      
      private var include_HavenbagManager:HavenbagManager = null;
      
      private var include_HavenbagUi:HavenbagUi = null;
      
      private var include_HavenbagFurnituresTypes:HavenbagFurnituresTypes = null;
      
      private var _subAreaAlliance:Boolean;
      
      private var _price:uint;
      
      public function House()
      {
         super();
      }
      
      public function main() : void
      {
         this._price = 0;
         this.sysApi.addHook(CurrentMap,this.onCurrentMap);
         this.sysApi.addHook(HouseEntered,this.houseEntered);
         this.sysApi.addHook(HouseExit,this.houseExit);
         this.sysApi.addHook(HouseSold,this.houseSold);
         this.sysApi.addHook(PurchasableDialog,this.purchasableDialog);
         this.sysApi.addHook(HouseBuyResult,this.houseBuyResult);
         this.sysApi.addHook(LockableShowCode,this.lockableShowCode);
         this.sysApi.addHook(LockableCodeResult,this.lockableCodeResult);
         this.sysApi.addHook(LockableStateUpdateHouseDoor,this.lockableStateUpdateHouseDoor);
         this.sysApi.addHook(HavenbagDisplayUi,this.onHavenbagDisplayUi);
         this.sysApi.addHook(HavenBagLotteryGift,this.onHavenBagLotteryGift);
         this.sysApi.addHook(UiLoaded,this.onUiLoaded);
      }
      
      private function lockableShowCode(param1:Boolean, param2:uint) : void
      {
         this.modCommon.openPasswordMenu(param2,param1,this.selectCode,this.codeCancelChange);
      }
      
      private function selectCode(param1:Boolean, param2:String) : void
      {
         if(param1)
         {
            this.sysApi.sendAction(new LockableChangeCode(param2));
         }
         else
         {
            this.sysApi.sendAction(new LockableUseCode(param2));
         }
      }
      
      private function codeCancelChange() : void
      {
         this.sysApi.sendAction(new LeaveDialog());
      }
      
      private function lockableCodeResult(param1:uint) : void
      {
         if(param1 == LockableResultEnum.LOCKABLE_UNLOCKED)
         {
            this.modCommon.openPopup(this.uiApi.getText("ui.common.code"),this.uiApi.getText("ui.house.codeChanged"),[this.uiApi.getText("ui.common.ok")]);
         }
         else if(param1 == LockableResultEnum.LOCKABLE_CODE_ERROR)
         {
            this.modCommon.openPopup(this.uiApi.getText("ui.common.code"),this.uiApi.getText("ui.error.badCode"),[this.uiApi.getText("ui.common.ok")]);
         }
         else if(param1 == LockableResultEnum.LOCKABLE_UNLOCK_FORBIDDEN)
         {
            this.modCommon.openPopup(this.uiApi.getText("ui.common.code"),this.uiApi.getText("ui.error.forbiddenUnlock"),[this.uiApi.getText("ui.common.ok")]);
         }
      }
      
      private function lockableStateUpdateHouseDoor(param1:int, param2:Boolean) : void
      {
         var _loc3_:Object = this.uiApi.getUi("houseManager");
         if(_loc3_ != null)
         {
            _loc3_.uiClass.locked = param2;
            _loc3_.uiClass.updateIcon();
         }
      }
      
      private function purchasableDialog(param1:Boolean, param2:uint, param3:Object) : void
      {
         currentHouse = param3;
         this._price = param2;
         if(param1)
         {
            this.uiApi.loadUi("houseSale","houseSale",{
               "buyMode":true,
               "price":param2
            });
         }
         else
         {
            this.uiApi.loadUi("houseSale","houseSale",{
               "buyMode":false,
               "inside":false,
               "price":param2
            });
         }
      }
      
      private function houseBuyResult(param1:uint, param2:Boolean, param3:uint, param4:String) : void
      {
         if(param2)
         {
            this.modCommon.openPopup(this.uiApi.getText("ui.login.news"),this.uiApi.getText("ui.common.houseBuy",this.uiApi.getText("ui.common.houseOwnerName",param4),this.utilApi.kamasToString(param3,"")),[this.uiApi.getText("ui.common.ok")]);
         }
         else
         {
            this.modCommon.openPopup(this.uiApi.getText("ui.login.news"),this.uiApi.getText("ui.common.cantBuyHouse",this.utilApi.kamasToString(param3,"")),[this.uiApi.getText("ui.common.ok")]);
         }
      }
      
      private function houseSold(param1:uint, param2:uint, param3:String) : void
      {
         var _loc6_:String = null;
         var _loc7_:Object = null;
         var _loc8_:Object = null;
         var _loc4_:Object = this.uiApi.getUi("houseManager");
         if(_loc4_ != null)
         {
            _loc4_.uiClass.updatePrice(param2);
         }
         var _loc5_:Object = this.sysApi.getPlayerManager();
         if(_loc5_.nickname == param3)
         {
            if(param2 == 0)
            {
               _loc6_ = this.uiApi.getText("ui.common.houseNosell",this.uiApi.getText("ui.common.houseOwnerName",param3));
            }
            else
            {
               _loc6_ = this.uiApi.getText("ui.common.houseSell",this.uiApi.getText("ui.common.houseOwnerName",param3),this.utilApi.kamasToString(param2,""));
            }
         }
         else
         {
            _loc7_ = this.playerApi.getPlayerHouses();
            for each(_loc8_ in _loc7_)
            {
               if(_loc8_.houseId == param1)
               {
                  break;
               }
            }
            if(_loc8_)
            {
               _loc6_ = this.uiApi.getText("ui.common.houseSold",this.mapApi.getSubArea(_loc8_.subAreaId).name,_loc8_.worldX,_loc8_.worldY);
            }
         }
         if(_loc6_)
         {
            this.modCommon.openPopup(this.uiApi.getText("ui.login.news"),_loc6_,[this.uiApi.getText("ui.common.ok")]);
         }
      }
      
      private function houseEntered(param1:Boolean, param2:int, param3:String, param4:uint, param5:Boolean, param6:int, param7:int, param8:Object) : void
      {
         currentHouse = param8;
         if(param1)
         {
            if(!this.uiApi.getUi("houseManager"))
            {
               this.uiApi.loadUi("houseManager","houseManager",{
                  "ownerId":param2,
                  "ownerName":param3,
                  "price":param4,
                  "isLocked":param5,
                  "subAreaAlliance":this._subAreaAlliance
               },0);
            }
         }
         else if(this.uiApi.getUi("houseManager"))
         {
            this.uiApi.unloadUi("houseManager");
         }
      }
      
      private function houseExit() : void
      {
         if(this.uiApi.getUi("houseManager"))
         {
            this.uiApi.unloadUi("houseManager");
         }
      }
      
      private function onCurrentMap(param1:uint) : void
      {
         var _loc3_:PrismSubAreaWrapper = null;
         var _loc2_:SubArea = this.mapApi.getMapPositionById(param1).subArea;
         this._subAreaAlliance = false;
         if(_loc2_)
         {
            _loc3_ = this.socialApi.getPrismSubAreaById(_loc2_.id);
            if(_loc3_ && _loc3_.mapId != -1)
            {
               this._subAreaAlliance = true;
            }
         }
      }
      
      private function onHavenbagDisplayUi(param1:Boolean, param2:uint, param3:uint, param4:int, param5:*, param6:CharacterMinimalInformations) : void
      {
         if(param1)
         {
            this.uiApi.loadUi("havenbagManager","havenbagManager",{
               "currentRoomId":param2,
               "availableRooms":param3,
               "currentRoomThemeId":param4,
               "availableThemes":param5,
               "ownerInfos":param6
            });
         }
         else
         {
            this.uiApi.unloadUi("havenbagUi");
            this.uiApi.unloadUi("havenbagFurnituresTypes");
            this.uiApi.unloadUi("havenbagManager");
         }
      }
      
      private function onHavenBagLotteryGift(param1:String) : void
      {
         this.modCommon.openPopup(this.uiApi.getText("ui.popup.information"),this.uiApi.getText("ui.common.giftReceived",param1),[this.uiApi.getText("ui.common.ok")]);
      }
      
      private function onUiLoaded(param1:String) : void
      {
         if(param1 == "havenbagManager")
         {
            this.uiApi.loadUi("havenbagUi");
            this.uiApi.loadUi("havenbagFurnituresTypes");
         }
      }
   }
}
