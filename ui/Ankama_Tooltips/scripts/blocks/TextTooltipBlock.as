package blocks
{
   public class TextTooltipBlock
   {
       
      
      private var _content:String;
      
      private var _param:Object;
      
      private var _block:Object;
      
      public function TextTooltipBlock(param1:String, param2:Object = null, param3:String = "chunks")
      {
         super();
         if(param2 == null)
         {
            this._param = {"css":"[local.css]tooltip_default.css"};
         }
         else
         {
            this._param = param2;
         }
         if(!this._param.classCss)
         {
            this._param.classCss = "left";
         }
         if(!this._param.css)
         {
            this._param.css = "[local.css]tooltip_default.css";
         }
         this._param.content = param1;
         this._block = Api.tooltip.createTooltipBlock(this.onAllChunkLoaded,this.getContent);
         if(this._param.width)
         {
            this._block.initChunk([Api.tooltip.createChunkData("content",param3 + "/text/fixedContent.txt")]);
         }
         else if(this._param.nameless)
         {
            this._block.initChunk([Api.tooltip.createChunkData("content",param3 + "/text/namelessContent.txt")]);
         }
         else
         {
            this._block.initChunk([Api.tooltip.createChunkData("content",param3 + "/text/content.txt")]);
         }
      }
      
      public function onAllChunkLoaded() : void
      {
         this._content = this._block.getChunk("content").processContent(this._param);
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
