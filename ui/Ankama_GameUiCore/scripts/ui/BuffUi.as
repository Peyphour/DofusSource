package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.components.TextureBitmap;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.uiApi.PlayedCharacterApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import d2hooks.FoldAll;
   import d2hooks.RoleplayBuffViewContent;
   import d2hooks.ShowObjectLinked;
   
   public class BuffUi
   {
       
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      public var playerApi:PlayedCharacterApi;
      
      private var _buffs:Object;
      
      private var _slots:Array;
      
      private var _hidden:Boolean = false;
      
      private var _backgroundWidthModifier:int;
      
      private var _backgroundOffset:int;
      
      private var _foldStatus:Boolean;
      
      public var buffCtr:GraphicContainer;
      
      public var btn_minimArrow:ButtonContainer;
      
      public var tx_button_minimize:Texture;
      
      public var tx_background:TextureBitmap;
      
      public var buffFrames:GraphicContainer;
      
      public var buff_slot_1:Texture;
      
      public var buff_slot_2:Texture;
      
      public var buff_slot_3:Texture;
      
      public var buff_slot_4:Texture;
      
      public var buff_slot_5:Texture;
      
      public var buff_slot_6:Texture;
      
      public var buff_slot_7:Texture;
      
      public var buff_slot_8:Texture;
      
      public function BuffUi()
      {
         super();
      }
      
      public function main(param1:Object) : void
      {
         var _loc2_:Texture = null;
         this._buffs = new Array();
         this._slots = [this.buff_slot_1,this.buff_slot_2,this.buff_slot_3,this.buff_slot_4,this.buff_slot_5,this.buff_slot_6,this.buff_slot_7,this.buff_slot_8];
         for each(_loc2_ in this._slots)
         {
            this.uiApi.addComponentHook(_loc2_,"onRollOver");
            this.uiApi.addComponentHook(_loc2_,"onRollOut");
            this.uiApi.addComponentHook(_loc2_,"onRelease");
         }
         this.tx_background.visible = false;
         this.buffFrames.visible = false;
         this.tx_background.height = this.uiApi.me().getConstant("backgroundHeight");
         this._backgroundWidthModifier = this.uiApi.me().getConstant("backgroundWidthModifier");
         this._backgroundOffset = this.uiApi.me().getConstant("backgroundOffset");
         this.sysApi.addHook(RoleplayBuffViewContent,this.onInventoryUpdate);
         this.sysApi.addHook(FoldAll,this.onFoldAll);
         this.update(param1.buffs);
      }
      
      private function onInventoryUpdate(param1:Object) : void
      {
         this.update(param1);
         this._hidden = false;
         this.fold();
      }
      
      public function onRelease(param1:Object) : void
      {
         var _loc2_:Object = null;
         switch(param1)
         {
            case this.btn_minimArrow:
               this._hidden = !this._hidden;
               this.fold();
               break;
            default:
               if(param1.name.indexOf("slot") != -1)
               {
                  if(!this.sysApi.getOption("displayTooltips","dofus"))
                  {
                     _loc2_ = this._buffs[this._slots.indexOf(param1)];
                     this.sysApi.dispatchHook(ShowObjectLinked,_loc2_);
                  }
               }
         }
      }
      
      private function fold() : void
      {
         this.tx_background.visible = !this._hidden;
         this.buffFrames.visible = !this._hidden;
         if(this._hidden)
         {
            this.tx_button_minimize.uri = this.uiApi.createUri(this.uiApi.me().getConstant("texture") + "hud/icon_plus_floating_menu.png");
         }
         else
         {
            this.tx_button_minimize.uri = this.uiApi.createUri(this.uiApi.me().getConstant("texture") + "hud/icon_minus_floating_menu.png");
         }
      }
      
      private function onFoldAll(param1:Boolean) : void
      {
         this._hidden = param1;
         this.fold();
      }
      
      public function onRollOver(param1:Object) : void
      {
         this.sysApi.log(2,"target : " + param1.name);
         var _loc2_:Object = this._buffs[this._slots.indexOf(param1)];
         if(_loc2_)
         {
            this.uiApi.showTooltip(_loc2_,param1,false,"standard",0,2,3,"itemName",null,{
               "showEffects":true,
               "header":true,
               "averagePrice":false,
               "noFooter":true,
               "noTheoreticalEffects":true
            },"ItemInfo");
         }
      }
      
      public function onRollOut(param1:Object) : void
      {
         this.uiApi.hideTooltip();
      }
      
      public function update(param1:Object) : void
      {
         var _loc2_:Object = null;
         var _loc3_:int = 0;
         this._buffs = param1;
         if(param1.length == 0)
         {
            this.buffCtr.visible = false;
         }
         else
         {
            this.buffCtr.visible = true;
            _loc3_ = 0;
            while(_loc3_ < this._slots.length)
            {
               _loc2_ = this._slots[_loc3_];
               if(_loc3_ >= param1.length)
               {
                  _loc2_.visible = false;
               }
               else
               {
                  _loc2_.visible = true;
                  _loc2_.uri = param1[_loc3_].iconUri;
               }
               _loc3_++;
            }
            this.tx_background.width = (this._slots[0].width + 6) * param1.length + this._backgroundWidthModifier;
            this.tx_background.x = -this.tx_background.width + this._backgroundOffset;
            this.uiApi.me().render();
         }
      }
   }
}
