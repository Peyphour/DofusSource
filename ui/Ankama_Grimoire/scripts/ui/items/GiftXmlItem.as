package ui.items
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.dofus.uiApi.SystemApi;
   
   public class GiftXmlItem
   {
       
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      public var lbl_giftName:Label;
      
      public var lbl_giftEffect:Label;
      
      public var tx_icon:Texture;
      
      private var _grid:Object;
      
      private var _data;
      
      private var _selected:Boolean;
      
      public function GiftXmlItem()
      {
         super();
      }
      
      public function main(param1:Object = null) : void
      {
         this._grid = param1.grid;
         this._data = param1.data;
         this.update(this._data,this._selected);
      }
      
      public function get data() : *
      {
         return this._data;
      }
      
      public function get selected() : Boolean
      {
         return this._selected;
      }
      
      public function update(param1:*, param2:Boolean) : void
      {
         this._data = param1;
         if(param1)
         {
            this.lbl_giftName.text = param1.giftName + " - " + this.uiApi.getText("ui.common.level") + " " + param1.giftLevel;
            if(param1.giftEffect)
            {
               if(param1.param)
               {
                  this.lbl_giftEffect.text = param1.giftEffect.split("#1").join(param1.param);
               }
               else
               {
                  this.lbl_giftEffect.text = param1.giftEffect;
               }
            }
            else
            {
               this.lbl_giftEffect.text = "";
            }
            this.tx_icon.uri = param1.giftUri;
         }
         else
         {
            this.lbl_giftName.text = "";
            this.lbl_giftEffect.text = "";
            this.tx_icon.uri = null;
         }
      }
      
      public function select(param1:Boolean) : void
      {
      }
      
      public function onRollOver(param1:Object) : void
      {
      }
      
      public function onRollOut(param1:Object) : void
      {
      }
   }
}
