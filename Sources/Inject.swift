//
// Created by Eduardo Appolinario on 2021-10-01.
//

open class BaseInject<T> {
    internal let objIdentifier = ObjectIdentifier(T.self)
    internal private(set) var componentName: String = ""
    internal private(set) var name: String? = nil
    internal private(set) lazy var component: DIComponent = {
        do {
            return try DIComponent.getComponent(componentName)
        } catch {
            fatalError("\(error)")
        }
    }()
    internal var currentValue: T?

    public init(_ componentName: String = DIComponent.defaultName, name: String? = nil) {
        self.componentName = componentName
        self.name = name
    }
}

@propertyWrapper
public final class Inject<T>: BaseInject<T> {
    public override init(_ componentName: String = DIComponent.defaultName, name: String? = nil) {
        super.init(componentName, name: name)
        do {
            //  The reason for declaring service:T is because currentValue is nullable,
            //  If we use this directly, resolveService will try to automatically resolver Optional<T> instead of T
            let service: T = try component.resolveService(name: name)
            self.currentValue = service
        } catch {
            fatalError("\(error)")
        }
    }

    public var wrappedValue: T {
        get {
            guard let v = currentValue else {
                fatalError("currentValue not initialized")
            }
            return v
        }
        set {
            currentValue = newValue
        }
    }
}

@propertyWrapper
public final class LazyInject<T>: BaseInject<T> {
    public override init(_ componentName: String = DIComponent.defaultName, name: String? = nil) {
        super.init(componentName, name: name)
    }

    public var wrappedValue: T {
        get {
            guard let v = currentValue else {
                do {
                    let newValue: T = try self.component.resolveService(name: self.name)
                    self.currentValue = newValue
                    return newValue

                } catch {
                    fatalError("\(error)")
                }
            }
            return v
        }
        set {
            currentValue = newValue
        }
    }
}
