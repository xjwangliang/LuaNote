###Resource Merging
```
http://tools.android.com/tech-docs/new-build-system/resource-merging

Priority Order for Library Dependencies

With transitive dependencies, the actual set of Library Projects seen by a project is not a flat list but a graph. However the merging mechanism only handles a flat priority list.

If we consider the following example of dependencies:
   Project -> A, B (meaning A higher priority than B)
   A -> C, D
   B -> C
The flat list passed to the merger will be A, D, B, C

This ensures that both A and B overrides C.
```

###Library project note
http://www.vogella.com/tutorials/AndroidLibraryProjects/article.html
http://www.sitepoint.com/getting-started-android-library-projects-part-3/
http://commonsware.com/blog/2014/07/03/consuming-aars-eclipse.html
https://code.google.com/p/android/issues/detail?id=59183


There are several items to remember when developing an Android library project and its dependent apps:

* Use prefixes to avoid resource conflicts. For example, to guarantee uniqueness, I would reverse my domain name and define @+id/ca_tutortutor_gameboard instead of @+id/gameboard in a library project resource file.

* You cannot export a library project to a JAR file. This capability will be introduced in a future release of the SDK tools.

* A library project can include a JAR library. You must manually edit the dependent app project’s build path and add a path to the JAR file.

* A library project can depend on an external JAR library. The dependent app project must build against a target that includes the external library. Also, the library and dependent app projects must declare the external library in their manifest files, in a <uses-library> element.

* Library projects cannot include raw assets. Raw asset files (saved in a library project’s assets directory) are ignored. Any asset resources used by an app must be stored in its project’s assets directory.

* The library project platform version number must be less than or equal to the app project platform version number. The API level (such as 10, which matches Android 2.3.3) used by a library project should be the same as or lower than the API level used by the dependent app.

* There is no restriction on library package names. A library’s package name isn’t required to match the package names of its dependent apps.

* Each library project creates its own R class. Each library has its own R class, named according to the library’s package name. The R class generated from the app project and its library project(s) is created in all the packages that are needed including the app project’s package and the library package(s).

* A library project’s storage location is flexible. Library projects can be stored anywhere on the hard drive as long as dependent app projects can reference them (via relative links).

* Declaring components and `auto-merge`：
If you define components, e.g., activities in your library project, you need to re-define these components in the consuming Android application. If you want to automatically add all components from your library project to your application, add the manifestmerger.enabled=true to your project.properties file of your application project.

* Priorities for conflicting resources：
The Android development tools merges the resources of a library project with the resources of the application project. In the case that a resource's ID is defined several times, the tools select the resource from the application, or the library with highest priority, and discard the other resource.

* The Android team introduced a new binary distribution format called Android `ARchive(AAR)`. The `<filenname>.aar</filenname>` bundle is the binary distribution of an Android Library Project. An AAR is similar to a JAR file, but it can contain resources as well as compiled byte-code. This allows that an AAR file is included in the build process of an Android application similar to a JAR file. This AAR format is currently directly support by the Eclipse IDE. Stare on the following issue so that Google solves this issue: `Allows Eclipse ADT plugin to work with .AAR files` . It is still possible to use AAR files with Eclipse. You can either convert them to to Android library projects as described in `Consuming AARs from Eclipse `blog post about it or use the `Android Maven plug-in` for your build(https://code.google.com/p/android/issues/detail?id=59183;http://commonsware.com/blog/2014/07/03/consuming-aars-eclipse.html;https://code.google.com/p/maven-android-plugin/wiki/AAR).

```
android create lib-project --target target_ID
                           --path /path/to/project/project_name 
                           --package library_package_namespace
                           
android update project --target target_ID 
                       --path /path/to/project/project_name 
                       --library relative/path/to/library/project
```