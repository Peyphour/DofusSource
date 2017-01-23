package d2data
{
   import utils.ReadOnlyData;
   
   public class TitleWrapper extends ReadOnlyData
   {
       
      
      public function TitleWrapper(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get id() : uint
      {
         return _target.id;
      }
      
      public function get text() : String
      {
         return _target.text;
      }
      
      public function get isOkForMultiUse() : Boolean
      {
         return _target.isOkForMultiUse;
      }
      
      public function get quantity() : uint
      {
         return _target.quantity;
      }
   }
}
