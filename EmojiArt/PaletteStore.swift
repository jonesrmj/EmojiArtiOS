//
//  PaletteStore.swift
//  EmojiArt
//
//  Created by Ryan Jones on 11/23/21.
//

import Foundation

struct Palette: Identifiable, Codable, Hashable {
  var name: String
  var emojis: String
  var id: Int
  
  fileprivate init(name: String, emojis: String, id: Int) {
    self.name = name
    self.emojis = emojis
    self.id = id
  }
}

class PaletteStore: ObservableObject {
  let name: String
  
  @Published var palettes = [Palette]() {
    didSet {
      storeInUserDefaults()
    }
  }
  
  private var userDefaultsKey: String {
    "PaletteStore" + name
  }
  
  private func storeInUserDefaults() {
    UserDefaults.standard.set(try? JSONEncoder().encode(palettes), forKey: userDefaultsKey)
    // UserDefaults.standard.set(palettes.map { [$0.name, $0.emojis, String($0.id)] }, forKey: userDefaultsKey)
  }
  
  private func restoreFromUserDefaults() {
    if let jsonData = UserDefaults.standard.data(forKey: userDefaultsKey),
    let decodedPalettes = try? JSONDecoder().decode(Array<Palette>.self, from: jsonData) {
      palettes = decodedPalettes
    }
    // if let palettesAsPropertyList = UserDefaults.standard.array(forKey: userDefaultsKey) as? [[String]] {
      // for paletteAsArray in palettesAsPropertyList {
        // if paletteAsArray.count == 3, let id = Int(paletteAsArray[2]), !palettes.contains(where: { $0.id == id }) {
          // let palette = Palette(name: paletteAsArray[0], emojis: paletteAsArray[1], id: id)
          // palettes.append(palette)
        // }
      // }
    // }
  }
  
  init(named name: String) {
    self.name = name
    restoreFromUserDefaults()
    if palettes.isEmpty {
      print("Using built-in palettes")
      insertPalette(named: "Vehicles", emojis: "🚀🚁🚂🚃🚄🚅🚆🚇🚈🚉🚊🚋🚌🚍🚎🚐🚑🚒🚓🚔🚕🚖🚗🚘🚙🚚🚛🚜🚝🚞🚟🚠🚡🚢🚣🚤🚲🛥🛩🛫🛬🛰🛳")
      insertPalette(named: "Sports", emojis: "🎳🎾🎿🏀🏂🏈⚽⚾⛳⛷🎱🏃🏇🏊")
      insertPalette(named: "Music", emojis: "🎹🎷🪗🎸🎺🎻🪕🥁🪘🎶")
      insertPalette(named: "Animals", emojis: "🐀🐁🐂🐃🐄🐅🐆🐇🐈🐉🐊🐋🐌🐍🐎🐏🐐🐑🐒🐓🐔🐕🐖🐗🐘🐙🐚🐛🐜🐝🐞🐟🐠🐡🐢🐣🐤🐥🐦🐧🐩🐪🐫🐬🐳🐴🐺🐽🐿🕊🕷")
      insertPalette(named: "Animal Faces", emojis: "🐨🐭🐮🐯🐰🐱🐲🐵🐶🐷🐸🐹🐺🐻🐼")
      insertPalette(named: "Flora", emojis: "🌵🎄🌲🌳🌴🌱🌿☘️🍀🎍🎋🍃🍂🍁🌾🥀")
      insertPalette(named: "Weather", emojis: "☀🌤⛅🌥🌦☁🌧⛈🌩⚡❄️🌨☃️⛄🌬💨🌪🌫☂☔💧💦🌊")
      insertPalette(named: "COVID", emojis: "💉🦠😷🤧🤒")
      insertPalette(named: "Faces", emojis: "😀😬😁😂😃😄😅😆😇😉😊🙂🙃☺️😋😌😍😘😗😙😚😜😝😛🤑🤓😎🤗😏😶😐😑😒🙄🤔😳😞😟😠😡😔😕🙁☹️😣😖😫😩😤😮😱😨😰😯😦😧😢😥😪😓😭😵😲🤐😷🤒🤕😴🤣🤤🤢🤧🤠🤡🤥🤩🤨🤯🤪🤬🤮🤫🤭🧐")
    } else {
      print("Successfully loaded palettes from UserDefaults: \(palettes)")
    }
  }
  
  // MARK: - Intent
  
  func palette(at index: Int) -> Palette {
    let safeIndex = min(max(index, 0), palettes.count - 1)
    return palettes[safeIndex]
  }
  
  @discardableResult
  func removePalette(at index: Int) -> Int {
    if palettes.count > 1, palettes.indices.contains(index) {
      palettes.remove(at: index)
    }
    return index % palettes.count
  }
  
  func insertPalette(named name: String, emojis: String? = nil, at index: Int = 0) {
    let unique = (palettes.max(by: { $0.id < $1.id })?.id ?? 0) + 1
    let palette = Palette(name: name, emojis: emojis ?? "", id: unique)
    let safeIndex = min(max(index, 0), palettes.count)
    palettes.insert(palette, at: safeIndex)
  }
}
