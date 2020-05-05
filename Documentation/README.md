# Documentation for RestfulSWIFT

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

Example:

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
TODO
### RestfulWriteError Protocol - for executing POST requests with server validation response <a name="restfulwriteerror"></a>
TODO
### RestfulUpdate Protocol - for executing PUT requests <a name="restfulupdate"></a>
TODO
### RestfulUpdateError Protocol - for executing PUT requests with server validation response <a name="restfulupdateerror"></a>
TODO
### RestfulDelete Protocol - for executing PUT requests <a name="restfuldelete"></a>
TODO
### RestfulUpload Protocol - for executing PUT requests <a name="restfulupload"></a>
TODO
### Interceptor Protocol - for injecting custom needs within all or some requests <a name="interceptor"></a>
TODO
### OAuthInterceptor - Implementation for injecting access_token within requests <a name="oauthinterceptor"></a>
TODO
