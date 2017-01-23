package blocks
{
   public class TchatTooltipBlock
   {
       
      
      private var _content:String;
      
      private var _msg:String;
      
      private var _block:Object;
      
      public function TchatTooltipBlock(param1:String)
      {
         super();
         param1 = Api.chat.unEscapeChatString(param1);
         param1 = Api.chat.getStaticHyperlink(param1);
         this._msg = param1;
         this._block = Api.tooltip.createTooltipBlock(this.onAllChunkLoaded,this.getContent);
         this._block.initChunk([Api.tooltip.createChunkData("content","chunks/tchat/tchat.txt")]);
      }
      
      public function onAllChunkLoaded() : void
      {
         this._content = this._block.getChunk("content").processContent({"msg":this._msg});
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
