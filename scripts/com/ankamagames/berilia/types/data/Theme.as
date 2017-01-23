package com.ankamagames.berilia.types.data
{
   import com.ankamagames.jerakine.types.Uri;
   
   public class Theme
   {
      
      public static const TYPE_OLD:uint = 0;
      
      public static const TYPE_NEW:uint = 1;
       
      
      public var id:String;
      
      public var name:String;
      
      public var author:String;
      
      public var description:String;
      
      public var previewUri:String;
      
      public var fileName:String;
      
      public var type:uint;
      
      public var folderFullPath:String;
      
      public var official:Boolean;
      
      public var version:Array;
      
      public var dofusVersion:Array;
      
      public var creationDate:String;
      
      public var modificationDate:String;
      
      public var data:Object;
      
      public function Theme(param1:String, param2:String, param3:String, param4:String, param5:String, param6:String = "", param7:String = "", param8:uint = 1, param9:Boolean = false, param10:Array = null, param11:Array = null, param12:String = "", param13:String = "")
      {
         super();
         this.id = param1;
         this.name = param4;
         this.author = param5;
         this.description = param6;
         this.previewUri = param7;
         this.fileName = param2;
         this.type = param8;
         this.folderFullPath = param3;
         this.official = param9;
         this.version = param10 == null?new Array(0,0,0):param10;
         this.dofusVersion = param11 == null?new Array(0,0,0):param11;
         this.creationDate = param12;
         this.modificationDate = param13;
      }
      
      public function get previewRealUri() : Uri
      {
         return new Uri(this.folderFullPath + "bitmap/" + this.previewUri,false);
      }
   }
}
