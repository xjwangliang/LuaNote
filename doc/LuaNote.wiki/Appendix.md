http://www.geeksforgeeks.org/next-power-of-2/

```
	static final int MAXIMUM_CAPACITY = 1 << 30;
	private static int roundUpToPowerOf2(int number) {
		// assert number >= 0 : "number must be non-negative";
//		int rounded = number >= MAXIMUM_CAPACITY ? MAXIMUM_CAPACITY
//				: (rounded = Integer.highestOneBit(number)) != 0 ? (Integer
//						.bitCount(number) > 1) ? rounded << 1 : rounded : 1;

		int rounded = 0 ;
		if(number >= MAXIMUM_CAPACITY){
			//超过最大数，则为最大数
			rounded = MAXIMUM_CAPACITY ;
		}else {
			//获取最高位数字表示的数，负数得到10000000000000000000000000000000（Integer种最小的数）
			rounded = Integer.highestOneBit(number) ;
			//最高位的数字表示的数不为0（即number非0）
			if(rounded != 0){
				boolean flag = Integer.bitCount(number) > 1;
				if(flag){
					//1的位数大于1（表示不是2的次方），向左移动一位
					rounded = rounded << 1 ;
				}else {
					
				}
			}else {
				//number为0
				rounded = 1 ;
			}
		}
		return rounded;
	}
```