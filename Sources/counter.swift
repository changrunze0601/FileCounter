//
//  counter.swift
//  
//
//  Created by changrunze on 2023/6/19.
//

import Foundation
import ArgumentParser

struct FileCounter: ParsableCommand {
    
    @Argument(help: "指定扫描的路径")
    var workspace: String
    
    /// 列出所有的文件占比
    @Option(name: .shortAndLong, help: "指定文件类型")
    var file: String?

    func run() throws {
        let root = currentPath().appending("/" + workspace)
        print(root)
        var total = 0
        var oc = CodeLanguage(itemType: .oc)
        var swift = CodeLanguage(itemType: .swift)
        var c = CodeLanguage(itemType: .c)
        var dart = CodeLanguage(itemType: .dart)
        
        do {
            let _l = try list(path: root)
            for item in _l {
                total += 1
                switch item.itemType {
                case .oc:
                    oc += 1
                case .swift:
                    swift += 1
                case .c:
                    c += 1
                case .dart:
                    dart += 1
                default:
                    continue
                }
            }
            
            print("Total \(total) files percentile：")
            let inputc = true
            let filter = file != nil
            
            var sorts = [oc, swift, c, dart]
            sorts.sort { (c1, c2) -> Bool in
                c1.count > c2.count
            }
            for c in sorts {
                let p = Float(c.count) / Float(total)
                
                if p == 0 {
                    continue
                }
                
                var pstr = "\(p * 100)"
                
                if pstr.contains(".") {
                    let parr = pstr.components(separatedBy: ".")
                    let last = parr.last ?? ""
                    if Int(last) != 0 {
                        var pindex = 1
                        for c in last {
                            if c == "0" {
                                pindex += 1
                            } else {
                                break
                            }
                        }
                        pstr = String(format: "%.\(pindex)f", p * 100)
                    } else {
                        pstr = parr.first ?? ""
                    }
                }
                
                var output = "\(c.name)"
                
                if filter {
                    if file!.lowercased() != c.name.lowercased() {
                        continue
                    }
                }
                
                if inputc {
                    output += " \(c.count)"
                }
                output += " "
                output += pstr
                output += "%"
                print(output)
            }
        }
    }
}

