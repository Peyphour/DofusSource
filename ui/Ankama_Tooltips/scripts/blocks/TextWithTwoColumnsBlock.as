package blocks
{
   public class TextWithTwoColumnsBlock
   {
       
      
      private var _content:String;
      
      private var _param:Object;
      
      private var _block:Object;
      
      public function TextWithTwoColumnsBlock(param1:Object, param2:String = "htmlChunks")
      {
         super();
         this._param = param1;
         this._block = Api.tooltip.createTooltipBlock(this.onAllChunkLoaded,this.getContent,param2);
         this._block.initChunk([Api.tooltip.createChunkData("twoColumns",param2 + "/text/twoColumns.txt")]);
      }
      
      public function onAllChunkLoaded() : void
      {
         this._content = this._block.getChunk("twoColumns").processContent(this._param);
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
