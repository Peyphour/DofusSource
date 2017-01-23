package ui.item
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.dofus.uiApi.ChatApi;
   import com.ankamagames.dofus.uiApi.ConfigApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import flash.geom.ColorTransform;
   
   public class ChannelColorizedItem
   {
       
      
      public var output:Object;
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      public var chatApi:ChatApi;
      
      public var configApi:ConfigApi;
      
      private var _data;
      
      private var _selected:Boolean;
      
      public var tx_color:Texture;
      
      public var lbl_colorChannel:Label;
      
      public function ChannelColorizedItem()
      {
         super();
      }
      
      public function main(param1:Object = null) : void
      {
         this._data = param1.data;
         this._selected = param1.selected;
         this.update(this._data,this._selected);
      }
      
      public function unload() : void
      {
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
         var _loc3_:uint = 0;
         var _loc4_:ColorTransform = null;
         this._data = param1;
         if(param1)
         {
            _loc3_ = this.configApi.getConfigProperty("chat","channelColor" + param1.id);
            _loc4_ = new ColorTransform();
            _loc4_.color = _loc3_;
            this.tx_color.transform.colorTransform = _loc4_;
            this.lbl_colorChannel.text = param1.name;
         }
      }
      
      public function select(param1:Boolean) : void
      {
      }
   }
}
