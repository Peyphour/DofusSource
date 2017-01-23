package d2data
{
   import utils.ReadOnlyData;
   
   public class Document extends ReadOnlyData
   {
       
      
      public function Document(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get id() : int
      {
         return _target.id;
      }
      
      public function get typeId() : uint
      {
         return _target.typeId;
      }
      
      public function get showTitle() : Boolean
      {
         return _target.showTitle;
      }
      
      public function get showBackgroundImage() : Boolean
      {
         return _target.showBackgroundImage;
      }
      
      public function get titleId() : uint
      {
         return _target.titleId;
      }
      
      public function get authorId() : uint
      {
         return _target.authorId;
      }
      
      public function get subTitleId() : uint
      {
         return _target.subTitleId;
      }
      
      public function get contentId() : uint
      {
         return _target.contentId;
      }
      
      public function get contentCSS() : String
      {
         return _target.contentCSS;
      }
      
      public function get clientProperties() : String
      {
         return _target.clientProperties;
      }
   }
}
