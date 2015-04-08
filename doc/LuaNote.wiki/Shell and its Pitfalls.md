#删除svn状态为！的文件
svn status | awk '$1=="!" {print $2}' | xargs svn delete
类似的
find . -iname "*foobar*" | xargs rm


#Example
```
插入行/追加行/替换行命令: i/a/c

example
	#==================
	使用行替换命令将第2行到最后一行的内容全部替换成'----'：

	sed '2,$c\
	--------------------------------------
	' 

	#==================
	删除第2行到最后一行
	cat test |sed '2,$d'

	#==================
	在第2行后面添加'------'：

	$ sed '2a\
	--------------------------------------
	' list

	#==================
	=命令显示当前行行号
	sed '=' list

	#==================
	Add a prefix string to beginning of each line
	sed -e 's/^/prefix/' file

	# If you want to edit the file in-place
	sed -i -e 's/^/prefix/' file

	# If you want to create a new file
	sed -e 's/^/prefix/' file > file.new

	awk '$0="prefix"$0' file > new_file
	
	#==================
	prepend a line number and tab to each line of a text file
	cat -n somefile.txt
	awk '{printf "%d\t%s\n", NR, $0}' < filename
	nl lines.txt

 	grep -n . file.txt | sed 's/\(^[0-9]*\):/\1    /g'
 	# this is a tab with Ctrl-V + Tab  =====>  ----
```
###CP
http://stackoverflow.com/questions/195655/how-to-copy-a-file-to-multiple-directories-using-the-gnu-cp-command 
http://stackoverflow.com/questions/216995/how-can-i-use-inverse-or-negative-wildcards-when-pattern-matching-in-a-unix-linu
```
复制指定文件
find . -iname "*foobar*" -exec cp "{}" ~/foo/bar \;
cp `ls | grep -v Music` /target_directory
for f in `find . -not -name "*Music*"`
do
    cp $f /target/dir
done
find . -maxdepth 1 ! -iname "*b*" -exec cp "{}" folder/  \;
find . -maxdepth 1 -not -iname "*b*" -exec cp "{}" folder/  \;

ls | grep -v "Music" | while read filename
do
cp "$filename" /target_directory
done

for FILE in *.txt; do                        # for each .txt file
    case "${FILE##*/}" in                    #   match on file basename
        *~|*-|*.bak|*.tmp|"#"*"#") continue;;  #     skip backup files
    esac
    #
    # do stuff with FILE here
    #
done

#find . -name "*b*" -exec sh -c 'echo "$@" ' sh {}  +


复制a1.txt到多个文件
echo file1 file2 file3 | xargs -n 1 cp a1.txt

复制a1.txt到多个folder
echo dir11/ dir22/ dir33/ | xargs -n 1 cp a1.txt 

复制a1.txt到多个文件（需要指定文件名）
cat <inputfile> | tee <outfile1> <outfile2> > /dev/null
cat a1.txt  | tee out11/a1.txt out22/a1.txt  > /dev/null

复制多个文件
cp ../dir5/dir4/dir3/dir2/file[1234] .
or (in Bash)

cp ../dir5/dir4/dir3/dir2/file{1..4} .
If the file names are non-contiguous, you can use

cp ../dir5/dir4/dir3/dir2/{march,april,may} .
```
###set
```
set $(echo 1 2 3 )
set 1 2 3
是一样的，就是设置$1为1，$2为2，$3为3.
```

###Sed(Add quotes)
```
find . -name '*b*' | sed 's/.*/"&"/'

#转义
r="android.library.reference.1=..\/LSGameSdk_lib" 			
sed -i "" "s/$r//g" $progdir/$release_dir/$line/tvpay/project.properties

echo "${someid}" | sed 's/\//\\\//'

#someidformatted=`echo "${someid}" | sed 's/\//\\\//'`报错：When the old-style backquote form of substitution is used, backslash retains its literal meaning except when followed by $, ‘, or \. The first backquote not preceded by a backslash terminates the command substitution. When using the $(command) form, all characters between the parentheses make up the command; none are treated specially. 反引号``中字符都是原始字符，除非后面跟随的是$或者\（它们都转义）,此时可用$(command) 解决。（an occurrence of \\ gets turned to \. Adding more backslashes works）
# someidformatted=$(echo "${someid}" | sed 's/\//\\\//')
或者
someidformatted=`echo "${someid}" | sed 's#\/#\\\/#'`

讲test文件中包含wang的行前面加上#
cat test  | sed 's/.*wang.*/#&/'

```

### Delete all files except some:

_delete file its name is not "test2"_
```
ls * | grep -v test2  | delete 
```

OR
```
find . \! -name 'test2' -delete 
```

###Get certain process and kill
```
ps -aux | grep <string> | awk '{print $1}' | <sudo> xargs kill -9
ps -ef | grep <string> | awk '{print $1}' | <sudo> xargs kill -9
```

###print last modified
```
ls -ls |  tr ':' ' ' | awk '{mm=sprintf("%02d%02d",$7,$8) ;print  mm $9 $10;}'
```		
### give THEFILE the same time as Referencefile
```
touch -r Referencefile  THEFILE 
```
###match usage
```
echo "F" | awk '{mm=sprintf("%02d",(match("JanFebMarAprMayJunJulAugSepOctNovDec", $1)+2)/3) ; print mm}'
```		
### get current year
```
date | cut -b 1-4
```

###数组
```
在Shell中，用括号来表示数组，数组元素用“空格”符号分割开。定义数组的一般形式为：
    array_name=(value1 ... valuen)
    array_name=(value0 value1 value2 value3)
    array_name=(
		value0
		value1
		value2
		value3
	)
	
还可以单独定义数组的各个分量(可以不使用连续的下标，而且下标的范围没有限制)：
	array_name[0]=value0
	array_name[1]=value1
	array_name[2]=value2
	
读取数组元素值的一般格式是：
    ${array_name[index]}
    
使用@ 或 * 可以获取数组中的所有元素
    
获取数组长度的方法与获取字符串长度的方法相同
    
    # 取得数组元素的个数
	length=${#array_name[@]}
	
	# 或者
	length=${#array_name[*]}
	
	# 取得数组单个元素的长度
	lengthn=${#array_name[n]}
    
```

###字符串分割
#####IFS and Array
```
(IFS=.;set -- $(echo 192.168.123.444) ;echo $4 $3 $2 $1)
>444 123 168 192

http://en.wikipedia.org/wiki/Internal_field_separator

IN="www:wangliang:hello"
IFS=':' read -ra ADDR <<< "$IN"
printf "%s\n" "${ADDR[@]}"
for i in "${ADDR[@]}"; do
	echo $i
done

或者：
IN="bla@some.com;john@home.com" 
set -- "$IN" 
SaveIFS=$IFS
IFS=";"; declare -a Array=($*)
IFS=$SaveIFS 
echo "${Array[@]}" 
echo "${Array[0]}" 
echo "${Array[1]}"




```
#####tr
```
IN="www:wangliang:hello"
for i in $(echo $IN | tr ":" "\n")
do
  echo $i
done

或者：
IN="bla@some.com;john@home.com"
arr=(`echo $IN | tr ';' ' '`)
....#已经得到数组，接下来同上
```

```
http://www.linuxquestions.org/questions/programming-9/bash-shell-script-split-array-383848/#post3270796

IN="www:wangliang:hello"
arrIN=(${IN//:/ })
printf "%s\n" "${arrIN[@]}" 
for v in "${arrIN[@]}"; do echo "${v}";done

```

cmd1 && cmd2 || cmd3

```
cmd1 && cmd2 || cmd3

有人喜欢用这种格式来代替 if...then...else 结构，但其实并不完全一样。如果cmd2返回一个非真值，那么cmd3则会被执行。 所以还是老老实实地用 if cmd1; then cmd2; else cmd3 为好.

var="bla@some.com;john@home.com;Full Name <fulnam@other.org>"
while [ "$var" ] ;do
    iter=${var%%;*}
    echo "> [$iter]"
    [ "$var" = "$iter" ] && \
        var='' || \
        var="${var#*;}"
  done
> [bla@some.com]
> [john@home.com]
> [Full Name <fulnam@other.org>]

```

awk

```
echo "bla@some.com;john@home.com" | awk -F';' '{print $1,$2}'
```

sed

```
echo "bla@some.com;john@home.com" | sed -e 's/;/\n/g'
```

cut

```
cut -d<delimiter> -f<fieldnums>

echo 1.2.3.4 | cut -d\. -f3  
>3
```

```
// print last modified
		//ls -ls |  tr ':' ' ' | awk '{mm=sprintf("%02d%02d",$7,$8) ;print  mm $9 $10;}'
		
		
		// give THEFILE the same time as Referencefile
		//touch -r Referencefile  THEFILE -->
		
		// match usage
		//echo "F" | awk '{mm=sprintf("%02d",(match("JanFebMarAprMayJunJulAugSepOctNovDec", $1)+2)/3) ; print mm}'
		
		// get current year
		// date | cut -b 1-4
```



http://blog.charlee.li/bash-pitfalls/

###for i in `ls *.mp3`
```
常见的错误写法：
   for i in `ls *.mp3`; do     # Wrong!

为什么错误呢？因为for...in语句是按照空白来分词的，包含空格的文件名会被拆成多个词。 如遇到 01 - Don't Eat the Yellow Snow.mp3 时，i的值会依次取 01，-，Don't，等等。

用双引号也不行，它会将ls *.mp3的全部结果当成一个词来处理。

   for i in "`ls *.mp3`"; do   # Wrong!
正确的写法是
   for i in *.mp3; do
```

###cp $file $target
```
这句话基本上正确，但同样有空格分词的问题。所以应当用双引号：

cp "$file" "$target"

但是如果凑巧文件名以 - 开头，这个文件名会被 cp 当作命令行选项来处理，依旧很头疼。可以试试下面这个。

cp -- "$file" "$target"

运气差点的再碰上一个不支持 -- 选项的系统，那只能用下面的方法了：使每个变量都以目录开头。

for i in ./*.mp3; do
  cp "$i" /target
  ...
```

###[ $foo = "bar" ]
```
当$foo为空时，上面的命令就变成了

[ = "bar" ]
类似地，当$foo包含空格时：

[ multiple words here = "bar" ]
两者都会出错。所以应当用双引号将变量括起来：

[ "$foo" = bar ]      # 几乎完美了。
但是！当$foo以 - 开头时依然会有问题。 在较新的bash中你可以用下面的方法来代替，[[ 关键字能正确处理空白、空格、带横线等问题。

[[ $foo = bar ]]      # 正确
旧版本bash中可以用这个技巧（虽然不好理解）：

[ x"$foo" = xbar ]    # 正确
或者干脆把变量放在右边，因为 [ 命令的等号右边即使是空白或是横线开头，依然能正常工作。 （Java编程风格中也有类似的做法，虽然目的不一样。）

[ bar = "$foo" ]      # 正确

```
###[ $foo > 7 ]
```
[ $foo > 7 ]

很可惜 [[ 只适用于字符串，不能做数字比较。数字比较应当这样写：

(( $foo > 7 ))
或者用经典的写法：

[ $foo -gt 7 ]
但上述使用 -gt 的写法有个问题，那就是当 $foo 不是数字时就会出错。你必须做好类型检验。

这样写也行。

[[ $foo -gt 7 ]]
```

###[ "$foo" = bar && "$bar" = foo ]
```

[ 中不能使用 && 符号！因为 [ 的实质是 test 命令，&& 会把这一行分成两个命令的。应该用以下的写法。

[ bar = "$foo" -a foo = "$bar" ]       # Right!
[ bar = "$foo" ] && [ foo = "$bar" ]   # Also right!
[[ $foo = bar && $bar = foo ]]         # Also right!
```

###引号嵌套
```

cd `dirname "$f"`

同样也存在空格问题。那么加上引号吧。

cd "`dirname "$f"`"
问题来了，是不是写错了？由于双引号的嵌套，你会认为`dirname 是第一个字符串，`是第二个字符串。 错了，那是C语言。在bash中，命令替换（反引号``中的内容）里面的双引号会被正确地匹配到一起， 不用特意去转义。

$()语法也相同，如下面的写法是正确的。

cd "$(dirname "$f")"
但是echo -e "``"没问题，而echo -e "`"就有问题了，改成echo -e '`'正确
```


###！
```
echo "Hello World!"

交互执行这条命令会产生以下的错误：
-bash: !": event not found
因为 !" 会被当作命令行历史替换的符号来处理。不过在shell脚本中没有这样的问题。
不幸的是，你无法使用转义符来转义!：
$ echo "hi\!"hi\!
解决方案之一，使用单引号，即
$ echo 'Hello, world!'
```

###if [grep foo myfile]

```
初学者常犯的错误，就是将 if 语句后面的 [ 当作if语法的一部分。实际上它是一个命令，相当于 test 命令， 而不是 if 语法。这一点C程序员特别应当注意。

if 会将 if 到 then 之间的所有命令的返回值当作判断条件。因此上面的语句应当写成

if grep foo myfile > /dev/null; then

test命令的用法：

（1）
if [ $a = $b ]
then
   echo "$a = $b : a is equal to b"
else
   echo "$a = $b: a is not equal to b"
fi


（2）
if [ $a ]
then
   echo "$a : string is not empty"
else
   echo "$a : string is empty"
fi
```

###if [ [ a = b ] && [ c = d ] ]
```

同样的问题，[ 不是 if 语句的一部分，当然也不是改变逻辑判断的括号。它是一个命令。可能C程序员比较容易犯这个错误？

if [ a = b ] && [ c = d ]        # 正确
```

###管道
```
cat file | sed s/foo/bar/ > file

你不能在同一条管道操作中同时读写一个文件。根据管道的实现方式，file要么被截断成0字节，要么会无限增长直到填满整个硬盘。 如果想改变原文件的内容，只能先将输出写到临时文件中再用mv命令。

sed 's/foo/bar/g' file > tmpfile && mv tmpfile file
```
 
###引号
```
echo $foo

这句话还有什么错误码？一般来说是正确的，但下面的例子就有问题了。

MSG="Please enter a file name of the form *.zip"
echo $MSG         # 错误！
如果恰巧当前目录下有zip文件，就会显示成

Please enter a file name of the form freenfss.zip lw35nfss.zip
所以即使是echo也别忘记给变量加引号。
```

###here document
```
echo <<EOF

here document是个好东西，它可以输出成段的文字而不用加引号也不用考虑换行符的处理问题。 不过here document输出时应当使用cat而不是echo。

# This is wrong:
echo <<EOF
Hello world
EOF


# This is right:
cat <<EOF
Hello world
EOF
```

###&&

```
cd /foo; bar

cd有可能会出错，出错后 bar 命令就会在你预想不到的目录里执行了。所以一定要记得判断cd的返回值。

cd /foo && bar
如果你要根据cd的返回值执行多条命令，可以用 ||。

cd /foo || exit 1;
bar
baz
关于目录的一点题外话，假设你要在shell程序中频繁变换工作目录，如下面的代码：

find ... -type d | while read subdir; do
  cd "$subdir" && whatever && ... && cd -
done
不如这样写：

find ... -type d | while read subdir; do
  (cd "$subdir" && whatever && ...)
done
括号会强制启动一个子shell，这样在这个子shell中改变工作目录不会影响父shell（执行这个脚本的shell）， 就可以省掉cd - 的麻烦。

你也可以灵活运用 pushd、popd、dirs 等命令来控制工作目录。
```

###==
```
[ bar == "$foo" ]

[ 命令中不能用 ==，应当写成

[ bar = "$foo" ] && echo yes
[[ bar == $foo ]] && echo yes
```

###;
```
for i in {1..10}; do ./something &; done

& 后面不应该再放 ; ，因为 & 已经起到了语句分隔符的作用，无需再用;。

for i in {1..10}; do ./something & done
```

###$@
```
for arg in $*

$*表示所有命令行参数，所以你可能想这样写来逐个处理参数，但参数中包含空格时就会失败。如：

#!/bin/bash
# Incorrect version
for x in $*; do
  echo "parameter: '$x'"
done


$ ./myscript 'arg 1' arg2 arg3
parameter: 'arg'
parameter: '1'
parameter: 'arg2'
parameter: 'arg3'
正确的方法是使用 $@。

#!/bin/bash
# Correct version
for x in "$@"; do
  echo "parameter: '$x'"
done


$ ./myscript 'arg 1' arg2 arg3
parameter: 'arg 1'
parameter: 'arg2'
parameter: 'arg3'
在 bash 的手册中对 $* 和 $@ 的说明如下：

*    Expands to the positional parameters, starting from one.  
     When the expansion occurs within double quotes, it 
     expands to a single word with the value of each parameter 
     separated by the first character of the IFS special variable.  
     That is, "$*" is equivalent to "$1c$2c...",
@    Expands to the positional parameters, starting from one. 
     When the expansion occurs within double quotes, each 
     parameter expands to a separate word.  That  is,  "$@"  
     is equivalent to "$1" "$2" ...  
可见，不加引号时 $* 和 $@ 是相同的，但"$*"会被扩展成一个字符串，而 "$@" 会 被扩展成每一个参数。
```


###function
```
function foo()

在bash中没有问题，但其他shell中有可能出错。不要把 function 和括号一起使用。 最为保险的做法是使用括号，即

foo() {
  ...
}
```