package org.as3commons.lang
{
   import org.as3commons.lang.typedescription.JSONTypeDescription;
   import org.as3commons.lang.typedescription.XMLTypeDescription;
   
   public class TypeDescriptor
   {
      
      public static var typeDescriptionKind:TypeDescriptionKind = TypeDescriptionKind.JSON;
       
      
      public function TypeDescriptor()
      {
         super();
      }
      
      public static function getTypeDescriptionForClass(param1:Class) : ITypeDescription
      {
         var _loc2_:ITypeDescription = null;
         if(typeDescriptionKind == TypeDescriptionKind.JSON)
         {
            try
            {
               _loc2_ = new JSONTypeDescription(param1);
            }
            catch(e:*)
            {
            }
         }
         if(!_loc2_)
         {
            _loc2_ = new XMLTypeDescription(param1);
         }
         return _loc2_;
      }
   }
}
