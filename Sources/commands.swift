//
//  commands.swift
//  
//
//  Created by changrunze on 2023/6/19.
//

import Foundation

func pwd() -> String {
    return zsh(command: "/bin/pwd") ?? ""
}

func ls(path: String) -> Array<String> {
    let _path = path.trimmingCharacters(in: .newlines)
    let str = zsh(command: "/bin/ls", arguments: [_path])
    let arr = str?.components(separatedBy: "\n")
    return arr?.filter({ (s) -> Bool in
        s.count > 0
    }) ?? []
}

func zsh(command: String, arguments: [String]? = nil) -> String? {
    let process = Process()
    let outpipe = Pipe()
    process.standardOutput = outpipe
    process.launchPath = command
    if let arguments = arguments {
        process.arguments = arguments
    }
    process.launch()
    
    let outdata = outpipe.fileHandleForReading.availableData
    let outputString = String(data: outdata, encoding: String.Encoding.utf8)
    return outputString
}
