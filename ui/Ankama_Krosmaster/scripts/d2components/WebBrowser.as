package d2components
{
   public class WebBrowser extends GraphicContainer
   {
       
      
      public function WebBrowser()
      {
         super();
      }
      
      public function get cacheLife() : Number
      {
         return 0;
      }
      
      public function set cacheLife(param1:Number) : void
      {
      }
      
      public function get cacheId() : String
      {
         return null;
      }
      
      public function set cacheId(param1:String) : void
      {
      }
      
      public function set scrollCss(param1:Object) : void
      {
      }
      
      public function get scrollCss() : Object
      {
         return null;
      }
      
      public function set displayScrollBar(param1:Boolean) : void
      {
      }
      
      public function get displayScrollBar() : Boolean
      {
         return false;
      }
      
      public function set scrollTopOffset(param1:int) : void
      {
      }
      
      public function get fromCache() : Boolean
      {
         return false;
      }
      
      public function get location() : String
      {
         return null;
      }
      
      public function clearLocation() : void
      {
      }
      
      public function set transparentBackground(param1:Boolean) : void
      {
      }
      
      public function setBlankLink(param1:String, param2:Boolean) : void
      {
      }
      
      public function hasContent() : Boolean
      {
         return false;
      }
      
      public function get content() : Object
      {
         return null;
      }
      
      public function load(param1:Object) : void
      {
      }
      
      public function javascriptSetVar(param1:String, param2:*) : void
      {
      }
      
      public function javascriptCall(param1:String, ... rest) : void
      {
      }
   }
}
