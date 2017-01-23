package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Grid;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.dofus.datacenter.world.SubArea;
   import com.ankamagames.dofus.network.types.game.paddock.PaddockContentInformations;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.MapApi;
   import com.ankamagames.dofus.uiApi.MountApi;
   import com.ankamagames.dofus.uiApi.SocialApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofusModuleLibrary.enum.SoundEnum;
   import d2actions.GuildFarmTeleportRequest;
   import d2actions.GuildGetInformations;
   import d2enums.GuildInformationsTypeEnum;
   import d2enums.StatesEnum;
   import d2hooks.CurrentMap;
   import d2hooks.GuildInformationsFarms;
   
   public class GuildPaddock
   {
       
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      public var dataApi:DataApi;
      
      public var mapApi:MapApi;
      
      public var mountApi:MountApi;
      
      public var socialApi:SocialApi;
      
      private var _selectedPaddock:Object;
      
      public var grid_paddock:Grid;
      
      public var grid_mount:Grid;
      
      public var lbl_subarea:Label;
      
      public var btn_join:ButtonContainer;
      
      public function GuildPaddock()
      {
         super();
      }
      
      public function main(... rest) : void
      {
         this.btn_join.soundId = SoundEnum.SPEC_BUTTON;
         this.sysApi.addHook(GuildInformationsFarms,this.onGuildInformationsFarms);
         this.sysApi.addHook(CurrentMap,this.onCurrentMap);
         this.uiApi.addComponentHook(this.btn_join,"onRelease");
         this.uiApi.addComponentHook(this.grid_mount,"onSelectItem");
         this.uiApi.addComponentHook(this.grid_mount,"onItemRollOver");
         this.uiApi.addComponentHook(this.grid_mount,"onItemRollOut");
         this.uiApi.addComponentHook(this.grid_paddock,"onSelectItem");
         this.sysApi.sendAction(new GuildGetInformations(GuildInformationsTypeEnum.INFO_PADDOCKS));
         this.lbl_subarea.text = "";
         this.btn_join.disabled = true;
      }
      
      public function unload() : void
      {
      }
      
      public function updatePaddockLine(param1:*, param2:*, param3:Boolean) : void
      {
         if(param1)
         {
            if(param1.paddock.abandonned)
            {
               param2.tx_abandonned.visible = true;
               this.uiApi.addComponentHook(param2.tx_abandonned,"onRollOver");
               this.uiApi.addComponentHook(param2.tx_abandonned,"onRollOut");
            }
            else
            {
               param2.tx_abandonned.visible = false;
            }
            param2.lbl_name.text = param1.text;
            param2.lbl_items.text = param1.paddock.maxItems + " " + this.uiApi.getText("ui.common.maxWord");
            param2.lbl_mounts.text = param1.paddock.mountsInformations.length + "/" + param1.paddock.maxOutdoorMount;
            param2.btn_paddock.visible = true;
            param2.btn_paddock.selected = param3;
            param2.btn_paddock.state = !!param3?StatesEnum.STATE_SELECTED:StatesEnum.STATE_NORMAL;
         }
         else
         {
            param2.tx_abandonned.visible = false;
            param2.lbl_name.text = "";
            param2.btn_paddock.visible = false;
            param2.btn_paddock.selected = false;
         }
      }
      
      public function updateMountLine(param1:*, param2:*, param3:Boolean) : void
      {
         if(param1)
         {
            param2.lbl_mountType.text = this.mountApi.getMount(param1.modelId).name;
            param2.lbl_owner.text = param1.ownerName;
         }
         else
         {
            param2.lbl_mountType.text = "";
            param2.lbl_owner.text = "";
         }
      }
      
      private function onGuildInformationsFarms() : void
      {
         var _loc5_:PaddockContentInformations = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:SubArea = null;
         var _loc1_:Array = new Array();
         var _loc2_:Object = this.socialApi.getGuildPaddocks();
         var _loc3_:int = _loc2_.length;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = _loc2_[_loc4_];
            if(_loc5_.worldX)
            {
               _loc6_ = _loc5_.worldX;
            }
            else
            {
               _loc6_ = this.mapApi.getMapCoords(_loc5_.mapId).x;
            }
            if(_loc5_.worldY)
            {
               _loc7_ = _loc5_.worldY;
            }
            else
            {
               _loc7_ = this.mapApi.getMapCoords(_loc5_.mapId).y;
            }
            _loc8_ = this.dataApi.getSubArea(_loc5_.subAreaId);
            _loc1_.push({
               "paddock":_loc5_,
               "text":_loc8_.area.name + " (" + _loc8_.name + ") (" + _loc6_ + ", " + _loc7_ + ")",
               "areaId":_loc8_.areaId,
               "subAreaName":_loc8_.name,
               "mapId":_loc5_.mapId
            });
            _loc4_++;
         }
         _loc1_.sortOn(["areaId","subAreaName","mapId"],[Array.NUMERIC,Array.CASEINSENSITIVE,Array.NUMERIC]);
         this.grid_paddock.dataProvider = _loc1_;
         if(_loc2_.length == 0)
         {
            this.grid_mount.dataProvider = new Array();
         }
      }
      
      private function onPaddockSelected(param1:Object) : void
      {
         var _loc3_:Object = null;
         this._selectedPaddock = param1;
         this.btn_join.disabled = false;
         var _loc2_:Array = new Array();
         for each(_loc3_ in param1.mountsInformations)
         {
            _loc2_.push(_loc3_);
         }
         this.grid_mount.dataProvider = _loc2_;
         this.lbl_subarea.text = this.uiApi.getText("ui.common.mountPark") + "\n" + this.dataApi.getSubArea(param1.subAreaId).name;
      }
      
      private function onCurrentMap(param1:uint) : void
      {
         this.uiApi.unloadUi("socialBase");
      }
      
      public function onRelease(param1:Object) : void
      {
         if(param1 == this.btn_join)
         {
            if(this._selectedPaddock != null)
            {
               this.sysApi.sendAction(new GuildFarmTeleportRequest(this._selectedPaddock.paddockId));
               this.uiApi.unloadUi("socialBase");
            }
         }
      }
      
      public function onSelectItem(param1:Object, param2:uint, param3:Boolean) : void
      {
         if(param1 == this.grid_paddock)
         {
            this.onPaddockSelected(this.grid_paddock.dataProvider[param1.selectedIndex].paddock);
         }
      }
      
      public function onRollOver(param1:Object) : void
      {
         var _loc2_:String = null;
         if(param1.name.indexOf("tx_abandonned") != -1)
         {
            _loc2_ = this.uiApi.getText("ui.social.paddockWithNoOwner");
         }
         if(_loc2_)
         {
            this.uiApi.showTooltip(this.uiApi.textTooltipInfo(_loc2_),param1,false,"standard",7,1,3,null,null,null,"TextInfo");
         }
      }
      
      public function onRollOut(param1:Object) : void
      {
         this.uiApi.hideTooltip();
      }
      
      public function onItemRollOver(param1:Object, param2:Object) : void
      {
         var _loc3_:String = null;
         if(param2 && param2.data)
         {
            if(param2.data.name)
            {
               _loc3_ = param2.data.name;
            }
            else
            {
               _loc3_ = this.uiApi.getText("ui.common.noName");
            }
            this.uiApi.showTooltip(this.uiApi.textTooltipInfo(_loc3_),param1,false,"standard",7,1,3,null,null,null,"TextInfo");
         }
      }
      
      public function onItemRollOut(param1:Object, param2:Object) : void
      {
         this.uiApi.hideTooltip();
      }
   }
}
