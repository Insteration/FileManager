//
//  Engine.swift
//  FileManager
//
//  Created by Artem Karmaz on 3/26/19.
//  Copyright © 2019 Johansson Group. All rights reserved.
//

import Foundation


struct FM {
    
    let fm = FileManager.default
    
    func getUrl(_ path: String) -> URL {
        var url = URL(fileURLWithPath: "")
        do {
            url = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent(path)
        }
        catch {
            print("File manger error.")
        }
        return url
    }
    
    
    func getListUrl(_ url: URL) -> [URL] {
        var listUrl = [URL]()
        do {
            listUrl = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: [])
        }
        catch {
            print("Error list url.")
        }
        return listUrl
    }
    
    
    func createDir(_ url: URL) {
        do {
            try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
        }
        catch {
            print("Sorry, but i can't create directory. Check system log.")
        }
    }
    
    
    func listDir (_ url: URL) -> [URL] {
        var urls = [URL]()
        do {
            urls = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: [])
        }
        catch {
            print("Sorry, but i can't list directory. Check system log.")
        }
        return urls
    }
    
    
    func createFile(_ url: URL, _ sdata: String = "") {
        let data: Data? = sdata.data(using: .utf8)
        FileManager.default.createFile(atPath: url.path, contents: data)
    }
    
    
    func removeFile(_ url: URL) {
        do {
            try FileManager.default.removeItem(at: url)
            print("File remove successful")
        }
        catch {
            print("Error remove file \(url)")
        }
    }
    
    
    func copyFile(_ url1: URL, _ url2: URL) {
        do {
            try FileManager.default.copyItem(at: url1, to: url2)
        }
        catch {
            print("Error copy file")
        }
    }
    
    
    func urlSort(_ url : [URL]) -> [URL] {
        func sortByName(_ url: URL) -> String {
            var subStr = String()
            for j in 0..<url.path.count {
                if url.path[url.path.index(url.path.startIndex, offsetBy: url.path.count - 1 - j)] == "/" {
                    subStr = String(url.path[url.path.index(url.path.startIndex, offsetBy: url.path.count - j)..<url.path.endIndex])
                    break
                }
            }
            return subStr
        }
        var arrUrl = url
        for i in 0..<url.count {
            do {
                let resourceValues = try arrUrl[i].resourceValues(forKeys: [.isDirectoryKey])
                if resourceValues.isDirectory ?? false {
                    print(sortByName(arrUrl[i]))
                } else {
                    print(sortByName(arrUrl[i]))
                }
            } catch {
                print("Error url") }
        }
        return arrUrl
    }
    
    
    func getIdUrlByName(_ urls: [URL], _ name: String) -> Int {
        for i in 0..<urls.count {
            if getNameByUrl(urls[i]) == name {
                return i
            }
        }
        return -1
    }
    
    
    func getNameByUrl(_ url: URL) -> String {
        var subStr = String()
        for j in 0..<url.path.count {
            if url.path[url.path.index(url.path.startIndex, offsetBy: url.path.count - 1 - j)] == "/" {
                subStr = String(url.path[url.path.index(url.path.startIndex, offsetBy: url.path.count - j)..<url.path.endIndex])
                break
            }
        }
        return subStr
    }
    
    func getLocalPathByFull(_ fullPath: String, _ startDirectory: String = "Documents") -> String {
        
        for i in 0..<fullPath.count {
            if i + startDirectory.count < fullPath.count {
                if startDirectory == fullPath[fullPath.index(fullPath.startIndex, offsetBy: i)..<fullPath.index(fullPath.startIndex, offsetBy: startDirectory.count + i)] {
                    return String(fullPath[fullPath.index(fullPath.startIndex, offsetBy: startDirectory.count + i)..<fullPath.endIndex])
                }
            }
        }
        return ""
    }
    
    func infoAbout(url: URL) -> String {
        do {
            let attributes = try fm.attributesOfItem(atPath: url.path)
            var report: [String] = ["\(url.path)", ""]

            for (key, value) in attributes {
                // ignore NSFileExtendedAttributes as it is a messy dictionary
                if key.rawValue == "NSFileExtendedAttributes" { continue }
                report.append("\(key.rawValue):\t \(value)")
            }
            
            return report.joined(separator: "\n")
        } catch {
            
            return "No information available for \(url.path)"
        }
    }
}
