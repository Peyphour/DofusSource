package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.EntityDisplayer;
   import com.ankamagames.berilia.components.Grid;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.dofus.internalDatacenter.guild.GuildWrapper;
   import com.ankamagames.dofus.internalDatacenter.spells.SpellWrapper;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.SocialApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import d2actions.GuildCharacsUpgradeRequest;
   import d2actions.GuildGetInformations;
   import d2actions.GuildSpellUpgradeRequest;
   import d2enums.ComponentHookList;
   import d2enums.GuildInformationsTypeEnum;
   import d2hooks.GuildInfosUpgrade;
   import flash.utils.Dictionary;
   
   public class GuildPersonalization
   {
       
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      public var dataApi:DataApi;
      
      public var socialApi:SocialApi;
      
      private var _allowModifyBoosts:Boolean;
      
      private var _stats:Array;
      
      private var _compsBtnSpellUpgrade:Dictionary;
      
      private var _compsSpellSlot:Dictionary;
      
      public var gd_spell:Grid;
      
      public var btn_taxCollectorProspecting:ButtonContainer;
      
      public var btn_taxCollectorWisdom:ButtonContainer;
      
      public var btn_taxCollectorPods:ButtonContainer;
      
      public var btn_maxTaxCollectorsCount:ButtonContainer;
      
      public var lbl_boostPoints:Label;
      
      public var gd_stat:Grid;
      
      public var ed_pony:EntityDisplayer;
      
      public function GuildPersonalization()
      {
         this._compsBtnSpellUpgrade = new Dictionary(true);
         this._compsSpellSlot = new Dictionary(true);
         super();
      }
      
      public function main(... rest) : void
      {
         this.sysApi.addHook(GuildInfosUpgrade,this.onGuildInfosUpgrade);
         this.uiApi.addComponentHook(this.btn_taxCollectorProspecting,"onRelease");
         this.uiApi.addComponentHook(this.btn_taxCollectorProspecting,"onRollOver");
         this.uiApi.addComponentHook(this.btn_taxCollectorProspecting,"onRollOut");
         this.uiApi.addComponentHook(this.btn_taxCollectorWisdom,"onRelease");
         this.uiApi.addComponentHook(this.btn_taxCollectorWisdom,"onRollOver");
         this.uiApi.addComponentHook(this.btn_taxCollectorWisdom,"onRollOut");
         this.uiApi.addComponentHook(this.btn_taxCollectorPods,"onRelease");
         this.uiApi.addComponentHook(this.btn_taxCollectorPods,"onRollOver");
         this.uiApi.addComponentHook(this.btn_taxCollectorPods,"onRollOut");
         this.uiApi.addComponentHook(this.btn_maxTaxCollectorsCount,"onRelease");
         this.uiApi.addComponentHook(this.btn_maxTaxCollectorsCount,"onRollOver");
         this.uiApi.addComponentHook(this.btn_maxTaxCollectorsCount,"onRollOut");
         this.sysApi.sendAction(new GuildGetInformations(GuildInformationsTypeEnum.INFO_BOOSTS));
         var _loc2_:GuildWrapper = this.socialApi.getGuild();
         this._allowModifyBoosts = _loc2_.manageGuildBoosts;
         this.displayBtnBoost(0);
         var _loc3_:String = "{714|";
         _loc3_ = _loc3_ + (this.dataApi.getEmblemSymbol(_loc2_.upEmblem.idEmblem).skinId + "|");
         _loc3_ = _loc3_ + ("7=" + _loc2_.backEmblem.color + ",8=" + _loc2_.upEmblem.color + "|110}");
         this.ed_pony.look = this.sysApi.getEntityLookFromString(_loc3_);
      }
      
      public function unload() : void
      {
      }
      
      public function updateStatLine(param1:*, param2:*, param3:Boolean) : void
      {
         if(param1)
         {
            param2.lbl_title.text = param1.text;
            param2.lbl_value.text = param1.value;
         }
         else
         {
            param2.lbl_title.text = "";
            param2.lbl_value.text = "";
         }
      }
      
      public function updateSpellLine(param1:*, param2:*, param3:Boolean) : void
      {
         var _loc4_:Object = null;
         if(!this._compsBtnSpellUpgrade[param2.btn_spellUpgrade.name])
         {
            this.uiApi.addComponentHook(param2.btn_spellUpgrade,ComponentHookList.ON_RELEASE);
            this.uiApi.addComponentHook(param2.btn_spellUpgrade,ComponentHookList.ON_ROLL_OVER);
            this.uiApi.addComponentHook(param2.btn_spellUpgrade,ComponentHookList.ON_ROLL_OUT);
         }
         this._compsBtnSpellUpgrade[param2.btn_spellUpgrade.name] = param1;
         if(!this._compsSpellSlot[param2.slot_icon.name])
         {
            this.uiApi.addComponentHook(param2.slot_icon,ComponentHookList.ON_ROLL_OVER);
            this.uiApi.addComponentHook(param2.slot_icon,ComponentHookList.ON_ROLL_OUT);
         }
         this._compsSpellSlot[param2.slot_icon.name] = param1;
         if(param1 != null)
         {
            _loc4_ = this.dataApi.getSpell(param1.spell.id);
            param2.slot_icon.data = param1.spell;
            param2.lbl_spellName.text = _loc4_.name;
            param2.lbl_spellLevel.text = param1.baseLevel;
            if(param1.displayUpgrade)
            {
               param2.btn_spellUpgrade.visible = true;
            }
            else
            {
               param2.btn_spellUpgrade.visible = false;
            }
         }
         else
         {
            param2.slot_icon = null;
            param2.lbl_spellName.text = "";
            param2.lbl_spellLevel.text = "";
            param2.btn_spellUpgrade.visible = false;
         }
      }
      
      private function displayBtnBoost(param1:int) : void
      {
         this.btn_taxCollectorProspecting.visible = param1 > 0 && this._allowModifyBoosts;
         this.btn_taxCollectorWisdom.visible = param1 > 0 && this._allowModifyBoosts;
         this.btn_taxCollectorPods.visible = param1 > 0 && this._allowModifyBoosts;
         this.btn_maxTaxCollectorsCount.visible = param1 > 9 && this._allowModifyBoosts;
      }
      
      private function onGuildInfosUpgrade(param1:uint, param2:uint, param3:Object, param4:Object, param5:uint, param6:uint, param7:uint, param8:uint, param9:uint, param10:uint) : void
      {
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         var _loc16_:Boolean = false;
         var _loc11_:int = param3.length;
         var _loc12_:Array = new Array(_loc11_);
         var _loc13_:int = 0;
         while(_loc13_ < _loc11_)
         {
            _loc14_ = param4[_loc13_];
            _loc15_ = _loc14_;
            _loc16_ = param1 > 0 && this._allowModifyBoosts;
            if(_loc15_ == 0)
            {
               _loc15_ = 1;
            }
            if(_loc15_ == 5)
            {
               _loc16_ = false;
            }
            _loc12_[_loc13_] = {
               "displayUpgrade":_loc16_,
               "spell":this.dataApi.getSpellWrapper(param3[_loc13_],_loc15_),
               "baseLevel":_loc14_
            };
            _loc13_++;
         }
         this.gd_spell.dataProvider = _loc12_;
         this.lbl_boostPoints.text = param1.toString();
         this._stats = new Array();
         this._stats.push({
            "text":this.uiApi.getText("ui.common.lifePoints"),
            "value":param6
         });
         this._stats.push({
            "text":this.uiApi.getText("ui.social.damagesBonus"),
            "value":param5
         });
         this._stats.push({
            "text":this.uiApi.getText("ui.social.discernment"),
            "value":param8
         });
         this._stats.push({
            "text":this.uiApi.getText("ui.stats.wisdom"),
            "value":param10
         });
         this._stats.push({
            "text":this.uiApi.getText("ui.common.weight"),
            "value":param7
         });
         this._stats.push({
            "text":this.uiApi.getText("ui.social.taxCollectorCount"),
            "value":param2
         });
         this.gd_stat.dataProvider = this._stats;
         this.displayBtnBoost(param1);
      }
      
      public function onRelease(param1:Object) : void
      {
         var _loc2_:Object = null;
         if(param1 == this.btn_taxCollectorPods)
         {
            this.sysApi.sendAction(new GuildCharacsUpgradeRequest(0));
         }
         else if(param1 == this.btn_taxCollectorProspecting)
         {
            this.sysApi.sendAction(new GuildCharacsUpgradeRequest(1));
         }
         else if(param1 == this.btn_taxCollectorWisdom)
         {
            this.sysApi.sendAction(new GuildCharacsUpgradeRequest(2));
         }
         else if(param1 == this.btn_maxTaxCollectorsCount)
         {
            this.sysApi.sendAction(new GuildCharacsUpgradeRequest(3));
         }
         else if(param1.name.indexOf("btn_spellUpgrade") != -1)
         {
            _loc2_ = this._compsBtnSpellUpgrade[param1.name];
            this.sysApi.sendAction(new GuildSpellUpgradeRequest(_loc2_.spell.id));
         }
      }
      
      public function onRollOver(param1:Object) : void
      {
         var _loc3_:Object = null;
         var _loc2_:* = "";
         if(param1 == this.btn_taxCollectorProspecting)
         {
            _loc2_ = this.uiApi.getText("ui.social.poneyCost",1,1,500);
         }
         else if(param1 == this.btn_taxCollectorWisdom)
         {
            _loc2_ = this.uiApi.getText("ui.social.poneyCost",1,1,400);
         }
         else if(param1 == this.btn_taxCollectorPods)
         {
            _loc2_ = this.uiApi.getText("ui.social.poneyCost",1,20,5000);
         }
         else if(param1 == this.btn_maxTaxCollectorsCount)
         {
            _loc2_ = this.uiApi.getText("ui.social.poneyCost",10,1,50);
         }
         else if(param1.name.indexOf("btn_spellUpgrade") != -1)
         {
            _loc2_ = this.uiApi.getText("ui.common.cost") + this.uiApi.getText("ui.common.colon") + "5";
         }
         else if(param1.name.indexOf("slot_icon") != -1)
         {
            _loc3_ = this._compsSpellSlot[param1.name];
            if(param1 != null && _loc3_ != null)
            {
               this.uiApi.showTooltip(_loc3_.spell as SpellWrapper,param1,false,"standard",2,0,0);
            }
         }
         if(_loc2_ != "")
         {
            this.uiApi.showTooltip(this.uiApi.textTooltipInfo(_loc2_),param1,false,"standard",6,0,3,null,null,null,"TextInfo");
         }
      }
      
      public function onRollOut(param1:Object) : void
      {
         this.uiApi.hideTooltip();
      }
   }
}
