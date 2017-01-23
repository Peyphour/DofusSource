package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.MapApi;
   import com.ankamagames.dofus.uiApi.PlayedCharacterApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofus.uiApi.UtilApi;
   import d2enums.ShortcutHookListEnum;
   import d2hooks.AddMapFlag;
   import d2hooks.ChatFocus;
   import flash.display.Shape;
   
   public class EstateForm
   {
       
      
      public var output:Object;
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      public var dataApi:DataApi;
      
      public var utilApi:UtilApi;
      
      public var playerApi:PlayedCharacterApi;
      
      public var mapApi:MapApi;
      
      private var _data:Object;
      
      private var _estateType:uint;
      
      private var _skillsList:Array;
      
      public var btn_mp:ButtonContainer;
      
      public var btn_loc:ButtonContainer;
      
      public var btn_close:ButtonContainer;
      
      public var tx_illusBg:Texture;
      
      public var tx_houseIcon:Texture;
      
      public var tx_kamas:Texture;
      
      public var lbl_name:Label;
      
      public var lbl_price:Label;
      
      public var lbl_priceContent:Label;
      
      public var lbl_nbRoomMount:Label;
      
      public var lbl_nbChestMachine:Label;
      
      public var lbl_skill:Label;
      
      public var lbl_locArea:Label;
      
      public var lbl_ownerContent:Label;
      
      public function EstateForm()
      {
         super();
      }
      
      public function main(param1:Array) : void
      {
         this._estateType = param1[0];
         this._data = param1[1];
         this.uiApi.addShortcutHook(ShortcutHookListEnum.CLOSE_UI,this.onShortCut);
         this.uiApi.addComponentHook(this.tx_houseIcon,"onTextureReady");
         this.tx_houseIcon.dispatchMessages = true;
         this.updateInformations();
      }
      
      public function unload() : void
      {
      }
      
      private function updateInformations() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:uint = 0;
         this.lbl_price.text = this.uiApi.getText("ui.common.price") + this.uiApi.getText("ui.common.colon");
         this.lbl_price.fullWidth();
         if(this._estateType == 0)
         {
            _loc1_ = this.dataApi.getHouse(this._data.modelId);
            this.lbl_nbRoomMount.text = this.uiApi.getText("ui.estate.nbRoom") + " " + this._data.nbRoom;
            this.lbl_nbChestMachine.text = this.uiApi.getText("ui.estate.nbChest") + " " + this._data.nbChest;
            this.tx_houseIcon.visible = false;
            this.tx_houseIcon.uri = this.uiApi.createUri(this.uiApi.me().getConstant("houses") + _loc1_.gfxId + ".png");
            this.lbl_name.text = _loc1_.name;
            this.lbl_priceContent.text = this.utilApi.kamasToString(this._data.price,"");
            this._skillsList = new Array();
            for each(_loc2_ in this._data.skillListIds)
            {
               if(_loc2_ != 339)
               {
                  this._skillsList.push(this.dataApi.getSkill(_loc2_).name);
               }
            }
            if(this._skillsList.length)
            {
               this.lbl_skill.text = this.uiApi.processText(this.uiApi.getText("ui.estate.houseSkills",this._skillsList.length),"m",this._skillsList.length == 1);
               this.uiApi.addComponentHook(this.lbl_skill,"onRollOver");
               this.uiApi.addComponentHook(this.lbl_skill,"onRollOut");
            }
            else
            {
               this.lbl_skill.text = this.uiApi.getText("ui.estate.noSkill");
            }
            this.lbl_locArea.text = this.dataApi.getArea(this.dataApi.getSubArea(this._data.subAreaId).areaId).name + " (" + this.dataApi.getSubArea(this._data.subAreaId).name + "), " + this._data.worldX + "," + this._data.worldY;
            if(!this._data.ownerName || this._data.ownerName == "")
            {
               this.lbl_ownerContent.text = this.uiApi.getText("ui.common.none");
               this.btn_mp.disabled = true;
            }
            else
            {
               this.lbl_ownerContent.text = this._data.ownerName;
               this.btn_mp.disabled = false;
               if(!this._data.ownerConnected)
               {
                  this.lbl_ownerContent.text = this.lbl_ownerContent.text + (" (" + this.uiApi.getText("ui.server.state.offline") + ")");
               }
            }
         }
         else
         {
            this.lbl_skill.visible = false;
            this.btn_mp.visible = false;
            this.lbl_ownerContent.width = this.lbl_ownerContent.width + 30;
            this.lbl_nbRoomMount.text = this.uiApi.getText("ui.estate.nbMount") + " " + this._data.nbMount;
            this.lbl_nbChestMachine.text = this.uiApi.getText("ui.estate.nbMachine") + " " + this._data.nbObject;
            this.tx_houseIcon.uri = this.uiApi.createUri(this.uiApi.me().getConstant("illus") + "enclos_tx_illuEnclos.png");
            this.lbl_name.text = this.uiApi.getText("ui.common.mountPark");
            this.lbl_priceContent.text = this.utilApi.kamasToString(this._data.price,"");
            this.lbl_locArea.text = this.dataApi.getArea(this.dataApi.getSubArea(this._data.subAreaId).areaId).name + " ( " + this.dataApi.getSubArea(this._data.subAreaId).name + "), " + this._data.worldX + "," + this._data.worldY;
            this.sysApi.log(2," proprio : " + this._data.guildOwner);
            if(!this._data.guildOwner || this._data.guildOwner == "")
            {
               this.lbl_ownerContent.text = this.uiApi.getText("ui.common.none");
            }
            else
            {
               this.lbl_ownerContent.text = this._data.guildOwner;
            }
         }
         this.lbl_priceContent.x = this.lbl_price.x + this.lbl_price.width;
         this.tx_kamas.x = this.lbl_priceContent.x + this.lbl_priceContent.textWidth + 10;
      }
      
      public function onTextureReady(param1:Texture) : void
      {
         var _loc2_:Shape = null;
         if(param1 == this.tx_houseIcon)
         {
            _loc2_ = new Shape();
            _loc2_.graphics.beginFill(16711680);
            _loc2_.graphics.drawRect(1,-2,this.tx_illusBg.width - 6,this.tx_illusBg.height - 7);
            _loc2_.y = 95;
            this.tx_houseIcon.addChild(_loc2_);
            this.tx_houseIcon.mask = _loc2_;
            this.tx_houseIcon.visible = true;
         }
      }
      
      public function onRelease(param1:Object) : void
      {
         switch(param1)
         {
            case this.btn_close:
               this.uiApi.unloadUi(this.uiApi.me().name);
               break;
            case this.btn_loc:
               this.sysApi.dispatchHook(AddMapFlag,"flag_teleportPoint",this.lbl_name.text + " (" + this._data.worldX + "," + this._data.worldY + ")",this.mapApi.getCurrentWorldMap().id,this._data.worldX,this._data.worldY,15636787,true);
               break;
            case this.btn_mp:
               this.sysApi.dispatchHook(ChatFocus,"*" + this._data.ownerName);
         }
      }
      
      public function onRollOver(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc3_:* = undefined;
         if(param1 == this.lbl_skill)
         {
            _loc2_ = "";
            for each(_loc3_ in this._skillsList)
            {
               _loc2_ = _loc2_ + (_loc3_ + " \n");
            }
            this.uiApi.showTooltip(this.uiApi.textTooltipInfo(_loc2_),param1,false,"standard",7,1,3,null,null,null,"TextInfo");
         }
      }
      
      public function onRollOut(param1:Object) : void
      {
         this.uiApi.hideTooltip();
      }
      
      private function onShortCut(param1:String) : Boolean
      {
         if(param1 == "closeUi")
         {
            this.uiApi.unloadUi(this.uiApi.me().name);
            return true;
         }
         return false;
      }
   }
}
