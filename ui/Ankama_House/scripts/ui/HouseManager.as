package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.uiApi.SocialApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import d2actions.HouseLockFromInside;
   
   public class HouseManager
   {
       
      
      public var uiApi:UiApi;
      
      public var sysApi:SystemApi;
      
      [Module(name="Ankama_Common")]
      public var modCommon:Object;
      
      public var socialApi:SocialApi;
      
      public var locked:Boolean;
      
      private var _price:uint;
      
      private var _ownerId:int;
      
      private var _ownerName:String;
      
      private var _playerAsGuild:Boolean;
      
      private var _houseWithNoOwner:Boolean;
      
      public var mainCtr:GraphicContainer;
      
      public var btnHouse:ButtonContainer;
      
      public var txHouse:Texture;
      
      public var txHouseSell:Texture;
      
      public var txHouseLock:Texture;
      
      public function HouseManager()
      {
         super();
      }
      
      public function main(param1:Object) : void
      {
         this._ownerId = param1.ownerId;
         this._ownerName = param1.ownerName;
         this._price = param1.price;
         this.locked = param1.isLocked;
         this.txHouse.mouseEnabled = false;
         this.txHouse.mouseChildren = false;
         this.txHouseSell.mouseEnabled = false;
         this.txHouseSell.mouseChildren = false;
         this.txHouseLock.mouseEnabled = false;
         this.txHouseLock.mouseChildren = false;
         this._houseWithNoOwner = this._ownerId == -1;
         this.updateIcon();
         this._playerAsGuild = this.socialApi.hasGuild();
         this.uiApi.addComponentHook(this.mainCtr,"onRelease");
         if(param1.subAreaAlliance)
         {
            this.mainCtr.y = this.mainCtr.y + 50;
         }
      }
      
      public function unload() : void
      {
         this.modCommon.closeAllMenu();
      }
      
      public function updatePrice(param1:uint) : void
      {
         this._price = param1;
         this.updateIcon();
      }
      
      public function updateIcon() : void
      {
         if(this._price == 0)
         {
            if(this.locked)
            {
               this.txHouseLock.visible = true;
               this.txHouse.x = 10;
            }
            else
            {
               this.txHouse.x = 25;
               this.txHouseLock.visible = false;
            }
            this.txHouseSell.visible = false;
         }
         else
         {
            this.txHouse.x = 10;
            this.txHouseSell.visible = true;
            this.txHouseLock.visible = false;
         }
      }
      
      private function displayHousePrice() : void
      {
         this.uiApi.loadUi("houseSale","houseSale",{
            "inside":true,
            "ownerName":this._ownerName,
            "price":this._price
         },3);
      }
      
      private function displayUiHouseGuildManager() : void
      {
         this.uiApi.loadUi("houseGuildManager","houseGuildManager",null,3);
      }
      
      private function displayPasswordMenu() : void
      {
         this.modCommon.openPasswordMenu(8,true,this.codeUpdate);
      }
      
      private function codeUpdate(param1:Boolean, param2:String) : void
      {
         this.sysApi.sendAction(new HouseLockFromInside(param2));
      }
      
      public function onRelease(param1:Object) : void
      {
         var _loc2_:Array = null;
         var _loc3_:Boolean = false;
         if(!this.uiApi.getUi("houseGuildManager") && !this.uiApi.getUi("houseSale"))
         {
            _loc2_ = new Array();
            _loc3_ = false;
            if(this._houseWithNoOwner)
            {
               _loc2_.push(this.modCommon.createContextMenuTitleObject(this.uiApi.getText("ui.common.houseWithNoOwner")));
            }
            else
            {
               _loc2_.push(this.modCommon.createContextMenuTitleObject(this.uiApi.getText("ui.common.houseOwnerName",this._ownerName)));
            }
            if(this._price == 0)
            {
               _loc2_.push(this.modCommon.createContextMenuItemObject(this.uiApi.getText("ui.common.sell"),this.displayHousePrice,null,_loc3_,null));
            }
            else
            {
               _loc2_.push(this.modCommon.createContextMenuItemObject(this.uiApi.getText("ui.common.changeHousePrice"),this.displayHousePrice,null,_loc3_));
            }
            if(this.locked)
            {
               _loc2_.push(this.modCommon.createContextMenuItemObject(this.uiApi.getText("ui.common.unlock"),this.displayPasswordMenu,null,false,null));
            }
            else
            {
               _loc2_.push(this.modCommon.createContextMenuItemObject(this.uiApi.getText("ui.common.lock"),this.displayPasswordMenu,null,false,null));
            }
            if(this._playerAsGuild)
            {
               _loc2_.push(this.modCommon.createContextMenuItemObject(this.uiApi.getText("ui.common.guildHouseConfiguration"),this.displayUiHouseGuildManager,null,false,null));
            }
            this.modCommon.createContextMenu(_loc2_);
         }
      }
   }
}
