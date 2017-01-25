package org.as3commons.lang
{
   import flash.events.TimerEvent;
   import flash.system.ApplicationDomain;
   import flash.utils.Proxy;
   import flash.utils.Timer;
   import flash.utils.getQualifiedClassName;
   import flash.utils.getQualifiedSuperclassName;
   
   public final class ClassUtils
   {
      
      public static const CLEAR_CACHE_INTERVAL:uint = 60000;
      
      public static var clearCacheInterval:uint = CLEAR_CACHE_INTERVAL;
      
      private static var _clearCacheIntervalEnabled:Boolean = true;
      
      private static const AS3VEC_SUFFIX:String = "__AS3__.vec";
      
      private static const CONSTRUCTOR_FIELD_NAME:String = "constructor";
      
      private static const LESS_THAN:String = "<";
      
      private static const PACKAGE_CLASS_SEPARATOR:String = "::";
      
      private static var _typeDescriptionCache:Object = {};
      
      private static var _timer:Timer;
       
      
      public function ClassUtils()
      {
         super();
      }
      
      public static function get clearCacheIntervalEnabled() : Boolean
      {
         return _clearCacheIntervalEnabled;
      }
      
      public static function set clearCacheIntervalEnabled(param1:Boolean) : void
      {
         _clearCacheIntervalEnabled = param1;
         if(!_clearCacheIntervalEnabled)
         {
            stopTimer();
         }
      }
      
      public static function clearDescribeTypeCache() : void
      {
         _typeDescriptionCache = {};
         stopTimer();
      }
      
      public static function convertFullyQualifiedName(param1:String) : String
      {
         return param1.replace(PACKAGE_CLASS_SEPARATOR,".");
      }
      
      public static function forInstance(param1:*, param2:ApplicationDomain = null) : Class
      {
         var _loc3_:String = null;
         if(!(param1 is Proxy) && param1.hasOwnProperty(CONSTRUCTOR_FIELD_NAME))
         {
            return param1[CONSTRUCTOR_FIELD_NAME];
         }
         _loc3_ = getQualifiedClassName(param1);
         return forName(_loc3_,param2);
      }
      
      public static function forName(param1:String, param2:ApplicationDomain = null) : Class
      {
         var result:Class = null;
         var name:String = param1;
         var applicationDomain:ApplicationDomain = param2;
         applicationDomain = applicationDomain || ApplicationDomain.currentDomain;
         while(!applicationDomain.hasDefinition(name))
         {
            if(applicationDomain.parentDomain)
            {
               applicationDomain = applicationDomain.parentDomain;
               continue;
            }
            break;
         }
         try
         {
            result = applicationDomain.getDefinition(name) as Class;
         }
         catch(e:ReferenceError)
         {
            throw new ClassNotFoundError("A class with the name \'" + name + "\' could not be found.");
         }
         return result;
      }
      
      public static function getClassParameterFromFullyQualifiedName(param1:String, param2:ApplicationDomain = null) : Class
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         if(StringUtils.startsWith(param1,AS3VEC_SUFFIX))
         {
            _loc3_ = param1.indexOf(LESS_THAN) + 1;
            _loc4_ = param1.length - _loc3_ - 1;
            _loc5_ = param1.substr(_loc3_,_loc4_);
            return forName(_loc5_,param2);
         }
         return null;
      }
      
      public static function getFullyQualifiedImplementedInterfaceNames(param1:Class, param2:Boolean = false, param3:ApplicationDomain = null) : Array
      {
         var _loc4_:ITypeDescription = getTypeDescription(param1,param3);
         return _loc4_.getFullyQualifiedImplementedInterfaceNames(param2);
      }
      
      public static function getFullyQualifiedName(param1:Class, param2:Boolean = false) : String
      {
         var _loc3_:String = getQualifiedClassName(param1);
         if(param2)
         {
            return convertFullyQualifiedName(_loc3_);
         }
         return _loc3_;
      }
      
      public static function getFullyQualifiedSuperClassName(param1:Class, param2:Boolean = false) : String
      {
         var _loc3_:String = getQualifiedSuperclassName(param1);
         if(param2)
         {
            _loc3_ = convertFullyQualifiedName(_loc3_);
         }
         return _loc3_;
      }
      
      public static function getImplementedInterfaceNames(param1:Class) : Array
      {
         var _loc2_:Array = getFullyQualifiedImplementedInterfaceNames(param1);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            _loc2_[_loc3_] = getNameFromFullyQualifiedName(_loc2_[_loc3_]);
            _loc3_++;
         }
         return _loc2_;
      }
      
      public static function getImplementedInterfaces(param1:Class, param2:ApplicationDomain = null) : Array
      {
         param2 = param2 || ApplicationDomain.currentDomain;
         var _loc3_:Array = getFullyQualifiedImplementedInterfaceNames(param1);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_.length)
         {
            _loc3_[_loc4_] = ClassUtils.forName(_loc3_[_loc4_],param2);
            _loc4_++;
         }
         return _loc3_;
      }
      
      public static function getName(param1:Class) : String
      {
         return getNameFromFullyQualifiedName(getFullyQualifiedName(param1));
      }
      
      public static function getNameFromFullyQualifiedName(param1:String) : String
      {
         var _loc2_:int = param1.indexOf(PACKAGE_CLASS_SEPARATOR);
         if(_loc2_ == -1)
         {
            return param1;
         }
         return param1.substring(_loc2_ + PACKAGE_CLASS_SEPARATOR.length,param1.length);
      }
      
      public static function getProperties(param1:*, param2:Boolean = false, param3:Boolean = true, param4:Boolean = true, param5:ApplicationDomain = null) : Object
      {
         var _loc6_:ITypeDescription = getTypeDescription(param1,param5);
         return _loc6_.getProperties(param2,param3,param4);
      }
      
      public static function getSuperClass(param1:Class, param2:ApplicationDomain = null) : Class
      {
         var _loc3_:ITypeDescription = getTypeDescription(param1,param2);
         return _loc3_.getSuperClass();
      }
      
      public static function getSuperClassName(param1:Class) : String
      {
         var _loc2_:String = getFullyQualifiedSuperClassName(param1);
         var _loc3_:int = _loc2_.indexOf(PACKAGE_CLASS_SEPARATOR) + PACKAGE_CLASS_SEPARATOR.length;
         return _loc2_.substring(_loc3_,_loc2_.length);
      }
      
      public static function isAssignableFrom(param1:Class, param2:Class, param3:ApplicationDomain = null) : Boolean
      {
         return param1 === param2 || isSubclassOf(param2,param1,param3) || isImplementationOf(param2,param1,param3);
      }
      
      public static function isImplementationOf(param1:Class, param2:Class, param3:ApplicationDomain = null) : Boolean
      {
         var _loc4_:ITypeDescription = getTypeDescription(param1,param3);
         return _loc4_.isImplementationOf(param2);
      }
      
      public static function isInformalImplementationOf(param1:Class, param2:Class, param3:ApplicationDomain = null) : Boolean
      {
         var _loc4_:ITypeDescription = getTypeDescription(param1,param3);
         return _loc4_.isInformalImplementationOf(param2);
      }
      
      public static function isInterface(param1:Class) : Boolean
      {
         var _loc2_:ITypeDescription = getTypeDescription(param1,ApplicationDomain.currentDomain);
         return _loc2_.isInterface();
      }
      
      public static function isPrivateClass(param1:*) : Boolean
      {
         var _loc2_:String = param1 is Class?getQualifiedClassName(param1):param1.toString();
         var _loc3_:int = _loc2_.indexOf("::");
         var _loc4_:* = _loc3_ == -1;
         if(_loc4_)
         {
            return false;
         }
         var _loc5_:String = _loc2_.substr(0,_loc3_);
         return _loc5_ === "" || _loc5_.indexOf(".as$") > -1;
      }
      
      public static function isSubclassOf(param1:Class, param2:Class, param3:ApplicationDomain = null) : Boolean
      {
         var _loc4_:ITypeDescription = getTypeDescription(param1,param3);
         return _loc4_.isSubclassOf(param2);
      }
      
      public static function newInstance(param1:Class, param2:Array = null) : *
      {
         var _loc3_:* = undefined;
         var _loc4_:Array = param2 == null?[]:param2;
         switch(_loc4_.length)
         {
            case 1:
               _loc3_ = new param1(_loc4_[0]);
               break;
            case 2:
               _loc3_ = new param1(_loc4_[0],_loc4_[1]);
               break;
            case 3:
               _loc3_ = new param1(_loc4_[0],_loc4_[1],_loc4_[2]);
               break;
            case 4:
               _loc3_ = new param1(_loc4_[0],_loc4_[1],_loc4_[2],_loc4_[3]);
               break;
            case 5:
               _loc3_ = new param1(_loc4_[0],_loc4_[1],_loc4_[2],_loc4_[3],_loc4_[4]);
               break;
            case 6:
               _loc3_ = new param1(_loc4_[0],_loc4_[1],_loc4_[2],_loc4_[3],_loc4_[4],_loc4_[5]);
               break;
            case 7:
               _loc3_ = new param1(_loc4_[0],_loc4_[1],_loc4_[2],_loc4_[3],_loc4_[4],_loc4_[5],_loc4_[6]);
               break;
            case 8:
               _loc3_ = new param1(_loc4_[0],_loc4_[1],_loc4_[2],_loc4_[3],_loc4_[4],_loc4_[5],_loc4_[6],_loc4_[7]);
               break;
            case 9:
               _loc3_ = new param1(_loc4_[0],_loc4_[1],_loc4_[2],_loc4_[3],_loc4_[4],_loc4_[5],_loc4_[6],_loc4_[7],_loc4_[8]);
               break;
            case 10:
               _loc3_ = new param1(_loc4_[0],_loc4_[1],_loc4_[2],_loc4_[3],_loc4_[4],_loc4_[5],_loc4_[6],_loc4_[7],_loc4_[8],_loc4_[9]);
               break;
            default:
               _loc3_ = new param1();
         }
         return _loc3_;
      }
      
      public static function getTypeDescription(param1:Object, param2:ApplicationDomain) : ITypeDescription
      {
         var _loc4_:ITypeDescription = null;
         Assert.notNull(param1,"The clazz argument must not be null");
         var _loc3_:String = getQualifiedClassName(param1);
         if(_typeDescriptionCache.hasOwnProperty(_loc3_))
         {
            _loc4_ = _typeDescriptionCache[_loc3_];
         }
         else
         {
            if(!_timer && clearCacheIntervalEnabled)
            {
               _timer = new Timer(clearCacheInterval,1);
               _timer.addEventListener(TimerEvent.TIMER,timerHandler);
            }
            if(!(param1 is Class))
            {
               if(param1.hasOwnProperty(CONSTRUCTOR_FIELD_NAME))
               {
                  param1 = param1.constructor;
               }
               else
               {
                  param1 = forName(_loc3_,param2);
               }
            }
            _loc4_ = TypeDescriptor.getTypeDescriptionForClass(param1 as Class);
            _typeDescriptionCache[_loc3_] = _loc4_;
            if(_timer && !_timer.running)
            {
               _timer.start();
            }
         }
         return _loc4_;
      }
      
      private static function stopTimer() : void
      {
         if(_timer && _timer.running)
         {
            _timer.stop();
         }
      }
      
      private static function timerHandler(param1:TimerEvent) : void
      {
         clearDescribeTypeCache();
      }
   }
}
