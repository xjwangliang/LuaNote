###Object#wait
---
```
    让调用线程等待，并且只能在获取了这个对象(wait方法所属的对象)的锁(monitor)的线程中执行(This method can only be invoked by a thread which owns this object's monitor)，也就是说调用此方法，线程必须先获取monitor(否则IllegalMonitorStateException)。并且调用wait方法之后，调用线程会释放对象的锁(monitor),当被唤醒活着interrupt后才会重新获取锁。
    调用wait方法的线程可以被interrupt，所以在某些情况下（比如根据条件决定是否继续往下执行）就应该在loop中执行，以循环检查条件是否满足。A thread can also wake up without being notified, interrupted, or timing out, a so-called spurious wakeup. While this will rarely occur in practice, applications must guard against it by testing for the condition that should have caused the thread to be awakened, and continuing to wait if the condition is not satisfied. In other words, waits should always occur in loops, like this one:

	     synchronized (obj) {
	         while (<condition does not hold>)
	             obj.wait(timeout);
	         ... // Perform action appropriate to condition
	     }



	例子：HandlerThread.java

    /**
     * Call back method that can be explicitly overridden if needed to execute some
     * setup before Looper loops.
     */
    protected void onLooperPrepared() {
    }

    @Override
    public void run() {
        mTid = Process.myTid();
        Looper.prepare();
        synchronized (this) {
            mLooper = Looper.myLooper();
            notifyAll();
        }
        Process.setThreadPriority(mPriority);
        onLooperPrepared();
        Looper.loop();
        mTid = -1;
    }
    
    /**
     * This method returns the Looper associated with this thread. If this thread not been started
     * or for any reason is isAlive() returns false, this method will return null. If this thread 
     * has been started, this method will block until the looper has been initialized.  
     * @return The looper.
     */
    public Looper getLooper() {
        if (!isAlive()) {
            return null;
        }
        
        // If the thread has been started, wait until the looper has been created.
        synchronized (this) {
            while (isAlive() && mLooper == null) {
                try {
                    wait();
                } catch (InterruptedException e) {
                }
            }
        }
        return mLooper;
    }

```
###Object#notify()
---
```
notify方法也同wait一样，当前线程必须获取对象的锁(否则IllegalMonitorStateException)。在当前线程调用此方法后，要等到当前线程释放对象的锁之后，被唤醒的线程才能继续(也就是当前线程先释放锁，被唤醒的线程后重新获取锁)。

Wakes up a single thread that is waiting on this object's monitor. If any threads are waiting on this object, one of them is chosen to be awakened. The choice is arbitrary and occurs at the discretion of the implementation. A thread waits on an object's monitor by calling one of the wait methods.
The awakened thread will not be able to proceed until the current thread relinquishes the lock on this object. The awakened thread will compete in the usual manner with any other threads that might be actively competing to synchronize on this object; for example, the awakened thread enjoys no reliable privilege or disadvantage in being the next thread to lock this object.

This method should only be called by a thread that is the owner of this object's monitor. A thread becomes the owner of the object's monitor in one of three ways:

By executing a synchronized instance method of that object.
By executing the body of a synchronized statement that synchronizes on the object.
For objects of type Class, by executing a synchronized static method of that class.
Only one thread at a time can own an object's monitor.

```

###Thread#interrupt
---
```
实例方法，当前线程中断目标线程(interrupt所属的对象/线程)
Posts an interrupt request to this Thread. The behavior depends on the state of this Thread:

Threads blocked in one of Object's wait() methods or one of Thread's join() or sleep() methods will be woken up, their interrupt status will be cleared, and they receive an InterruptedException.
如果Thread是因为先前调用Object#wait或者Thread#sleep/Thread#join被阻塞的，那么调用此方法放之后被中断的线程将收到异常信息（InterruptedException），中断信息（状态）被清除。

Threads blocked in an I/O operation of an InterruptibleChannel will have their interrupt status set and receive an ClosedByInterruptException. Also, the channel will be closed.
如果是因为可中断的IO操作而阻塞，那么调用之后Thread将收到interrupt status，同时收到ClosedByInterruptException

If this thread is blocked in a java.nio.channels.Selector then the thread's interrupt status will be set and it will return immediately from the selection operation, possibly with a non-zero value, just as if the selector's  java.nio.channels.Selector#wakeup wakeup
如果是因为Selector阻塞而被中断，那么立即返回（收到非0值，类似于wakeup调用），Thread将收到interrupt status。

If none of the previous conditions hold then this thread's interrupt status will be set. Interrupting a thread that is not alive need not have any effect.
其他情形也会设置中断状态。中断一个死亡的（not alive）的线程没有任何影响。

```
###Thread#join
 
 ```
 让调用线程最多等待millis目标线程（join所属对象代表的线程）死亡：要么目标线程死亡就立即返回，否则最多等待millis（不管目标线程是否死亡）。如果等待中途有其他线程中断了当前调用线程，那么InterruptedException抛出
 
 public final synchronized void join(long millis)
    throws InterruptedException {
        long base = System.currentTimeMillis();
        long now = 0;

        if (millis < 0) {
            throw new IllegalArgumentException("timeout value is negative");
        }

        if (millis == 0) {
            while (isAlive()) {
                wait(0);
            }
        } else {
            while (isAlive()) {
                long delay = millis - now;
                if (delay <= 0) {
                    break;
                }
                wait(delay);
                now = System.currentTimeMillis() - base;
            }
        }
    }

```

例子Handler
---

HandlerThread:

```
    /**
     * Call back method that can be explicitly overridden if needed to execute some
     * setup before Looper loops.
     */
    protected void onLooperPrepared() {
    }

    public void run() {
        mTid = Process.myTid();
        Looper.prepare();
        synchronized (this) {
            mLooper = Looper.myLooper();
            notifyAll();
        }
        Process.setThreadPriority(mPriority);
        onLooperPrepared();
        Looper.loop();
        mTid = -1;
    }
    
    /**
     * This method returns the Looper associated with this thread. If this thread not been started
     * or for any reason is isAlive() returns false, this method will return null. If this thread 
     * has been started, this method will block until the looper has been initialized.  
     * @return The looper.
     */
    public Looper getLooper() {
        if (!isAlive()) {
            return null;
        }
        // If the thread has been started, wait until the looper has been created.
        synchronized (this) {
            while (isAlive() && mLooper == null) {
                try {
                    wait();
                } catch (InterruptedException e) {
                }
            }
        }
        return mLooper;
    }
```

使用  

```
		final HandlerThread thread = new HandlerThread(
						"registerDownloadListener");
		thread.setPriority(4);
		thread.start();
		Looper looper = thread.getLooper(); // Looper{40b90550}
		Handler sAsyncHandler = new Handler(looper);

```
子线程创建Handler

```
private Handler restartWorkerThread() {
            Handler ret = null;
            final SynchronousQueue<Handler> handlerQueue = new SynchronousQueue<Handler>();
            Thread thread = new Thread() {
                @Override
                public void run() {
                    if (MPConfig.DEBUG)
                        Log.i(LOGTAG, "Starting worker thread " + this.getId());

                    Looper.prepare();
                    
                    try {
                        handlerQueue.put(new AnalyticsMessageHandler());
                    } catch (InterruptedException e) {
                        throw new RuntimeException("Couldn't build worker thread for Analytics Messages", e);
                    }
                    Looper.loop();
                }
            };
            thread.setPriority(Thread.MIN_PRIORITY);
            thread.start();

            HandlerThread handlerThread = new HandlerThread("");
            new Handler(handlerThread.getLooper());
            try {
                ret = handlerQueue.take();
            } catch (InterruptedException e) {
                throw new RuntimeException("Couldn't retrieve handler from worker thread");
            }

            return ret;
        }
```

```
	public static int executeCommandLine(final String commandLine,
			final boolean printOutput, final boolean printError,
			final long timeout) throws IOException, InterruptedException,
			TimeoutException {
		
		Runtime runtime = Runtime.getRuntime();
		Process process = runtime.exec(commandLine);
		/* Set up process I/O. */
		// ...
		Worker worker = new Worker(process);
		worker.start();
		try {
			worker.join(timeout);
			if (worker.exit != null) {
				return worker.exit;
			} else {
				throw new TimeoutException();
			}
		} catch (InterruptedException ex) {
			worker.interrupt();
			Thread.currentThread().interrupt();
			throw ex;
		} finally {
			process.destroy();
		}
	}

	private static class Worker extends Thread {
		private final Process process;
		private Integer exit;

		private Worker(Process process) {
			this.process = process;
		}

		public void run() {
			try {
				exit = process.waitFor();
			} catch (InterruptedException ignore) {
				return;
			}
		}
	}

	public int exeCMD(String cmd) {
		try {
			Process process = Runtime.getRuntime().exec(cmd);
			ProcessWithTimeout processWithTimeout = new ProcessWithTimeout(process);
			/* Set up process I/O. */
			// ...
			int exitCode = processWithTimeout.waitForProcess(5000);
			if (exitCode == Integer.MIN_VALUE) {
				// Timeout
				return exitCode;
			} else {
				return -1;
			}
		} catch (IOException e) {
			e.printStackTrace();
		}
		return -1;

	}
	/**
	 * 
	 * @author wangliang
	 *
	 */
	private class ProcessWithTimeout extends Thread {
		private Process process;
		private int exitCode = Integer.MIN_VALUE;

		public ProcessWithTimeout(Process process) {
			this.process = process;
		}

		public int waitForProcess(int milliseconds) {
			this.start();

			try {
				this.join(milliseconds);
			} catch (InterruptedException e) {
				this.interrupt();
				Thread.currentThread().interrupt();
			} finally {
				process.destroy();
			}
			return exitCode;
		}

		@Override
		public void run() {
			try {
				exitCode = process.waitFor();
			} catch (InterruptedException ignore) {
				// Do nothing
			} catch (Exception ex) {
				// Unexpected exception
			}
		}
	}

	public static int executeCommandWithExecutors(final String command,
			final boolean printOutput, final boolean printError,
			final long timeOut) {
		// validate the system and command line and get a system-appropriate
		// command line
		String massagedCommand = validateSystemAndMassageCommand(command);

		try {
			// create the process which will run the command
			Runtime runtime = Runtime.getRuntime();
			final Process process = runtime.exec(massagedCommand);

			// consume and display the error and output streams
			StreamGobbler outputGobbler = new StreamGobbler(
					process.getInputStream(), "OUTPUT", printOutput);
			StreamGobbler errorGobbler = new StreamGobbler(
					process.getErrorStream(), "ERROR", printError);
			outputGobbler.start();
			errorGobbler.start();

			// create a Callable for the command's Process which can be called
			// by an Executor
			Callable<Integer> call = new Callable<Integer>() {
				public Integer call() throws Exception {
					process.waitFor();
					return process.exitValue();
				}
			};

			// submit the command's call and get the result from a
			Future<Integer> futureResultOfCall = Executors
					.newSingleThreadExecutor().submit(call);
			try {
				int exitValue = futureResultOfCall.get(timeOut,
						TimeUnit.MILLISECONDS);
				return exitValue;
			} catch (TimeoutException ex) {
				String errorMessage = "The command [" + command
						+ "] timed out.";
				// log.error(errorMessage, ex);
				throw new RuntimeException(errorMessage, ex);
			} catch (ExecutionException ex) {
				String errorMessage = "The command [" + command
						+ "] did not complete due to an execution error.";
				// log.error(errorMessage, ex);
				throw new RuntimeException(errorMessage, ex);
			}
		} catch (InterruptedException ex) {
			String errorMessage = "The command [" + command
					+ "] did not complete due to an unexpected interruption.";
			// log.error(errorMessage, ex);
			throw new RuntimeException(errorMessage, ex);
		} catch (IOException ex) {
			String errorMessage = "The command [" + command
					+ "] did not complete due to an IO error.";
			// log.error(errorMessage, ex);
			throw new RuntimeException(errorMessage, ex);
		}
	}
```
