```
http://www.cnblogs.com/ijiami/p/3579761.html
http://www.eoeandroid.com/forum.php?mod=viewthread&tid=316988&extra=&authorid=1233227&page=1
http://security.tencent.com/index.php/blog/msg/26
http://hold-on.iteye.com/blog/1901152  
http://cdmd.cnki.com.cn/Article/CDMD-10076-1014104642.htm

http://www.freebuf.com/articles/others-articles/36452.html
http://yusi123.com/3061.html
http://pan.baidu.com/s/1jGDnUvG
https://drive.google.com/folderview?id=0BzKpXHh8y0PRRllpUE8wMEpiLTQ&usp=sharing
```

* 纯客户端的保护可是保护级别很低,纯客户端的破解可能无法修改服务器上的数据 但是能够通过`钓鱼`形式，`静态注入`形式对用户的信息进行盗取等.

* 直接修改ClassLoader类，这种然后通过加密算法加密APK，在LoadCLASS里面解压APK，运行，这个方式效果如何？加壳dex 然后重写类加载器。以apk为基础把dex文件里面的源码提取出来存放到我们的壳(自定义文件)里面，然后再重写android classloader的形式来实现对apk的保护.(对so库进行加壳保护，防止ida的F5;隐藏源码，防止静态破解，还能够防止内存dump的，会对内存上的dex的头与尾做混淆加密，破解者是很难从内存中把dex完整的截取下来的)

* 很多手机安全软件都有广告拦截的功能,他们都是通过hook的思想来进行监控+拦截。。。相关的资料网上也一大堆。

* 梆梆加密


* BlueBox和Dexter。https://dexter.bluebox.com

* wxsqlite的可扩展性


    静态分析方法是不需要运行程序直接对程序源码进行静态分析来发现安全漏洞的方法。依赖于制定好的规则或者缺陷模型。静态分析的主要优点在于可以实现代码的全面覆盖、挖掘具有自动化、高效等优点。但同时存在针对性不强、结果集庞大并且误报率高等局限性。另一挖掘方法是动态分析，动态分析不需要获得源码，通过运行应用程序来检测漏洞。动态分析通过输入半有效数据触发并挖掘漏洞。动态分析具有针对性强、准确率高。但由于它没有获得源码，代码覆盖率低，存在漏报。

　　静态分析一般是将源码转换为某种中间数据结构并采用相应算法进行分析。`约束分析、模型匹配分析、类型推断和词法语法分析`是静态分析常用的分析方法。另外`MECA安全属静态分析方法`是杨军峰提出的，写入程序编译扩展方法是美国斯坦福大学DaWson Engler和KenAshcrm提出的。因为静态分析的快速高效、代码覆盖率高等特点容易实现自动化。其中基于词法分析检查的的静态分析工具有`ITS4、FLA、VFINDER`等。基于java的漏洞扫描工具，其中`FindBugs`是一个分析静态JaVa源代码的工具，能够检测出许多潜在的Bug和不推荐的代码编写方式。FindBugs虽然可以检测代码质量问题，但对安全问题效果不明显。`Checkstyle`也是一款Java程序源码样式的工具，同FindBugs一样，它也不能检测出软件存在的相关安全问题。可以针对安全问题的检测工具是Foni句Source Code Analysis Suite，它是在全球范围普遍使用的软件分析、源码安全挖掘的管理软件，是基于安全代码规则来识别和修复源码中的安全漏洞。`Fonify`是基于源码功能强大的安全检测软件，并且提供了集成开发插件Foni知SCA IDE，允许开发者在编码阶段进行安全漏洞扫描。但是FonifI，是国外开发的商业软件，对检测具有机密和敏感的程序让国内使用者很担心。因此，有必要研究自己的安全软件工具。

　　静态分析虽具有一些优点，但是它需要获得源码和安全规则和模式库，并且静态挖掘效果的好坏往往决定于模式库和安全规则。静态分析在挖掘漏洞的时候不能考虑程序实际运行情况，因此需要分析所有路径，误报率较高，会产生大量虚假漏洞导致结果集很庞大，分析困难。高效、快速、准确挖掘安全漏洞是性能系安全领域重要的研究方向。

　　动态分析国内外研究现状

　　常见的动态分析方法有`故障注入分析法、输入追踪法和堆栈比较法`等，`Fuzzing`是一种基于动态分析的自动化的安全漏洞挖掘技术，它使用大量半有效的数据或者文件作为应用程序的输入，试图发现应用程序中存在的安全漏洞。最早提出Fuzzing概念是在1989年，当时威斯康星大学的Banon Miller教授开发了一个原始的Fuzzing工具，用来测试UNIX应用程序的健壮性。当时的Fuzzing测试是向目标程序中随机输入数据和字符串，观察系统是否产生异常或崩溃，来判断系统的健壮性。属于完全的黑盒暴力方式。1999年是Fuzzing发展的关键一年，是因为针对Fuzzing测试数据的生成结合了白盒测试。这种测试用例生成是Oulu大学使用硬编码方式生成PROTOS网络测试集时使用的。随后一系列Fuzzing工具开使出现，如2002年，开源Fuzzing工具`SPIKE`是DaVe Aitel发布的。2005年，微软发布了针对JPEG文件引擎的缓冲区漏洞Fuzzing工具。2006年，H．D．Moore和DaVid Zimmer发布了针对ActiveX控件测试的Fuzzing工具`AxMall`与`COMRaider`。

　　Fuzzing技术目前主要应用于安全方面，在国内，研究还处于起步阶段。Fuzzing技术面临的一个很大的挑战就是没有足够的代码覆盖率，未来的发展趋势是结合其他多种漏洞挖掘分析方法。动态分析的优点是准确率高，针对性强，但是存在漏报及自动化程度不高等缺点。
　　
　　安卓软件应用研究现状

　　移动互联网是科技发展的趋势，智能手机的性能和功能逐渐逼近计算机，Android做为最流行的智能终端操作系统，将会成为社交网络的连接设备。企业、军队和政府的管理系统等由于Android的接入增加许多安全问题。Android移动终端的安全对以后的信息安全以及用户隐私安全至关重要。目前国内对Android基于源代码的静态分析还刚起步，主要是针对恶意行为的检测方向。由于Android的巨大潜力和开放性以及Android存在的安全问题，安全研究分析人员对增强—州roid的安全进行了多方面的研究，取得了一定成果。主要是对Android系统的硬件、操作系统内核、虚拟机、框架及应用程序层等方面进行了研究。

　　硬件层：体现在对硬件的改造和扩充安全机制来增强整个系统的安全性。通过设计出的硬件可信设备监测控制系统的行为和系统最底层。`TmstZone`是DaVid Kleidemlacher提出的用来增强Android的设备安全性。1’mstZone是将硬件形式的系统进行虚拟化，分为安全和可信的两种分区。安全区内运行的是涉及用户隐私安全的安全软件，它可以访问运行在普通区的其他软件，但普通区的其他软件不能访问安全软件。因为TmstZone技术已经成熟，并不会因为分区而产生额外的执行负载。智能终端的ARM一般都支持TmstZone技术，那么移动终端的安全输入、安全显示以及安全支付可以采用该技术。

　　内核层：Android操作系统是基于Linux内核开发的，山1droid继承了Linux的安全机制，因此增强Linux内核的方案的机制也就是对Android内核安全机制的增强。Linux包括安全模块LSM(Linux Securitv Module)模块，这个模块是用来保障Linux的安全。LSM在进程间通信、socket类操作和文件类等关键路径上插入许多钩子，以此作为安全机制实施点让各种安全模块挂接相应的钩子。这种安全增强实现可以分为路径名安全增强(如TOMOYO Linux Android)和标签安全增强(SELinuX)。

　　虚拟机层：鉴于对硬件层安全增强的难度大，研究人员提出让虚拟机具有更高的权限来管控和检测平台行为的基于虚拟化的安全增强方案。文献[26】提出移动`Rootkit`、硬件抽象层、用于近距离通信的SIM卡等应用，基于虚拟机技术的虚拟产品主要有`Xen、OKL4、L4Android`等，其中`L4Android`是一个支持虚拟机上同时运行多个Android实例的开源项目。

　　Android应用框架层：应用程序框架为应用程序的开发提供各种组件，其中包括活动管理器、包管理器、引用监视器等对应用程序的授权、权限检查各种信息进行管理和检测。这层的安全机制增强主要在于对安全权限进行管理和控制，提高可信性及安全性。主要成果有A`PEX、Saint、Kirin`等。其次在动态运行权限加强方面，主要采用`Quire、IPC Inspection、XMAndroid`等来防止权限提升。另外在隐私数据方面有`TISSA、AppFenceMockDroid`是在保护用户隐私数据不被窃取而提供一些虚假数据。`TaintDro`是用来对隐私数据做污点，然后对这些污点数据的流向进行记录来保护用户隐私。
　　
　　应用程序层：Android源码程序中存在的漏洞是Android受到攻击的主要原因，目前主要研究在程序中是否存在危险权限组合、最小特权原则方面。`Ded`是Enck设计实现的反编译工具，其中采用了`Fonify SCA组件对应用程序进行语义分析、结构、数据流、控制流的一个静态分析`。`SCANDROID`是针对开源应用程序，从Manifest文件中提取权限等安全信息，检测程序源码中的数据流向是否安全的基于`WALA Java`框架实现的自动推理工具。`ComDroid`是对程序字节码进行分析的工具，用来检测恶意服务启动、服务劫持、窃取等。`W60dpecke`在`balsmali`反汇编程序基础上采用数据流分析技术对程序进行非授权访问和权限泄露等问题的分析。基于Android的静态分析主要隐集中在私泄露及开放特权接口。

　　国内对安卓软件应用的应用层进行的研究包括，发明了Android平台安卓软件应用安全漏洞挖掘方法，提出先提取漏洞规则库，然后对Android的字节码文件进行数据流分析，根据漏洞规则库进行漏洞检测。提出为解决Android平台的软件的恶意软件杀毒速度慢、误报率高问题，发明了Android应用程序安全检测方法。该方法基于对安装包的扫描过程，在安全识别库中匹配扫描特征。发明了对Android手机的安全检测方法，采用对应用程序的接口或类进行插钩来获得程序行为的安全检测方法。提出了采用静态信息流分析技术来挖掘Android应用日志中的信息泄露。文献中针对Android内核代码，采用控制流的挖掘方法进行了分析检测，对多个Android系统版本问进行横向分析对比。可以发现系统中存在的弱点。但在挖掘新错误类型方面有限，并且不能降低误报和进行精确验证等问题。文献【46]中分析了Android商城中程序获取用户隐私的行为，采用了对Android二进制格式文件进行函数调用图的构建，用静态分析方法获取隐私泄露的路径，然后通过人工动态验证，对隐私泄露路径进行验证。采用了动态污点跟踪技术来实现％ntChaser自动化检测系统，进行细粒度的跟踪用户隐私泄露行为。提出一种基于数据流分析的Android应用权限检测方法，设计并实现了静态检测工具`Brox`，实现对过多的权限进行检测，但是分析比较耗时。对Android隐私泄露作为一种缺陷模式，依据缺陷规则，对Android应用程序的源代码进行静态分析，对规范Android软件市场起到规范作用，防范窃取用户隐私行为。南京邮电大学研究出一种Android平台恶意软件行为的方法。该方法采用静态行为检测，利用可执行可链接(ELF)文件符号信息，利用逆向工程来抽取程序特征的手段检测恶意软件。

　　国外对A安卓软件应用研究非常重视，Kirin系统是宾州大学帕克分校的安全实验室以及计算机学院研究出的。该系统用于Android应用程序的安装阶段对其进行分析，属于动态分析领域。堪萨斯州立大学采用`Indus`对Android应用源代码进行程序切片的方法来分析应用程序中可能存在的资源信息泄露问题，前提是先对Android应用程序反编译得到源代码。“Indus”是由他们学校开发的JaVa静态分析工具，indus在检测的时间上存在一定的局限性，即使代码量很小，检测时间也非常长。意法的两所大学共同研究出一种对Android应用程序源码的静态分析系统，该系统主要是为开发人员用来检测代码中的缺陷来完善代码，在应用隐私泄露等安全问题没有涉及到。

　　目前，软件漏洞挖掘技术大多是基于静态或动态一种技术，如何结合多种挖掘方法的优点，研究出一款快速、高效、准确的混合型挖掘方法是研究的热点。现在智能手机功能越来越强大，手机不单纯是通讯工具，更成为了用户的个人信息中心，Android占智能手机的绝大部分市场，而且发展迅猛。由于Android操作系统的开源性，使其很容易遭到攻击，消除安全漏洞是减少被攻击的一个重要方面，目前，针对安卓软件应用安全挖掘技术还很少，为保障用户的隐私及移动互联网安全， 针对Android平台的安全研究将会是一项长期而艰巨的任务。

---



###APK保护方法之一：防止工具反编译之伪加密
```
伪加密是Android4.2.x系统发布前最流行的加密方式之一，通过java代码对APK(压缩文件)进行伪加密，其修改原理是修改连续4位字节标记为”P K 01 02”的后第5位字节，奇数表示不加密偶数表示加密。伪加密后的APK不但可以防止PC端对它的解压和查看也同样能防止反编译工具编译。

但是伪加密对其APK加密后市场也无法对其进行安全检测，部分市场会拒绝这类APK上传市场。伪加密的加密方式和解密方式也早已公布导致它的安全程度也大大降低。Android4.2+系统由于修改了签名验证的方式导致无法安装伪加密的APK。

对于伪加密的 代码，未加密apk和加密后的apk 的下载地址：http://dl1.zywa.com.cn/ijiami/apkbus/1.zip


import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.nio.ByteBuffer;
import java.nio.channels.FileChannel;
import java.util.Arrays;
import java.util.zip.ZipError;

class ZipConstants {
	public static void main(String[] args) {
		ApkUtilTool apk = new ApkUtilTool();
		try {
			/**
			 * 进行伪加密
			 */
			apk.ChangToEncryptedEntry("需要伪加密的apk地址", "伪加密后的apk地址");
			/**
			 * 进行解密
			 */
			apk.FixEncryptedEntry("进行过伪加密的apk地址", "解密后的apk地址");
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	/*
	 * Compression methods
	 */
	static final int METHOD_STORED = 0;
	static final int METHOD_DEFLATED = 8;
	static final int METHOD_DEFLATED64 = 9;
	static final int METHOD_BZIP2 = 12;
	static final int METHOD_LZMA = 14;
	static final int METHOD_LZ77 = 19;
	static final int METHOD_AES = 99;

	/*
	 * General purpose big flag
	 */
	static final int FLAG_ENCRYPTED = 0x01;
	static final int FLAG_DATADESCR = 0x08; // crc, size and csize in dd
	static final int FLAG_EFS = 0x800; // If this bit is set the filename and
										// comment fields for this file must be
										// encoded using UTF-8.
	/*
	 * Header signatures
	 */
	static long LOCSIG = 0x04034b50L; // "PK\003\004"
	static long EXTSIG = 0x08074b50L; // "PK\007\008"
	static long CENSIG = 0x02014b50L; // "PK\001\002"
	static long ENDSIG = 0x06054b50L; // "PK\005\006"

	/*
	 * Header sizes in bytes (including signatures)
	 */
	static final int LOCHDR = 30; // LOC header size
	static final int EXTHDR = 16; // EXT header size
	static final int CENHDR = 46; // CEN header size
	static final int ENDHDR = 22; // END header size

	/*
	 * Local file (LOC) header field offsets
	 */
	static final int LOCVER = 4; // version needed to extract
	static final int LOCABC = 6; // general purpose bit flag
	static final int LOCHOW = 8; // compression method
	static final int LOCTIM = 10; // modification time
	static final int LOCCRC = 14; // uncompressed file crc-32 value
	static final int LOCSIZ = 18; // compressed size
	static final int LOCLEN = 22; // uncompressed size
	static final int LOCNAM = 26; // filename length
	static final int LOCEXT = 28; // extra field length

	/*
	 * Extra local (EXT) header field offsets
	 */
	static final int EXTCRC = 4; // uncompressed file crc-32 value
	static final int EXTSIZ = 8; // compressed size
	static final int EXTLEN = 12; // uncompressed size

	/*
	 * Central directory (CEN) header field offsets
	 */
	static final int CENVEM = 4; // version made by
	static final int CENVER = 6; // version needed to extract
	static final int CENABC = 8; // encrypt, decrypt flags
	static final int CENHOW = 10; // compression method
	static final int CENTIM = 12; // modification time
	static final int CENCRC = 16; // uncompressed file crc-32 value
	static final int CENSIZ = 20; // compressed size
	static final int CENLEN = 24; // uncompressed size
	static final int CENNAM = 28; // filename length
	static final int CENEXT = 30; // extra field length
	static final int CENCOM = 32; // comment length
	static final int CENDSK = 34; // disk number start
	static final int CENATT = 36; // internal file attributes
	static final int CENATX = 38; // external file attributes
	static final int CENOFF = 42; // LOC header offset

	/*
	 * End of central directory (END) header field offsets
	 */
	static final int ENDSUB = 8; // number of entries on this disk
	static final int ENDTOT = 10; // total number of entries
	static final int ENDSIZ = 12; // central directory size in bytes
	static final int ENDOFF = 16; // offset of first CEN header
	static final int ENDCOM = 20; // zip file comment length

	/*
	 * ZIP64 constants
	 */
	static final long ZIP64_ENDSIG = 0x06064b50L; // "PK\006\006"
	static final long ZIP64_LOCSIG = 0x07064b50L; // "PK\006\007"
	static final int ZIP64_ENDHDR = 56; // ZIP64 end header size
	static final int ZIP64_LOCHDR = 20; // ZIP64 end loc header size
	static final int ZIP64_EXTHDR = 24; // EXT header size
	static final int ZIP64_EXTID = 0x0001; // Extra field Zip64 header ID

	static final int ZIP64_MINVAL32 = 0xFFFF;
	static final long ZIP64_MINVAL = 0xFFFFFFFFL;

	/*
	 * Zip64 End of central directory (END) header field offsets
	 */
	static final int ZIP64_ENDLEN = 4; // size of zip64 end of central dir
	static final int ZIP64_ENDVEM = 12; // version made by
	static final int ZIP64_ENDVER = 14; // version needed to extract
	static final int ZIP64_ENDNMD = 16; // number of this disk
	static final int ZIP64_ENDDSK = 20; // disk number of start
	static final int ZIP64_ENDTOD = 24; // total number of entries on this disk
	static final int ZIP64_ENDTOT = 32; // total number of entries
	static final int ZIP64_ENDSIZ = 40; // central directory size in bytes
	static final int ZIP64_ENDOFF = 48; // offset of first CEN header
	static final int ZIP64_ENDEXT = 56; // zip64 extensible data sector

	/*
	 * Zip64 End of central directory locator field offsets
	 */
	static final int ZIP64_LOCDSK = 4; // disk number start
	static final int ZIP64_LOCOFF = 8; // offset of zip64 end
	static final int ZIP64_LOCTOT = 16; // total number of disks

	/*
	 * Zip64 Extra local (EXT) header field offsets
	 */
	static final int ZIP64_EXTCRC = 4; // uncompressed file crc-32 value
	static final int ZIP64_EXTSIZ = 8; // compressed size, 8-byte
	static final int ZIP64_EXTLEN = 16; // uncompressed size, 8-byte

	/*
	 * Extra field header ID
	 */
	static final int EXTID_ZIP64 = 0x0001; // ZIP64
	static final int EXTID_NTFS = 0x000a; // NTFS
	static final int EXTID_UNIX = 0x000d; // UNIX
	static final int EXTID_EFS = 0x0017; // Strong Encryption
	static final int EXTID_EXTT = 0x5455; // Info-ZIP Extended Timestamp

	/*
	 * fields access methods
	 */
	// /////////////////////////////////////////////////////
	static final int CH(byte[] b, int n) {
		return b[n] & 0xff;
	}

	static final int SH(byte[] b, int n) {
		return (b[n] & 0xff) | ((b[n + 1] & 0xff) << 8);
	}

	static final long LG(byte[] b, int n) {
		return ((SH(b, n)) | (SH(b, n + 2) << 16)) & 0xffffffffL;
	}

	static final long LL(byte[] b, int n) {
		return (LG(b, n)) | (LG(b, n + 4) << 32);
	}

	static final long GETSIG(byte[] b) {
		return LG(b, 0);
	}

	// local file (LOC) header fields
	static final long LOCSIG(byte[] b) {
		return LG(b, 0);
	} // signature

	static final int LOCVER(byte[] b) {
		return SH(b, 4);
	} // version needed to extract

	static final int LOCABC(byte[] b) {
		return SH(b, 6);
	} // general purpose bit flags

	static final int LOCHOW(byte[] b) {
		return SH(b, 8);
	} // compression method

	static final long LOCTIM(byte[] b) {
		return LG(b, 10);
	} // modification time

	static final long LOCCRC(byte[] b) {
		return LG(b, 14);
	} // crc of uncompressed data

	static final long LOCSIZ(byte[] b) {
		return LG(b, 18);
	} // compressed data size

	static final long LOCLEN(byte[] b) {
		return LG(b, 22);
	} // uncompressed data size

	static final int LOCNAM(byte[] b) {
		return SH(b, 26);
	} // filename length

	static final int LOCEXT(byte[] b) {
		return SH(b, 28);
	} // extra field length

	// extra local (EXT) header fields
	static final long EXTCRC(byte[] b) {
		return LG(b, 4);
	} // crc of uncompressed data

	static final long EXTSIZ(byte[] b) {
		return LG(b, 8);
	} // compressed size

	static final long EXTLEN(byte[] b) {
		return LG(b, 12);
	} // uncompressed size

	// end of central directory header (END) fields
	static final int ENDSUB(byte[] b) {
		return SH(b, 8);
	} // number of entries on this disk

	static final int ENDTOT(byte[] b) {
		return SH(b, 10);
	} // total number of entries

	static final long ENDSIZ(byte[] b) {
		return LG(b, 12);
	} // central directory size

	static final long ENDOFF(byte[] b) {
		return LG(b, 16);
	} // central directory offset

	static final int ENDCOM(byte[] b) {
		return SH(b, 20);
	} // size of zip file comment

	static final int ENDCOM(byte[] b, int off) {
		return SH(b, off + 20);
	}

	// zip64 end of central directory recoder fields
	static final long ZIP64_ENDTOD(byte[] b) {
		return LL(b, 24);
	} // total number of entries on disk

	static final long ZIP64_ENDTOT(byte[] b) {
		return LL(b, 32);
	} // total number of entries

	static final long ZIP64_ENDSIZ(byte[] b) {
		return LL(b, 40);
	} // central directory size

	static final long ZIP64_ENDOFF(byte[] b) {
		return LL(b, 48);
	} // central directory offset

	static final long ZIP64_LOCOFF(byte[] b) {
		return LL(b, 8);
	} // zip64 end offset

	// central directory header (CEN) fields
	static final long CENSIG(byte[] b, int pos) {
		return LG(b, pos + 0);
	}

	static final int CENVEM(byte[] b, int pos) {
		return SH(b, pos + 4);
	}

	static final int CENVER(byte[] b, int pos) {
		return SH(b, pos + 6);
	}

	static final int CENABC(byte[] b, int pos) {
		return SH(b, pos + 8);
	}

	static final int CENHOW(byte[] b, int pos) {
		return SH(b, pos + 10);
	}

	static final long CENTIM(byte[] b, int pos) {
		return LG(b, pos + 12);
	}

	static final long CENCRC(byte[] b, int pos) {
		return LG(b, pos + 16);
	}

	static final long CENSIZ(byte[] b, int pos) {
		return LG(b, pos + 20);
	}

	static final long CENLEN(byte[] b, int pos) {
		return LG(b, pos + 24);
	}

	static final int CENNAM(byte[] b, int pos) {
		return SH(b, pos + 28);
	}

	static final int CENEXT(byte[] b, int pos) {
		return SH(b, pos + 30);
	}

	static final int CENCOM(byte[] b, int pos) {
		return SH(b, pos + 32);
	}

	static final int CENDSK(byte[] b, int pos) {
		return SH(b, pos + 34);
	}

	static final int CENATT(byte[] b, int pos) {
		return SH(b, pos + 36);
	}

	static final long CENATX(byte[] b, int pos) {
		return LG(b, pos + 38);
	}

	static final long CENOFF(byte[] b, int pos) {
		return LG(b, pos + 42);
	}

	/* The END header is followed by a variable length comment of size < 64k. */
	static final long END_MAXLEN = 0xFFFF + ENDHDR;
	static final int READBLOCKSZ = 128;

	public static class ApkUtilTool {

		private FileChannel ch; // channel to the zipfile
		private FileChannel fc;

		/**
		 * 修复zip伪加密状态的Entry
		 * 
		 * @param inZip
		 * @param storeZip
		 * @throws IOException
		 */
		public void FixEncryptedEntry(File inZip, File fixZip)
				throws IOException {
			changEntry(inZip, fixZip, true);
		}

		/**
		 * 修复zip伪加密状态的Entry
		 * 
		 * @param inZip
		 * @param storeZip
		 * @throws IOException
		 */
		public void FixEncryptedEntry(String inZip, String fixZip)
				throws IOException {
			FixEncryptedEntry(new File(inZip), new File(fixZip));
		}

		/**
		 * 修改zip的Entry为伪加密状态
		 * 
		 * @param inZip
		 * @param storeZip
		 * @throws IOException
		 */
		public void ChangToEncryptedEntry(File inZip, File storeZip)
				throws IOException {
			changEntry(inZip, storeZip, false);
		}

		/**
		 * 修改zip的Entry为伪加密状态
		 * 
		 * @param inZip
		 * @param storeZip
		 * @throws IOException
		 */
		public void ChangToEncryptedEntry(String inZip, String storeZip)
				throws IOException {
			ChangToEncryptedEntry(new File(inZip), new File(storeZip));
		}

		/**
		 * 更改zip的Entry为伪加密状态
		 * 
		 * @param inZip
		 * @param storeZip
		 * @param fix
		 *            ture:修复伪加密 false:更改到伪加密
		 * @throws IOException
		 */
		private void changEntry(File inZip, File storeZip, boolean fix)
				throws IOException {
			FileInputStream fis = new FileInputStream(inZip);
			FileOutputStream fos = new FileOutputStream(storeZip);

			byte[] buf = new byte[10240];
			int len;
			while ((len = fis.read(buf)) != -1) {
				fos.write(buf, 0, len);
			}

			ch = fis.getChannel();
			fc = fos.getChannel();

			changEntry(fix);

			ch.close();
			fc.close();

			fis.close();
			fos.close();
		}

		// Reads zip file central directory. Returns the file position of first
		// CEN header, otherwise returns -1 if an error occured. If zip->msg !=
		// NULL
		// then the error was a zip format error and zip->msg has the error
		// text.
		// Always pass in -1 for knownTotal; it's used for a recursive call.
		private void changEntry(boolean fix) throws IOException {
			END end = findEND();

			if (end.cenlen > end.endpos)
				zerror("invalid END header (bad central directory size)");
			long cenpos = end.endpos - end.cenlen; // position of CEN table

			// Get position of first local file (LOC) header, taking into
			// account that there may be a stub prefixed to the zip file.
			long locpos = cenpos - end.cenoff;
			if (locpos < 0)
				zerror("invalid END header (bad central directory offset)");

			// read in the CEN and END
			byte[] cen = new byte[(int) (end.cenlen + ENDHDR)];
			if (readFullyAt(cen, 0, cen.length, cenpos) != end.cenlen + ENDHDR) {
				zerror("read CEN tables failed");
			}

			int pos = 0;
			int limit = cen.length - ENDHDR;
			while (pos < limit) {
				if (CENSIG(cen, pos) != CENSIG)
					zerror("invalid CEN header (bad signature)");
				int method = CENHOW(cen, pos);
				int nlen = CENNAM(cen, pos);
				int elen = CENEXT(cen, pos);
				int clen = CENCOM(cen, pos);

				if (fix) {
					if ((CENABC(cen, pos) & 1) != 0) {
						byte[] name = Arrays.copyOfRange(cen, pos + CENHDR, pos
								+ CENHDR + nlen);
						// System.out.println("Found the encrypted entry : "
						// + new String(name) + ", fix...");
						// b[n] & 0xff) | ((b[n + 1] & 0xff) << 8
						cen[pos + 8] &= 0xFE;
						// cen[pos+8] ^= CEN***(cen, pos) % 2;
						// cen[pos+8] ^= cen[pos+8] % 2;
						// zerror("invalid CEN header (encrypted entry)");
					}
				} else {
					if ((CENABC(cen, pos) & 1) == 0) {
						byte[] name = Arrays.copyOfRange(cen, pos + CENHDR, pos
								+ CENHDR + nlen);
						// System.out.println("Chang the entry : "
						// + new String(name) + ", Encrypted...");
						// b[n] & 0xff) | ((b[n + 1] & 0xff) << 8
						cen[pos + 8] |= 0x1;
						// zerror("invalid CEN header (encrypted entry)");
					}
				}

				if (method != METHOD_STORED && method != METHOD_DEFLATED)
					zerror("invalid CEN header (unsupported compression method: "
							+ method + ")");
				if (pos + CENHDR + nlen > limit)
					zerror("invalid CEN header (bad header size)");

				// skip ext and comment
				pos += (CENHDR + nlen + elen + clen);
			}

			writeFullyAt(cen, 0, cen.length, cenpos);

			if (pos + ENDHDR != cen.length) {
				zerror("invalid CEN header (bad header size)");
			}
		}

		// Reads len bytes of data from the specified offset into buf.
		// Returns the total number of bytes read.
		// Each/every byte read from here (except the cen, which is mapped).
		final long readFullyAt(byte[] buf, int off, long len, long pos)
				throws IOException {
			ByteBuffer bb = ByteBuffer.wrap(buf);
			bb.position(off);
			bb.limit((int) (off + len));
			return readFullyAt(bb, pos);
		}

		private final long readFullyAt(ByteBuffer bb, long pos)
				throws IOException {
			synchronized (ch) {
				return ch.position(pos).read(bb);
			}
		}

		final long writeFullyAt(byte[] buf, int off, long len, long pos)
				throws IOException {
			ByteBuffer bb = ByteBuffer.wrap(buf);
			bb.position(off);
			bb.limit((int) (off + len));
			return writeFullyAt(bb, pos);
		}

		private final long writeFullyAt(ByteBuffer bb, long pos)
				throws IOException {
			synchronized (fc) {
				return fc.position(pos).write(bb);
			}
		}

		// Searches for end of central directory (END) header. The contents of
		// the END header will be read and placed in endbuf. Returns the file
		// position of the END header, otherwise returns -1 if the END header
		// was not found or an error occurred.
		private END findEND() throws IOException {
			byte[] buf = new byte[READBLOCKSZ];
			long ziplen = ch.size();
			long minHDR = (ziplen - END_MAXLEN) > 0 ? ziplen - END_MAXLEN : 0;
			long minPos = minHDR - (buf.length - ENDHDR);

			for (long pos = ziplen - buf.length; pos >= minPos; pos -= (buf.length - ENDHDR)) {
				int off = 0;
				if (pos < 0) {
					// Pretend there are some NUL bytes before start of file
					off = (int) -pos;
					Arrays.fill(buf, 0, off, (byte) 0);
				}
				int len = buf.length - off;
				if (readFullyAt(buf, off, len, pos + off) != len)
					zerror("zip END header not found");

				// Now scan the block backwards for END header signature
				for (int i = buf.length - ENDHDR; i >= 0; i--) {
					if (buf[i + 0] == (byte) 'P' && buf[i + 1] == (byte) 'K'
							&& buf[i + 2] == (byte) '\005'
							&& buf[i + 3] == (byte) '\006'
							&& (pos + i + ENDHDR + ENDCOM(buf, i) == ziplen)) {
						// Found END header
						buf = Arrays.copyOfRange(buf, i, i + ENDHDR);
						END end = new END();
						end.endsub = ENDSUB(buf);
						end.centot = ENDTOT(buf);
						end.cenlen = ENDSIZ(buf);
						end.cenoff = ENDOFF(buf);
						end.comlen = ENDCOM(buf);
						end.endpos = pos + i;
						if (end.cenlen == ZIP64_MINVAL
								|| end.cenoff == ZIP64_MINVAL
								|| end.centot == ZIP64_MINVAL32) {
							// need to find the zip64 end;
							byte[] loc64 = new byte[ZIP64_LOCHDR];
							if (readFullyAt(loc64, 0, loc64.length, end.endpos
									- ZIP64_LOCHDR) != loc64.length) {
								return end;
							}
							long end64pos = ZIP64_LOCOFF(loc64);
							byte[] end64buf = new byte[ZIP64_ENDHDR];
							if (readFullyAt(end64buf, 0, end64buf.length,
									end64pos) != end64buf.length) {
								return end;
							}
							// end64 found, re-calcualte everything.
							end.cenlen = ZIP64_ENDSIZ(end64buf);
							end.cenoff = ZIP64_ENDOFF(end64buf);
							end.centot = (int) ZIP64_ENDTOT(end64buf); // assume
																		// total
																		// < 2g
							end.endpos = end64pos;
						}
						return end;
					}
				}
			}
			zerror("zip END header not found");
			return null; // make compiler happy
		}

		static void zerror(String msg) {
			throw new ZipError(msg);
		}

		// End of central directory record
		static class END {
			int disknum;
			int sdisknum;
			int endsub; // endsub
			int centot; // 4 bytes
			long cenlen; // 4 bytes
			long cenoff; // 4 bytes
			int comlen; // comment length
			byte[] comment;

			/* members of Zip64 end of central directory locator */
			int diskNum;
			long endpos;
			int disktot;

			@Override
			public String toString() {
				return "disknum : " + disknum + "\n" + "sdisknum : " + sdisknum
						+ "\n" + "endsub : " + endsub + "\n" + "centot : "
						+ centot + "\n" + "cenlen : " + cenlen + "\n"
						+ "cenoff : " + cenoff + "\n" + "comlen : " + comlen
						+ "\n" + "diskNum : " + diskNum + "\n" + "endpos : "
						+ endpos + "\n" + "disktot : " + disktot;
			}
		}
	}
}
```

###APK保护方法之一：防止工具反编译之APK包破坏
```
APK在PC上面也可以看作一个压缩文件，在Android系统里面它是一个手机系统软件文件。Android系统对APK的识别是从标志头到标志尾，其他多余数据都会无视。所以说在标志尾添加其他数据对把APK看做压缩文件的PC端来说这个文件被破坏了，所以你要对其进行解压或者查看都会提示文件已损坏，用反编译工具也会提示文件已损坏，但是它却不会影响在Android系统里面的正常运行和安装而且也能兼容到所有系统。
但是这种APK压缩包破坏存在个别市场会不能识别导致不能上传市场。使用压缩文件修复工具也能把它修复好让我们做的保护消失。

对于APK包破坏的 代码，破坏前的apk和破坏后的apk 的下载地址：http://dl1.zywa.com.cn/ijiami/apkbus/2.zip

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;

public class ZipConstans_zipDestroy {

	public static void main(String[] args) {
		ZipConstans_zipDestroy.destory("目标apk地址", "破坏后的apk地址");
	}

	/**
	 * apk包破坏
	 * 
	 * @param 目标apk地址
	 * @param 破坏后的apk地址
	 */
	public static void destory(String arg1, String arg2) {
		try {
			File file = new File(arg1);
			FileInputStream in = new FileInputStream(file);
			FileOutputStream out = new FileOutputStream(new File(arg2));
			int read = 0;
			long count = 0;
			long readLen = file.length() - 512;
			ByteArrayOutputStream buffer = new ByteArrayOutputStream();
			while ((read = in.read()) != -1) {
				count++;
				out.write(read);
				if (count >= readLen) {
					buffer.write(read);
				}
			}
			byte[] b = buffer.toByteArray();
			out.write(b);
			in.close();
			out.flush();
			out.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}

```
###APK保护方法之一：防止工具反编译之素材中的图片故意破坏
```
素材破坏和包破坏的原理其实差不多，这种破坏也只是针对视apk为压缩文件的pc来说的。具体的做法是：在开发工具中(例如：eclipse)在打包前将jpg格式的图片强行修改成png（由于jpg和png格式图片的识别格式不一样 强行修改后 压缩文件在被解压缩的时候会对任何格式的文件进行验证，在验证到图片格式的时候 会因为文件类型与格式不一样导致无法反编译）。。这种保护措施不能防止查看主要是防止工具反编译(例如:apktool)，前提是不会影响其apk在手机上的正常运行。。
不过这种保护措施，在最新版本的apktool已经修复了。。在老版本的apktool上面这种保护措施是绝对可行的。
```
###APK保护方法之一：防止工具反编译之使用无效的字节码

```

由于大部分逆向工具都是线性读取字节码并解析，当遇到无效字节码时，就会引起反编译工具字节码解析失败。我们可以插入无效字节码到DEX文件，但要保证该无效字节码永远不会被执行（否则您的程序就会崩溃了！）。
下面我们使用一个测试例子进行试验
首先我们新建一个测试类。为了绕过Dalvik运行时代码验证，BadCode.java要保证不被调用。(否则运行app，会出现java.lang.verifyerror异常)

然后生成apk，用ida打开classes.dex。并找到BadCode类的aaa方法。选中的三行代码对应”System.out.println("aaaa");”

切换到HexView-a视图，记录下指令码 “62 00 02 04 1A 01 8E 07  6E 20 19 10 10 00” 和对应偏移“0003A2A4”

使用C32asm，以十六进制的方式打开dex文件。按快捷键“Ctrl + G”，定位到“0003A2A4”
把“62 00 02 04 1A 01 8E 07  6E 20 19 10 10 00”改为“12 01 38 01 03 00 1A 00 FF FF 00 00 00  00”

Opcodes解释：
12 01                //  const/4  v1, 0                                //v1=0
38 01 03 00     //  if-eqz   v1, loc_3A2AC                //if(v1==0) 跳转到 loc_3A2AC:
1A 00 FF FF     //  const-string v0,（不存在的引用 FFFF）
                       //        本行代码被跳过，永远不会执行
                       //        loc_3A2AC：
保存dex。把修改后的dex文件拖入DexFixer进行修复。
用修复后的dex覆盖原apk中的dex文件。
而后压缩打开apk删除META-INF签名文件后再次给apk进行签名。现在一切都搞定了。




使用到的工具下载：
用到的工具：
IDA ：http://pan.baidu.com/share/link?shareid=132208&uk=1795434040
C32Asm：http://www.crsky.com/soft/3128.html
DexFixer：http://bbs.pediy.com/showthread.php?p=1158816
Ijiami signer：http://www.ijiami.cn/
```

###APK保护方法之二：代码高级混淆 - 花指令
```
花指令是程序中有一些指令，由设计者特别构思，希望使反汇编的时候出错，让破解者无法清楚正确地反汇编程序的内容，迷失方向。【花指令】这个词来源于汇编语言，它的思想是非常不错的。。【花指令】另外个目的就是利用反编译工具漏洞，来使工具无法使用。  接下来 我们就在java代码处制造【花指令】，让反编译工具(jd-gui)无法反编译查询你的java代码。。。
jd-gui的bug其实挺多了。。很多特殊代码块或者字段集 都能够让其崩溃无法反编译出源码。。。
比如：
private static final char[] wJ = "0123456789abcdef".toCharArray();
        public static String imsi = "204046330839890";
        public static String p = "0";
        public static String keyword = "电话";
        public static String tranlateKeyword = "%E7%94%B5%E8%AF%9D";
在每个类里面加入 如上字段。。。。 你会发现反编译的类 通过jd-gui查看 后的结果。
```


###APK保护方法之二：代码高级混淆 – 文件夹混淆
```
文件夹混淆之一：文件夹后缀追加.2
文件夹混淆主要指的是 利用windows,linux,android 三个系统环境下的文件夹名的特殊性来对源码文件夹进行混淆，让混淆后的文件夹在window看起来失去原有的逻辑性，但是完全不影响其在android系统上的运行。

原理：在windows和linux下文件夹的名字是不区分大小写的，但是在android环境下它却要区分大小写。.2在linux算一个特殊符号，所以文件夹名字里面添加的.2会被忽略。。但是windows下 .2却是一个很普通的字符串。

方法：反编译开发完成的apk，找到包目录下的最后一层文件夹(例如：包名是com.example.test2222,找到test2222所在的文件夹)，修改test2222文件夹名字为test2222.2并创建文件夹Test2222并随意存放一个有效的smali文件在Test2222里面，然后重新重写打包成apk,签名。
```

###文件夹混淆之二:文件名字混淆
```
大家一定知道proguard混淆，会对java的类名进行混淆，修改为a,b,c,d等等名字来混淆反编译的阅读，但是其混淆的类只能是开发者自己创建的类，对android原始类不能进行混淆。
原理：proguard混淆为基础，在开发完毕后统一修改自己程序的类名(包括主配文件也进行修改)


这两类保护，不但能够使自己的apk在破解后很难被破解者阅读，还能防止一键反编译工具和检测工具，因为自己文件夹.2的方法已经破坏了windows下包路径的规律让其不能通过代码去根据主配文件里面的包名去寻找到类。
```

APK保护方法之三：运行时验证 – Android技术验证

```
运行时验证，主要是指在代码启动的时候本地获取签名信息然后对签名信息进行检验来判断自己的应用是否是正版，如果签名信息不是正版则提示盗版或者直接崩溃。
原理：APK的唯一识别是根据包名+签名，包名信息是写死在AndroidManifest.xml里面的，但是签名则是与APK绑定的，一旦APK被反编译后签名会自动消失。APK的签名需要签名文件，签名文件的md5值基本上是无法伪造成一样的。
签名验证的方法也可以细分为3种：
1)        Java 层验证
获取签名信息和验证的方法都写在android 的java层。这种保护方法保护的意义并不大，因为反编译出源码后通过关键字搜索很快就能够找到验证的代码块，稍微一修改这验证保护就完全无效了。
目前市场上使用此方法验证的应用：神庙逃亡2，qq电池管家，微信，360手机管家等

2)        服务器验证
在android 的java层获取签名信息，上传服务器在服务端进行签名然后返回验证结果。这种保护还不如在纯java层验证有用，一旦没有网络验证保护就无效了。用android方法获取的签名信息用java方法也可以获取，验证存放在服务器上也是为了把保护正确的签名信息值，但是保护的意义其实没有任何作用。同样破解后全局搜索关键字然后伪造一个正确的签名信息就可以完美破解了。
目前市场上使用此方法验证的应用：地铁跑酷等

3)        NDK技术底层获取签名和验证
通过把Context,Activity,PackageManager,PackageInfo四个对象中的一个作为参数参入底层，在底层获取签名信息并验证。因为获取和验证的方法都封闭在更安全的so库里面，能够起到一定意义上的保护作用。不过通过java层的hook技术一样可以把这种保护完美破解。 但是相比于前两种，此保护的意义和价值就更大了。
目前市场上使用此方法验证的应用：植物大战僵尸2等

```

####APK保护方法之三：运行时验证 – java技术验证
```
同样是获取签名信息进行验证，只是不是通过Android的方法，相比Android获取签名的方法用java获取签名更有意义，因为关键字搜索很容易就将Android获取签名的代码找到。
原理：通过Context的getPackageCodePath()和ApplicationInfo的sourceDir的方法获取apk本地储存地址，然后通过java获取签名的方法获取签名信息并验证。
此验证方法一般是通过ndk技术底层验证，此方法在和Android技术验证方式原理差别不大，不过效果会更好，安全作用更高。不过依旧有破解的方法，无法保证安全。
目前市场上使用此方法验证的应用：捕鱼达人2
```

```
客户端与服务端的一次交互可以当做一次请求，在请求里面可以添加一个请求标识，这个标识可以在请求前和服务器交互生成一个，然后正式请求的服务端会对每个请求进行标识验证，非法标识都拒绝。。。。
这样的执行效率肯定比之前的要低，在重要的请求中可以加上这个来为请求做保护，就算连接被暴露 也无所谓，因为每次请求都需要一个标识。。。。 标识那边你可以加点其他参数来做保证更安全。。
```

setprop service.adb.tcp.port 5555
stop adbd
start adbd
在/system/下有个build.prop文件，里面记录

系统启动时所用到的各种prop环境变量，可以在其中加入

service.adb.tcp.port=5555



z4Root和Root Explorer

Android 系统在 `/system/core/private/android_filesystem_config.h` 头文件中对 Android 用户 / 用户组作了如下定义，且权限均基于该用户 / 用户组设置。

```
#define AID_ROOT 0 /* traditional unix root user */
 #define AID_SYSTEM 1000 /* system server */
 #define AID_RADIO 1001 /* telephony subsystem, RIL */
 #define AID_BLUETOOTH 1002 /* bluetooth subsystem */
 #define AID_GRAPHICS 1003 /* graphics devices */
 #define AID_INPUT 1004 /* input devices */
 #define AID_AUDIO 1005 /* audio devices */
 #define AID_CAMERA 1006 /* camera devices */
 #define AID_LOG 1007 /* log devices */
 #define AID_COMPASS 1008 /* compass device */
 #define AID_MOUNT 1009 /* mountd socket */
 #define AID_WIFI 1010 /* wifi subsystem */
 #define AID_ADB 1011 /* android debug bridge (adbd) */
 #define AID_INSTALL 1012 /* group for installing packages */
 #define AID_MEDIA 1013 /* mediaserver process */
 #define AID_DHCP 1014 /* dhcp client */
 #define AID_SDCARD_RW 1015 /* external storage write access */
 #define AID_VPN 1016 /* vpn system */
 #define AID_KEYSTORE 1017 /* keystore subsystem */
 #define AID_USB 1018 /* USB devices */
 #define AID_DRM 1019 /* DRM server */
 #define AID_DRMIO 1020 /* DRM IO server */
 #define AID_GPS 1021 /* GPS daemon */
 #define AID_NFC 1022 /* nfc subsystem */
 #define AID_SHELL 2000 /* adb and debug shell user */
 #define AID_CACHE 2001 /* cache access */
 #define AID_DIAG 2002 /* access to diagnostic resources */
/* The 3000 series are intended for use as supplemental group id's only.
 * They indicate special Android capabilities that the kernel is aware of. */
 #define AID_NET_BT_ADMIN 3001 /* bluetooth: create any socket */
 #define AID_NET_BT 3002 /* bluetooth: create sco, rfcomm or l2cap sockets */
 #define AID_INET 3003 /* can create AF_INET and AF_INET6 sockets */
 #define AID_NET_RAW 3004 /* can create raw INET sockets */
 #define AID_NET_ADMIN 3005 /* can configure interfaces and routing tables. */
#define AID_MISC 9998 /* access to misc storage */
 #define AID_NOBODY 9999
#define AID_APP 10000 /* first app user */
```

值得注意的是：每个应用程序在安装到 Android 系统后，系统都会为其分配一个用户 ID，如 app_4、app_11 等。以下是 Calendar 和 Terminal 软件在 Android 系统中进程浏览的结果（其中，黑色字体标明的即为应用分配的用户 ID）：

```
 USER PID PPID VSIZE RSS WCHAN PC NAME
 app_16 2855 2363 216196 20960 ffffffff afd0ee48 S com.android.providers.calendar
 app_91 4178 2363 218872 25076 ffffffff afd0ee48 S jackpal.androidterm
```

在 Android 系统中，上述用户 / 用户组对文件的访问遵循 Linux 系统的访问控制原则，即根据长度为 10 个字符的权限控制符来决定用户 / 用户组对文件的访问权限。该控制符的格式遵循下列规则：

* 第 1 个字符：表示一种特殊的文件类型。其中字符可为 d( 表示该文件是一个目录 )、b( 表示该文件是一个系统设备，使用块输入 / 输出与外界交互，通常为一个磁盘 )、c( 表示该文件是一个系统设备，使用连续的字符输入 / 输出与外界交互，如串口和声音设备 )，“.”表示该文件是一个普通文件，没有特殊属性。


Android 系统对应用程序权限申请的处理方式分析

对 Android 源代码中的如下文件进行分析：

* InstallAppProgress.java：其路径为 \packages\apps\PackageInstaller\src\com\android\packageinstaller\InstallAppProgress.java；

* PackageInstallerActivity.java：其路径为 \packages\apps\PackageInstaller\src\com\android\packageinstaller\PackageInstallerActivity.java；

* AppSecurityPermissions.java：其路径为 \frameworks\base\core\java\android\widget\AppSecurityPermissions.java


总结得出如下图所示的 Android 系统对应用程序授权申请的处理流程：

* 进入处理应用程序授权申请的入口函数；

* 系统从被安装应用程序的 AndroidManifest.xml 文件中获取该应用正常运行需申请的权限列表；

* 显示对话框，请求用户确认是否满足这些权限需求；

* 若同意，则应用程序正常安装，并被赋予相应的权限；若否定，则应用程序不被安装。系统仅提供给用户选择“是”或者“否”的权利，没有选择其中某些权限进行授权的权利。





http://bbs.pediy.com/showthread.php?t=163215
http://bbs.pediy.com/showthread.php?t=163216

身为测试答一个，这类安全性测试，是app专项测试中必须要做的一环，简单列举下目前常做的测试类别

1. 用户隐私
检查是否在本地保存用户密码，无论加密与否
检查敏感的隐私信息，如聊天记录、关系链、银行账号等是否进行加密
检查是否将系统文件、配置文件明文保存在外部设备上
部分需要存储到外部设备的信息，需要每次使用前都判断信息是否被篡改
2. 文件权限
检查App所在的目录，其权限必须为不允许其他组成员读写
3. 网络通讯
检查敏感信息在网络传输中是否做了加密处理，重要数据要采用TLS或者SSL
4. 运行时解释保护
对于嵌有解释器的软件，检查是否存在XSS、SQL注入漏洞
使用webiew的App，检查是否存在URL欺骗漏洞
5. Android组件权限保护
禁止App内部组件被任意第三方程序调用。
若需要供外部调用的组件，应检查对调用者是否做了签名限制
6. 升级
检查是否对升级包的完整性、合法性进行了校验，避免升级包被劫持
7. 3rd库
如果使用了第三方库，需要跟进第三方库的更新

```
最近在研究Android中基于Java虚拟机的拦截技术。需要用到DexClassLoader加载自己写的第三方jar包，例如金山毒霸需要加载ksremote.jar。现在将DexClassLoader加载jar包成果分享一下。
   1.新建Android工程，封装功能java类。
   2.选中需要导出的文件夹，右键选中“Export”->"Java(Jar file)"导出jar文件。
   3.使用dx工具将jar包转换为android 字节码。
      命令：dx  --dex --Output=xx.jar    hello.jar
   4.将dx工具处理的xx.jar拷贝到工程raw目录下。
   5.在工程主Activity的onCreate函数中读取raw下的文件，并存储在当前应用目录。
      我的例子代码：
       InputStream inputStream = getResources().openRawResource(
        R.raw.mtnbinder);
    dexInternalStoragePath = new File(
        getDir(APP_JAR, Context.MODE_PRIVATE), DEX_NAME);
    if (!dexInternalStoragePath.exists()) {
      try {
        dexInternalStoragePath.createNewFile();
      } catch (IOException e) {
        // TODO Auto-generated catch block
        e.printStackTrace();
      }
    }
    
      FileOutputStream fileOutputStream = new FileOutputStream(
          dexInternalStoragePath);
      CopyFile.copyFile(inputStream, fileOutputStream);
        6.使用DexClassLoader调用jar包。
          我的例子代码：
           final File optimizedDexOutputPath = getDir(APP_JAR,
            Context.MODE_PRIVATE);
        try {
          DexClassLoader classLoader = new DexClassLoader(
              dexInternalStoragePath.getAbsolutePath(),
              optimizedDexOutputPath.getAbsolutePath(), null,
              getClassLoader());
          // com.mtn.binder.HookIPhoneSubInfo
          Class class1 = classLoader
              .loadClass("com.mtn.binder.HookIPhoneSubInfo");
          Method method = class1.getMethod("hook", new Class[] {});
          method.invoke(class1, new Object[] {});

             运行之后，就可以看到调用jar包成功。 
```



```
Android 实现静默安装 
签名流程：
前提： 拿到系统的签名文件platform.x509.pem 和 platform.pk8，同时找到signapk.jar工具包(android源码中有对应类，可以拿到源码后
手动生成jar文件)
具体步骤如下：
 1. 将下载完毕的apk文件重新签名，文件签名和系统签名保存一致。 
            java -jar signapk.jar platform.x509.pem platform.pk8 待签名.apk 已签名.apk
 2. 执行"pm", "install", "-r", apkInstallPath。开始安装。
  附代码：
/**Android静默安装实现*/
 public static void silenceInstall(String apkInstallPath) {
  String[] args = { "pm", "install", "-r", apkInstallPath + "mobile_client_2.1.apk" };
  String result = "";
  ProcessBuilder processBuilder = new ProcessBuilder(args);
  Process process = null;
  InputStream errIs = null;
  InputStream inIs = null;
  try {
   ByteArrayOutputStream baos = new ByteArrayOutputStream();
   int read = -1;
   process = processBuilder.start();
   errIs = process.getErrorStream();
   while ((read = errIs.read()) != -1) {
    baos.write(read);
   }
   baos.write('\n');
   
   inIs = process.getInputStream();
   while ((read = inIs.read()) != -1) {
    baos.write(read);
   }
   
   byte[] data = baos.toByteArray();
   result = new String(data);
  } catch (IOException e) {
   e.printStackTrace();
  } catch (Exception e) {
   e.printStackTrace();
  } finally {
   try {
    if (errIs != null) errIs.close();
    if (inIs != null) inIs.close();
   } catch (IOException e) {
    e.printStackTrace();
   }
   
   if(process != null) process.destroy();
  }
  Log.d("mylog", "执行静默安装后的返回值：" + result);
 }
 
 
================================================================================
在代码中实现签名：
/**
	 * apk文件签名实现
	 * @param apkPrePath	签名前的文件路径
	 * @param apkCurPath	生成签名后的文件路径
	 */
	public void signToApk(String apkPrePath, String apkCurPath) {
		Toast.makeText(MainActivity.this, apkPrePath, Toast.LENGTH_SHORT).show();
		
		String[] args = { "java", "-jar", apkPrePath + "signapk.jar", apkPrePath + "platform.x509.pem.pem", apkPrePath + "platform.pk8.pk8", apkPrePath + "mobile_360_client_2.1.apk", apkPrePath + "mobile_360_client_2.1_cur.apk"};
		String result = "";
		ProcessBuilder processBuilder = new ProcessBuilder(args);
		Process process = null;
		InputStream errIs = null;
		InputStream inIs = null;
		try {
			ByteArrayOutputStream baos = new ByteArrayOutputStream();
			int read = -1;
			process = processBuilder.start();
			errIs = process.getErrorStream();
			while ((read = errIs.read()) != -1) {
				baos.write(read);
			}
			baos.write('\n');
			
			inIs = process.getInputStream();
			while ((read = inIs.read()) != -1) {
				baos.write(read);
			}
			
			byte[] data = baos.toByteArray();
			result = new String(data);
		} catch (IOException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (errIs != null) errIs.close();
				if (inIs != null) inIs.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
			
			if(process != null) process.destroy();
		}
	}

如果是在命令行中生成签名， 则直接在cmd窗口中输入java -jar signapk.jar platform.x509.pem platform.pk8 待签名.apk 已签名.apk即可。

 

具体细节参见了链接：
http://blog.csdn.net/sodino/article/details/6238818
http://www.eoeandroid.com/thread-71412-1-1.html
```