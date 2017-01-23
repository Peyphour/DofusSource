package d2network
{
   public class HumanOptionFollowers extends HumanOption
   {
       
      
      public function HumanOptionFollowers(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get followingCharactersLook() : Object
      {
         return secure(_target.followingCharactersLook);
      }
   }
}
