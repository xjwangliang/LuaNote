###EventBus...


官方描述  

```
simplifies the communication between components  

decouples event senders and receivers

performs well with Activities, Fragments, and background threads

avoids complex and error-prone dependencies and life cycle issues

makes your code simpler

is fast

is tiny (<50k jar)

is proven in practice by apps with 100,000,000+ installs
```


###使用方式，三个步骤EventBus in 3 steps

- Define events:

```
public class MessageEvent { /* Additional fields if needed */ }
```
- Prepare subscribers:

```
eventBus.register(this);
public void onEvent(AnyEventType event) {/* Do something */};
```

- Post events:

```
eventBus.post(event);

```