package blocks
{
   public class DescriptionTooltipBlock
   {
       
      
      private var _description:String;
      
      private var _content:String;
      
      private var _cssClass:String;
      
      private var _block:Object;
      
      public function DescriptionTooltipBlock(param1:String, param2:String = "description", param3:String = "chunks")
      {
         super();
         this._description = param1;
         this._cssClass = param2;
         this._block = Api.tooltip.createTooltipBlock(this.onAllChunkLoaded,this.getContent);
         this._block.initChunk([Api.tooltip.createChunkData("description",param3 + "/description/description.txt")]);
      }
      
      public function onAllChunkLoaded() : void
      {
         this._content = this._block.getChunk("description").processContent({
            "description":this._description,
            "cssClass":this._cssClass
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
