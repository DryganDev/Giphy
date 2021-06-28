//
//  KVO.swift
//  
//
//  Created by Artsiom Sazonau on 27.06.21.
//

import Foundation
import Combine

// MARK: - https://stackoverflow.com/questions/60386000/how-to-use-combine-framework-nsobject-keyvalueobservingpublisher/60390057#60390057
/// The type of value published from a publisher created from
/// `NSObject.keyValueObservationPublisher(for:)`. Represents either an
/// initial KVO observation or a non-initial KVO observation.
enum KeyValueObservation<T: Equatable>: Equatable {
    case initial(T)
    case notInitial(old: T, new: T)

    /// Sets self to `.initial` if there is exactly one element in the array.
    /// Sets self to `.notInitial` if there are two or more elements in the array.
    /// Otherwise, the initializer fails.
    ///
    /// - Parameter values: An array of values to initialize with.
    init?(_ values: [T]) {
        if values.count == 1, let value = values.first {
            self = .initial(value)
        } else if let old = values.first, let new = values.last {
            self = .notInitial(old: old, new: new)
        } else {
            return nil
        }
    }
}

extension NSObjectProtocol where Self: NSObject {

    /// Publishes `KeyValueObservation` values when the value identified
    /// by a KVO-compliant keypath changes.
    ///
    /// - Parameter keyPath: The keypath of the property to publish.
    /// - Returns: A publisher that emits `KeyValueObservation` elements each
    ///            time the property’s value changes.
    func keyValueObservationPublisher<Value>(for keyPath: KeyPath<Self, Value>)
        -> AnyPublisher<KeyValueObservation<Value>, Never> {

        // Gets a built-in KVO publisher for the property at `keyPath`.
        //
        // We specify all the options here so that we get the most information
        // from the observation as possible.
        //
        // We especially need `.prior`, which makes it so the publisher fires
        // the previous value right before any new value is set to the property.
        //
        // `.old` doesn't seem to make any difference, but I'm including it
        // here anyway for no particular reason.
        let kvoPublisher = publisher(for: keyPath,
                                     options: [.initial, .new, .old, .prior])

        // Makes a publisher for just the initial value of the property.
        //
        // Since we specified `.initial` above, the first published value will
        // always be the initial value, so we use `first()`.
        //
        // We then map this value to a `KeyValueObservation`, which in this case
        // is `KeyValueObservation.initial` (see the initializer of
        // `KeyValueObservation` for why).
        let publisherOfInitialValue = kvoPublisher
            .first()
            .compactMap { KeyValueObservation([$0]) }

        // Makes a publisher for every non-initial value of the property.
        //
        // Since we specified `.initial` above, the first published value will
        // always be the initial value, so we ignore that value using
        // `dropFirst()`.
        //
        // Then, after the first value is ignored, we wait to collect two values
        // so that we have an "old" and a "new" value for our
        // `KeyValueObservation`. This works because we specified `.prior` above,
        // which causes the publisher to emit the value of the property
        // _right before_ it is set to a new value. This value becomes our "old"
        // value, and the next value emitted becomes the "new" value.
        // The `collect(2)` function puts the old and new values into an array,
        // with the old value being the first value and the new value being the
        // second value.
        //
        // We then map this array to a `KeyValueObservation`, which in this case
        // is `KeyValueObservation.notInitial` (see the initializer of
        // `KeyValueObservation` for why).
        let publisherOfTheRestOfTheValues = kvoPublisher
            .dropFirst()
            .collect(2)
            .compactMap { KeyValueObservation($0) }

        // Finally, merge the two publishers we created above
        // and erase to `AnyPublisher`.
        return publisherOfInitialValue
            .merge(with: publisherOfTheRestOfTheValues)
            .eraseToAnyPublisher()
    }
}
