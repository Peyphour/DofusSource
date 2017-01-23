package ui.behavior
{
   import d2actions.ExchangeObjectMove;
   import d2enums.SelectMethodEnum;
   import ui.enum.StorageState;
   
   public class MountBehavior extends BankBehavior
   {
       
      
      public function MountBehavior()
      {
         super();
      }
      
      override public function getName() : String
      {
         return StorageState.MOUNT_MOD;
      }
      
      override public function onSelectItem(param1:Object, param2:uint, param3:Boolean) : void
      {
         var _loc4_:Object = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         if(param1 == _storage.grid)
         {
            _loc4_ = _storage.grid.selectedItem;
            if(param2 == SelectMethodEnum.CTRL_DOUBLE_CLICK)
            {
               if(Api.inventory.getItem(_loc4_.objectUID))
               {
                  _loc5_ = _loc4_.quantity;
                  _loc6_ = Api.storage.dracoTurkyMaxInventoryWeight() - Api.storage.dracoTurkyInventoryWeight();
                  if(_loc4_.realWeight * _loc4_.quantity > _loc6_)
                  {
                     _loc5_ = Math.floor(_loc6_ / _loc4_.realWeight);
                  }
                  Api.system.sendAction(new ExchangeObjectMove(_loc4_.objectUID,_loc5_));
               }
            }
            else
            {
               super.onSelectItem(param1,param2,param3);
            }
         }
      }
   }
}
