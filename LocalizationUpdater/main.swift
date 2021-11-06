//
//  main.swift
//  LocalizationUpdater
//
//  Created by Muiz on 06/11/21.
//

import Foundation
import PathKit

func getParsedText(file: Path) -> [Strings.Entry] {
    let pOpt = try! ParserOptionValues.init(options: [:], available: .init(options: [
        ParserOption(key: "separator", defaultValue: "=", help: "foo")
    ]))
    let p = Strings.StringsFileParser(options: pOpt)
    return try! p.parseFile(at: file)
}

let old = Path( "/Users/muiz/Desktop/AstraMovic-Badr/Movic%20partner%20iOS/App/Resources/en.lproj/Localization.strings")
let new = Path("/Users/muiz/Downloads/id.id.en.txt")
//let new = Path("/Users/muiz/Downloads/ssx.txt")


let oldKvs = getParsedText(file: old)
let newKvs = getParsedText(file: new)
print(oldKvs.count, newKvs.count)

var inserts = [
    Strings.Entry
]()

var removes = [
    Strings.Entry
]()

for el in newKvs.map({ $0.key}).difference(from: oldKvs.map({ $0.key })) {
    switch el {
    case .insert(let offset, let element, let associatedWith):
        inserts.append(newKvs[offset])
    case .remove(let offset, let element, let associatedWith):
        removes.append(oldKvs[offset])
    }
}

let final = oldKvs
    .filter({ o in !removes.contains(where: { $0.key == o.key })})
    + inserts

print(
    final
        .sorted(by: { $0.key < $1.key })
        .map({ String(format: #"%@ = "%@";"#, $0.key , $0.translation) })
        .joined(separator: "\n\n")
)
