package blocks
{
   import com.ankamagames.dofus.datacenter.items.Item;
   import com.ankamagames.dofus.internalDatacenter.communication.DelayedActionItem;
   import d2enums.DelayedActionTypeEnum;
   
   public class DelayedActionTooltipBlock
   {
       
      
      private var _content:String;
      
      private var _block:Object;
      
      private var _iconUrl:String;
      
      private var _data:DelayedActionItem;
      
      public function DelayedActionTooltipBlock(param1:DelayedActionItem)
      {
         var _loc2_:Item = null;
         super();
         this._data = param1;
         switch(param1.type)
         {
            case DelayedActionTypeEnum.DELAYED_ACTION_OBJECT_USE:
               _loc2_ = Api.data.getItem(param1.dataId);
               if(_loc2_)
               {
                  this._iconUrl = "[config.gfx.path.item.bitmap]" + _loc2_.iconId + ".png";
               }
         }
         this._block = Api.tooltip.createTooltipBlock(this.onAllChunkLoaded,this.getContent);
         this._block.initChunk([Api.tooltip.createChunkData("content","chunks/world/delayedAction.txt")]);
      }
      
      public function onAllChunkLoaded() : void
      {
         var _loc1_:String = null;
         var _loc2_:String = null;
         switch(this._data.type)
         {
            case DelayedActionTypeEnum.DELAYED_ACTION_OBJECT_USE:
               _loc2_ = "[local.assets]delayedItemUse";
         }
         this._content = this._block.getChunk("content").processContent({
            "uri":this._iconUrl,
            "backName":_loc2_
         });
      }
      
      public function getContent() : String
      {
         return this._content;
      }
      
      public function get block() : Object
      {
         return this._block;
      }
   }
}
