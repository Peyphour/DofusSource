package d2components
{
   import flash.errors.IllegalOperationError;
   import flash.events.Event;
   import flash.geom.Transform;
   import flash.system.ApplicationDomain;
   import flash.text.TextField;
   import flash.utils.Dictionary;
   import flash.utils.Proxy;
   import flash.utils.flash_proxy;
   import flash.utils.getQualifiedClassName;
   import utils.Secure;
   
   public class SecureComponent extends Proxy implements Secure
   {
      
      private static var _accessKey:Object;
      
      private static var unsecureContent:Function;
      
      private static var secure:Function;
      
      private static var unsecure:Function;
      
      private static var getVariables:Function;
      
      private static var _secureComponents:Dictionary = new Dictionary(true);
      
      private static var _classDefinitionsCache:Dictionary = new Dictionary(true);
      
      private static var _newInstanceIsTrusted:Boolean;
       
      
      protected var _localApplicationDomain:ApplicationDomain;
      
      protected var _component:Object;
      
      protected var _trusted:Boolean;
      
      protected var _properties:Array;
      
      public function SecureComponent(param1:Object, param2:Object)
      {
         super();
         if(param2 != _accessKey)
         {
            throw new IllegalOperationError();
         }
         this._component = param1;
         this._trusted = _newInstanceIsTrusted;
      }
      
      public static function init(param1:Object, param2:Function, param3:Function, param4:Function, param5:Function) : void
      {
         if(_accessKey)
         {
            throw new IllegalOperationError();
         }
         SecureComponent.unsecureContent = param2;
         SecureComponent.secure = param3;
         SecureComponent.unsecure = param4;
         SecureComponent.getVariables = param5;
         _accessKey = param1;
      }
      
      public static function getSecureComponent(param1:Object, param2:Boolean, param3:ApplicationDomain, param4:Object) : SecureComponent
      {
         var _loc5_:* = null;
         var _loc6_:SecureComponent = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc9_:Class = null;
         if(param4 != _accessKey)
         {
            throw new IllegalOperationError();
         }
         if(param1 is SecureComponent)
         {
            return param1 as SecureComponent;
         }
         for(_loc5_ in _secureComponents)
         {
            _loc6_ = _loc5_ as SecureComponent;
            if(_loc6_._component == param1)
            {
               return _loc6_;
            }
         }
         _loc7_ = getQualifiedClassName(param1);
         _loc7_ = _loc7_.substr(_loc7_.indexOf("::") + 2);
         _newInstanceIsTrusted = param2;
         _loc8_ = "d2components::" + _loc7_;
         if(_classDefinitionsCache[_loc8_])
         {
            _loc9_ = _classDefinitionsCache[_loc8_];
         }
         else if(ApplicationDomain.currentDomain.hasDefinition(_loc8_))
         {
            _classDefinitionsCache[_loc8_] = ApplicationDomain.currentDomain.getDefinition(_loc8_);
            _loc9_ = _classDefinitionsCache[_loc8_];
         }
         else
         {
            _loc9_ = SecureComponent;
         }
         var _loc10_:SecureComponent = new _loc9_(param1,_accessKey);
         _newInstanceIsTrusted = false;
         _loc10_._localApplicationDomain = param3;
         _secureComponents[_loc10_] = null;
         return _loc10_;
      }
      
      public static function destroy(param1:Object, param2:Object) : void
      {
         var _loc3_:* = null;
         var _loc4_:SecureComponent = null;
         if(param2 !== _accessKey)
         {
            throw IllegalOperationError("Wrong access key");
         }
         for(_loc3_ in _secureComponents)
         {
            _loc4_ = _loc3_ as SecureComponent;
            if(_loc4_._component == param1)
            {
               _loc4_._component = null;
               delete _secureComponents[param1];
               return;
            }
         }
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         throw new IllegalOperationError("Opération interdite");
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         throw new IllegalOperationError("Opération interdite");
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         throw new IllegalOperationError("Opération interdite");
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         throw new IllegalOperationError("Opération interdite");
      }
      
      public function get contextMenu() : *
      {
         throw new IllegalOperationError("Opération interdite");
      }
      
      public function set contextMenu(param1:*) : void
      {
         throw new IllegalOperationError("Opération interdite");
      }
      
      public function get loaderInfo() : *
      {
         throw new IllegalOperationError("Opération interdite");
      }
      
      public function addChild(param1:*) : *
      {
         return secure(this._component.addChild(unsecure(param1)));
      }
      
      public function removeChild(param1:*) : *
      {
         return secure(this._component.removeChild(unsecure(param1)));
      }
      
      public function get isNull() : Boolean
      {
         if(this._component)
         {
            if(this._component.hasOwnProperty("isNull"))
            {
               return this._component[this.isNull];
            }
            return false;
         }
         return true;
      }
      
      override flash_proxy function callProperty(param1:*, ... rest) : *
      {
         var _loc3_:Array = unsecureContent(rest);
         var _loc4_:* = this._component[param1].apply(this._component[param1],_loc3_);
         return secure(_loc4_);
      }
      
      override flash_proxy function hasProperty(param1:*) : Boolean
      {
         if(!this._component)
         {
            return false;
         }
         return this._component.hasOwnProperty(param1);
      }
      
      override flash_proxy function getProperty(param1:*) : *
      {
         if(!this._component)
         {
            return null;
         }
         var _loc2_:* = this._component[param1];
         if(_loc2_ is Transform)
         {
            return _loc2_;
         }
         if(_loc2_ is TextField)
         {
            if(this._trusted)
            {
               return _loc2_;
            }
            return secure(_loc2_);
         }
         if(this._localApplicationDomain && this._localApplicationDomain.hasDefinition(getQualifiedClassName(_loc2_)) && _loc2_ is (this._localApplicationDomain.getDefinition(getQualifiedClassName(_loc2_)) as Class) && !(_loc2_ is Array || _loc2_ is Dictionary || _loc2_ is Vector || getQualifiedClassName(_loc2_) == "Object"))
         {
            return _loc2_;
         }
         return secure(_loc2_);
      }
      
      override flash_proxy function setProperty(param1:*, param2:*) : void
      {
         if(!this._component)
         {
            return;
         }
         var _loc3_:* = unsecure(param2);
         this._component[param1] = _loc3_;
      }
      
      override flash_proxy function nextNameIndex(param1:int) : int
      {
         if(param1 == 0 && !this._properties)
         {
            this._properties = getVariables(this._component);
         }
         if(param1 < this._properties.length)
         {
            return param1 + 1;
         }
         return 0;
      }
      
      override flash_proxy function nextName(param1:int) : String
      {
         return this._properties[param1 - 1];
      }
      
      public function getObject(param1:Object) : Object
      {
         if(param1 !== _accessKey)
         {
            throw IllegalOperationError("Wrong access key");
         }
         return this._component;
      }
   }
}
