package d2data
{
   import utils.ReadOnlyData;
   
   public class Item extends ReadOnlyData
   {
       
      
      public function Item(param1:*, param2:Object)
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
      
      public function get typeId() : uint
      {
         return _target.typeId;
      }
      
      public function get descriptionId() : uint
      {
         return _target.descriptionId;
      }
      
      public function get iconId() : uint
      {
         return _target.iconId;
      }
      
      public function get level() : uint
      {
         return _target.level;
      }
      
      public function get realWeight() : uint
      {
         return _target.realWeight;
      }
      
      public function get cursed() : Boolean
      {
         return _target.cursed;
      }
      
      public function get useAnimationId() : int
      {
         return _target.useAnimationId;
      }
      
      public function get usable() : Boolean
      {
         return _target.usable;
      }
      
      public function get targetable() : Boolean
      {
         return _target.targetable;
      }
      
      public function get exchangeable() : Boolean
      {
         return _target.exchangeable;
      }
      
      public function get price() : Number
      {
         return _target.price;
      }
      
      public function get twoHanded() : Boolean
      {
         return _target.twoHanded;
      }
      
      public function get etheral() : Boolean
      {
         return _target.etheral;
      }
      
      public function get itemSetId() : int
      {
         return _target.itemSetId;
      }
      
      public function get criteria() : String
      {
         return _target.criteria;
      }
      
      public function get criteriaTarget() : String
      {
         return _target.criteriaTarget;
      }
      
      public function get hideEffects() : Boolean
      {
         return _target.hideEffects;
      }
      
      public function get enhanceable() : Boolean
      {
         return _target.enhanceable;
      }
      
      public function get nonUsableOnAnother() : Boolean
      {
         return _target.nonUsableOnAnother;
      }
      
      public function get appearanceId() : uint
      {
         return _target.appearanceId;
      }
      
      public function get secretRecipe() : Boolean
      {
         return _target.secretRecipe;
      }
      
      public function get dropMonsterIds() : Object
      {
         return secure(_target.dropMonsterIds);
      }
      
      public function get recipeSlots() : uint
      {
         return _target.recipeSlots;
      }
      
      public function get recipeIds() : Object
      {
         return secure(_target.recipeIds);
      }
      
      public function get bonusIsSecret() : Boolean
      {
         return _target.bonusIsSecret;
      }
      
      public function get possibleEffects() : Object
      {
         return secure(_target.possibleEffects);
      }
      
      public function get favoriteSubAreas() : Object
      {
         return secure(_target.favoriteSubAreas);
      }
      
      public function get favoriteSubAreasBonus() : uint
      {
         return _target.favoriteSubAreasBonus;
      }
      
      public function get craftXpRatio() : int
      {
         return _target.craftXpRatio;
      }
      
      public function get needUseConfirm() : Boolean
      {
         return _target.needUseConfirm;
      }
      
      public function get isDestructible() : Boolean
      {
         return _target.isDestructible;
      }
      
      public function get nuggetsBySubarea() : Object
      {
         return secure(_target.nuggetsBySubarea);
      }
      
      public function get containerIds() : Object
      {
         return secure(_target.containerIds);
      }
      
      public function get resourcesBySubarea() : Object
      {
         return secure(_target.resourcesBySubarea);
      }
   }
}
