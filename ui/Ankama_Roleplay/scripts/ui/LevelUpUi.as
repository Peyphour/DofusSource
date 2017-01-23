package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.EntityDisplayer;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.Slot;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.components.TextureBitmap;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.modules.utils.ItemTooltipSettings;
   import com.ankamagames.dofus.uiApi.PlayedCharacterApi;
   import com.ankamagames.dofus.uiApi.SoundApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofus.uiApi.TimeApi;
   import d2enums.DataStoreEnum;
   import d2enums.ProtocolConstantsEnum;
   
   public class LevelUpUi
   {
       
      
      public var sysApi:SystemApi;
      
      public var timeApi:TimeApi;
      
      public var uiApi:UiApi;
      
      public var playerApi:PlayedCharacterApi;
      
      public var soundApi:SoundApi;
      
      public var spellSlot:Slot;
      
      public var levelupWindow:GraphicContainer;
      
      public var ctr_stats:GraphicContainer;
      
      public var ctr_spell:GraphicContainer;
      
      public var ctr_button:GraphicContainer;
      
      public var btn_close_main:ButtonContainer;
      
      public var lbl_lifeStatPoints:Label;
      
      public var lbl_spellStatPoints:Label;
      
      public var lbl_caracStatPoints:Label;
      
      public var lbl_lifeStat:Label;
      
      public var lbl_spellStat:Label;
      
      public var lbl_caracStat:Label;
      
      public var lbl_spell:Label;
      
      public var lbl_newLevel:Label;
      
      public var lbl_levelup:Label;
      
      public var tx_spellSlotEffect:Texture;
      
      public var tx_banner:TextureBitmap;
      
      public var ed_player:EntityDisplayer;
      
      private var _assetsUri:Object;
      
      public function LevelUpUi()
      {
         super();
      }
      
      public function main(param1:Object) : void
      {
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:Number = NaN;
         if(this.lbl_levelup.textWidth > 160)
         {
            _loc6_ = this.lbl_levelup.textWidth - 160;
            this.tx_banner.width = this.tx_banner.width + _loc6_;
         }
         this.uiApi.addComponentHook(this.spellSlot,"onRollOver");
         this.uiApi.addComponentHook(this.spellSlot,"onRollOut");
         this.uiApi.addComponentHook(this.lbl_lifeStat,"onRollOut");
         this.uiApi.addComponentHook(this.lbl_lifeStat,"onRollOver");
         this.uiApi.addComponentHook(this.lbl_spellStat,"onRollOut");
         this.uiApi.addComponentHook(this.lbl_spellStat,"onRollOver");
         this.uiApi.addComponentHook(this.lbl_caracStat,"onRollOut");
         this.uiApi.addComponentHook(this.lbl_caracStat,"onRollOver");
         this.uiApi.addShortcutHook("validUi",this.onShortcut);
         this.uiApi.addShortcutHook("closeUi",this.onShortcut);
         this._assetsUri = this.uiApi.me().getConstant("assets");
         var _loc2_:Object = this.playerApi.getPlayedCharacterInfo();
         var _loc3_:Object = _loc2_.entityLook;
         _loc3_.setBone(1);
         this.ed_player.animation = "AnimEmoteInterface_" + (!!_loc2_.sex?"1":"0");
         this.ed_player.look = _loc3_;
         this.spellSlot.allowDrag = false;
         this.spellSlot.data = param1.newSpell;
         if(param1.newLevel > ProtocolConstantsEnum.MAX_LEVEL)
         {
            this.ctr_stats.visible = false;
            this.ctr_spell.y = this.ctr_spell.y - 70;
            this.ctr_button.y = this.ctr_button.y - 70;
            this.levelupWindow.height = this.levelupWindow.height - 70;
            this.lbl_newLevel.text = this.uiApi.getText("ui.common.prestige") + " " + (param1.newLevel - ProtocolConstantsEnum.MAX_LEVEL);
            _loc4_ = this.uiApi.getText("ui.levelUp.newVariant");
            if(param1.newSpell)
            {
               _loc5_ = this.uiApi.getText("ui.levelUp.nextVariant",param1.newSpell.obtentionLevel);
            }
         }
         else
         {
            this.lbl_newLevel.text = this.uiApi.getText("ui.levelUp.titleLevel",param1.newLevel);
            this.lbl_lifeStatPoints.text = "+ " + param1.caracPointEarned;
            this.lbl_spellStatPoints.text = "+ " + param1.spellPointEarned;
            this.lbl_caracStatPoints.text = "+ " + param1.caracPointEarned;
            _loc4_ = this.uiApi.getText("ui.levelUp.newSpell");
            _loc5_ = this.uiApi.getText("ui.levelUp.nextSpell",param1.levelSpellObtention);
         }
         if(param1.spellObtained)
         {
            this.lbl_spell.text = _loc4_;
            this.tx_spellSlotEffect["playOnce"] = true;
            this.tx_spellSlotEffect.uri = this.uiApi.createUri(this._assetsUri + "levelUp_tx_animPaillette");
            this.tx_spellSlotEffect.gotoAndPlay = "1";
         }
         else
         {
            this.lbl_spell.text = _loc5_;
         }
      }
      
      public function unload() : void
      {
      }
      
      public function onRelease(param1:Object) : void
      {
         switch(param1)
         {
            case this.btn_close_main:
               this.uiApi.unloadUi(this.uiApi.me().name);
         }
      }
      
      public function onRollOver(param1:Object) : void
      {
         var _loc3_:ItemTooltipSettings = null;
         var _loc2_:String = "";
         switch(param1)
         {
            case this.spellSlot:
               if(!param1.data)
               {
                  return;
               }
               _loc3_ = this.sysApi.getData("itemTooltipSettings",DataStoreEnum.BIND_ACCOUNT) as ItemTooltipSettings;
               this.uiApi.showTooltip(param1.data,param1,false,"standard",3,3,0,null,null,_loc3_);
               break;
            case this.lbl_lifeStat:
               _loc2_ = this.uiApi.getText("ui.levelUp.tooltip.lifePoints");
               this.uiApi.showTooltip(this.uiApi.textTooltipInfo(_loc2_),param1,false,"standard",7,1,3,null,null,null,"TextInfo");
               break;
            case this.lbl_spellStat:
               _loc2_ = this.uiApi.getText("ui.levelUp.tooltip.spellPoints");
               this.uiApi.showTooltip(this.uiApi.textTooltipInfo(_loc2_),param1,false,"standard",7,1,3,null,null,null,"TextInfo");
               break;
            case this.lbl_caracStat:
               _loc2_ = this.uiApi.getText("ui.levelUp.tooltip.caracPoints");
               this.uiApi.showTooltip(this.uiApi.textTooltipInfo(_loc2_),param1,false,"standard",7,1,3,null,null,null,"TextInfo");
         }
      }
      
      public function onRollOut(param1:Object) : void
      {
         this.uiApi.hideTooltip();
      }
      
      public function onShortcut(param1:String) : Boolean
      {
         switch(param1)
         {
            case "validUi":
            case "closeUi":
               this.uiApi.unloadUi(this.uiApi.me().name);
               return true;
            default:
               return false;
         }
      }
   }
}
