package com.ankamagames.dofus.logic.game.common.misc
{
   import com.ankamagames.atouin.Atouin;
   import com.ankamagames.jerakine.entities.interfaces.IEntity;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import flash.utils.getQualifiedClassName;
   
   public class DofusEntities
   {
      
      private static const LOCALIZER_DEBUG:Boolean = true;
      
      private static const _log:Logger = Log.getLogger(getQualifiedClassName(DofusEntities));
      
      private static var _atouin:Atouin = Atouin.getInstance();
      
      private static var _localizers:Vector.<IEntityLocalizer> = new Vector.<IEntityLocalizer>();
       
      
      public function DofusEntities()
      {
         super();
      }
      
      public static function getEntity(param1:Number) : IEntity
      {
         var _loc3_:IEntityLocalizer = null;
         var _loc2_:IEntity = null;
         for each(_loc3_ in _localizers)
         {
            _loc2_ = _loc3_.getEntity(param1);
            if(_loc2_)
            {
               return _loc2_;
            }
         }
         return _atouin.getEntity(param1);
      }
      
      public static function registerLocalizer(param1:IEntityLocalizer) : void
      {
         var _loc4_:IEntityLocalizer = null;
         var _loc2_:String = getQualifiedClassName(param1);
         var _loc3_:String = null;
         for each(_loc4_ in _localizers)
         {
            _loc3_ = getQualifiedClassName(_loc4_);
            if(_loc3_ == _loc2_)
            {
               throw new Error("There\'s more than one " + _loc3_ + " localizer added to DofusEntites. Nope, that won\'t work.");
            }
         }
         _localizers.push(param1);
      }
      
      public static function reset() : void
      {
         var _loc2_:IEntityLocalizer = null;
         var _loc1_:int = 0;
         while(_loc1_ < _localizers.length)
         {
            _loc2_ = _localizers[_loc1_];
            _loc2_.unregistered();
            _loc1_++;
         }
         _localizers = new Vector.<IEntityLocalizer>();
      }
   }
}
