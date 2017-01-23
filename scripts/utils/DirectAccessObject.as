package utils
{
   import flash.errors.IllegalOperationError;
   import flash.system.ApplicationDomain;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   
   public class DirectAccessObject
   {
      
      protected static var _accessKey:Object;
      
      private static const _objectList:Dictionary = new Dictionary(true);
      
      private static const _objectExist:Dictionary = new Dictionary(true);
       
      
      protected var _target:Object;
      
      private var _getQualifiedClassName:String;
      
      private var _simplyfiedQualifiedClassName:String;
      
      public function DirectAccessObject(param1:Object, param2:Object)
      {
         super();
         if(param2 != _accessKey)
         {
            throw new IllegalOperationError();
         }
         this._target = param1;
         this._getQualifiedClassName = getQualifiedClassName(param1);
      }
      
      public static function init(param1:Object) : void
      {
         if(_accessKey)
         {
            throw new IllegalOperationError();
         }
         _accessKey = param1;
      }
      
      public static function create(param1:Object, param2:String, param3:Object) : DirectAccessObject
      {
         var _loc4_:DirectAccessObject = null;
         var _loc6_:* = undefined;
         if(param3 != _accessKey)
         {
            throw new IllegalOperationError();
         }
         if(param1 is DirectAccessObject)
         {
            return param1 as DirectAccessObject;
         }
         if(_objectExist[param1])
         {
            for(_loc6_ in _objectList)
            {
               if(_loc6_ && _loc6_._target == param1)
               {
                  return _loc6_;
               }
            }
         }
         var _loc5_:String = getQualifiedClassName(param1);
         _loc5_ = _loc5_.substr(_loc5_.indexOf("::") + 2);
         if(ApplicationDomain.currentDomain.hasDefinition(param2 + "::" + _loc5_))
         {
            _loc4_ = new (ApplicationDomain.currentDomain.getDefinition(param2 + "::" + _loc5_) as Class)(param1,_accessKey);
         }
         else
         {
            _loc4_ = null;
         }
         _objectList[_loc4_] = null;
         _objectExist[param1] = true;
         return _loc4_;
      }
      
      public function get simplyfiedQualifiedClassName() : String
      {
         var _loc1_:Array = null;
         if(this._simplyfiedQualifiedClassName == null)
         {
            _loc1_ = this._getQualifiedClassName.split("::");
            this._simplyfiedQualifiedClassName = _loc1_[_loc1_.length - 1];
         }
         return this._simplyfiedQualifiedClassName;
      }
      
      public function getObject(param1:Object) : *
      {
         if(param1 != _accessKey)
         {
            throw new IllegalOperationError();
         }
         return this._target;
      }
   }
}
