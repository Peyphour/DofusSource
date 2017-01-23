package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.EntityDisplayer;
   import com.ankamagames.berilia.components.Grid;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.ProgressBar;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.dofus.uiApi.AlignmentApi;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.PlayedCharacterApi;
   import com.ankamagames.dofus.uiApi.SoundApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofusModuleLibrary.enum.SoundTypeEnum;
   import d2actions.SetEnablePVPRequest;
   import d2enums.AggressableStatusEnum;
   import d2enums.ShortcutHookListEnum;
   import d2hooks.CharacterStatsList;
   
   public class AlignmentTab
   {
       
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      public var playerApi:PlayedCharacterApi;
      
      public var alignApi:AlignmentApi;
      
      public var dataApi:DataApi;
      
      [Module(name="Ankama_Common")]
      public var modCommon:Object;
      
      public var soundApi:SoundApi;
      
      private var _characterInfos:Object;
      
      private var _alignmentInfos:Object;
      
      private var _listRanksID:Vector.<int>;
      
      private var _pvpEnabled:Boolean = false;
      
      private var _percentBalance:uint;
      
      public var lbl_alignment:Label;
      
      public var lbl_alignmentInfo:Label;
      
      public var btn_lbl_btn_pvp:Label;
      
      public var lbl_alignmentGrade:Label;
      
      public var lbl_order:Label;
      
      public var tx_alignmentIcon:Texture;
      
      public var tx_orderIcon:Texture;
      
      public var tx_wing:Texture;
      
      public var tx_pvpOff:Texture;
      
      public var tx_neutralAlignment:Texture;
      
      public var tx_progressBar1:ProgressBar;
      
      public var btn_pvp:ButtonContainer;
      
      public var btn_close:ButtonContainer;
      
      public var entityDisplayer:EntityDisplayer;
      
      public var gd_specializations:Grid;
      
      public function AlignmentTab()
      {
         this._listRanksID = new Vector.<int>(6,true);
         super();
      }
      
      public function main(param1:Object = null) : void
      {
         var _loc6_:Object = null;
         var _loc7_:int = 0;
         var _loc8_:Object = null;
         var _loc9_:int = 0;
         this.soundApi.playSound(SoundTypeEnum.OPEN_WINDOW);
         this.sysApi.addHook(CharacterStatsList,this.onCharacterStatsList);
         this.uiApi.addComponentHook(this.tx_progressBar1,"onRollOver");
         this.uiApi.addComponentHook(this.tx_progressBar1,"onRollOut");
         this.uiApi.addComponentHook(this.btn_pvp,"onRollOver");
         this.uiApi.addComponentHook(this.btn_pvp,"onRollOut");
         this.uiApi.addComponentHook(this.entityDisplayer,"onEntityReady");
         this.uiApi.addShortcutHook(ShortcutHookListEnum.CLOSE_UI,this.onShortCut);
         this._characterInfos = this.playerApi.getPlayedCharacterInfo();
         this.entityDisplayer.look = this._characterInfos.entityLook;
         this._alignmentInfos = this.playerApi.characteristics().alignmentInfos;
         var _loc2_:int = this._alignmentInfos.alignmentSide;
         this.displayPvpInformations();
         var _loc3_:Object = this.alignApi.getSide(_loc2_);
         this.lbl_alignment.text = this.uiApi.getText("ui.common.alignment") + " " + _loc3_.name;
         var _loc4_:int = this.alignApi.getPlayerRank();
         var _loc5_:Object = this.alignApi.getRank(_loc4_);
         this.lbl_alignmentInfo.text = _loc5_.name + " - " + this.uiApi.getText("ui.common.level") + " " + this._alignmentInfos.alignmentValue;
         this.lbl_order.text = this.alignApi.getOrder(_loc5_.orderId).name;
         if(_loc2_ == 0)
         {
            this.tx_neutralAlignment.visible = true;
            this.tx_alignmentIcon.uri = this.uiApi.createUri(this.uiApi.me().getConstant("alignment_uri") + "Alignement_tx_IllusNeutre.png");
         }
         else
         {
            this.tx_neutralAlignment.visible = false;
            if(_loc2_ == 1)
            {
               this.tx_alignmentIcon.uri = this.uiApi.createUri(this.uiApi.me().getConstant("alignment_uri") + "Alignement_tx_IllusBontarien.png");
            }
            else if(_loc2_ == 2)
            {
               this.tx_alignmentIcon.uri = this.uiApi.createUri(this.uiApi.me().getConstant("alignment_uri") + "Alignement_tx_IllusBrakmarien.png");
            }
            else if(_loc2_ == 3)
            {
               this.tx_alignmentIcon.uri = this.uiApi.createUri(this.uiApi.me().getConstant("alignment_uri") + "Alignement_tx_IllusMercenaire.png");
            }
         }
         if((_loc2_ == 1 || _loc2_ == 2 || _loc2_ == 3) && _loc5_)
         {
            this.tx_orderIcon.uri = this.uiApi.createUri(this.uiApi.me().getConstant("alignment_uri") + "order_" + _loc5_.orderId + ".png");
         }
         else if(_loc2_ == 0)
         {
            this.tx_orderIcon.uri = this.uiApi.createUri(this.uiApi.me().getConstant("alignment_uri") + "order_" + _loc2_ + ".png");
         }
         if(_loc2_ != 0)
         {
            this.btn_pvp.visible = true;
            _loc6_ = this.alignApi.getOrderRanks(_loc5_.orderId);
            this.gd_specializations.dataProvider = _loc6_;
            if(this._alignmentInfos.alignmentSide == 3 || _loc5_.minimumAlignment < 20)
            {
               this.gd_specializations.selectedIndex = Math.floor(_loc5_.minimumAlignment / 20);
            }
            else
            {
               this.gd_specializations.selectedIndex = Math.floor(_loc5_.minimumAlignment / 20) - 1;
            }
            _loc7_ = 0;
            for each(_loc8_ in _loc6_)
            {
               this._listRanksID[_loc7_] = _loc8_.id;
               _loc7_++;
            }
            _loc9_ = _loc7_;
            while(_loc9_ < 6)
            {
               this._listRanksID[_loc7_] = -1;
               _loc7_++;
               _loc9_++;
            }
            if(this.sysApi.getCurrentServer().gameTypeId == 1)
            {
               this.btn_pvp.softDisabled = true;
            }
            else
            {
               this.btn_pvp.softDisabled = false;
            }
         }
         else
         {
            this.btn_pvp.visible = false;
         }
      }
      
      public function updateAliBonusLine(param1:*, param2:*, param3:Boolean) : void
      {
         if(param1)
         {
            param2.lbl_name.text = param1.name;
            param2.lbl_valueP.text = param1.valueP;
            param2.lbl_valueM.text = param1.valueM;
         }
         else
         {
            param2.lbl_title.text = "";
            param2.lbl_valueP.text = "";
            param2.lbl_valueM.text = "";
         }
      }
      
      public function updateSpecLine(param1:*, param2:*, param3:Boolean) : void
      {
         if(param1)
         {
            param2.specItemCtr.selected = param3;
            param2.lbl_name.text = param1.name;
            param2.lbl_level.text = param1.minimumAlignment;
            if(this._alignmentInfos.alignmentValue - param1.minimumAlignment >= 0 && this._alignmentInfos.alignmentValue - param1.minimumAlignment < 20)
            {
               param2.tx_whiteArrow.visible = true;
            }
            else
            {
               param2.tx_whiteArrow.visible = false;
            }
         }
         else
         {
            param2.lbl_name.text = "";
            param2.lbl_level.text = "";
            param2.tx_whiteArrow.visible = false;
         }
      }
      
      private function displayPvpInformations() : void
      {
         if(this._alignmentInfos.aggressable == AggressableStatusEnum.PvP_ENABLED_AGGRESSABLE || this._alignmentInfos.aggressable == AggressableStatusEnum.PvP_ENABLED_NON_AGGRESSABLE)
         {
            this._pvpEnabled = true;
            this.btn_lbl_btn_pvp.text = this.uiApi.getText("ui.pvp.disabled");
            this.tx_pvpOff.visible = false;
            this.tx_wing.uri = this.uiApi.createUri(this.uiApi.me().getConstant("alignment_uri") + "wings.swf|demonAngel");
            this.tx_wing.gotoAndStop = (this._alignmentInfos.alignmentSide - 1) * 10 + 1 + this._alignmentInfos.alignmentGrade;
            this.lbl_alignmentGrade.text = this._alignmentInfos.alignmentGrade + " (" + this.alignApi.getTitleName(this._alignmentInfos.alignmentSide,this._alignmentInfos.alignmentGrade) + ")";
            this.tx_progressBar1.value = this._alignmentInfos.honor / 20000;
         }
         else
         {
            this._pvpEnabled = false;
            this.btn_lbl_btn_pvp.text = this.uiApi.getText("ui.pvp.enabled");
            this.tx_pvpOff.visible = true;
            this.tx_wing.uri = null;
            this.lbl_alignmentGrade.text = "-";
            this.tx_progressBar1.width = 0;
         }
      }
      
      private function onCharacterStatsList(param1:Boolean = false) : void
      {
         if(!param1)
         {
            this._alignmentInfos = this.playerApi.characteristics().alignmentInfos;
            if(this._alignmentInfos.aggressable == AggressableStatusEnum.PvP_ENABLED_AGGRESSABLE || this._alignmentInfos.aggressable == AggressableStatusEnum.PvP_ENABLED_NON_AGGRESSABLE)
            {
               if(!this._pvpEnabled)
               {
                  this.displayPvpInformations();
               }
            }
            else if(this._pvpEnabled)
            {
               this.displayPvpInformations();
            }
         }
      }
      
      private function onShortCut(param1:String) : Boolean
      {
         if(param1 == ShortcutHookListEnum.CLOSE_UI)
         {
            this.uiApi.unloadUi(this.uiApi.me().name);
            return true;
         }
         return false;
      }
      
      public function onRelease(param1:Object) : void
      {
         if(param1 == this.btn_pvp)
         {
            this.sysApi.sendAction(new SetEnablePVPRequest(!this._pvpEnabled));
         }
         else if(param1 == this.btn_close)
         {
            this.uiApi.unloadUi(this.uiApi.me().name);
         }
      }
      
      public function onRollOver(param1:Object) : void
      {
         var _loc2_:String = null;
         if(param1 == this.tx_progressBar1)
         {
            _loc2_ = String(this._alignmentInfos.honor);
         }
         else if(param1 == this.btn_pvp && this.btn_pvp.softDisabled)
         {
            _loc2_ = this.uiApi.getText("ui.grimoire.alignment.hardcore");
         }
         if(_loc2_)
         {
            this.uiApi.showTooltip(this.uiApi.textTooltipInfo(_loc2_),param1,false,"standard",7,1,0,null,null,null,"TextInfo");
         }
      }
      
      public function onRollOut(param1:Object) : void
      {
         this.uiApi.hideTooltip();
      }
      
      public function onEntityReady(param1:Object) : void
      {
         var _loc2_:* = this.entityDisplayer.getSlotPosition("Cape_2");
         if(_loc2_)
         {
            this.tx_wing.x = this.entityDisplayer.x + _loc2_.x;
            this.tx_wing.y = this.entityDisplayer.y + this.entityDisplayer.height + _loc2_.y;
         }
         else
         {
            this.tx_wing.x = this.entityDisplayer.x + this.entityDisplayer.width / 2;
         }
      }
      
      public function unload() : void
      {
      }
   }
}
