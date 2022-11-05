# DependencyInjection

A Simple Dependency Injection SDK for Swift



## Usage

First, we need the component. If you have only one component in the project you can use (Peferable called from AppDelegate):
    do {
        DIComponent.initDefaultComponent([
            modules...
        ])
    }
    catch {
        fatalError("\(error)")
    }
}


The component need modules.
What's a module?

A module will contain all the logic for creating your dependencies, you can have multiple modules, one for the API, one for your ViewModels one for Persistence layer and so on.

An example of a module

class LocalStorageModule: DIModule {
    override init() {
        super.init()
    }
    
    override func registerAllServices() throws {
        try self.register(self.registerLocalStorage())
    }
    
    private func registerLocalStorage() -> () -> LocalStorage {
        return {
            return LocalStorageImpl(UserDefaults.standard)
        }
    }
}

You can also inject dependencies while creating your objects inside the module
*** Should only be called inside the register method, not in a global way


class AppRepositoryModule: DIModule {
    override func registerAllServices() throws {
        try self.registerSingleton(self.provideAppInfoRepository())
        try self.register(self.provideAppInfoRepository())
    }
    
    private func provideUserDefaults() -> () -> UserDefaults {
        return {
            return UserDefaults.standard
        }
    }
    
    private func provideAppInfoRepository() -> () -> AppInfoRepository {
        return {
            @Inject
            let userDefaults: UserDefaults
            return AppInfoRepositoryImpl(userDefaults)
        }
    }
}


Registering an object can be done in a few different ways

-Register
-RegisterSingleton
-Register/RegisterSingleton (Named)



**** Register means every time you inject the object, it will be recreated
**** RegisterSingleton means the object will only be created once upon request and the same instance will be used every time the object is injected 
**** Registering with Name means you can have multiple objects of the same type, but with different names... If objects are not named, you can only register the type once per component.



*** Injecting

Anywhere in your code you can simply inject by adding @Inject

i.e: 

@Inject
var xyz: UserDefaults

Or if you need:

@LazyInject
var xyz: UserDefaults
