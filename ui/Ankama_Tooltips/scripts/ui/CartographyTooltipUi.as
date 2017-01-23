package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.datacenter.guild.EmblemSymbol;
   import com.ankamagames.dofus.datacenter.jobs.Skill;
   import com.ankamagames.dofus.internalDatacenter.guild.AllianceWrapper;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.PlayedCharacterApi;
   import com.ankamagames.dofus.uiApi.SocialApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofus.uiApi.TooltipApi;
   import com.ankamagames.dofus.uiApi.UtilApi;
   import d2hooks.UiLoaded;
   
   public class CartographyTooltipUi
   {
       
      
      private const _containers:Vector.<GraphicContainer> = new <GraphicContainer>[this.ctr_additionalInfo,this.ctr_subAreaInfo,this.ctr_alliance];
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      public var tooltipApi:TooltipApi;
      
      public var dataApi:DataApi;
      
      public var utilApi:UtilApi;
      
      public var socialApi:SocialApi;
      
      public var playerApi:PlayedCharacterApi;
      
      public var ctr_additionalInfo:GraphicContainer;
      
      public var ctr_additionalInfoBg:GraphicContainer;
      
      public var lbl_additionalInfo:Label;
      
      public var ctr_mapElementBg:GraphicContainer;
      
      public var lbl_mapElement:Label;
      
      public var ctr_subAreaInfo:GraphicContainer;
      
      public var ctr_subAreaInfoBg:GraphicContainer;
      
      public var lbl_subAreaInfo:Label;
      
      public var lbl_subAreaDare:Label;
      
      public var lbl_subAreaLevel:Label;
      
      public var tx_subArea_separator:Texture;
      
      public var ctr_alliance:GraphicContainer;
      
      public var ctr_allianceBg:GraphicContainer;
      
      public var lbl_allianceName:Label;
      
      public var ctr_emblem:GraphicContainer;
      
      public var tx_emblemBack:Texture;
      
      public var tx_emblemUp:Texture;
      
      private var _currentAlliance:AllianceWrapper;
      
      private var _uiParams:Object;
      
      public function CartographyTooltipUi()
      {
         super();
      }
      
      public function main(param1:Object = null) : void
      {
         this.uiApi.addComponentHook(this.tx_emblemBack,"onTextureReady");
         this.uiApi.addComponentHook(this.tx_emblemUp,"onTextureReady");
         this._uiParams = param1;
         this.sysApi.addHook(UiLoaded,this.onUiLoaded);
         var _loc2_:String = this.uiApi.me().customUnicName;
         if(_loc2_ && !this.uiApi.isUiLoading(_loc2_))
         {
            this.onUiLoaded(_loc2_);
         }
      }
      
      public function update(param1:Array) : void
      {
         this.ctr_additionalInfo.visible = false;
         if(param1[0] == "subAreaInfo")
         {
            this.updateMapInfo(param1[1],param1[2],param1[3],param1[4],param1[5],param1[6]);
         }
         else if(param1[0] == "search")
         {
            this.updateSearchInfo(param1[1],param1[2],param1[3]);
         }
      }
      
      public function unload() : void
      {
      }
      
      private function updateMapInfo(param1:int, param2:int, param3:String, param4:Object, param5:uint, param6:AllianceWrapper) : void
      {
         var _loc9_:uint = 0;
         var _loc12_:GraphicContainer = null;
         var _loc13_:GraphicContainer = null;
         var _loc14_:Number = NaN;
         var _loc7_:* = param4 != null;
         this.ctr_additionalInfoBg.visible = this.lbl_additionalInfo.visible = false;
         if(param3)
         {
            this.ctr_additionalInfo.visible = this.ctr_mapElementBg.visible = this.lbl_mapElement.visible = true;
            this.initLabel(this.lbl_mapElement,"<b>" + param3 + "</b>");
            this.ctr_mapElementBg.height = this.lbl_mapElement.textHeight + 12;
            this.ctr_subAreaInfo.y = this.ctr_mapElementBg.height + 4;
         }
         else
         {
            this.ctr_additionalInfo.visible = this.ctr_mapElementBg.visible = this.lbl_mapElement.visible = false;
            this.lbl_additionalInfo.text = "";
            this.ctr_subAreaInfo.y = 0;
         }
         var _loc8_:String = "";
         if(_loc7_)
         {
            _loc8_ = _loc8_ + ("<b>" + param4.name + "</b>");
            _loc9_ = this.socialApi.getTotalDaresInSubArea(param4.id);
         }
         this.initLabel(this.lbl_subAreaInfo,_loc8_);
         this.lbl_subAreaLevel.text = this.uiApi.getText("ui.common.short.level") + " " + param5;
         this.lbl_subAreaLevel.fullWidth();
         var _loc10_:int = param5 - this.playerApi.getPlayedCharacterInfo().level;
         var _loc11_:Boolean = _loc10_ < 0?true:false;
         _loc10_ = Math.abs(_loc10_);
         if(_loc11_)
         {
            if(_loc10_ < 20)
            {
               this.lbl_subAreaLevel.cssClass = "subarealevelgreen";
            }
            else
            {
               this.lbl_subAreaLevel.cssClass = "subarealevelgray";
            }
         }
         else if(_loc10_ < 20)
         {
            this.lbl_subAreaLevel.cssClass = "subarealevelgreen";
         }
         else if(_loc10_ > 20 && _loc10_ < 40)
         {
            this.lbl_subAreaLevel.cssClass = "subarealevelorange";
         }
         else
         {
            this.lbl_subAreaLevel.cssClass = "subarealevelred";
         }
         if(_loc9_)
         {
            this.lbl_subAreaDare.text = this.uiApi.processText(this.uiApi.getText("ui.social.dare.totalAvailable",_loc9_),"",_loc9_ == 1);
            this.lbl_subAreaDare.fullWidth();
            this.lbl_subAreaDare.visible = true;
            this.tx_subArea_separator.visible = true;
            this.ctr_subAreaInfoBg.height = this.lbl_subAreaDare.y + this.lbl_subAreaDare.textHeight + 15 + 15;
         }
         else
         {
            this.lbl_subAreaDare.visible = false;
            this.lbl_subAreaDare.text = "";
            this.tx_subArea_separator.visible = false;
            this.ctr_subAreaInfoBg.height = this.lbl_subAreaInfo.textHeight + 15 + 15;
         }
         this.lbl_subAreaLevel.x = Math.max(this.lbl_subAreaInfo.textWidth + 20,this.lbl_subAreaDare.textWidth - this.lbl_subAreaLevel.textWidth);
         this.lbl_subAreaLevel.y = this.ctr_subAreaInfo.y;
         if(param6)
         {
            if(!this._currentAlliance || param6.allianceId != this._currentAlliance.allianceId)
            {
               this.initLabel(this.lbl_allianceName,param6.allianceName + " [" + param6.allianceTag + "]");
               _loc14_ = this.tx_emblemBack.height / 2 + this.ctr_emblem.x;
               this.lbl_allianceName.y = _loc14_ - this.lbl_allianceName.textHeight / 2 - 3;
               this.ctr_allianceBg.height = Math.max(this.tx_emblemBack.height,this.lbl_allianceName.textHeight) + 7 * 2;
               this.tx_emblemBack.dispatchMessages = this.tx_emblemUp.dispatchMessages = true;
               this.tx_emblemBack.uri = this.uiApi.createUri(this.sysApi.getConfigEntry("config.gfx.path.emblem_icons.large") + "backalliance/" + param6.backEmblem.idEmblem + ".swf");
               this.tx_emblemUp.uri = this.uiApi.createUri(this.sysApi.getConfigEntry("config.gfx.path.emblem_icons.large") + "up/" + param6.upEmblem.idEmblem + ".swf");
               this._currentAlliance = param6;
            }
            _loc12_ = this.ctr_subAreaInfo;
            _loc13_ = this.ctr_subAreaInfoBg;
            this.ctr_alliance.y = _loc12_.y + _loc13_.height;
            this.ctr_alliance.visible = true;
         }
         else
         {
            this.ctr_alliance.visible = false;
         }
         this.updateSize();
      }
      
      private function updateSearchInfo(param1:Object, param2:String, param3:String) : void
      {
         var _loc5_:String = null;
         var _loc6_:Object = null;
         var _loc7_:Skill = null;
         var _loc8_:GraphicContainer = null;
         var _loc9_:GraphicContainer = null;
         if(param2)
         {
            this.initLabel(this.lbl_mapElement,"<b>" + param2 + "</b>");
            this.ctr_mapElementBg.height = this.lbl_mapElement.textHeight + 12;
            this.ctr_additionalInfoBg.y = this.lbl_additionalInfo.y = this.ctr_mapElementBg.y + this.ctr_mapElementBg.height + 4;
            this.ctr_mapElementBg.visible = this.lbl_mapElement.visible = true;
         }
         else
         {
            this.lbl_mapElement.text = "";
            this.ctr_additionalInfoBg.y = this.lbl_additionalInfo.y = 0;
            this.ctr_mapElementBg.visible = this.lbl_mapElement.visible = false;
         }
         this.ctr_additionalInfoBg.visible = this.lbl_additionalInfo.visible = true;
         var _loc4_:String = param1.data.name;
         if(param1.type == 4)
         {
            if(param1.resourceSubAreaIds)
            {
               _loc6_ = this.dataApi.getSkills();
               for each(_loc7_ in _loc6_)
               {
                  if(_loc7_.gatheredRessourceItem == param1.data.id)
                  {
                     _loc5_ = _loc7_.parentJob.name;
                     break;
                  }
               }
               _loc4_ = _loc4_ + (" (" + _loc5_ + ")");
            }
            else if(param1.subAreasIds)
            {
               _loc4_ = _loc4_ + ("\n" + this.uiApi.getText("ui.search.foundOn"));
            }
         }
         this.initLabel(this.lbl_additionalInfo,"<b>" + _loc4_ + "</b>\n" + param3);
         this.ctr_additionalInfoBg.height = this.lbl_additionalInfo.textHeight + 12;
         this.ctr_additionalInfo.visible = true;
         this.ctr_subAreaInfo.y = this.ctr_additionalInfoBg.y + this.ctr_additionalInfoBg.height + 9;
         if(this.ctr_alliance.visible)
         {
            _loc8_ = this.ctr_subAreaInfo;
            _loc9_ = this.ctr_subAreaInfoBg;
            this.ctr_alliance.y = _loc8_.y + _loc9_.height;
         }
         this.updateSize();
      }
      
      private function initLabel(param1:Label, param2:String) : void
      {
         param1.wordWrap = false;
         param1.text = "";
         param1.width = 1;
         param1.appendText(param2);
         param1.fullWidth();
      }
      
      private function updateSize() : void
      {
         var _loc5_:Number = NaN;
         var _loc1_:Number = this.lbl_subAreaLevel.x + this.lbl_subAreaLevel.width;
         if(this.lbl_mapElement.visible && this.lbl_mapElement.width > _loc1_)
         {
            _loc1_ = this.lbl_mapElement.width;
            this.lbl_subAreaLevel.x = this.lbl_mapElement.width - this.lbl_subAreaLevel.width;
         }
         if(this.lbl_additionalInfo.visible && this.lbl_additionalInfo.width > _loc1_)
         {
            _loc1_ = this.lbl_additionalInfo.width;
            this.lbl_subAreaLevel.x = this.lbl_additionalInfo.width - this.lbl_subAreaLevel.width;
         }
         var _loc2_:Number = !!this.ctr_alliance.visible?Number(this.lbl_allianceName.textWidth + 8 + 40):Number(0);
         if(_loc2_ > _loc1_)
         {
            _loc1_ = _loc2_;
            this.lbl_subAreaLevel.x = _loc2_ - this.lbl_subAreaLevel.width;
         }
         var _loc3_:* = this.uiApi.me();
         var _loc4_:Number = _loc1_ + 40;
         _loc3_.width = _loc4_;
         this.ctr_subAreaInfo.width = this.ctr_subAreaInfoBg.width = _loc4_;
         this.ctr_additionalInfo.width = this.ctr_mapElementBg.width = this.ctr_additionalInfoBg.width = _loc4_;
         this.ctr_alliance.width = this.ctr_allianceBg.width = _loc4_;
         if(this.ctr_alliance.visible)
         {
            _loc5_ = this.ctr_alliance.y + this.ctr_allianceBg.height;
         }
         else
         {
            _loc5_ = this.ctr_subAreaInfo.y + this.ctr_subAreaInfoBg.height;
         }
         _loc3_.height = _loc5_;
         this.tx_subArea_separator.width = this.ctr_subAreaInfoBg.width;
      }
      
      public function onTextureReady(param1:Object) : void
      {
         var _loc2_:EmblemSymbol = null;
         if(param1 == this.tx_emblemBack)
         {
            this.utilApi.changeColor(this.tx_emblemBack.getChildByName("back"),this._currentAlliance.backEmblem.color,1);
         }
         else if(param1 == this.tx_emblemUp)
         {
            _loc2_ = this.dataApi.getEmblemSymbol(this._currentAlliance.upEmblem.idEmblem);
            this.utilApi.changeColor(this.tx_emblemUp.getChildByName("up"),this._currentAlliance.upEmblem.color,0,!_loc2_.colorizable);
         }
      }
      
      public function onUiLoaded(param1:String) : void
      {
         if(param1 == this.uiApi.me().customUnicName)
         {
            this.updateMapInfo(this._uiParams.data.mapX,this._uiParams.data.mapY,this._uiParams.data.mapElementText,this._uiParams.data.subArea,this._uiParams.data.subAreaLevel,this._uiParams.data.alliance);
            this._uiParams.data.updatePositionFunction.call();
         }
      }
   }
}
