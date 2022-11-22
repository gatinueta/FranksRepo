package ch.frank;

class InnerBase {
	public class Inner {
		public class InnerInner {
			public class InnerInnerInner {
				public void f() {}
			}
		}
	}
}

public class InnerExtended extends InnerBase {
	class InnerExtendedInner extends InnerBase.Inner.InnerInner.InnerInnerInner {
		public InnerExtendedInner(InnerBase.Inner.InnerInner inner) {
			inner.super();
		}
		@Override
		public void f() {
		}
	}
	public static void main(String[] args) {
		InnerBase innerBase = new InnerBase();
		InnerBase.Inner.InnerInner innerInner = innerBase.new Inner().new InnerInner();
		InnerExtendedInner ei = new InnerExtended().new InnerExtendedInner(innerInner);
		ei.f();
	}
}

