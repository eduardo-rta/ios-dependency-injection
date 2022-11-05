//
// Created by Eduardo Appolinario on 2021-10-01.
//

open class DIModule {
    public typealias T = Any
    
    public private(set) var registry = [RegistryIdentifier: Any]()
    
    public init() {
        
    }
    
    public func register<T>(_ factory: @escaping () -> T, isSingleton: Bool = false, name: String? = nil) throws {
        let id = ObjectIdentifier(T.self)
        
        if (self.registry.keys.contains(where: { r in
            r.id == id && (name == nil || r.name == name)
        })) {
            throw DIError.serviceAlreadyRegistered(type: "\(T.self)", name: name)
        }

        let registration = DIService<T>(
            id: id,
            factory: factory,
            isSingleton: isSingleton,
            name: name
        )
        
        let registryIdentifier = RegistryIdentifier(id: id, name: name)

        self.registry[registryIdentifier] = registration
    }

    public func registerSingleton<T>(_ factory: @escaping () -> T) throws {
        return try self.registerSingleton(name: nil, factory)
    }
    
    public func registerSingleton<T>(name: String?, _ factory: @escaping () -> T) throws {
        try self.register(factory, isSingleton: true, name: name)
    }
    
    open func registerAllServices() throws {
        
    }
}
