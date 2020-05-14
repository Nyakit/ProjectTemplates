import Foundation

public class Condition<Value> {
    let message: String

    init(message: String) {
        self.message = message
    }

    func check(_ value: Value) -> Bool {
        fatalError("override")
    }
}

public final class PatternCondition: Condition<String> {
    private let pattern: String

    init(pattern: String, message: String) {
        self.pattern = pattern
        super.init(message: message)
    }

    override func check(_ value: String) -> Bool {
        let test = NSPredicate(format: "SELF MATCHES %@", pattern)
        if test.evaluate(with: value) {
            return true
        }
        return false
    }
}

public final class LengthCondition: Condition<String> {
    private let length: Int

    init(length: Int, message: String) {
        self.length = length
        super.init(message: message)
    }

    override func check(_ value: String) -> Bool {
        return value.count >= length
    }
}

public final class MaxLengthCondition: Condition<String> {
    private let length: Int

    init(length: Int, message: String) {
        self.length = length
        super.init(message: message)
    }

    override func check(_ value: String) -> Bool {
        return value.count <= length
    }
}

public final class EqualityCondition: Condition<String> {
    private let resource: () -> String

    init(resource: @escaping () -> String, message: String) {
        self.resource = resource
        super.init(message: message)
    }

    override func check(_ value: String) -> Bool {
        return self.resource() == value
    }
}

public final class IntValueCondition: Condition<String> {
    private let minValue: Int

    init(minValue: Int, message: String) {
        self.minValue = minValue
        super.init(message: message)
    }

    override func check(_ value: String) -> Bool {
        guard let value = Int(value) else {
            return true
        }
        return value >= minValue
    }
}
public final class CompareCondition: Condition<String> {
    private let mainObject: String

    init(mainObject: String, message: String) {
        self.mainObject = mainObject
        super.init(message: message)
    }

    override func check(_ value: String) -> Bool {
        return mainObject == value
    }
}

public struct Validator<T> {
    private let conditions: [Condition<T>]

    init(_ conditions: [Condition<T>]) {
        self.conditions = conditions
    }

    func validate(_ value: T) -> [String]? {
        if self.conditions.isEmpty {
            return nil
        }

        let results = self.conditions
            .compactMap { condition -> String? in
                if condition.check(value) {
                    return nil
                }
                return condition.message
        }

        return results
    }
}
