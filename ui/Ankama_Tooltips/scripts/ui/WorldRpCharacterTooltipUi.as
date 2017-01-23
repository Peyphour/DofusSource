package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.datacenter.guild.EmblemSymbol;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayMerchantInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.HumanInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.HumanOptionAlliance;
   import com.ankamagames.dofus.network.types.game.context.roleplay.HumanOptionGuild;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.PlayedCharacterApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofus.uiApi.TooltipApi;
   import com.ankamagames.dofus.uiApi.UtilApi;
   import flash.geom.Rectangle;
   
   public class WorldRpCharacterTooltipUi extends AbstractWorldCharacterTooltipUi
   {
      
      private static const TOOLTIP_MIN_WIDTH:int = 160;
      
      private static const TOOLTIP_MIN_HEIGHT:int = 40;
      
      private static const EMBLEM_BACK_WIDTH:int = 40;
       
      
      public var tooltipApi:TooltipApi;
      
      public var uiApi:UiApi;
      
      public var dataApi:DataApi;
      
      public var playerApi:PlayedCharacterApi;
      
      public var utilApi:UtilApi;
      
      public var sysApi:SystemApi;
      
      private var _guildInformations:Object;
      
      private var _colorBack:int;
      
      private var _colorUp:int;
      
      private var _allianceInformations:Object;
      
      private var _allianceEmblemBgColor:int;
      
      private var _allianceEmblemIconColor:int;
      
      public var mainCtr:Object;
      
      public var ctr_alignment_top:GraphicContainer;
      
      public var ctr_alignment_bottom:GraphicContainer;
      
      public var infosCtr:GraphicContainer;
      
      public var tx_back:GraphicContainer;
      
      public var tx_emblemBack:Texture;
      
      public var tx_emblemUp:Texture;
      
      public var tx_AllianceEmblemBack:Texture;
      
      public var tx_AllianceEmblemUp:Texture;
      
      public var tx_alignment:Texture;
      
      public var tx_alignmentBottom:Texture;
      
      public var lbl_playerName:Label;
      
      public var lbl_guildName:Label;
      
      public var lbl_title:Label;
      
      public var ctr_ornament:GraphicContainer;
      
      public var tx_ornament:Texture;
      
      private var _achievementData:Object;
      
      private var _tooltipIsLoaded:Boolean = false;
      
      public function WorldRpCharacterTooltipUi()
      {
         super();
      }
      
      public function main(param1:Object = null) : void
      {
         var _loc8_:* = undefined;
         var _loc9_:Label = null;
         var _loc10_:int = 0;
         var _loc11_:Object = null;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:Number = NaN;
         var _loc15_:int = 0;
         this.uiApi.me().mouseEnabled = this.uiApi.me().mouseChildren = false;
         var _loc2_:Object = param1.data;
         this.lbl_playerName.x = this.lbl_playerName.y = this.lbl_playerName.width = 0;
         this.lbl_guildName.x = this.lbl_guildName.y = this.lbl_guildName.width = 0;
         this.lbl_guildName.removeFromParent();
         this.tx_emblemBack.removeFromParent();
         this.tx_emblemUp.removeFromParent();
         this.tx_AllianceEmblemBack.removeFromParent();
         this.tx_AllianceEmblemUp.removeFromParent();
         this.lbl_playerName.removeFromParent();
         this.updatePlayerName(param1.makerName,_loc2_);
         this.infosCtr.addContent(this.lbl_playerName);
         var _loc3_:Boolean = false;
         var _loc4_:Boolean = false;
         var _loc5_:Boolean = _loc2_.hasOwnProperty("infos");
         var _loc6_:Boolean = _loc2_.hasOwnProperty("titleName") && _loc2_.titleName;
         var _loc7_:Boolean = _loc2_.hasOwnProperty("ornamentAssetId") && _loc2_.ornamentAssetId > 0;
         if(_loc5_)
         {
            this._guildInformations = null;
            if(_loc2_.infos.humanoidInfo is HumanInformations)
            {
               for each(_loc8_ in (_loc2_.infos.humanoidInfo as HumanInformations).options)
               {
                  if(_loc8_ is HumanOptionGuild)
                  {
                     this._guildInformations = _loc8_.guildInformations;
                     _loc3_ = true;
                  }
                  else if(_loc8_ is HumanOptionAlliance)
                  {
                     this._allianceInformations = _loc8_.allianceInformations;
                     _loc4_ = true;
                  }
               }
            }
         }
         else if(_loc2_ is GameRolePlayMerchantInformations)
         {
            for each(_loc8_ in (_loc2_ as GameRolePlayMerchantInformations).options)
            {
               if(_loc8_ is HumanOptionGuild)
               {
                  this._guildInformations = _loc8_.guildInformations;
                  _loc3_ = true;
               }
               else if(_loc8_ is HumanOptionAlliance)
               {
                  this._allianceInformations = _loc8_.allianceInformations;
                  _loc4_ = true;
               }
            }
         }
         if(_loc3_)
         {
            this.lbl_playerName.y = 18;
            this.tx_emblemBack.visible = false;
            this.tx_emblemUp.visible = false;
            this.infosCtr.addContent(this.tx_emblemBack);
            this.infosCtr.addContent(this.tx_emblemUp);
            this.infosCtr.addContent(this.lbl_guildName);
            this.lbl_guildName.text = this._guildInformations.guildName;
            this.lbl_guildName.fullWidth();
            this.tx_emblemBack.dispatchMessages = true;
            this.uiApi.addComponentHook(this.tx_emblemBack,"onTextureReady");
            this.tx_emblemUp.dispatchMessages = true;
            this.uiApi.addComponentHook(this.tx_emblemUp,"onTextureReady");
            this.tx_emblemBack.uri = this.uiApi.createUri(this.uiApi.me().getConstant("emblems") + "back/" + this._guildInformations.guildEmblem.backgroundShape + ".swf",true);
            this.tx_emblemUp.uri = this.uiApi.createUri(this.uiApi.me().getConstant("emblems") + "up/" + this._guildInformations.guildEmblem.symbolShape + ".swf",true);
            this._colorUp = this._guildInformations.guildEmblem.symbolColor;
            this._colorBack = this._guildInformations.guildEmblem.backgroundColor;
            this.tx_emblemBack.x = 2;
            this.tx_emblemUp.x = 10;
            this.tx_emblemUp.y = 8;
            this.lbl_guildName.x = 50;
            this.lbl_guildName.y = -2;
            this.lbl_playerName.x = 50;
         }
         this.lbl_title.x = this.lbl_title.y = 0;
         this.lbl_title.width = 0;
         this.lbl_title.removeFromParent();
         if(_loc6_)
         {
            this.lbl_title.useCustomFormat = true;
            if(_loc2_.titleColor)
            {
               this.lbl_title.text = "<font color=\'#" + _loc2_.titleColor.substr(2) + "\'>" + _loc2_.titleName + "</font>";
            }
            this.lbl_title.fullWidth();
            this.infosCtr.addContent(this.lbl_title);
            if(_loc3_)
            {
               this.lbl_title.y = 40;
               this.lbl_title.x = 48;
            }
            else
            {
               this.lbl_title.y = 20;
            }
         }
         else
         {
            this.lbl_title.text = "";
            this.tx_emblemBack.x = 2;
            this.tx_emblemUp.x = 10;
         }
         if(_loc3_)
         {
            if(_loc4_)
            {
               this.tx_AllianceEmblemBack.visible = false;
               this.tx_AllianceEmblemUp.visible = false;
               this.infosCtr.addContent(this.tx_AllianceEmblemBack);
               this.infosCtr.addContent(this.tx_AllianceEmblemUp);
               this.lbl_guildName.appendText(" - [" + this._allianceInformations.allianceTag + "]");
               this.lbl_guildName.fullWidth();
               this._allianceEmblemBgColor = this._allianceInformations.allianceEmblem.backgroundColor;
               this._allianceEmblemIconColor = this._allianceInformations.allianceEmblem.symbolColor;
               this.tx_AllianceEmblemBack.dispatchMessages = this.tx_AllianceEmblemUp.dispatchMessages = true;
               this.uiApi.addComponentHook(this.tx_AllianceEmblemBack,"onTextureReady");
               this.uiApi.addComponentHook(this.tx_AllianceEmblemUp,"onTextureReady");
               if(this._allianceInformations.allianceEmblem.backgroundShape != this._guildInformations.guildEmblem.backgroundShape)
               {
                  this.tx_AllianceEmblemBack.uri = this.uiApi.createUri(this.uiApi.me().getConstant("emblems") + "backalliance/" + this._allianceInformations.allianceEmblem.backgroundShape + ".swf",true);
               }
               if(this._allianceInformations.allianceEmblem.symbolShape != this._guildInformations.guildEmblem.symbolShape)
               {
                  this.tx_AllianceEmblemUp.uri = this.uiApi.createUri(this.uiApi.me().getConstant("emblems") + "up/" + this._allianceInformations.allianceEmblem.symbolShape + ".swf",true);
               }
               this.tx_AllianceEmblemBack.y = this.tx_emblemBack.y;
               this.tx_AllianceEmblemUp.y = this.tx_emblemUp.y;
               if(this.lbl_guildName.width > this.lbl_playerName.width)
               {
                  _loc9_ = this.lbl_guildName;
               }
               else
               {
                  _loc9_ = this.lbl_playerName;
               }
               if(_loc6_ && this.lbl_title.width > _loc9_.width)
               {
                  _loc9_ = this.lbl_title;
               }
               this.tx_AllianceEmblemBack.x = _loc9_.x + _loc9_.width + 8;
               this.tx_AllianceEmblemUp.x = this.tx_AllianceEmblemBack.x + 8;
            }
            if(this.lbl_guildName.width > this.lbl_playerName.width)
            {
               _loc9_ = this.lbl_guildName;
            }
            else
            {
               _loc9_ = this.lbl_playerName;
            }
            if(_loc6_ && this.lbl_title.width > _loc9_.width)
            {
               _loc9_ = this.lbl_title;
            }
            this.lbl_playerName.x = this.lbl_playerName.x + (_loc9_.width - this.lbl_playerName.width) / 2;
            this.lbl_guildName.x = this.lbl_guildName.x + (_loc9_.width - this.lbl_guildName.width) / 2;
            this.lbl_title.x = this.lbl_title.x + (_loc9_.width - this.lbl_title.width) / 2;
         }
         this.tx_back.height = 0;
         this.tx_back.width = 0;
         this.tx_back.removeFromParent();
         if(this.lbl_title.text != "")
         {
            if(_loc3_ && this.lbl_guildName.width > this.lbl_playerName.width)
            {
               _loc9_ = this.lbl_guildName;
            }
            else
            {
               _loc9_ = this.lbl_playerName;
            }
            if(this.lbl_title.width > _loc9_.width)
            {
               _loc9_ = this.lbl_title;
            }
            _loc10_ = _loc9_.x + _loc9_.width + 8;
            if(_loc3_ && _loc4_)
            {
               _loc10_ = _loc10_ + (EMBLEM_BACK_WIDTH + 8);
            }
            this.tx_back.width = _loc10_;
            if(_loc3_)
            {
               this.lbl_guildName.x = _loc9_.x + _loc9_.width / 2 - this.lbl_guildName.width / 2;
            }
            this.lbl_playerName.x = _loc9_.x + _loc9_.width / 2 - this.lbl_playerName.width / 2;
            this.lbl_title.x = _loc9_.x + _loc9_.width / 2 - this.lbl_title.width / 2;
            this.tx_back.height = this.infosCtr.height + 8;
         }
         else if(_loc3_)
         {
            if(this.lbl_guildName.width > this.lbl_playerName.width)
            {
               this.tx_back.width = this.lbl_guildName.x + this.lbl_guildName.width + 8;
            }
            else
            {
               this.tx_back.width = this.lbl_playerName.x + this.lbl_playerName.width + 8;
            }
            if(_loc4_)
            {
               if(this.lbl_guildName.width > this.lbl_playerName.width)
               {
                  this.tx_back.width = this.lbl_guildName.x + this.lbl_guildName.width + EMBLEM_BACK_WIDTH + 16;
               }
               else
               {
                  this.tx_back.width = this.lbl_playerName.x + this.lbl_playerName.width + EMBLEM_BACK_WIDTH + 16;
               }
            }
            this.tx_back.height = this.infosCtr.height + 6;
         }
         else
         {
            if(this.lbl_playerName.width < 60)
            {
               this.lbl_playerName.x = (60 - this.lbl_playerName.width) / 2;
               this.tx_back.width = 68;
            }
            else
            {
               this.tx_back.width = this.lbl_playerName.width + 8;
            }
            this.tx_back.height = this.infosCtr.height + 5;
         }
         this.tx_back.width = this.tx_back.width + 2;
         if(this.lbl_title.text != "" && !_loc3_ && !_loc4_)
         {
            this.lbl_playerName.x = this.tx_back.width / 2 - this.lbl_playerName.width / 2 - 4;
         }
         if(_loc2_.hasOwnProperty("infos") && _loc2_.infos.hasOwnProperty("alignmentInfos"))
         {
            _loc11_ = param1.data.infos.alignmentInfos;
         }
         else if(_loc2_.hasOwnProperty("alignmentInfos"))
         {
            _loc11_ = _loc2_.alignmentInfos;
         }
         if(_loc11_ && _loc11_.alignmentSide > 0 && _loc11_.alignmentGrade > 0)
         {
            _loc7_ = false;
         }
         if(_loc7_ && this.tx_back.width < TOOLTIP_MIN_WIDTH)
         {
            _loc13_ = TOOLTIP_MIN_WIDTH - this.tx_back.width;
            this.tx_back.width = TOOLTIP_MIN_WIDTH;
            this.lbl_playerName.x = (TOOLTIP_MIN_WIDTH - this.lbl_playerName.width) / 2;
            if(_loc3_)
            {
               if(this.lbl_playerName.width > this.lbl_guildName.width)
               {
                  _loc14_ = (TOOLTIP_MIN_WIDTH - (this.tx_emblemBack.width + this.lbl_playerName.width)) / 2;
               }
               else
               {
                  _loc14_ = (TOOLTIP_MIN_WIDTH - (this.tx_emblemBack.width + this.lbl_guildName.width)) / 2;
               }
               if(_loc14_ > 8)
               {
                  _loc14_ = _loc14_ - 8;
               }
               this.tx_emblemBack.x = _loc14_;
               this.tx_emblemUp.x = _loc14_ + 8;
               this.lbl_playerName.x = this.tx_emblemBack.x + 48;
               this.lbl_guildName.x = this.tx_emblemBack.x + 48;
            }
            if(_loc6_)
            {
               this.lbl_title.x = (TOOLTIP_MIN_WIDTH - this.lbl_title.width) / 2 - 5;
            }
         }
         if(_loc7_ && this.tx_back.height < TOOLTIP_MIN_HEIGHT)
         {
            _loc15_ = TOOLTIP_MIN_HEIGHT - this.tx_back.height;
            this.tx_back.height = TOOLTIP_MIN_HEIGHT;
            this.lbl_playerName.y = (TOOLTIP_MIN_HEIGHT - this.lbl_playerName.height) / 2 - 3;
         }
         this.infosCtr.addContent(this.tx_back,0);
         this._tooltipIsLoaded = false;
         this.tx_ornament.uri = null;
         if(_loc7_)
         {
            this.mainCtr.visible = false;
            this.tx_ornament.dispatchMessages = true;
            this.uiApi.addComponentHook(this.tx_ornament,"onTextureReady");
            this.tx_ornament.uri = this.uiApi.createUri(this.sysApi.getConfigEntry("config.gfx.path.ornament") + "ornament_" + _loc2_.ornamentAssetId + ".swf|ornament_" + _loc2_.ornamentAssetId);
         }
         else
         {
            this.mainCtr.visible = true;
         }
         if(param1.zoom)
         {
            this.uiApi.me().scale = param1.zoom;
         }
         this.tx_alignment.removeFromParent();
         this.tx_alignmentBottom.removeFromParent();
         this.tooltipApi.place(param1.position,param1.point,param1.relativePoint,param1.offset);
         showAlignmentWings(param1);
      }
      
      private function updatePlayerName(param1:String, param2:Object) : void
      {
         switch(param1)
         {
            case "player":
            case "mutant":
               this.lbl_playerName.text = param2.infos.name;
               break;
            case "merchant":
               this.lbl_playerName.text = param2.name + " (" + Api.ui.getText("ui.common.merchant") + ")";
         }
         this.lbl_playerName.fullWidth();
      }
      
      public function updateContent(param1:Object) : void
      {
         this.updatePlayerName(param1.makerName,param1.data);
      }
      
      private function updateEmblemBack(param1:Texture, param2:int) : void
      {
         this.utilApi.changeColor(param1.getChildByName("back"),param2,1);
         param1.visible = true;
      }
      
      private function updateEmblemUp(param1:Texture, param2:int, param3:int) : void
      {
         var _loc4_:EmblemSymbol = this.dataApi.getEmblemSymbol(param3);
         if(_loc4_.colorizable)
         {
            this.utilApi.changeColor(param1.getChildByName("up"),param2,0);
         }
         else
         {
            this.utilApi.changeColor(param1.getChildByName("up"),param2,0,true);
         }
         param1.visible = true;
      }
      
      public function onTextureReady(param1:Object) : void
      {
         var _loc2_:Object = null;
         var _loc3_:* = undefined;
         switch(param1)
         {
            case this.tx_emblemBack:
               if(!this._guildInformations)
               {
                  return;
               }
               this.updateEmblemBack(this.tx_emblemBack,this._colorBack);
               if(this._allianceInformations && this._allianceInformations.allianceEmblem.backgroundShape == this._guildInformations.guildEmblem.backgroundShape)
               {
                  this.tx_AllianceEmblemBack.uri = this.uiApi.createUri(this.uiApi.me().getConstant("emblems") + "backalliance/" + this._allianceInformations.allianceEmblem.backgroundShape + ".swf",true);
               }
               break;
            case this.tx_emblemUp:
               if(!this._guildInformations)
               {
                  return;
               }
               this.updateEmblemUp(this.tx_emblemUp,this._colorUp,this._guildInformations.guildEmblem.symbolShape);
               if(this._allianceInformations && this._allianceInformations.allianceEmblem.symbolShape == this._guildInformations.guildEmblem.symbolShape)
               {
                  this.tx_AllianceEmblemUp.uri = this.uiApi.createUri(this.uiApi.me().getConstant("emblems") + "up/" + this._allianceInformations.allianceEmblem.symbolShape + ".swf",true);
               }
               break;
            case this.tx_AllianceEmblemBack:
               if(!this._allianceInformations)
               {
                  return;
               }
               this.updateEmblemBack(this.tx_AllianceEmblemBack,this._allianceEmblemBgColor);
               break;
            case this.tx_AllianceEmblemUp:
               if(!this._allianceInformations)
               {
                  return;
               }
               this.updateEmblemUp(this.tx_AllianceEmblemUp,this._allianceEmblemIconColor,this._allianceInformations.allianceEmblem.symbolShape);
               break;
            case this.tx_ornament:
               if(!this._tooltipIsLoaded)
               {
                  this.uiApi.buildOrnamentTooltipFrom(this.tx_ornament,new Rectangle(0,0,this.tx_back.width,this.tx_back.height));
                  this.mainCtr.visible = true;
                  if(this.tx_ornament.child && this.tx_ornament.child.hasOwnProperty("bottom"))
                  {
                     _loc3_ = Object(this.tx_ornament.child).bottom.getBounds(Object(this.tx_ornament.child).bottom);
                     this.uiApi.me().y = this.uiApi.me().y - (Object(this.tx_ornament.child).bottom.height + _loc3_.top);
                  }
                  _loc2_ = this.uiApi.me().getBounds(this.uiApi.me());
                  if(this.uiApi.me().x + _loc2_.left < 0)
                  {
                     this.uiApi.me().x = this.uiApi.me().x - _loc2_.left;
                  }
                  else if(this.uiApi.me().x + _loc2_.right > this.uiApi.getStageWidth())
                  {
                     this.uiApi.me().x = this.uiApi.me().x - (this.uiApi.me().x + _loc2_.right - this.uiApi.getStageWidth());
                  }
                  if(this.uiApi.me().y + _loc2_.top < 0)
                  {
                     this.uiApi.me().y = this.uiApi.me().y - (this.uiApi.me().y + _loc2_.top);
                  }
                  this._tooltipIsLoaded = true;
               }
         }
      }
      
      public function unload() : void
      {
      }
   }
}
