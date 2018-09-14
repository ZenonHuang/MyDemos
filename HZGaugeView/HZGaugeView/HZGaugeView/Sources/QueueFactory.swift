import Foundation

class QueueFactory {

    private static let queueKey = DispatchSpecificKey<String>()

    static let queue: DispatchQueue = {
        //定义了一个队列
        let q = DispatchQueue(label: "Zenon.ProcessingQueue")
        //在队列里面加入一个Specific的标识，通常用于之后判断是不是在这个队列里面，取不出来就不在这个队列
        q.setSpecific(key: QueueFactory.queueKey, value: "Zenon.ProcessingQueue")
        return q
    }()

    static func getQueue() -> DispatchQueue {
        //获取队列
        return QueueFactory.queue
    }

    static func onQueue() -> Bool {
        //根据 Specific的标识判断，是否存在
        return DispatchQueue.getSpecific(key: QueueFactory.queueKey) == "Zenon.ProcessingQueue"
    }

    static func executeOnQueueSynchronizedly<T>(block: () throws -> T ) rethrows -> T {
        if onQueue() {//存在，直接回调 block
            return try block()
        } else {//不存在，调取 getQueue 的 sync 方法，再回调 block
            return try getQueue().sync {
                return try block()
            }
        }
    }
}
