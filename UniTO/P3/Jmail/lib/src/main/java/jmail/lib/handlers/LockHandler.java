package jmail.lib.handlers;

import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantReadWriteLock;

public class LockHandler {
    private static final LockHandler instance = new LockHandler();
    /** La chiave del lock è l'uuid del'utente TODO: Documentare */
    private final ConcurrentHashMap<String, CountableLock> lockMap;

    private LockHandler() {
        lockMap = new ConcurrentHashMap<>();
    }

    public static LockHandler getInstance() {
        // https://errorprone.info/bugpattern/DoubleCheckedLocking
        // https://www.infoworld.com/article/2075306/can-double-checked-locking-be-fixed-.html
        //    if (instance == null) {
        //      synchronized (LockHandler.class) {
        //        if (instance == null) {
        //          instance = new LockHandler();
        //        }
        //      }
        //    }
        return instance;
    }

    private CountableLock getLock(String key) {
        return lockMap.getOrDefault(key, new CountableLock());
    }

    public Lock getWriteLock(String key) {
        var lock = getLock(key);
        lock.occurences.incrementAndGet();
        return lock.writeLock();
    }

    public Lock getReadLock(String key) {
        var lock = getLock(key);
        lock.occurences.incrementAndGet();
        return getLock(key).readLock();
    }

    public void removeLock(String key) {
        var lock = getLock(key);
        if (lock.occurences.decrementAndGet() == 0) {
            lockMap.remove(key);
        }
    }

    private static class CountableLock extends ReentrantReadWriteLock {
        public final AtomicInteger occurences = new AtomicInteger();
    }
}
