package d2network
{
   import utils.ReadOnlyData;
   
   public class InteractiveElement extends ReadOnlyData
   {
       
      
      public function InteractiveElement(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get elementId() : uint
      {
         return _target.elementId;
      }
      
      public function get elementTypeId() : int
      {
         return _target.elementTypeId;
      }
      
      public function get enabledSkills() : Object
      {
         return secure(_target.enabledSkills);
      }
      
      public function get disabledSkills() : Object
      {
         return secure(_target.disabledSkills);
      }
      
      public function get onCurrentMap() : Boolean
      {
         return _target.onCurrentMap;
      }
   }
}
