package d2data
{
   public class EffectInstanceMount extends EffectInstance
   {
       
      
      public function EffectInstanceMount(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get date() : Number
      {
         return _target.date;
      }
      
      public function get modelId() : uint
      {
         return _target.modelId;
      }
      
      public function get mountId() : uint
      {
         return _target.mountId;
      }
   }
}
