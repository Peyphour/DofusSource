package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.EntityDisplayer;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.internalDatacenter.fight.FighterInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightCharacterInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightCompanionInformations;
   import com.ankamagames.dofus.uiApi.FightApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import d2enums.ProtocolConstantsEnum;
   import d2hooks.FightEvent;
   import d2hooks.FighterInfoUpdate;
   import d2hooks.FontActiveTypeChanged;
   import d2hooks.GameFightEnd;
   import d2hooks.GameFightJoin;
   import d2hooks.SpectateUpdate;
   import d2hooks.SpectatorWantLeave;
   import flash.utils.Dictionary;
   
   public class FighterInfo
   {
       
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      public var fightApi:FightApi;
      
      public var mainCtr:GraphicContainer;
      
      public var ctr_entity:GraphicContainer;
      
      public var btn_spectatorPanel:ButtonContainer;
      
      public var entityDisplayer:EntityDisplayer;
      
      public var lbl_name:Label;
      
      public var lbl_lifePoints:Label;
      
      public var lbl_shieldPoints:Label;
      
      public var lbl_actionPoints:Label;
      
      public var lbl_movementPoints:Label;
      
      public var lbl_action:Label;
      
      public var lbl_movement:Label;
      
      public var lbl_tackle:Label;
      
      public var lbl_criticalDmgReduction:Label;
      
      public var lbl_pushDmgReduction:Label;
      
      public var lbl_neutralPercent:Label;
      
      public var lbl_strengthPercent:Label;
      
      public var lbl_intelligencePercent:Label;
      
      public var lbl_chancePercent:Label;
      
      public var lbl_agilityPercent:Label;
      
      public var lbl_neutral:Label;
      
      public var lbl_strength:Label;
      
      public var lbl_intelligence:Label;
      
      public var lbl_chance:Label;
      
      public var lbl_agility:Label;
      
      private var _fighterId:Number;
      
      private var _lastFighterId:Number;
      
      private var _stats:Dictionary;
      
      public function FighterInfo()
      {
         this._stats = new Dictionary();
         super();
      }
      
      public function main(param1:Object) : void
      {
         this.sysApi.addHook(FighterInfoUpdate,this.onFighterInfoUpdate);
         this.sysApi.addHook(FightEvent,this.onFightEvent);
         this.sysApi.addHook(SpectateUpdate,this.onSpectateUpdate);
         this.sysApi.addHook(GameFightJoin,this.onGameFightJoin);
         this.sysApi.addHook(GameFightEnd,this.onGameFightEnd);
         this.sysApi.addHook(SpectatorWantLeave,this.onSpectatorWantLeave);
         this.sysApi.addHook(FontActiveTypeChanged,this.onFontActiveTypeChanged);
         this.mainCtr.visible = false;
         this.entityDisplayer.useFade = false;
         this.forceLabelUpdate();
      }
      
      public function unload() : void
      {
         var _loc1_:Object = this.uiApi.getUi("bannerMenu").uiClass;
         _loc1_.gd_btnUis.mouseChildren = true;
      }
      
      private function forceLabelUpdate() : void
      {
         var _loc1_:String = null;
         var _loc2_:int = 0;
         if(this.sysApi.getActiveFontType() == "smallScreen" && this.lbl_lifePoints.aStyleObj && this.lbl_lifePoints.aStyleObj[this.lbl_lifePoints.cssClass])
         {
            _loc1_ = this.lbl_lifePoints.aStyleObj[this.lbl_lifePoints.cssClass].letterSpacing;
            _loc2_ = parseInt(_loc1_.substring(0,_loc1_.indexOf("px")));
            this.lbl_lifePoints.updateTextFormatProperty("letterSpacing",_loc2_);
         }
      }
      
      private function showEntityDisplayer() : void
      {
         this.entityDisplayer.look = this.fightApi.getFighterInformations(this._fighterId).look;
         this.entityDisplayer.setAnimationAndDirection("AnimStatique",1);
         this.entityDisplayer.visible = true;
      }
      
      public function onRelease(param1:Object) : void
      {
         if(param1 == this.btn_spectatorPanel)
         {
            if(!this.uiApi.getUi("spectatorPanel"))
            {
               this.sysApi.dispatchHook(SpectateUpdate,0,"","");
               this.btn_spectatorPanel.selected = true;
            }
            else
            {
               this.uiApi.unloadUi("spectatorPanel");
               this.btn_spectatorPanel.selected = false;
            }
         }
      }
      
      public function onFontActiveTypeChanged() : void
      {
         this.forceLabelUpdate();
      }
      
      public function onFighterInfoUpdate(param1:Object = null) : void
      {
         var _loc3_:* = null;
         var _loc4_:int = 0;
         var _loc2_:Object = this.uiApi.getUi("bannerMenu").uiClass;
         if(param1 && !this.fightApi.preFightIsActive())
         {
            _loc2_.gd_btnUis.mouseChildren = false;
            if(this.fightApi.isSpectator() && this.sysApi.getOption("spectatorAutoShowCurrentFighterInfo","dofus"))
            {
               this.btn_spectatorPanel.visible = false;
            }
            this.entityDisplayer.disabled = param1.stats.lifePoints <= 0;
            _loc3_ = this.fightApi.getFighterName(param1.contextualId) + "  ";
            _loc4_ = this.fightApi.getFighterLevel(param1.contextualId);
            if(param1.contextualId > 0 && _loc4_ > ProtocolConstantsEnum.MAX_LEVEL)
            {
               _loc3_ = _loc3_ + (this.uiApi.getText("ui.common.short.prestige") + (_loc4_ - ProtocolConstantsEnum.MAX_LEVEL));
            }
            else
            {
               _loc3_ = _loc3_ + (this.uiApi.getText("ui.common.short.level") + _loc4_);
            }
            this.lbl_name.text = _loc3_;
            this._lastFighterId = this._fighterId;
            this._fighterId = param1.contextualId;
            if(this._stats["lifePoints"] != param1.stats.lifePoints || this._stats["maxLifePoints"] != param1.stats.maxLifePoints)
            {
               this._stats["lifePoints"] = param1.stats.lifePoints;
               this._stats["maxLifePoints"] = param1.stats.maxLifePoints;
               this.updateLifePoints();
            }
            if(this._stats["shieldPoints"] != param1.stats.shieldPoints)
            {
               this._stats["shieldPoints"] = param1.stats.shieldPoints;
               this.updateShieldPoints();
            }
            if(this._stats["fighterUsedAP"] != param1.stats.actionPoints)
            {
               this._stats["fighterUsedAP"] = param1.stats.actionPoints;
               this.lbl_actionPoints.text = this._stats["fighterUsedAP"];
            }
            if(this._stats["movementPoints"] != param1.stats.movementPoints)
            {
               this._stats["movementPoints"] = param1.stats.movementPoints;
               this.lbl_movementPoints.text = this._stats["movementPoints"];
            }
            if(this._stats["dodgePALostProbability"] != param1.stats.dodgePALostProbability)
            {
               this._stats["dodgePALostProbability"] = param1.stats.dodgePALostProbability;
               this.lbl_action.text = param1.stats.dodgePALostProbability;
            }
            if(this._stats["dodgePMLostProbability"] != param1.stats.dodgePMLostProbability)
            {
               this._stats["dodgePMLostProbability"] = param1.stats.dodgePMLostProbability;
               this.lbl_movement.text = this._stats["dodgePMLostProbability"];
            }
            if(this._stats["tackleBlock"] != param1.stats.tackleBlock)
            {
               this._stats["tackleBlock"] = param1.stats.tackleBlock;
               this.lbl_tackle.text = this._stats["tackleBlock"] > 0?this._stats["tackleBlock"].toString():"0";
            }
            if(this._stats["criticalDamageReduction"] != param1.stats.criticalDamageFixedResist)
            {
               this._stats["criticalDamageReduction"] = param1.stats.criticalDamageFixedResist;
               this.lbl_criticalDmgReduction.text = this._stats["criticalDamageReduction"];
            }
            if(this._stats["pushDamageReduction"] != param1.stats.pushDamageFixedResist)
            {
               this._stats["pushDamageReduction"] = param1.stats.pushDamageFixedResist;
               this.lbl_pushDmgReduction.text = this._stats["pushDamageReduction"];
            }
            if(param1 is GameFightCharacterInformations || param1 is GameFightCompanionInformations)
            {
               this._stats["neutralPercent"] = param1.stats.neutralElementResistPercent > 50?50:param1.stats.neutralElementResistPercent;
               this._stats["strengthPercent"] = param1.stats.earthElementResistPercent > 50?50:param1.stats.earthElementResistPercent;
               this._stats["intelligencePercent"] = param1.stats.fireElementResistPercent > 50?50:param1.stats.fireElementResistPercent;
               this._stats["chancePercent"] = param1.stats.waterElementResistPercent > 50?50:param1.stats.waterElementResistPercent;
               this._stats["agilityPercent"] = param1.stats.airElementResistPercent > 50?50:param1.stats.airElementResistPercent;
               this._stats["neutral"] = param1.stats.neutralElementReduction;
               this._stats["strength"] = param1.stats.earthElementReduction;
               this._stats["intelligence"] = param1.stats.fireElementReduction;
               this._stats["chance"] = param1.stats.waterElementReduction;
               this._stats["agility"] = param1.stats.airElementReduction;
            }
            else
            {
               this._stats["neutralPercent"] = param1.stats.neutralElementResistPercent;
               this._stats["strengthPercent"] = param1.stats.earthElementResistPercent;
               this._stats["intelligencePercent"] = param1.stats.fireElementResistPercent;
               this._stats["chancePercent"] = param1.stats.waterElementResistPercent;
               this._stats["agilityPercent"] = param1.stats.airElementResistPercent;
               this._stats["neutral"] = param1.stats.neutralElementReduction;
               this._stats["strength"] = param1.stats.earthElementReduction;
               this._stats["intelligence"] = param1.stats.fireElementReduction;
               this._stats["chance"] = param1.stats.waterElementReduction;
               this._stats["agility"] = param1.stats.airElementReduction;
            }
            this.updateResistance();
            this.mainCtr.visible = true;
            if(this.entityDisplayer.look != this.fightApi.getFighterInformations(this._fighterId).look)
            {
               this.showEntityDisplayer();
            }
         }
         else
         {
            _loc2_.gd_btnUis.mouseChildren = true;
            this.mainCtr.visible = false;
         }
      }
      
      private function updateLifePoints() : void
      {
         this.lbl_lifePoints.text = this._stats["lifePoints"] + " / " + this._stats["maxLifePoints"];
      }
      
      private function updateShieldPoints() : void
      {
         this.lbl_shieldPoints.text = this._stats["shieldPoints"];
      }
      
      private function updateResistance() : void
      {
         this.lbl_neutralPercent.text = this._stats["neutralPercent"] + "%";
         this.lbl_strengthPercent.text = this._stats["strengthPercent"] + "%";
         this.lbl_intelligencePercent.text = this._stats["intelligencePercent"] + "%";
         this.lbl_chancePercent.text = this._stats["chancePercent"] + "%";
         this.lbl_agilityPercent.text = this._stats["agilityPercent"] + "%";
         this.lbl_neutral.text = this._stats["neutral"];
         this.lbl_strength.text = this._stats["strength"];
         this.lbl_intelligence.text = this._stats["intelligence"];
         this.lbl_chance.text = this._stats["chance"];
         this.lbl_agility.text = this._stats["agility"];
      }
      
      private function onFightEvent(param1:String, param2:Object, param3:Object = null) : void
      {
         var _loc6_:Number = NaN;
         var _loc7_:FighterInformations = null;
         if(!this._fighterId)
         {
            return;
         }
         if(param3 == null)
         {
            param3 = new Array();
            if(param2.length)
            {
               param3[0] = param2[0];
            }
         }
         var _loc4_:int = param3.length;
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc6_ = param3[_loc5_];
            if(this._fighterId != _loc6_)
            {
               _loc5_++;
               continue;
            }
            switch(param1)
            {
               case "fighterUsedMP":
               case "fighterLostMP":
                  this._stats["movementPoints"] = this._stats["movementPoints"] - param2[1];
                  this.lbl_movementPoints.text = this._stats["movementPoints"];
                  break;
               case "fighterGainedMP":
                  this._stats["movementPoints"] = this._stats["movementPoints"] + param2[1];
                  this.lbl_movementPoints.text = this._stats["movementPoints"];
                  break;
               case "fighterUsedAP":
               case "fighterLostAP":
                  this._stats["fighterUsedAP"] = this._stats["fighterUsedAP"] - param2[1];
                  this.lbl_actionPoints.text = this._stats["fighterUsedAP"];
                  break;
               case "fighterGainedAP":
                  this._stats["fighterUsedAP"] = this._stats["fighterUsedAP"] + param2[1];
                  this.lbl_actionPoints.text = this._stats["fighterUsedAP"];
                  break;
               case "fighterLifeGain":
                  this._stats["lifePoints"] = this._stats["lifePoints"] + param2[1];
                  this.updateLifePoints();
                  break;
               case "fighterLifeLoss":
                  this._stats["lifePoints"] = this._stats["lifePoints"] - param2[1];
                  this.updateLifePoints();
                  break;
               case "fighterShieldLoss":
                  this._stats["shieldPoints"] = this._stats["shieldPoints"] - param2[1];
                  this.updateShieldPoints();
                  break;
               case "fighterShieldGain":
                  this._stats["shieldPoints"] = this._stats["shieldPoints"] + param2[1];
                  this.updateShieldPoints();
                  break;
               case "fighterGotDispelled":
               case "fighterTemporaryBoosted":
                  _loc7_ = this.fightApi.getFighterInformations(_loc6_);
                  this._stats["shieldPoints"] = _loc7_.shieldPoints;
                  this._stats["lifePoints"] = _loc7_.lifePoints;
                  this.updateLifePoints();
                  this.updateShieldPoints();
                  if(this._stats["movementPoints"] != _loc7_.movementPoints)
                  {
                     this._stats["movementPoints"] = _loc7_.movementPoints;
                     this.lbl_movementPoints.text = this._stats["movementPoints"];
                  }
                  if(this._stats["fighterUsedAP"] != _loc7_.actionPoints)
                  {
                     this._stats["fighterUsedAP"] = _loc7_.actionPoints;
                     this.lbl_actionPoints.text = this._stats["fighterUsedAP"];
                  }
                  this._stats["neutral"] = _loc7_.neutralFixedResist;
                  this._stats["strength"] = _loc7_.earthFixedResist;
                  this._stats["intelligence"] = _loc7_.fireFixedResist;
                  this._stats["chance"] = _loc7_.waterFixedResist;
                  this._stats["agility"] = _loc7_.airFixedResist;
                  this._stats["neutralPercent"] = _loc7_.neutralResist > 50?50:_loc7_.neutralResist;
                  this._stats["strengthPercent"] = _loc7_.earthResist > 50?50:_loc7_.earthResist;
                  this._stats["intelligencePercent"] = _loc7_.fireResist > 50?50:_loc7_.fireResist;
                  this._stats["chancePercent"] = _loc7_.waterResist > 50?50:_loc7_.waterResist;
                  this._stats["agilityPercent"] = _loc7_.airResist > 50?50:_loc7_.airResist;
                  this.updateResistance();
                  break;
               case "fighterGotTackled":
                  this._stats["fighterUsedAP"] = this._stats["fighterUsedAP"] - param2[1];
                  this._stats["movementPoints"] = this._stats["movementPoints"] - param2[2];
                  this.lbl_actionPoints.text = this._stats["fighterUsedAP"];
                  this.lbl_movementPoints.text = this._stats["movementPoints"];
                  break;
               case "fighterDeath":
               case "fighterLeave":
                  this._stats["lifePoints"] = 0;
                  this.updateLifePoints();
            }
            return;
         }
      }
      
      public function onGameFightJoin(param1:Boolean, param2:Boolean, param3:Boolean, param4:int, param5:int, param6:Boolean) : void
      {
      }
      
      private function onSpectateUpdate(param1:Number, param2:String = "", param3:String = "") : void
      {
         this.btn_spectatorPanel.selected = true;
      }
      
      private function onGameFightEnd(param1:Object) : void
      {
         this.btn_spectatorPanel.visible = false;
      }
      
      private function onSpectatorWantLeave() : void
      {
         this.btn_spectatorPanel.visible = false;
      }
   }
}
