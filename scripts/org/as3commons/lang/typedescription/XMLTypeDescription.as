package org.as3commons.lang.typedescription
{
   import flash.utils.describeType;
   import flash.utils.getQualifiedClassName;
   import org.as3commons.lang.ClassUtils;
   import org.as3commons.lang.ITypeDescription;
   
   public class XMLTypeDescription implements ITypeDescription
   {
       
      
      private var _clazz:Class;
      
      private var _instanceInfo:XML;
      
      private var _classInfo:XML;
      
      public function XMLTypeDescription(param1:Class)
      {
         super();
         this._clazz = param1;
         this._classInfo = describeType(param1);
         this._instanceInfo = this._classInfo.factory[0];
      }
      
      public function get clazz() : Class
      {
         return this._clazz;
      }
      
      public function get classInfo() : *
      {
         return this._classInfo;
      }
      
      public function get instanceInfo() : *
      {
         return this._instanceInfo;
      }
      
      public function isImplementationOf(param1:Class) : Boolean
      {
         var result:Boolean = false;
         var interfaze:Class = param1;
         if(this.clazz == null)
         {
            result = false;
         }
         else
         {
            result = this.instanceInfo.implementsInterface.(@type == getQualifiedClassName(interfaze)).length() != 0;
         }
         return result;
      }
      
      public function isInformalImplementationOf(param1:Class) : Boolean
      {
         var interfaceInstanceInfo:XML = null;
         var interfaceAccessors:XMLList = null;
         var interfaceAccessor:XML = null;
         var interfaceMethods:XMLList = null;
         var interfaceMethod:XML = null;
         var accessorMatchesInClass:XMLList = null;
         var methodMatchesInClass:XMLList = null;
         var interfaceMethodParameters:XMLList = null;
         var classMethodParameters:XMLList = null;
         var interfaceParameter:XML = null;
         var parameterMatchesInClass:XMLList = null;
         var interfaze:Class = param1;
         var result:Boolean = true;
         if(interfaze == null)
         {
            result = false;
         }
         else
         {
            interfaceInstanceInfo = new XMLTypeDescription(interfaze).instanceInfo;
            interfaceAccessors = interfaceInstanceInfo.accessor;
            for each(interfaceAccessor in interfaceAccessors)
            {
               accessorMatchesInClass = this.instanceInfo.accessor.(@name == interfaceAccessor.@name && @access == interfaceAccessor.@access && @type == interfaceAccessor.@type);
               if(accessorMatchesInClass.length() < 1)
               {
                  result = false;
                  break;
               }
            }
            interfaceMethods = interfaceInstanceInfo.method;
            for each(interfaceMethod in interfaceMethods)
            {
               methodMatchesInClass = this.instanceInfo.method.(@name == interfaceMethod.@name && @returnType == interfaceMethod.@returnType);
               if(methodMatchesInClass.length() < 1)
               {
                  result = false;
                  break;
               }
               interfaceMethodParameters = interfaceMethod.parameter;
               classMethodParameters = methodMatchesInClass.parameter;
               if(interfaceMethodParameters.length() != classMethodParameters.length())
               {
                  result = false;
               }
               for each(interfaceParameter in interfaceMethodParameters)
               {
                  parameterMatchesInClass = methodMatchesInClass.parameter.(@index == interfaceParameter.@index && @type == interfaceParameter.@type && @optional == interfaceParameter.@optional);
                  if(parameterMatchesInClass.length() < 1)
                  {
                     result = false;
                     break;
                  }
               }
            }
         }
         return result;
      }
      
      public function isSubclassOf(param1:Class) : Boolean
      {
         var parentClass:Class = param1;
         var parentName:String = getQualifiedClassName(parentClass);
         return this.instanceInfo.extendsClass.(@type == parentName).length() != 0;
      }
      
      public function isInterface() : Boolean
      {
         return this.clazz === Object?false:this.instanceInfo.extendsClass.length() == 0;
      }
      
      public function getFullyQualifiedImplementedInterfaceNames(param1:Boolean = false) : Array
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         var _loc2_:Array = [];
         var _loc3_:XMLList = this.instanceInfo.implementsInterface;
         if(_loc3_)
         {
            _loc4_ = _loc3_.length();
            _loc5_ = 0;
            while(_loc5_ < _loc4_)
            {
               _loc6_ = _loc3_[_loc5_].@type.toString();
               if(param1)
               {
                  _loc6_ = ClassUtils.convertFullyQualifiedName(_loc6_);
               }
               _loc2_[_loc2_.length] = _loc6_;
               _loc5_++;
            }
         }
         return _loc2_;
      }
      
      public function getProperties(param1:Boolean = false, param2:Boolean = true, param3:Boolean = true) : Object
      {
         var properties:XMLList = null;
         var result:Object = null;
         var node:XML = null;
         var nodeClass:Class = null;
         var statik:Boolean = param1;
         var readable:Boolean = param2;
         var writable:Boolean = param3;
         var xml:XML = !!statik?this.classInfo:this.instanceInfo;
         if(readable && writable)
         {
            properties = xml.accessor.(@access == Access.READ_WRITE) + xml.variable;
         }
         else if(!readable && !writable)
         {
            properties = new XMLList();
         }
         else if(!writable)
         {
            properties = xml.constant + xml.accessor.(@access == Access.READ_ONLY);
         }
         else
         {
            properties = xml.accessor.(@access == Access.WRITE_ONLY);
         }
         result = {};
         for each(node in properties)
         {
            try
            {
               nodeClass = ClassUtils.forName(node.@type);
            }
            catch(e:Error)
            {
               nodeClass = Object;
            }
            if(node.@uri && QName(node.@uri).localName != "")
            {
               result[node.@uri + "::" + node.@name] = nodeClass;
            }
            else
            {
               result[node.@name] = nodeClass;
            }
         }
         return result;
      }
      
      public function getSuperClass() : Class
      {
         var _loc1_:Class = null;
         var _loc2_:XMLList = this.instanceInfo.extendsClass;
         if(_loc2_.length() > 0)
         {
            _loc1_ = ClassUtils.forName(_loc2_[0].@type);
         }
         return _loc1_;
      }
   }
}
