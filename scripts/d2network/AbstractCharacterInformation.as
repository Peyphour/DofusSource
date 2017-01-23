package d2network
{
   import utils.ReadOnlyData;
   
   public class AbstractCharacterInformation extends ReadOnlyData
   {
       
      
      public function AbstractCharacterInformation(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get id() : Number
      {
         return _target.id;
      }
   }
}
