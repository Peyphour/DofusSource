package d2data
{
   public class MountWrapper extends ItemWrapper
   {
       
      
      public function MountWrapper(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get mountId() : int
      {
         return _target.mountId;
      }
   }
}
