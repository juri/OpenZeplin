import Foundation
import ShellOut

/// Convert an URL like `https://app.zeplin.io/project/XXXXXX/screen/YYYYY` passed
/// as a command line parameter to the form `zpl://screen?pid=XXXXXX&sid=YYYYY` and
/// open it.

class StandardErrorOutputStream: TextOutputStream {
    func write(_ string: String) {
        let stderr = FileHandle.standardError
        stderr.write(string.data(using: String.Encoding.utf8)!)
    }
}

var stderr = StandardErrorOutputStream()
let name = CommandLine.arguments[0].split(separator: "/").last ?? ""

func errorExit(_ message: String) -> Never {
    print("\(name): \(message)", to: &stderr)
    print("usage: \(name) URL", to: &stderr)
    print("       URL format: https://app.zeplin.io/project/XXXXXX/screen/YYYYY", to: &stderr)
    exit(1)
}

func makeZplURL(project: String, screen: String) -> URL? {
    guard var zplURLComps = URLComponents(string: "zpl://screen") else {
        return nil
    }
    zplURLComps.queryItems = [
        URLQueryItem(name: "pid", value: project),
        URLQueryItem(name: "sid", value: screen)]
    return zplURLComps.url
}

guard CommandLine.arguments.count == 2 else {
    errorExit("One parameter required")
}

let arg = CommandLine.arguments[1]
guard
    let url = URL(string: arg.trimmingCharacters(in: .whitespacesAndNewlines)),
    let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
else {
    errorExit("Couldn't parse URL: '\(arg)'")
}

let path = components.path.split(separator: "/")
guard
    path.count == 4,
    path[0] == "project",
    path[2] == "screen"
else {
    errorExit("Path of \(arg) was in unexpected format")
}

guard let zplURL = makeZplURL(project: String(path[1]), screen: String(path[3])) else {
    errorExit("Failed to create zpl URL")
}

print("Opening \(zplURL.absoluteString)")
try shellOut(to: "open", arguments: ["'\(zplURL.absoluteString)'"])
