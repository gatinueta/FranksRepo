import java.util.List;
import java.util.ArrayList;

public class Erasure {
    private static void fill(List<? super Number> list) {
        list.add(Integer.valueOf(10));
        list.add(Long.valueOf(210L));
        list.add(Float.valueOf(12.5f));
    }
    private static void print(List<? extends Number> numberList) {
        for (Number n: numberList) {
            System.out.println(n.longValue());
        }
    } 
    public static void main(String[] args) {
        List<Object> list = new ArrayList<>();
        fill(list);
        List<Number> nList = new ArrayList<>();
        fill(nList);

        List<Number> numberList = (List<Number>)(List<?>)list;
        print(numberList);
        print(nList);
    }
}


