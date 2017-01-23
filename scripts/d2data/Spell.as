package d2data
{
   import utils.ReadOnlyData;
   
   public class Spell extends ReadOnlyData
   {
       
      
      public function Spell(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get id() : int
      {
         return _target.id;
      }
      
      public function get nameId() : uint
      {
         return _target.nameId;
      }
      
      public function get descriptionId() : uint
      {
         return _target.descriptionId;
      }
      
      public function get typeId() : uint
      {
         return _target.typeId;
      }
      
      public function get order() : uint
      {
         return _target.order;
      }
      
      public function get scriptParams() : String
      {
         return _target.scriptParams;
      }
      
      public function get scriptParamsCritical() : String
      {
         return _target.scriptParamsCritical;
      }
      
      public function get scriptId() : int
      {
         return _target.scriptId;
      }
      
      public function get scriptIdCritical() : int
      {
         return _target.scriptIdCritical;
      }
      
      public function get iconId() : uint
      {
         return _target.iconId;
      }
      
      public function get spellLevels() : Object
      {
         return secure(_target.spellLevels);
      }
      
      public function get useParamCache() : Boolean
      {
         return _target.useParamCache;
      }
      
      public function get verbose_cast() : Boolean
      {
         return _target.verbose_cast;
      }
   }
}
