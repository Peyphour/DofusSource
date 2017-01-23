package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.components.TextureBitmap;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.datacenter.spells.SpellPair;
   import com.ankamagames.dofus.modules.utils.SpellTooltipSettings;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.PlayedCharacterApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofus.uiApi.TooltipApi;
   import d2enums.LocationEnum;
   import d2hooks.AreaFightModificatorUpdate;
   import d2hooks.FoldAll;
   
   public class FightModificatorUi
   {
       
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      public var playerApi:PlayedCharacterApi;
      
      public var tooltipApi:TooltipApi;
      
      public var dataApi:DataApi;
      
      private var _hidden:Boolean = false;
      
      private var _foldStatus:Boolean;
      
      private var _spellPair:SpellPair;
      
      public var ctr_ui:GraphicContainer;
      
      public var btn_minimArrow:ButtonContainer;
      
      public var tx_button_minimize:Texture;
      
      public var tx_background:TextureBitmap;
      
      public var tx_slot:Texture;
      
      public function FightModificatorUi()
      {
         super();
      }
      
      public function main(param1:Object) : void
      {
         this.sysApi.addHook(AreaFightModificatorUpdate,this.onAreaFightModificatorUpdate);
         this.uiApi.addComponentHook(this.tx_slot,"onRollOver");
         this.uiApi.addComponentHook(this.tx_slot,"onRollOut");
         this.sysApi.addHook(FoldAll,this.onFoldAll);
         this._hidden = false;
         this.ctr_ui.visible = true;
         if(param1)
         {
            this._spellPair = this.dataApi.getSpellPair(param1.pairId);
            if(this._spellPair)
            {
               this.update();
            }
            else
            {
               this.sysApi.log(2,"La paire " + param1.pairId + " n\'existe pas");
            }
         }
      }
      
      public function unload() : void
      {
         this.uiApi.hideTooltip();
      }
      
      public function update() : void
      {
         this.tx_slot.uri = this.uiApi.createUri(this.uiApi.me().getConstant("spells_uri") + this._spellPair.iconId);
         this.uiApi.me().render();
      }
      
      private function onAreaFightModificatorUpdate(param1:int) : void
      {
         if(param1 == -1)
         {
            this.uiApi.unloadUi(this.uiApi.me().name);
         }
         else
         {
            this._spellPair = this.dataApi.getSpellPair(param1);
            this.update();
         }
      }
      
      public function onRelease(param1:Object) : void
      {
         switch(param1)
         {
            case this.btn_minimArrow:
               this._hidden = !this._hidden;
               this.fold();
         }
      }
      
      public function onRollOver(param1:Object) : void
      {
         var _loc2_:SpellTooltipSettings = null;
         if(this._spellPair)
         {
            _loc2_ = this.tooltipApi.createSpellSettings();
            _loc2_.header = false;
            _loc2_.effects = false;
            _loc2_.CC_EC = false;
            this.uiApi.showTooltip(this._spellPair,this.tx_slot,false,"standard",LocationEnum.POINT_TOPLEFT,LocationEnum.POINT_BOTTOMRIGHT,0,null,null,_loc2_);
         }
      }
      
      public function onRollOut(param1:Object) : void
      {
         this.uiApi.hideTooltip();
      }
      
      private function onFoldAll(param1:Boolean) : void
      {
         this._hidden = param1;
         this.fold();
      }
      
      private function fold() : *
      {
         this.tx_background.visible = !this._hidden;
         this.ctr_ui.visible = !this._hidden;
         if(this._hidden)
         {
            this.tx_button_minimize.uri = this.uiApi.createUri(this.uiApi.me().getConstant("texture") + "hud/icon_plus_floating_menu.png");
         }
         else
         {
            this.tx_button_minimize.uri = this.uiApi.createUri(this.uiApi.me().getConstant("texture") + "hud/icon_minus_floating_menu.png");
         }
      }
   }
}
