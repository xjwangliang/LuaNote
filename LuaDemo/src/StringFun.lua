str="[in brackets]"
print(string.sub(str,2,-2)) --in brackets
print(string.sub(str,2,-1))

print(string.upper(str))

--char
a=97
print(string.char(a))
print(string.char(a+1))

--byte
print(string.byte("abc",1,3))
print(string.byte("abc",1,-1))

--format
print(string.format("my name is %s","wangliang"))
print(string.format("my age is %s",26))
print(string.format("PI is %s",math.pi))    --PI is 3.1415926535898
print(string.format("PI is %.4f",math.pi))  --PI is 3.1416

year=2014;month=8;day=20
print(string.format("TODAY is %02d/%02d/%04d",month, day, year)) --TODAY is 08/20/2014
