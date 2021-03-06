package org.as3commons.bytecode.abc
{
   import org.as3commons.bytecode.abc.enum.MultinameKind;
   import org.as3commons.lang.StringUtils;
   
   public final class Multiname extends NamedMultiname
   {
       
      
      private var _namespaceSet:NamespaceSet;
      
      public function Multiname(param1:String, param2:NamespaceSet, param3:MultinameKind = null)
      {
         param3 = !!param3?param3:MultinameKind.MULTINAME;
         super(param3,param1);
         assertAppropriateMultinameKind([MultinameKind.MULTINAME,MultinameKind.MULTINAME_A],param3);
         this._namespaceSet = param2;
      }
      
      public function get namespaceSet() : NamespaceSet
      {
         return this._namespaceSet;
      }
      
      override public function equals(param1:Object) : Boolean
      {
         var _loc3_:Multiname = null;
         var _loc2_:Boolean = false;
         if(param1 is Multiname)
         {
            _loc3_ = Multiname(param1);
            if(_loc3_.namespaceSet)
            {
               if(_loc3_.namespaceSet.equals(this.namespaceSet))
               {
                  if(super.equals(param1))
                  {
                     _loc2_ = true;
                  }
               }
            }
         }
         return _loc2_;
      }
      
      override public function toString() : String
      {
         return StringUtils.substitute("{0}[name={1}, nsset={2}]",kind.description,name,this.namespaceSet);
      }
   }
}
