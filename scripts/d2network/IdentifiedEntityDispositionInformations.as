package d2network
{
   public class IdentifiedEntityDispositionInformations extends EntityDispositionInformations
   {
       
      
      public function IdentifiedEntityDispositionInformations(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get id() : Number
      {
         return _target.id;
      }
   }
}
