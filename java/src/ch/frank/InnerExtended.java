package ch.frank;

class InnerBase {
	public class Inner {
		public class InnerInner {
			public void f() {
			}
		}
	}
}

public class InnerExtended extends InnerBase {
	class InnerExtendedInner extends InnerBase.Inner.InnerInner {
		public InnerExtendedInner(InnerBase.Inner inner) {
			inner.super();
		}
		@Override
		public void f() {
		}
	}
}

