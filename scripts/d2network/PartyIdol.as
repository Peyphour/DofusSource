package d2network
{
   public class PartyIdol extends Idol
   {
       
      
      public function PartyIdol(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get ownersIds() : Object
      {
         return secure(_target.ownersIds);
      }
   }
}
