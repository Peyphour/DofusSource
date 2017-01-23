package d2data
{
   import utils.ReadOnlyData;
   
   public class Effect extends ReadOnlyData
   {
       
      
      public function Effect(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get id() : int
      {
         return _target.id;
      }
      
      public function get descriptionId() : uint
      {
         return _target.descriptionId;
      }
      
      public function get iconId() : uint
      {
         return _target.iconId;
      }
      
      public function get characteristic() : int
      {
         return _target.characteristic;
      }
      
      public function get category() : uint
      {
         return _target.category;
      }
      
      public function get operator() : String
      {
         return _target.operator;
      }
      
      public function get showInTooltip() : Boolean
      {
         return _target.showInTooltip;
      }
      
      public function get useDice() : Boolean
      {
         return _target.useDice;
      }
      
      public function get forceMinMax() : Boolean
      {
         return _target.forceMinMax;
      }
      
      public function get boost() : Boolean
      {
         return _target.boost;
      }
      
      public function get active() : Boolean
      {
         return _target.active;
      }
      
      public function get oppositeId() : int
      {
         return _target.oppositeId;
      }
      
      public function get theoreticalDescriptionId() : uint
      {
         return _target.theoreticalDescriptionId;
      }
      
      public function get theoreticalPattern() : uint
      {
         return _target.theoreticalPattern;
      }
      
      public function get showInSet() : Boolean
      {
         return _target.showInSet;
      }
      
      public function get bonusType() : int
      {
         return _target.bonusType;
      }
      
      public function get useInFight() : Boolean
      {
         return _target.useInFight;
      }
      
      public function get effectPriority() : uint
      {
         return _target.effectPriority;
      }
      
      public function get elementId() : int
      {
         return _target.elementId;
      }
   }
}
