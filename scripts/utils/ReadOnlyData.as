package utils
{
   import flash.errors.IllegalOperationError;
   import flash.system.ApplicationDomain;
   import flash.utils.Dictionary;
   import flash.utils.Proxy;
   import flash.utils.flash_proxy;
   import flash.utils.getQualifiedClassName;
   
   public class ReadOnlyData extends Proxy implements Secure
   {
      
      protected static var _accessKey:Object;
      
      private static const _createdObjectProperties:Dictionary = new Dictionary(true);
      
      private static const _readOnlyObjectList:Dictionary = new Dictionary(true);
      
      private static const _readOnlyObjectExist:Dictionary = new Dictionary(true);
      
      protected static var unsecureContent:Function;
      
      protected static var secure:Function;
      
      protected static var unsecure:Function;
       
      
      protected var _target:Object;
      
      private var _getQualifiedClassName:String;
      
      private var _simplyfiedQualifiedClassName:String;
      
      private var _properties:Array;
      
      protected var _component:Object;
      
      protected var _trusted:Boolean;
      
      public function ReadOnlyData(param1:Object, param2:Object)
      {
         super();
         if(param2 != _accessKey)
         {
            throw new IllegalOperationError();
         }
         this._target = param1;
         this._getQualifiedClassName = getQualifiedClassName(param1);
      }
      
      public static function init(param1:Object, param2:Function, param3:Function, param4:Function) : void
      {
         if(_accessKey)
         {
            throw new IllegalOperationError();
         }
         ReadOnlyData.unsecureContent = param2;
         ReadOnlyData.secure = param3;
         ReadOnlyData.unsecure = param4;
         _accessKey = param1;
      }
      
      public static function create(param1:Object, param2:String, param3:Object) : ReadOnlyData
      {
         var _loc4_:ReadOnlyData = null;
         var _loc6_:* = undefined;
         if(param3 != _accessKey)
         {
            throw new IllegalOperationError();
         }
         if(param1 is ReadOnlyData)
         {
            return param1 as ReadOnlyData;
         }
         if(_readOnlyObjectExist[param1])
         {
            for(_loc6_ in _readOnlyObjectList)
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
            _loc4_ = new ReadOnlyData(param1,param3);
         }
         _readOnlyObjectList[_loc4_] = null;
         _readOnlyObjectExist[param1] = true;
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
      
      public function hasOwnProperty(param1:String) : Boolean
      {
         return this._target.hasOwnProperty(param1);
      }
      
      public function propertyIsEnumerable(param1:String) : Boolean
      {
         return this._target.propertyIsEnumerable(param1);
      }
      
      public function indexOf(param1:*) : int
      {
         return this._target.indexOf(param1);
      }
      
      public function getObject(param1:Object) : *
      {
         if(param1 != _accessKey)
         {
            throw new IllegalOperationError();
         }
         return this._target;
      }
      
      override flash_proxy function callProperty(param1:*, ... rest) : *
      {
         if(param1 == "toString")
         {
            return this._target + "";
         }
         var _loc3_:Error = new Error();
         if(!_loc3_.getStackTrace())
         {
         }
         return null;
      }
      
      override flash_proxy function hasProperty(param1:*) : Boolean
      {
         return this._target.hasOwnProperty(param1);
      }
      
      override flash_proxy function getProperty(param1:*) : *
      {
         return secure(this._target[param1]);
      }
      
      override flash_proxy function setProperty(param1:*, param2:*) : void
      {
         var _loc3_:Error = new Error();
         if(!_loc3_.getStackTrace())
         {
         }
      }
      
      override flash_proxy function nextNameIndex(param1:int) : int
      {
         var _loc2_:* = undefined;
         if(param1 == 0 && (!this._properties || this._target is Dictionary || this._target is Array || this._target is Vector.<*> || this._target is Vector.<uint> || this._target is Vector.<int> || this._target is Vector.<Number> || this._target is Vector.<Boolean>))
         {
            this._properties = new Array();
            for(_loc2_ in this._target)
            {
               this._properties.push(_loc2_);
            }
         }
         if(param1 < this._properties.length)
         {
            return param1 + 1;
         }
         return 0;
      }
      
      override flash_proxy function nextValue(param1:int) : *
      {
         var _loc2_:* = this._properties[param1 - 1];
         var _loc3_:* = this._target[_loc2_];
         switch(true)
         {
            case _loc3_ == null:
            case _loc3_ is uint:
            case _loc3_ is int:
            case _loc3_ is Number:
            case _loc3_ is String:
            case _loc3_ is Boolean:
            case _loc3_ == undefined:
               return _loc3_;
            default:
               return secure(_loc3_);
         }
      }
      
      override flash_proxy function nextName(param1:int) : String
      {
         return this._properties[param1 - 1];
      }
   }
}
