package d2data
{
   import utils.ReadOnlyData;
   
   public class ActionDescription extends ReadOnlyData
   {
       
      
      public function ActionDescription(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get id() : uint
      {
         return _target.id;
      }
      
      public function get typeId() : uint
      {
         return _target.typeId;
      }
      
      public function get name() : String
      {
         return _target.name;
      }
      
      public function get descriptionId() : uint
      {
         return _target.descriptionId;
      }
      
      public function get trusted() : Boolean
      {
         return _target.trusted;
      }
      
      public function get needInteraction() : Boolean
      {
         return _target.needInteraction;
      }
      
      public function get maxUsePerFrame() : uint
      {
         return _target.maxUsePerFrame;
      }
      
      public function get minimalUseInterval() : uint
      {
         return _target.minimalUseInterval;
      }
      
      public function get needConfirmation() : Boolean
      {
         return _target.needConfirmation;
      }
   }
}
