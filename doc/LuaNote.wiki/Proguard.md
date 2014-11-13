###Processing serializable classes

* ``More complex applications, applets, servlets, libraries, etc., may contain classes that are serialized. Depending on the way in which they are used, they may require special attention:
Often, serialization is simply a means of transporting data, without long-term storage. Classes that are shrunk and obfuscated should then continue to function fine with the following additional options:

```
-keepclassmembers class * implements java.io.Serializable {
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}
```
The -keepclassmembers option makes sure that any serialization methods are kept. By using this option instead of the basic -keep option, we're not forcing preservation of all serializable classes, just preservation of the listed members of classes that are actually used.

* Sometimes, the serialized data are stored, and read back later into newer versions of the serializable classes. One then has to take care the classes remain compatible with their unprocessed versions and with future processed versions. In such cases, the relevant classes will most likely have serialVersionUID fields. The following options should then be sufficient to ensure compatibility over time:

```
-keepnames class * implements java.io.Serializable

-keepclassmembers class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    !static !transient <fields>;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}
```
The serialVersionUID and serialPersistentFields lines makes sure those fields are preserved, if they are present. The <fields> line preserves all non-static, non-transient fields, with their original names. The introspection of the serialization process and the de-serialization process will then find consistent names.

* Occasionally, the serialized data have to remain compatible, but the classes involved lack serialVersionUID fields. I imagine the original code will then be hard to maintain, since the serial version UID is then computed from a list of features the serializable class. Changing the class ever so slightly may change the computed serial version UID. The list of features is specified in the section on `Stream Unique Identifiers` of Sun's `Java Object Serialization Specification`. The following directives should at least partially ensure compatibility with the original classes:

```
-keepnames class * implements java.io.Serializable

-keepclassmembers class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    !static !transient <fields>;
    !private <fields>;
    !private <methods>;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}
```
* The new options force preservation of the elements involved in the UID computation. In addition, the user will have to manually specify all interfaces of the serializable classes (using something like "-keep interface MyInterface"), since these names are also used when computing the UID. A fast but sub-optimal alternative would be simply keeping all interfaces with "-keep interface *".

Note that the above options may preserve more classes and class members than strictly necessary. For instance, a large number of classes may implement the Serialization interface, yet only a small number may actually ever be serialized. Knowing your application and tuning the configuration often produces more compact results.

###Processing bean classes
```
-keep class mybeans.** {
    void set*(***);
    void set*(int, ***);

    boolean is*(); 
    boolean is*(int);

    *** get*();
    *** get*(int);
}

The '***' wildcard matches any type (primitive or non-primitive, array or non-array). The methods with the 'int' arguments matches properties that are lists.

example:


-keepclassmembers public class * extends android.view.View {
   void set*(***);
   *** get*();
}
```

###Processing annotations

If your application, applet, servlet, library, etc., uses annotations, you may want to preserve them in the processed output. Annotations are represented by attributes that have no direct effect on the execution of the code. However, their values can be retrieved through introspection, allowing developers to adapt the execution behavior accordingly. By default, ProGuard treats annotation attributes as optional, and removes them in the obfuscation step. If they are required, you'll have to specify this explicitly:

```
-keepattributes *Annotation*
```
	
For brevity, we're specifying a wildcarded attribute name, which will match RuntimeVisibleAnnotations, RuntimeInvisibleAnnotations, RuntimeVisibleParameterAnnotations, RuntimeInvisibleParameterAnnotations, and AnnotationDefault. Depending on the purpose of the processed code, you could refine this selection, for instance not keeping the run-time invisible annotations (which are only used at compile-time).

Some code may make further use of `introspection` to figure out the enclosing methods of anonymous inner classes. In that case, the corresponding attribute has to be preserved as well:

```
-keepattributes EnclosingMethod
```

###Producing useful obfuscated stack traces

```
-printmapping out.map

-renamesourcefileattribute SourceFile
-keepattributes SourceFile,LineNumberTable
```

###Obfuscating package names

```
-flattenpackagehierarchy 'myobfuscated' 
-repackageclasses 'myobfuscated'	#-repackageclasses ''
-allowaccessmodification

```
-allowaccessmodification option allows access permissions of classes and class members to be broadened, opening up the opportunity to repackage all obfuscated classes.

####native
```
# For native methods, see http://proguard.sourceforge.net/manual/examples.html#native
-keepclasseswithmembernames class * {
    native <methods>;
}
```

###R
```
-keepclassmembers class **.R$* {
    public static <fields>;
}
```

###keepattributes
```
-keepattributes Exceptions,InnerClasses,Signature,Deprecated,
                SourceFile,LineNumberTable,*Annotation*,EnclosingMethod
```
The "InnerClasses" attribute (or more precisely, its source name part) has to be preserved too, for any inner classes that can be referenced from outside the library. The javac compiler would be unable to find the inner classes otherwise.

The "Signature" attribute is required to be able to access generic types when compiling in JDK 5.0 and higher.

we're keeping the "Deprecated" attribute and the attributes for producing useful stack traces.

###keepparameternames
The -keepparameternames option keeps the parameter names in the "LocalVariableTable" and "LocalVariableTypeTable" attributes of public library methods. Some IDEs can present these names to the developers who use the library.
```
-keepparameternames
```

###Inner class

静态内部类


```
-keepattributes Exceptions,InnerClasses,...  
-keep class [packagename].A {  
    *;  
}  
-keep class [packagename].A$* {  
    *;  
}  
```

其中 A$* 表示所有A的内部类都保留下来，也可以如下使用：

```
-keepattributes Exceptions,InnerClasses,...  
-keep class com.xxx.A{ *; }  
-keep class com.xxx.A$B { *; }  
-keep class com.xxx.A$C { *; }  
```
这样可以根据需要只保留A的某一个内部类


以下是proguard文件一部分

```
#-keepattributes Exceptions,InnerClasses,Signature,Deprecated,SourceFile,LineNumberTable,*Annotation*,EnclosingMethod  
-keepattributes Exceptions,InnerClasses,...  
-keep class com.yulore.reverselookup.api.YuloreWindowConfiguration{ *; }  
-keep class com.yulore.reverselookup.api.YuloreWindowConfiguration$Builder{ *; }  
```

注意：第一行和第二行都可以解决问题

###enum

```
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}
```
###Filters过滤

ProGuard offers options with filters for many different aspects of the configuration: names of files, directories, classes, packages, attributes, optimizations, etc.
A filter is a list of comma-separated names that can contain wildcards. Only names that match an item on the list pass the filter. The supported wildcards depend on the type of names for which the filter is being used, but the following wildcards are typical:

```
?	matches any single character in a name.
*	matches any part of a name not containing the package separator or directory separator.
**	matches any part of a name, possibly containing any number of package separators or directory separators.
```

For example, `"foo,*bar"` matches the name foo and all names ending with bar.

Furthermore, a name can be preceded by a negating exclamation mark '!' to exclude the name from further attempts to match with subsequent names. So, if a name matches an item in the filter, it is accepted or rejected right away, depending on whether the item has a negator. If the name doesn't match the item, it is tested against the next item, and so on. It if doesn't match any items, it is accepted or rejected, depending on the whether the last item has a negator or not.

For example, `"!foobar,*bar"` matches all names ending with bar, except foobar.






###Keep Options

The various -keep options for shrinking and obfuscation may seem a bit confusing at first, but there's actually a pattern behind them. The following table summarizes how they are related:

|                         Keep                         | From being removed or renamed | From being renamed          |
|:----------------------------------------------------:|:-----------------------------:|-----------------------------|
| Classes and class members                            | -keep                         | -keepnames                  |
| Class members only                                   | -keepclassmembers             | -keepclassmembernames       |
| Classes and class members,  if class members present | -keepclasseswithmembers       | -keepclasseswithmembernames |

Each of these -keep options is of course followed by a specification of the classes and class members (fields and methods) to which it should be applied.

If you're not sure which option you need, you should probably simply use -keep. It will make sure the specified classes and class members are not removed in the shrinking step, and not renamed in the obfuscation step.

`attention	Always remember`:

* Specifying a class without class members only preserves the class as an entry point — any class members may then still be removed, optimized, or obfuscated.

* Specifying a class member only preserves the class member as an entry point — any associated code may still be optimized and adapted.


####Keep Option Modifiers

* allowshrinking
* 
Specifies that the entry points specified in the -keep option may be shrunk, even if they have to be preserved otherwise. That is, the entry points may be removed in the shrinking step, but if they are necessary after all, they may not be optimized or obfuscated.


* allowoptimization
* Specifies that the entry points specified in the -keep option may be optimized, even if they have to be preserved otherwise. That is, the entry points may be altered in the optimization step, but they may not be removed or obfuscated. This modifier is only useful for achieving unusual requirements.

* allowobfuscation
* Specifies that the entry points specified in the -keep option may be obfuscated, even if they have to be preserved otherwise. That is, the entry points may be renamed in the obfuscation step, but they may not be removed or optimized. This modifier is only useful for achieving unusual requirements.

###Class Specifications

A class specification is a template of classes and class members (fields and methods). It is used in the various -keep options and in the -assumenosideeffects option. The corresponding option is only applied to classes and class members that match the template.
The template was designed to look very Java-like, with some extensions for wildcards. To get a feel for the syntax, you should probably look at the examples, but this is an attempt at a complete formal definition:

```
[@annotationtype] [[!]public|final|abstract|@ ...] [!]interface|class|enum classname
    [extends|implements [@annotationtype] classname]
[{
    [@annotationtype] [[!]public|private|protected|static|volatile|transient ...] <fields> |
                                                                      (fieldtype fieldname);
    [@annotationtype] [[!]public|private|protected|static|synchronized|native|abstract|strictfp ...] <methods> |
                                                                                           <init>(argumenttype,...) |
                                                                                           classname(argumenttype,...) |
                                                                                           (returntype methodname(argumenttype,...));
    [@annotationtype] [[!]public|private|protected|static ... ] *;
    ...
}]
```
Square brackets `"[]"` mean that their contents are optional. Ellipsis dots `"..." `mean that any number of the preceding items may be specified. A vertical bar `"|" `delimits two alternatives. Non-bold parentheses` "()"` just group parts of the specification that belong together. The indentation tries to clarify the intended meaning, but white-space is irrelevant in actual configuration files.

The `class` keyword refers to any interface or class. The `interface` keyword restricts matches to interface classes. The `enum` keyword restricts matches to enumeration classes. Preceding the interface or enum keywords by a `!` restricts matches to classes that are not interfaces or enumerations, respectively.
Every classname must be fully qualified, e.g. java.lang.String. Class names may be specified as regular expressions containing the following wildcards:

```
?	matches any single character in a class name, but not the package separator. For example, "mypackage.Test?" matches "mypackage.Test1" and "mypackage.Test2", but not "mypackage.Test12".

*	matches any part of a class name not containing the package separator. For example, "mypackage.*Test*" matches "mypackage.Test" and "mypackage.YourTestApplication", but not "mypackage.mysubpackage.MyTest". Or, more generally, "mypackage.*" matches all classes in "mypackage", but not in its subpackages.
	
**	matches any part of a class name, possibly containing any number of package separators. For example, "**.Test" matches all Test classes in all packages except the root package. Or, "mypackage.**" matches all classes in "mypackage" and in its subpackages.
```

For additional flexibility, class names can actually be comma-separated lists of class names, with optional `! `negators, just like file name filters. This notation doesn't look very Java-like, so it should be used with moderation.
For convenience and for backward compatibility, the class name `*` refers to any class, irrespective of its package.

The `extends` and `implements` specifications are typically used to restrict classes with wildcards. They are currently equivalent, specifying that only classes extending or implementing the given class qualify. Note that the given class itself is not included in this set. If required, it should be specified in a separate option.

The `@` specifications can be used to restrict classes and class members to the ones that are annotated with the specified annotation types. An annotationtype is specified just like a classname.

Fields and methods are specified much like in Java, except that method argument lists don't contain argument names (just like in other tools like javadoc and javap). The specifications can also contain the following catch-all wildcards:

```
<init>	matches any constructor.
<fields>	matches any field.
<methods>	matches any method.
*	matches any field or method.
```

Note that the above wildcards don't have return types. Only the <init> wildcard has an argument list.

Fields and methods may also be specified using regular expressions. Names can contain the following wildcards:

```
?	matches any single character in a method name.
*	matches any part of a method name.
```

Types in descriptors can contain the following wildcards:

```
%	matches any primitive type ("boolean", "int", etc, but not "void").
?	matches any single character in a class name.
*	matches any part of a class name not containing the package separator.
**	matches any part of a class name, possibly containing any number of package separators.
***	matches any type (primitive or non-primitive, array or non-array).
...	matches any number of arguments of any type.
```

Note that the `?, *,` and `**` wildcards will never match primitive types. Furthermore, only the *** wildcards will match array types of any dimension. For example, `"** get*()"` matches `"java.lang.Object getObject()"`, but not` "float getFloat()"`, nor `"java.lang.Object[] getObjects()"`.

Constructors can also be specified using their short class names (without package) or using their full class names. As in the Java language, the constructor specification has an argument list, but no return type.

The class access modifiers and class member access modifiers are typically used to restrict wildcarded classes and class members. They specify that the corresponding access flags have to be set for the member to match. A preceding ! specifies that the corresponding access flag should be unset.

Combining multiple flags is allowed (e.g. public static). It means that both access flags have to be set (e.g. public and static), except when they are conflicting, in which case at least one of them has to be set (e.g. at least public or protected).

ProGuard supports the additional modifiers synthetic, bridge, and varargs, which may be set by compilers.


https://stuff.mit.edu/afs/sipb/project/android/sdk/android-sdk-linux/tools/proguard/docs/index.html#manual/usage.html

http://sd7y.iteye.com/blog/2047741

http://blog.csdn.net/evoshark/article/details/7726434