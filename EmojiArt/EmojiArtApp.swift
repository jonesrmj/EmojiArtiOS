//
//  EmojiArtApp.swift
//  EmojiArt
//
//  Created by Ryan Jones on 9/11/21.
//

import SwiftUI

@main
struct EmojiArtApp: App {
  @StateObject var document = EmojiArtDocument()
  @StateObject var paletteStore = PaletteStore(named: "Default")
  
  var body: some Scene {
    WindowGroup {
      EmojiArtDocumentView(document: document)
        .environmentObject(paletteStore)
    }
  }
}
