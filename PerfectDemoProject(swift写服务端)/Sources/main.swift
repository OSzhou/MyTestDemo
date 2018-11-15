//print("你好！")
import Foundation
import PerfectLib
import PerfectHTTP
import PerfectHTTPServer


//HTTP服务
    let networkServer = NetworkServerManager(root: "webroot", port: 8181)
    networkServer.startServer()

