print("hello")
-----------------------------------------------------
--算数运算
  a = 10
  b = -3
  r = a % b --a - floor(a/b) * b，结果与与b的符号相同
  print(r)
  
  a = 10.3
  n = a % 1 --去正实数的小数部分：0.3
  p = a - n --取正实数的整数部分：10
  print(n , p)
  
  
  a = -10.3
  n = a % (-1)  --去负实数的小数部分：-0.3
  p = a - n     --取负实数的整数部分：-10
  print(n , p)
  
  x = math.pi
  print(x - x%0.01) --取精确到小数点两位的结果:3.14（不会进行四舍五入，直接截取）
  
-----------------------------------------------------
--  关系运算 <、>、>=、<=、~=、==
--  对与table/userdata/函数，比较的是引用(是否引用同一个对象)，不是内容
arr1 = {}; arr1.x = 10; arr1.y = 10
arr2 = {}; arr2.x = 10; arr2.y = 10
arr3 = arr1
print("arr1 == arr2? " .. tostring((arr1 == arr2))) -- false
print("arr1 == arr2? " .. tostring((arr1 == arr3))) -- true

-- table
print(type(arr1))

-----------------------------------------------------
-- 逻辑运算(and、or、not),and(第一个为假，就返回第一个，否则返回第二个)和or(第一个为真就返回第一个，否则返回第二个)都是短路求值
print(false and "hello")  --false
print(nil or "hello")     --hello
print(false or "hello")   --hello
print(4 or "hello")       --4
print(4 and "hello")      --hello

if ((type(arr1) == "table") and arr1.x == 10) then
	print("arr1 is a table and arr1.x = " .. arr1.x)
end

-----------------------------------------------------
-- x = x or v
default = "default_value"
x_value = x_value or default
print(x_value)

if not x_value then  x_value = default end
print(x_value)

-----------------------------------------------------
--a and b or c (前提是b要为真，and的优先级大于or，类似于a ? b : c),
a = 10
b = 12
max = (a > b) and a or b --等价于max(x,y)，如果a和b未定义，会报错的
print(max, ((a > b)))

-----------------------------------------------------
--table
my_table = {"Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"}
for var=1, #my_table do
	print("my_table[".. var .. "]=" .. my_table[var]) --索引从1开始
end

rev_table = {}
my_table[0]=100
for key, var in pairs(my_table) do
	print("pairs <" .. key .. ", " .. var .. ">")
	rev_table[var] = key
end

--table反转
print("rev_table is",#rev_table) --结果为0，因为#rev_table计算的是以整数为key的entry的个数
for key, var in pairs(rev_table) do
  print("rev_table[".. key .. "]=" .. var) --索引从1开始
end

complex_table = {x=10, y=20}
complex_table.z = my_table; --用table作为value
print(complex_table.z[2])

complex_data = {color="blue", thickness=2.3, points_count=4,
  {x=10,y=3},
  {x=30,y=8},
  {x=20,y=13},
  {x=50,y=6}
}

for key, var in pairs(complex_data) do
  print("complex_data pairs <" .. key .. ", " .. tostring(var) .. ">")
end

for var=1, #complex_data do
  print("complex_data[".. var .. "]=" .. tostring(complex_data[var].x)) --索引从1开始(attempt to concatenate field '?' (a table value))
end

complex_data2 = {
  ["*"] = "mul", ["/"] = "div", ["+"] = "add", ["-"] = "sub"
}
-----------------------------------------------------
--赋值
x = 10; y = 100
x, y = y, x
print(x,y)

complex_data2["+"], complex_data2["-"] = complex_data2["-"], complex_data2["+"]
print(complex_data2["+"], complex_data2["-"])


--作用域
global_var = 10
do
  local global_var = 122  --local
  global_var = 10000      --local
  print("global_var is " .. global_var) --问题，如何访问全局变量？
end

local global_var = global_var;          --创建一个local变量，并且用global变量初始化
print("global_var is " .. global_var)






--  public static String a(Context paramContext)
--  {
--    String str = "";
--    if (((paramContext = (WifiManager)paramContext.getSystemService("wifi")) != null) && ((paramContext = paramContext.getConnectionInfo()) != null))
--      str = paramContext.getMacAddress();
--    return str;
--  }
--
--  public static String a()
--  {
--    String str1 = null;
--    String str2 = "";
--    try
--    {
--      localObject = Runtime.getRuntime().exec("cat /sys/class/net/eth0/address ");
--      localObject = new InputStreamReader(((Process)localObject).getInputStream());
--      localObject = new LineNumberReader((Reader)localObject);
--      while (str2 != null)
--        if ((str2 = ((LineNumberReader)localObject).readLine()) != null)
--        {
--          str1 = str2.trim();
--          break;
--        }
--    }
--    catch (IOException localIOException)
--    {
--      Object localObject;
--      (localObject = localIOException).printStackTrace();
--    }
--    return str1;
--  }
