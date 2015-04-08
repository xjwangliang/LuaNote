static class SdkContextWrapper extends ContextWrapper {
		private SdkClassLoader mLoader;
		private SdkResources mResources;

		public SdkContextWrapper(Context base, SdkClassLoader loader,
				SdkResources resources) {
			super(base);
			this.mLoader = loader;
			this.mResources = resources;
		}

		public ClassLoader getLoader() {
			return this.mLoader;
		}

		public AssetManager getAssets() {
			return this.mResources == null ? super.getAssets()
					: this.mResources.getAssets();
		}

		public Resources getResources() {
			return this.mResources == null ? super.getResources()
					: this.mResources.getResources();
		}
	}

	static class DynamicLoaderUtils {
		private static SdkClassLoader sLoader;
		private static SdkResources sdkResources;
		private static SdkContextWrapper wrapper;

		public static ClassLoader getClassLoader(Context context, File file) {
			if (sLoader != null) {
				return sLoader;
			}
			try {
				loadSdk(context, file);
			} catch (Exception e) {
				e.printStackTrace();
			}
			return sLoader;
		}

		private static void loadSdk(Context context, File file) {
			Context baseContext = ((ContextWrapper) context).getBaseContext();
			sLoader = SdkClassLoader.getClassLoader(baseContext,
					file.getAbsolutePath());
			sdkResources = SdkResources.getResources(baseContext,
					file.getAbsolutePath());
			wrapper = new SdkContextWrapper(baseContext, sLoader, sdkResources);
		}

		public static SdkClassLoader getsLoader() {
			return sLoader;
		}

		public static SdkResources getSdkResources() {
			return sdkResources;
		}

		public static SdkContextWrapper getWrapper() {
			return wrapper;
		}
	}

	static class DynamicLoader {
		private static DynamicLoader mInstance;
		private Context mContext;
		private String mDexPath;
		private String mClassName;

		public static DynamicLoader getInstance() {
			if (mInstance == null) {
				mInstance = new DynamicLoader();
			}
			return mInstance;
		}

		public DynamicLoader init(Context context, String dexpath,
				String className) {
			this.mContext = context;
			this.mDexPath = dexpath;
			this.mClassName = className;
			return mInstance;
		}

		public Object load() {
			ClassLoader classLoader = null;
			Object object = null;
			try {
				File file = new File(this.mDexPath);
				classLoader = DynamicLoaderUtils.getClassLoader(this.mContext,
						file);
				Class clazz = classLoader.loadClass(this.mClassName);
				Constructor localConstructor = clazz
						.getConstructor(new Class[0]);
				object = localConstructor.newInstance(new Object[0]);
			} catch (Exception e) {
				e.printStackTrace();
			}
			return object;
		}
	}

	static class SdkClassLoader extends DexClassLoader {
		SdkClassLoader(String dexPath, String optimizedDirectory,
				String libraryPath, ClassLoader parent) {
			super(dexPath, optimizedDirectory, libraryPath, parent);
		}

		@SuppressLint({ "NewApi" })
		protected Class<?> loadClass(String className, boolean resolve)
				throws ClassNotFoundException {
			Class clazz = findLoadedClass(className);
			if (clazz != null) {
				return clazz;
			}

			try {
				clazz = getParent().loadClass(className);
			} catch (ClassNotFoundException e) {
				e.printStackTrace();
			}
			if (clazz != null) {
				return clazz;
			}

			clazz = findClass(className);
			return clazz;
		}

		public static SdkClassLoader getClassLoader(Context context,
				String sdkPath) {
			File dexOutputDir = context.getDir("dex", 0);
			String dexoutputpath = dexOutputDir.getAbsolutePath();
			SdkClassLoader loader = new SdkClassLoader(sdkPath, dexoutputpath,
					null, context.getClassLoader());
			return loader;
		}
	}

	static class SdkResources {
		public static final String SDK_ASSETS_METHOD_NAME = "addAssetPath";
		public static final String MANIFEST_FILE_NAME = "AndroidManifest.xml";
		public static final String MANIFEST_NODE_NAME = "manifest";
		public static final String PACKAGE_PARAMETER_NAME = "package";
		private String mPackageName;
		private Resources mResources;
		private AssetManager mAssetManager;

		SdkResources(String packageName, Resources res, AssetManager asset) {
			this.mPackageName = packageName;
			this.mResources = res;
			this.mAssetManager = asset;
		}

		public Resources getResources() {
			return this.mResources;
		}

		public AssetManager getAssets() {
			return this.mAssetManager;
		}

		public static SdkResources getResources(Context context, String sdkPath) {
			try {
				AssetManager assets = (AssetManager) AssetManager.class
						.newInstance();
				assets.getClass()
						.getMethod("addAssetPath", new Class[] { String.class })
						.invoke(assets, new Object[] { sdkPath });

				String packageName = null;
				XmlResourceParser xml = assets
						.openXmlResourceParser("AndroidManifest.xml");
				int eventType = xml.getEventType();
				while (eventType != 1) {
					switch (eventType) {
					case 2:
						if ("manifest".equals(xml.getName())) {
							packageName = xml
									.getAttributeValue(null, "package");
						}
						break;
					}

					eventType = xml.nextToken();
				}
				xml.close();
				if (packageName == null) {
					throw new RuntimeException(
							"package not found in AndroidManifest.xml ["
									+ sdkPath + "]");
				}

				Resources superRes = context.getResources();
				Resources res = new Resources(assets,
						superRes.getDisplayMetrics(),
						superRes.getConfiguration());

				return new SdkResources(packageName, res, assets);
			} catch (Exception e) {
				if ((e instanceof RuntimeException)) {
					throw ((RuntimeException) e);
				}
				throw new RuntimeException(e);
			}
		}
	}