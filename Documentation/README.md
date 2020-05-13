# Documentation for PromisedRestfulSwift

## Table of Contents
1.  [Description](#description)
1.  [RestfulRead](#restfulread)
2.  [RestfulWrite](#restfulwrite)
3.  [RestfulWriteError](#restfulwriteerror)
4.  [RestfulUpdate](#restfulupdate)
5.  [RestfulUpdateError](#restfulupdateerror)
6.  [RestfulDelete](#restfuldelete)
7.  [RestfulUpload](#restfulupload)
8.  [Interceptor](#interceptor)
9.  [OAuthInterceptor](#oauthinterceptor)

## Description <a name="description"></a>
The library provides swift protocols which can be integrated wherever required for example: in a service class or UIViewController.

### RestfulRead Protocol - for executing GET requests <a name="restfulread"></a>
This protocol provides possibility to execute GET http requests on a URL and returns a promise with a decodable result.

Remarks:
-   Pagination can be achieved by building the URL accordingly(through URLComponents)
-   Sorting can be be achieved by building the URL accordingly(through URLComponents)

Services:

```swift
read(url: URL) -> Promise<Decodable>
```

Examples:

```swift
struct EntityType: Decodable {
    var id: String
    var data: [Int]
}

class MyCustomService: RestfulRead {

    private let domain: URL = URL(string: "https://mydomain.com/entities")!

    public func get(by id: String) -> Promise<EntityType> {
        let url = domain.appendingPathComponent(id)
        return read(url)
    }

    public func getAll(by id: String) -> Promise<[EntityType]> {
        return read(domain)
    }
}
```

### RestfulWrite Protocol - for executing POST requests <a name="restfulwrite"></a>
This protocol provides possibility to execute POST requests on an URL and returns a promise with a decodable result or a location header.

Services:

```swift
func write(_ url: URL) -> Promise<Decodable>

func writeAndExtractLocation(_ url: URL) -> Promise<String>

func write(_ url: URL, _  entity: Encodable) -> Promise<Decodable>

func writeAndExtractLocation(_ url: URL, _ entity: Encodable) -> Promise<String>

func writeAndExtractHeaders(_ url: URL, _ entity: Encodable, _ headerKeys: [String]) -> Promise<HTTPHeadersType>
```

Examples:

```swift
struct Request: Encodable {
    var firstName: String
    var lastName: String
}

struct Response: Decodable {
    var location: String
    var firstName: String
    var lastName: String
}

class MyCustomService: RestfulWrite {
    
    private let domain: URL = URL(string: "https://mydomain.com/entities")!
    
    public func createWithUrlEncodingAndExtractResponse(entity: Request) -> Promise<Response> {
        return entity.toPromisedQueryParameters(in: domain).then(write)
    }
    
    public func createWithUrlEncodingAndExtractLocation(entity: Request) -> Promise<String> {
        return entity.toPromisedQueryParameters(in: domain).then(writeAndExtractLocation)
    }
    
    public func createWithJsonEncodingAndExtractResponse(entity: Request) -> Promise<Response> {
        return write(domain, entity)
    }
    
    public func createWithJsonEncodingAndExtractLocation(entity: Request) -> Promise<String> {
        return writeAndExtractLocation(domain, entity)
    }
    
    public func createWithJsonEncodingAndExtractHeaders(entity: Request) -> Promise<HTTPHeadersType> {
        let headerKeys: [String] = ["Location", "Transaction"]
        return writeAndExtractHeaders(domain, entity, headerKeys)
    }
}
```

### RestfulWriteError Protocol - for executing POST requests with server validation response <a name="restfulwriteerror"></a>
This protocol provides possibility to execute POST requests on an URL and returns a promise with a decodable result or a location header.
Additionally to the RestfulWrite protocol, this protocol can decode server errors by providing the associated decodable error type.

[For services and examples please look at the RestfulWrite Protocol](#restfulwrite)

### RestfulUpdate Protocol - for executing PUT requests <a name="restfulupdate"></a>
This protocol provides possibility to execute PUT requests on an URL and returns an empty promise or a promise with the updated entity.

Services:

```swift
func update(_ url: URL, _ entity: Encodable) -> Promise<Void>

func update(_ url: URL, _ entity: Encodable) -> Promise<Decodable>
```

Examples:

```swift
struct Entity: Codable {
    var firstName: String
    var lastName: String
}

class MyCustomService: RestfulUpdate {

    private let domain: URL = URL(string: "https://mydomain.com/entities")!
    
    public func change(entity: Entity) -> Promise<Void> {
        return update(domain, entity)
    }
    
    public func change(entity: Entity) -> Promise<Entity> {
        return update(domain, entity)
    }
}
```

### RestfulUpdateError Protocol - for executing PUT requests with server validation response <a name="restfulupdateerror"></a>
This protocol provides possibility to execute PUT requests on an URL and returns an empty promise or a promise with the updated entity.
Additionally to the RestfulUpdate protocol, this protocol can decode server errors by providing the associated decodable error type.

[For services and examples please look at the RestfulUpdate Protocol](#restfulupdate)

### RestfulDelete Protocol - for executing DELETE requests <a name="restfuldelete"></a>
This protocol provides possibility to execute DELETE request on an URL and returns an empty promise.

Services:

```swift
func delete(_ url: URL) -> Promise<Void>
```

Examples:

```swift
class MyCustomService: RestfulDelete {

    private let domain: URL = URL(string: "https://mydomain.com/entities")!

    public func remove(on location: String) -> Promise<Void> {
        let url = domain.appendingPathComponent(location)
        return delete(url)
    }
}
```

### RestfulUpload Protocol - for executing PUT requests <a name="restfulupload"></a>
This protocol is not implemented yet.

### Interceptor Protocol - for injecting custom needs within all or some requests <a name="interceptor"></a>


### OAuthInterceptor - Implementation for injecting access_token within requests <a name="oauthinterceptor"></a>

