import java.util.List;
import java.util.ArrayList;

class TypedPersisters {
    static abstract class Entity {
    }

    static class AEntity extends Entity {
        private int m_a;
        private int m_key;
        int getA() { return m_a; }
        void setA(int a) {
            m_a = a;
        }
        void setKey(int key) {
            m_key = key;
        }
    }

    static class BEntity extends Entity {
        private String m_b;
        private int m_key;
        String getB() {
            return m_b;
        }
        void setB(String b) {
            m_b = b;
        }
        void setKey(int key) {
            m_key = key;
        }
    }

    interface EntityMapper<E extends Entity> {
        void generate();
        void prepareForPersist();
        E getEntity();
    }

    static class KeyService {
        static int currentKey = 0;
        static int getNextKey() {
            currentKey++;
            return currentKey;
        }
    }

    static class AEntityMapper implements EntityMapper<AEntity> {
        private AEntity m_aEntity;
        @Override
        public void generate() {
            m_aEntity = new AEntity();
            m_aEntity.setA(10);
        }
        @Override
        public void prepareForPersist() {
            int key = KeyService.getNextKey();
            m_aEntity.setKey(key);
        }
        @Override
        public AEntity getEntity() {
            return m_aEntity;
        }
    }

    public static void main(String[] args) {
        List<Entity> entities = new ArrayList<>();
        AEntityMapper aEntityMapper = new AEntityMapper();
        aEntityMapper.generate();
        aEntityMapper.prepareForPersist();
        Entity e = aEntityMapper.getEntity();
    }
}


