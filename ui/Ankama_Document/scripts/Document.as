package
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.dofus.uiApi.DocumentApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import d2hooks.DocumentReadingBegin;
   import flash.display.Sprite;
   import ui.ReadingBook;
   import ui.Scroll;
   
   public class Document extends Sprite
   {
      
      private static const TYPE_BOOK:uint = 1;
      
      private static const TYPE_SCROLL:uint = 2;
       
      
      protected var readingBook:ReadingBook;
      
      protected var scroll:Scroll;
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      public var docApi:DocumentApi;
      
      [Module(name="Ankama_Common")]
      public var modCommon:Object;
      
      public function Document()
      {
         super();
      }
      
      public function main() : void
      {
         this.sysApi.addHook(DocumentReadingBegin,this.onDocumentReadingBegin);
      }
      
      private function onDocumentReadingBegin(param1:uint) : void
      {
         var _loc2_:uint = this.docApi.getType(param1);
         switch(_loc2_)
         {
            case TYPE_BOOK:
               if(!this.uiApi.getUi("readingBook"))
               {
                  this.uiApi.loadUi("readingBook","readingBook",{"documentId":param1});
               }
               break;
            case TYPE_SCROLL:
               if(!this.uiApi.getUi("scroll"))
               {
                  this.uiApi.loadUi("scroll","scroll",{"documentId":param1});
               }
         }
      }
   }
}
