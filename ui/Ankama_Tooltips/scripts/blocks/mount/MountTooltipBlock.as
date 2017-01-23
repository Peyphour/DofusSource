package blocks.mount
{
   public class MountTooltipBlock
   {
       
      
      private var _content:String;
      
      private var _mount:Object;
      
      private var _block:Object;
      
      public function MountTooltipBlock(param1:Object)
      {
         super();
         this._mount = param1;
         this._block = Api.tooltip.createTooltipBlock(this.onAllChunkLoaded,this.getContent);
         this._block.initChunk(new Array(Api.tooltip.createChunkData("base","chunks/mount/base.txt")));
      }
      
      public function onAllChunkLoaded() : void
      {
         var _loc1_:Object = Api.ui;
         this._content = this._block.getChunk("base").processContent(this._mount);
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
