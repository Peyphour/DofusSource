package blocks
{
   import com.ankamagames.dofus.datacenter.communication.Smiley;
   
   public class SmileyTooltipBlock
   {
       
      
      private var _content:String;
      
      private var _smileyId:uint;
      
      private var _block:Object;
      
      public function SmileyTooltipBlock(param1:uint)
      {
         super();
         this._smileyId = param1;
         this._block = Api.tooltip.createTooltipBlock(this.onAllChunkLoaded,this.getContent);
         this._block.initChunk([Api.tooltip.createChunkData("content","chunks/smiley/content.txt")]);
      }
      
      public function onAllChunkLoaded() : void
      {
         var _loc1_:Smiley = Api.data.getSmiley(this._smileyId);
         var _loc2_:String = "";
         if(_loc1_)
         {
            _loc2_ = "[config.gfx.path]smilies/assets.swf|" + _loc1_.gfxId;
         }
         this._content = this._block.getChunk("content").processContent({
            "id":this._smileyId,
            "uri":_loc2_
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
