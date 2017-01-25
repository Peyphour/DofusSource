package org.as3commons.lang.typedescription
{
   import avmplus.DescribeType;
   import avmplus.getQualifiedClassName;
   import org.as3commons.lang.Access;
   import org.as3commons.lang.ArrayUtils;
   import org.as3commons.lang.ClassUtils;
   import org.as3commons.lang.ITypeDescription;
   import org.as3commons.lang.StringUtils;
   
   public class JSONTypeDescription implements ITypeDescription
   {
      
      private static var _describeTypeJSON:Function = DescribeType.getJSONFunction();
       
      
      private var _clazz:Class;
      
      private var _instanceInfo:Object;
      
      private var _classInfo:Object;
      
      public function JSONTypeDescription(param1:Class)
      {
         super();
         this._clazz = param1;
         this._instanceInfo = _describeTypeJSON(param1,DescribeType.GET_INSTANCE_INFO);
         this._classInfo = _describeTypeJSON(param1,DescribeType.GET_CLASS_INFO);
      }
      
      public function get clazz() : Class
      {
         return this._clazz;
      }
      
      public function get instanceInfo() : *
      {
         return this._instanceInfo;
      }
      
      public function get classInfo() : *
      {
         return this._classInfo;
      }
      
      public function isImplementationOf(param1:Class) : Boolean
      {
         var _loc2_:Boolean = false;
         var _loc3_:String = null;
         var _loc4_:Array = null;
         if(this.clazz == null)
         {
            _loc2_ = false;
            return _loc2_;
         }
         _loc3_ = getQualifiedClassName(param1);
         _loc4_ = this.instanceInfo.traits.interfaces;
         return ArrayUtils.contains(_loc4_,_loc3_);
      }
      
      public function isInformalImplementationOf(param1:Class) : Boolean
      {
         var _loc3_:Object = null;
         var _loc4_:Array = null;
         var _loc5_:XML = null;
         var _loc6_:Array = null;
         var _loc7_:Object = null;
         var _loc8_:Array = null;
         var _loc9_:Array = null;
         var _loc10_:Array = null;
         var _loc11_:Array = null;
         var _loc12_:int = 0;
         var _loc13_:Object = null;
         var _loc14_:Array = null;
         var _loc2_:Boolean = true;
         if(param1 == null)
         {
            _loc2_ = false;
         }
         else
         {
            _loc3_ = new JSONTypeDescription(param1).instanceInfo;
            _loc4_ = _loc3_.traits.accessors;
            for each(_loc5_ in _loc4_)
            {
               _loc8_ = this.getMembers(this.instanceInfo.traits.accessors,_loc5_.name,_loc5_.access,_loc5_.type);
               if(ArrayUtils.isEmpty(_loc8_))
               {
                  _loc2_ = false;
                  break;
               }
            }
            _loc6_ = _loc3_.traits.methods;
            for each(_loc7_ in _loc6_)
            {
               _loc9_ = this.getMethods(this.instanceInfo.traits.methods,_loc7_.name,_loc7_.returnType);
               if(ArrayUtils.isEmpty(_loc9_))
               {
                  _loc2_ = false;
                  break;
               }
               _loc10_ = _loc7_.parameters;
               _loc11_ = _loc9_[0].parameters;
               if(_loc10_.length != _loc11_.length)
               {
                  _loc2_ = false;
               }
               _loc12_ = 0;
               while(_loc12_ < _loc10_.length)
               {
                  _loc13_ = _loc10_[_loc12_];
                  _loc14_ = this.getParameters(_loc11_,_loc12_,_loc13_.type,_loc13_.optional);
                  if(ArrayUtils.isEmpty(_loc14_))
                  {
                     _loc2_ = false;
                     break;
                  }
                  _loc12_++;
               }
            }
         }
         return _loc2_;
      }
      
      public function isSubclassOf(param1:Class) : Boolean
      {
         var _loc2_:String = getQualifiedClassName(param1);
         var _loc3_:Array = this.instanceInfo.traits.bases;
         return ArrayUtils.contains(_loc3_,_loc2_);
      }
      
      public function isInterface() : Boolean
      {
         return this.clazz === Object?false:Boolean(ArrayUtils.isEmpty(this.instanceInfo.traits.bases));
      }
      
      public function getFullyQualifiedImplementedInterfaceNames(param1:Boolean = false) : Array
      {
         var _loc4_:int = 0;
         var _loc6_:String = null;
         var _loc2_:Array = [];
         var _loc3_:Array = this.instanceInfo.traits.interfaces;
         if(!_loc3_)
         {
            return _loc2_;
         }
         var _loc5_:int = _loc3_.length;
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = _loc3_[_loc4_];
            if(param1)
            {
               _loc6_ = ClassUtils.convertFullyQualifiedName(_loc6_);
            }
            _loc2_[_loc2_.length] = _loc6_;
            _loc4_++;
         }
         return _loc2_;
      }
      
      public function getProperties(param1:Boolean = false, param2:Boolean = true, param3:Boolean = true) : Object
      {
         var properties:Array = null;
         var node:Object = null;
         var nodeClass:Class = null;
         var statik:Boolean = param1;
         var readable:Boolean = param2;
         var writable:Boolean = param3;
         var info:Object = !!statik?this.classInfo:this.instanceInfo;
         if(readable && writable)
         {
            properties = this.getMembers(info.traits.accessors,Access.READ_WRITE).concat(this.getMembers(info.traits.variables,Access.READ_WRITE));
         }
         else if(!readable && !writable)
         {
            properties = [];
         }
         else if(!writable)
         {
            properties = this.getMembers(info.traits.accessors,Access.READ_ONLY).concat(this.getMembers(info.traits.variables,Access.READ_ONLY));
         }
         else
         {
            properties = this.getMembers(info.traits.accessors,Access.WRITE_ONLY).concat(this.getMembers(info.traits.variables,Access.WRITE_ONLY));
         }
         var result:Object = {};
         for each(node in properties)
         {
            try
            {
               nodeClass = ClassUtils.forName(node.type);
            }
            catch(e:Error)
            {
               nodeClass = Object;
            }
            if(node.uri && QName(node.uri).localName != "")
            {
               result[node.uri + "::" + node.name] = nodeClass;
            }
            else
            {
               result[node.name] = nodeClass;
            }
         }
         return result;
      }
      
      public function getSuperClass() : Class
      {
         var _loc1_:Class = null;
         var _loc2_:Array = this.instanceInfo.traits.bases;
         if(ArrayUtils.isNotEmpty(_loc2_))
         {
            _loc1_ = ClassUtils.forName(_loc2_[0]);
         }
         return _loc1_;
      }
      
      private function getMembers(param1:Array, param2:String = null, param3:String = null, param4:String = null) : Array
      {
         var _loc6_:int = 0;
         var _loc8_:Object = null;
         var _loc9_:Boolean = false;
         var _loc10_:Boolean = false;
         var _loc11_:Boolean = false;
         var _loc5_:Array = [];
         if(!param1)
         {
            return _loc5_;
         }
         var _loc7_:int = param1.length;
         _loc6_ = 0;
         while(_loc6_ < _loc7_)
         {
            _loc8_ = param1[_loc6_];
            _loc9_ = !!StringUtils.isNotEmpty(param3)?_loc8_.name == param3:true;
            _loc10_ = !!StringUtils.isNotEmpty(param2)?_loc8_.access == param2:true;
            _loc11_ = !!StringUtils.isNotEmpty(param4)?_loc8_.type == param4:true;
            if(_loc9_ && _loc10_ && _loc11_)
            {
               _loc5_[_loc5_.length] = _loc8_;
            }
            _loc6_++;
         }
         return _loc5_;
      }
      
      private function getMethods(param1:Array, param2:String = null, param3:String = null) : Array
      {
         var _loc5_:int = 0;
         var _loc7_:Object = null;
         var _loc8_:Boolean = false;
         var _loc9_:Boolean = false;
         var _loc4_:Array = [];
         if(!param1)
         {
            return _loc4_;
         }
         var _loc6_:int = param1.length;
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            _loc7_ = param1[_loc5_];
            _loc8_ = !!StringUtils.isNotEmpty(param2)?_loc7_.name == param2:true;
            _loc9_ = !!StringUtils.isNotEmpty(param3)?_loc7_.returnType == param3:true;
            if(_loc8_ && _loc9_)
            {
               _loc4_[_loc4_.length] = _loc7_;
            }
            _loc5_++;
         }
         return _loc4_;
      }
      
      private function getParameters(param1:Array, param2:int, param3:String, param4:Boolean = false) : Array
      {
         var _loc6_:int = 0;
         var _loc8_:Object = null;
         var _loc9_:* = false;
         var _loc10_:Boolean = false;
         var _loc11_:* = false;
         var _loc5_:Array = [];
         if(!param1)
         {
            return _loc5_;
         }
         var _loc7_:int = param1.length;
         _loc6_ = 0;
         while(_loc6_ < _loc7_)
         {
            _loc8_ = param1[_loc6_];
            _loc9_ = param2 == _loc6_;
            _loc10_ = !!StringUtils.isNotEmpty(param3)?_loc8_.type == param3:true;
            _loc11_ = _loc8_.optional == param4;
            if(_loc9_ && _loc10_ && _loc11_)
            {
               _loc5_[_loc5_.length] = _loc8_;
            }
            _loc6_++;
         }
         return _loc5_;
      }
   }
}
