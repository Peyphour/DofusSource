package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Grid;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.PlayedCharacterApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofusModuleLibrary.enum.components.GridItemSelectMethodEnum;
   import d2actions.GetComicsLibraryRequest;
   import d2enums.ComponentHookList;
   import d2enums.StrataEnum;
   import d2hooks.ComicsLibraryLoaded;
   
   public class WebLibrary
   {
       
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      public var playerApi:PlayedCharacterApi;
      
      public var dataApi:DataApi;
      
      public var gd_books:Grid;
      
      public function WebLibrary()
      {
         super();
      }
      
      public function main(param1:Object = null) : void
      {
         this.uiApi.addComponentHook(this.gd_books,ComponentHookList.ON_SELECT_ITEM);
         this.sysApi.addHook(ComicsLibraryLoaded,this.onComicsLibraryLoaded);
         var _loc2_:String = "nullUser";
         this.sysApi.sendAction(new GetComicsLibraryRequest(_loc2_));
      }
      
      public function onSelectItem(param1:Object, param2:uint, param3:Boolean) : void
      {
         if(param2 != GridItemSelectMethodEnum.AUTO)
         {
            this.uiApi.loadUi("webReader","webReader",{
               "remoteId":param1.selectedItem.comicId,
               "readerUrl":"",
               "language":param1.selectedItem.language
            },StrataEnum.STRATA_TOP);
         }
      }
      
      public function onComicsLibraryLoaded(param1:Object) : void
      {
         this.gd_books.dataProvider = param1;
      }
      
      public function updateBook(param1:*, param2:*, param3:Boolean) : void
      {
         if(param1)
         {
            param2.tx_cover.alpha = 1;
         }
         else
         {
            param2.tx_cover.alpha = 0.1;
         }
      }
   }
}
