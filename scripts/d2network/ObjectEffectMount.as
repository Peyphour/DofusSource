package d2network
{
   public class ObjectEffectMount extends ObjectEffect
   {
       
      
      public function ObjectEffectMount(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get mountId() : uint
      {
         return _target.mountId;
      }
      
      public function get date() : Number
      {
         return _target.date;
      }
      
      public function get modelId() : uint
      {
         return _target.modelId;
      }
   }
}
