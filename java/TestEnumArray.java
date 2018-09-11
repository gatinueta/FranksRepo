import java.util.EnumMap;
import java.util.Arrays;

public class TestEnumArray {
    static class EnumArray<K extends Enum<K>,V> {
        private EnumMap<K,V> map;
        EnumArray(Class<K> enumClass) {
            map = new EnumMap<K,V>(enumClass);
            K[] keys = enumClass.getEnumConstants();
            for (K key: keys) {
                map.put(key, null);
            }
        }
        void set(K name, V value) {
            map.put(name, value);
        }

        V[] toArray(V[] arr) {
            return map.values().toArray(arr);
        }
    }
    enum EnglishNumbers {
        ONE,
        TWO,
        THREE,
        FOUR
    }
    public static void main(String[] args) {
        EnumArray<EnglishNumbers, String> enumArray = new EnumArray<>(EnglishNumbers.class);
        enumArray.set(EnglishNumbers.TWO, "two");
        enumArray.set(EnglishNumbers.FOUR, "four");
        System.out.println(Arrays.toString(enumArray.toArray(new String[0])));
    }
}

    
