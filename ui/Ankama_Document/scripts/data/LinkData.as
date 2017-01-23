package data
{
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class LinkData
   {
       
      
      public var text:String;
      
      public var href:String;
      
      public var page:String;
      
      private var _parent:GraphicContainer;
      
      private var _graphicContainer:GraphicContainer;
      
      public function LinkData(param1:String, param2:String, param3:String = "")
      {
         super();
         this.text = param1;
         this.href = param2.replace("event:","");
         this.page = param3;
      }
      
      public function setGraphicData(param1:GraphicContainer, param2:GraphicContainer, param3:Rectangle, param4:Point) : void
      {
         this._parent = param2;
         this._graphicContainer = param1;
         this._graphicContainer.buttonMode = true;
         this._graphicContainer.x = param3.x + param4.x;
         this._graphicContainer.y = param3.y + param4.y;
         this._graphicContainer.width = param3.width;
         this._graphicContainer.height = param3.height;
         this._graphicContainer.bgColor = 16711680;
         this._graphicContainer.alpha = 0;
         this._parent.addChild(this._graphicContainer);
      }
      
      public function get graphic() : GraphicContainer
      {
         return this._graphicContainer;
      }
      
      public function set parent(param1:GraphicContainer) : void
      {
         this._parent = param1;
         this._parent.addChild(this._graphicContainer);
      }
      
      public function destroy() : void
      {
         if(this._parent)
         {
            this._parent.removeChild(this._graphicContainer);
            this._parent = null;
         }
         this._graphicContainer.remove();
         this._graphicContainer = null;
      }
   }
}
