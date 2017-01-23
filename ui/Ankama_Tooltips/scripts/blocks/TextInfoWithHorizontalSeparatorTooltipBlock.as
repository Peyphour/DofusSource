package blocks
{
   public class TextInfoWithHorizontalSeparatorTooltipBlock
   {
       
      
      private var _content:String;
      
      private var _data:Object;
      
      private var _block:Object;
      
      public function TextInfoWithHorizontalSeparatorTooltipBlock(param1:Object)
      {
         super();
         this._data = param1;
         this._block = Api.tooltip.createTooltipBlock(this.onAllChunkLoaded,this.getContent);
         this._block.initChunk([Api.tooltip.createChunkData("content","chunks/textInfoWithSeparator/textInfoWithHorizontalSeparator.txt")]);
      }
      
      public function onAllChunkLoaded() : void
      {
         this._content = this._block.getChunk("content").content;
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
