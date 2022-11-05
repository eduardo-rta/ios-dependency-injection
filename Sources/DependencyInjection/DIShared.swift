//
// Created by Eduardo Appolinario on 2021-10-01.
//

public enum DIError: Error, Equatable {
    case componentAlreadyRegistered
    case errorInitializingComponent
    case componentNotFound

    case moduleAlreadyRegistered

    case serviceAlreadyRegistered (type: String, name: String?)
    case serviceDeclarationCannotBeOptional (String)
    case serviceNotRegistered (String)
    case unexpectedErrorCreatingSingletonService
    case unexpectedErrorRegisteringService
}
