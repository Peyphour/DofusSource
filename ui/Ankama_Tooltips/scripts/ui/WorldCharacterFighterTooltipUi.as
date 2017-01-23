package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.uiApi.ChatApi;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.FightApi;
   import com.ankamagames.dofus.uiApi.PlayedCharacterApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofus.uiApi.TooltipApi;
   import com.ankamagames.dofus.uiApi.UtilApi;
   import d2enums.BreedEnum;
   import d2enums.ProtocolConstantsEnum;
   import utils.TooltipUtil;
   
   public class WorldCharacterFighterTooltipUi extends AbstractWorldCharacterTooltipUi
   {
       
      
      public var tooltipApi:TooltipApi;
      
      public var uiApi:UiApi;
      
      public var dataApi:DataApi;
      
      public var playerApi:PlayedCharacterApi;
      
      public var utilApi:UtilApi;
      
      public var sysApi:SystemApi;
      
      public var fightApi:FightApi;
      
      public var chatApi:ChatApi;
      
      public var mainCtr:Object;
      
      public var ctr_alignment_top:GraphicContainer;
      
      public var ctr_alignment_bottom:GraphicContainer;
      
      public var tx_alignment:Texture;
      
      public var tx_alignmentBottom:Texture;
      
      public var infosCtr:GraphicContainer;
      
      public var lbl_playerName:Label;
      
      public var lbl_info:Label;
      
      public var lbl_damage:Label;
      
      public var lbl_fightStatus:Label;
      
      public var tx_back:GraphicContainer;
      
      public var tx_status:Texture;
      
      private var _isInPreFight:Boolean;
      
      private var _icons:Vector.<Texture>;
      
      public function WorldCharacterFighterTooltipUi()
      {
         this._icons = new Vector.<Texture>(0);
         super();
      }
      
      public function main(param1:Object = null) : void
      {
         var _loc2_:Texture = null;
         var _loc6_:String = null;
         var _loc7_:Object = null;
         var _loc8_:String = null;
         var _loc9_:* = null;
         this._isInPreFight = this.playerApi.isInPreFight();
         for each(_loc2_ in this._icons)
         {
            _loc2_.remove();
         }
         this._icons.length = 0;
         this.updatePlayerName(param1);
         this.lbl_info.height = this.lbl_info.width = 0;
         this.lbl_info.removeFromParent();
         if(this._isInPreFight)
         {
            this.lbl_info.useCustomFormat = true;
            _loc6_ = "";
            if(param1.data.breed > 0)
            {
               _loc6_ = Api.data.getBreed(param1.data.breed).shortName;
            }
            else if(param1.data.breed == BreedEnum.INCARNATION)
            {
               _loc6_ = Api.ui.getText("ui.common.incarnation");
            }
            if(_loc6_ != "")
            {
               if(param1.data.contextualId > 0 && param1.data.level > ProtocolConstantsEnum.MAX_LEVEL)
               {
                  _loc6_ = _loc6_ + (" " + this.uiApi.getText("ui.common.short.prestige") + (param1.data.level - ProtocolConstantsEnum.MAX_LEVEL));
               }
               else
               {
                  _loc6_ = _loc6_ + (" " + this.uiApi.getText("ui.common.short.level") + param1.data.level);
               }
            }
            else
            {
               _loc6_ = _loc6_ + (Api.ui.getText("ui.common.level") + " " + param1.data.level);
            }
            this.lbl_info.text = _loc6_;
            this.lbl_info.fullWidth();
            this.infosCtr.addChild(this.lbl_info);
            this.lbl_info.y = 20;
         }
         this.lbl_fightStatus.height = this.lbl_fightStatus.width = 0;
         this.lbl_fightStatus.removeFromParent();
         if(param1.makerParam && param1.makerParam.fightStatus)
         {
            _loc7_ = this.chatApi.getChatColors();
            _loc8_ = this.dataApi.getSpellState(param1.makerParam.fightStatus).name;
            _loc9_ = "<font color=\"#" + _loc7_[10].toString(16) + "\">" + _loc8_ + "</font>";
            this.lbl_fightStatus.text = "";
            this.lbl_fightStatus.appendText(_loc9_);
            this.lbl_fightStatus.fullWidth();
            this.infosCtr.addChild(this.lbl_fightStatus);
            this.lbl_fightStatus.y = 20;
         }
         this.tx_back.height = this.tx_back.width = 0;
         this.tx_back.removeFromParent();
         var _loc3_:Number = this.lbl_playerName.width;
         if(this.lbl_info.width > 0 && _loc3_ < this.lbl_info.width)
         {
            _loc3_ = this.lbl_info.width;
         }
         if(this.lbl_fightStatus.width > 0 && _loc3_ < this.lbl_fightStatus.width)
         {
            _loc3_ = this.lbl_fightStatus.width;
         }
         this.lbl_damage.removeFromParent();
         this.tx_back.width = _loc3_ + 8;
         this.tx_back.height = this.infosCtr.height + 8;
         this.infosCtr.addContent(this.tx_back,0);
         this.updateSpellDamage(param1);
         if(this.lbl_info.width > 0)
         {
            this.lbl_info.x = (this.tx_back.width - this.lbl_info.width) / 2 - 4;
         }
         if(this.lbl_fightStatus.width > 0)
         {
            this.lbl_fightStatus.x = (this.tx_back.width - this.lbl_fightStatus.width) / 2 - 4;
         }
         this.lbl_playerName.x = this.tx_back.width / 2 - this.lbl_playerName.width / 2 - 4;
         this.updateStatus(param1);
         this.tx_alignment.removeFromParent();
         this.tx_alignmentBottom.removeFromParent();
         var _loc4_:uint = param1.makerParam && param1.makerParam.cellId?uint(param1.makerParam.cellId):uint(param1.data.disposition.cellId);
         var _loc5_:Object = param1.makerParam && param1.makerParam.offsetRect?param1.makerParam.offsetRect:null;
         this.tooltipApi.place(param1.position,param1.point,param1.relativePoint,param1.offset,true,_loc4_,_loc5_);
         if(Api.system.getOption("showAlignmentWings","dofus"))
         {
            showAlignmentWings(param1);
         }
      }
      
      private function updatePlayerName(param1:Object) : void
      {
         var _loc2_:Boolean = !!this.fightApi.isMouseOverFighter(param1.data.contextualId)?true:false;
         if(!this._isInPreFight)
         {
            if(param1.data.stats.shieldPoints > 0)
            {
               this.lbl_playerName.text = "";
               this.lbl_playerName.appendText((!!_loc2_?param1.data.name + " ":"") + "(" + param1.data.stats.lifePoints + "+","p");
               this.lbl_playerName.appendText(param1.data.stats.shieldPoints,"shield");
               this.lbl_playerName.appendText(")","p");
            }
            else
            {
               this.lbl_playerName.text = !!_loc2_?param1.data.name + " ":"";
               this.lbl_playerName.text = this.lbl_playerName.text + ("(" + param1.data.stats.lifePoints + ")");
            }
         }
         else
         {
            this.lbl_playerName.text = param1.data.name;
         }
         this.lbl_playerName.fullWidth();
         if(this.lbl_playerName.width > this.lbl_damage.width)
         {
            this.tx_back.width = this.lbl_playerName.width + 8;
         }
      }
      
      private function updateStatus(param1:Object) : void
      {
         this.tx_status.visible = false;
         var _loc2_:int = Api.fight.getFighterStatus(param1.data.contextualId);
         if(_loc2_ == 20 || _loc2_ == 21)
         {
            this.tx_status.visible = true;
            if(!this._isInPreFight)
            {
               this.lbl_playerName.y = 0;
               if(!param1.makerParam || !param1.makerParam.spellDamage)
               {
                  this.lbl_playerName.x = 25;
                  this.tx_back.width = this.tx_back.width + 25;
               }
               else if(param1.makerParam.spellDamage)
               {
                  if(this.lbl_damage.width < this.lbl_playerName.width + 25)
                  {
                     this.lbl_playerName.x = 25;
                     if(this.tx_back.width < this.lbl_playerName.width + 25)
                     {
                        this.tx_back.width = this.tx_back.width + 25;
                        this.lbl_damage.x = this.lbl_damage.x + this.tx_status.width;
                     }
                     else
                     {
                        this.tx_back.width = this.tx_back.width + 8;
                     }
                  }
                  else
                  {
                     this.lbl_playerName.x = this.lbl_damage.x + this.lbl_damage.width / 2 + 25 - (this.lbl_playerName.width + 25) / 2;
                  }
               }
            }
            else if(this.lbl_playerName.width > this.lbl_info.width)
            {
               this.lbl_playerName.x = this.lbl_playerName.x + 25;
               this.tx_back.width = this.tx_back.width + 25;
               this.lbl_info.x = this.lbl_info.x + (this.tx_status.width - 4);
            }
            else
            {
               this.lbl_playerName.x = 25;
            }
            this.tx_status.y = this.lbl_playerName.y + 4;
            this.tx_status.x = this.lbl_playerName.x - 25;
         }
      }
      
      private function updateSpellDamage(param1:Object) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         this.lbl_damage.width = 1;
         if(param1.makerParam && param1.makerParam.spellDamage)
         {
            this.infosCtr.addContent(this.lbl_damage);
            this.lbl_damage.y = !param1.makerParam.fightStatus?Number(this.lbl_playerName.y + 20):Number(this.lbl_fightStatus.y + 20);
            this.lbl_damage.text = "";
            this.lbl_damage.appendText(param1.makerParam.spellDamage);
            this.lbl_damage.fullWidth();
            _loc2_ = TooltipUtil.showDamagePreviewIcons(this.lbl_damage,this.getInFightMaxLabelWidth(),param1.makerParam.spellDamage.effectIcons,this._icons,this.infosCtr);
            _loc3_ = this.getInFightMaxLabelWidth();
            this.tx_back.width = _loc3_ + 8 + _loc2_;
            this.tx_back.height = this.infosCtr.height + 8;
            this.lbl_playerName.x = _loc3_ / 2 - this.lbl_playerName.width / 2 + _loc2_;
            this.lbl_damage.x = _loc3_ / 2 - this.lbl_damage.width / 2 + _loc2_;
         }
      }
      
      private function getInFightMaxLabelWidth() : Number
      {
         var _loc1_:Number = NaN;
         if(this.lbl_playerName.text != "")
         {
            _loc1_ = this.lbl_playerName.width;
         }
         if(this.lbl_damage.text != "" && (isNaN(_loc1_) || this.lbl_damage.width > _loc1_))
         {
            _loc1_ = this.lbl_damage.width;
         }
         return _loc1_;
      }
      
      public function updateContent(param1:Object) : void
      {
         this.updatePlayerName(param1);
      }
      
      public function unload() : void
      {
      }
   }
}
