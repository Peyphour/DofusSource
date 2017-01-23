package com.ankamagames.dofus.logic.game.roleplay.actions.havenbag
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class HavenbagFurnitureSelectedAction implements Action
   {
       
      
      public var furnitureTypeId:uint;
      
      public function HavenbagFurnitureSelectedAction()
      {
         super();
      }
      
      public static function create(param1:uint) : HavenbagFurnitureSelectedAction
      {
         var _loc2_:HavenbagFurnitureSelectedAction = new HavenbagFurnitureSelectedAction();
         _loc2_.furnitureTypeId = param1;
         return _loc2_;
      }
   }
}
