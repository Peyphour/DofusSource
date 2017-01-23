package blocks
{
   public class CraftSmileyTooltipBlock
   {
       
      
      private var _content:String;
      
      private var _block:Object;
      
      private var _iconId:int;
      
      private var _craftResult:uint;
      
      public function CraftSmileyTooltipBlock(param1:Object)
      {
         super();
         this._iconId = param1.iconId;
         this._craftResult = param1.craftResult;
         this._block = Api.tooltip.createTooltipBlock(this.onAllChunkLoaded,this.getContent);
         this._block.initChunk([Api.tooltip.createChunkData("content","chunks/craftSmiley/content.txt")]);
      }
      
      public function onAllChunkLoaded() : void
      {
         var _loc1_:* = null;
         var _loc2_:String = null;
         var _loc3_:Boolean = false;
         var _loc4_:Boolean = true;
         switch(this._craftResult)
         {
            case 0:
               _loc2_ = "Craft_tx_bulleRouge";
               _loc3_ = true;
               break;
            case 1:
               _loc2_ = "Craft_tx_bulleRouge";
               break;
            case 2:
               _loc2_ = "Craft_tx_bulle";
         }
         if(this._iconId == 0)
         {
            _loc1_ = "[config.ui.skin]assets.swf|inventaire_tx_kama";
         }
         else
         {
            _loc1_ = "[config.gfx.path.item.bitmap]" + this._iconId + ".png";
         }
         if(this._iconId == -1)
         {
            _loc4_ = false;
         }
         this._content = this._block.getChunk("content").processContent({
            "uri":_loc1_,
            "backName":_loc2_,
            "xVisible":_loc3_,
            "oVisible":_loc4_
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
