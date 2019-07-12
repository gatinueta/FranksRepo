package ch.frank;

import java.util.ArrayList;
import java.util.List;
import java.util.Random;

public class TestThreadLocal {
	static class MyObject {
		public MyObject() {
			System.out.println("constructing MyObject, current thread is " + Thread.currentThread().getId());
		}
		List<Long> m_list = new ArrayList<>();
	}
	static Random m_random = new Random();
	static class Singleton {
		ThreadLocal<MyObject> m_threadLocal = ThreadLocal.withInitial((() -> new MyObject()));
		MyObject m_object = new MyObject();
	}
	static Singleton m_singleton = new Singleton();
	private static void runThread() {
		System.out.println("thread " + Thread.currentThread().getId() + " starting");
		for (int i=0; i<3; i++) {
			m_singleton.m_threadLocal.get().m_list.add(Thread.currentThread().getId());
			m_singleton.m_object.m_list.add(Thread.currentThread().getId());
			try {
				Thread.sleep(m_random.nextInt(5000));
			} catch (InterruptedException e) {
				e.printStackTrace();
			}
		}
		System.out.println("thread " + Thread.currentThread().getId() + " terminating");
		System.out.println("thread local list: " + m_singleton.m_threadLocal.get().m_list.toString());
		System.out.println("global list: " + m_singleton.m_object.m_list.toString());
		
	}
	public static void main(String[] args) {
		new Thread(() -> runThread()).start();
		new Thread(() -> runThread()).start();
		new Thread(() -> runThread()).start();
	}
}
