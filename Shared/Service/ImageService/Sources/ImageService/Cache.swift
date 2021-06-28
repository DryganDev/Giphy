//
//  Cache.swift
//  GiphyApp
//
//  Created by Artsiom Sazonau on 9.06.21.
//

import Foundation
import Combine

public final class Cache<T: AnyObject, Y: AnyObject>: NSCache<AnyObject,AnyObject>, Subject, NSCacheDelegate {
    
    public typealias Output = (T, Y)
    
    public typealias Failure = Never
    
    let wrapped: PassthroughSubject<Output, Failure>
    
    override init() {
        
        self.wrapped = .init()
        super.init()
    }

    public func send(_ value: Output) {
        wrapped.send(value)
    }

    public func send(completion: Subscribers.Completion<Failure>) {
        wrapped.send(completion: completion)
    }

    public func send(subscription: Subscription) {
        wrapped.send(subscription: subscription)
    }

    public func receive<Downstream: Subscriber>(subscriber: Downstream) where Failure == Downstream.Failure, Output == Downstream.Input {
        wrapped.subscribe(subscriber)
    }
    
    public override func setObject(_ obj: AnyObject, forKey key: AnyObject) {
        super.setObject(obj, forKey: key)
        let tupple = (key, obj) as! (T, Y)
        wrapped.send(tupple)
    }
    
    public override func object(forKey key: AnyObject) -> AnyObject? {
        super.object(forKey: key)
    }
    
    // MARK: - NSCacheDelegate
    public func cache(_ cache: NSCache<AnyObject, AnyObject>, willEvictObject obj: Any) {
        
    }
    
}

