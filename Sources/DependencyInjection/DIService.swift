//
// Created by Eduardo Appolinario on 2021-10-01.
//

public class DIService<T> {
    typealias instanceFactory = () -> T

    let id: ObjectIdentifier
    let name: String?
    let buildNewInstance: instanceFactory
    let isSingleton: Bool

    init(id: ObjectIdentifier,
         factory: @escaping instanceFactory,
         isSingleton: Bool = false,
         name: String? = nil
         
    ) {
        self.id = id
        self.buildNewInstance = factory
        self.isSingleton = isSingleton
        self.name = name
    }

    fileprivate var instance: T? = nil

    func getInstance() throws -> T {
        if (!self.isSingleton) {
            return buildNewInstance()
        }

        guard let existingInstance = self.instance else {
            self.instance = self.buildNewInstance()
            return try self.instance ?? {
                throw DIError.unexpectedErrorCreatingSingletonService
            }()
        }

        return existingInstance
    }
}
