package d2network
{
   public class AbstractCharacterToRefurbishInformation extends AbstractCharacterInformation
   {
       
      
      public function AbstractCharacterToRefurbishInformation(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get colors() : Object
      {
         return secure(_target.colors);
      }
      
      public function get cosmeticId() : uint
      {
         return _target.cosmeticId;
      }
   }
}
