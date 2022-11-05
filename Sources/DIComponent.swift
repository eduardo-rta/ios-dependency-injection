//
// Created by Eduardo Appolinario on 2021-10-01.
//

public class DIComponent {
    public static var components = [String: DIComponent]()
    
    public static let defaultName = ""

    public let componentName: String
    private var modules: [DIModule]

    private init(_ componentName: String, _ modules: [DIModule]) throws {
        DIComponent.validateDuplicatedModules(modules)
        
        self.modules = modules
        self.componentName = componentName
        
        try self.modules.forEach { m in
            try m.registerAllServices()
        }
    }

    fileprivate func getServiceRegistration<T>(name: String? = nil) -> DIService<T>? {
        let ri = RegistryIdentifier(
            id: ObjectIdentifier(T.self),
            name: name
        )
        
        for m in self.modules {
            if let r = m.registry[ri] as? DIService<T> {
                return r
            }
        }
        return nil
    }
    
    private static func validateDuplicatedModules(_ modules: [DIModule]) {
        modules.forEach { m in
            let hasDuplicated = modules.filter({ mf in
                return type(of: m) == type(of: mf)
            }).count > 1
            
            if (hasDuplicated) {
                fatalError("")
            }
        }
    }

    public func resolveService<T>(name: String? = nil) throws -> T {
        if (_isOptional(T.self)) {
            throw DIError.serviceDeclarationCannotBeOptional("\(T.self)")
        }

        guard let registration: DIService<T> = self.getServiceRegistration(name: name) else {
            throw DIError.serviceNotRegistered("\(T.self)")
        }
        return try registration.getInstance()
    }

    private func addModule(_ module: DIModule) throws {
        if let _ = self.modules.first(where: { m in (m as AnyObject) === (module as AnyObject) }) {
            throw DIError.moduleAlreadyRegistered
        }
        self.modules.append(module)
    }

    @discardableResult
    public static func initComponent(componentName: String, modules: [DIModule]) throws -> DIComponent {
        guard let _ = components[componentName] else {
            do {
                let component = try DIComponent(componentName, modules)
                components[componentName] = component
                return component
            } catch (let e) {
                if let e = e as? DIError {
                    throw e
                }
                throw DIError.errorInitializingComponent
            }
        }
        throw DIError.componentAlreadyRegistered
    }

    @discardableResult
    public static func initDefaultComponent(_ modules: [DIModule]) throws -> DIComponent {
        return try initComponent(componentName: DIComponent.defaultName, modules: modules)
    }

    public static func getDefaultInstance() throws -> DIComponent {
        guard let component = components[DIComponent.defaultName] else {
            return try initDefaultComponent([])
        }
        return component
    }

    public static func clear() {
        components.removeAll()
    }

    public static func getComponent(_ componentName: String) throws -> DIComponent {
        guard let component = components[componentName] else {
            throw DIError.componentNotFound
        }
        return component
    }
}
