//
//  PaletteChooser.swift
//  EmojiArt
//
//  Created by Ryan Jones on 11/27/21.
//

import SwiftUI

struct PaletteChooser: View {
  var emojiFontSize: CGFloat = 40
  var emojiFont: Font { .system(size: emojiFontSize) }
  
  @EnvironmentObject var store: PaletteStore
  
  @SceneStorage("PaletteChooser.chosenPaletteIndex")
  private var chosenPaletteIndex = 0
  
  var body: some View {
    HStack {
      paletteControlButton
      body(for: store.palette(at: chosenPaletteIndex))
    }
    .clipped()
  }
  
  var paletteControlButton: some View {
    Button {
      withAnimation {
        chosenPaletteIndex = (chosenPaletteIndex + 1) % store.palettes.count
      }
    } label: {
      Image(systemName: "paintpalette")
    }
    .font(emojiFont)
    .contextMenu { contextMenu }
  }
  
  @ViewBuilder
  var contextMenu: some View {
    AnimatedActionButton(title: "Edit", systemImage: "pencil") {
      //editing = true
      paletteToEdit = store.palette(at: chosenPaletteIndex)
    }
    AnimatedActionButton(title: "New", systemImage: "plus") {
      store.insertPalette(named: "New", emojis: "", at: chosenPaletteIndex)
      //editing = true
      paletteToEdit = store.palette(at: chosenPaletteIndex)
    }
    AnimatedActionButton(title: "Delete", systemImage: "minus.circle") {
      chosenPaletteIndex = store.removePalette(at: chosenPaletteIndex)
    }
    AnimatedActionButton(title: "Manager", systemImage: "slider.vertical.3") {
      managing = true
    }
    gotoMenu
  }
  
  var gotoMenu: some View {
    Menu {
      ForEach (store.palettes) { palette in
        AnimatedActionButton(title: palette.name) {
          if let index = store.palettes.index(matching: palette) {
            chosenPaletteIndex = index
          }
        }
      }
    } label: {
      Label("Go To", systemImage: "text.insert")
    }
  }
  
  func body(for palette: Palette) -> some View {
    HStack {
      Text(palette.name)
      ScrollingEmojisView(emojis: palette.emojis)
        .font(emojiFont)
    }
    .id(palette.id)
    .transition(rollTransition)
    .popover(item: $paletteToEdit) { palette in
      PaletteEditor(palette: $store.palettes[palette])
        .wrappedInNavigationViewToMakeDismissable { paletteToEdit = nil }
    }
    .sheet(isPresented: $managing) {
      PaletteManager()
    }
  }
  
  //@State private var editing = false
  @State private var managing = false
  @State private var paletteToEdit: Palette?
  
  var rollTransition: AnyTransition {
    AnyTransition.asymmetric(
      insertion: .offset(x: 0, y: emojiFontSize),
      removal: .offset(x: 0, y: -emojiFontSize)
    )
  }
}

struct ScrollingEmojisView: View {
  let emojis: String
  
  var body: some View {
    ScrollView(.horizontal) {
      HStack {
        ForEach(emojis.map { String($0) }, id: \.self) { emoji in
          Text(emoji)
            .onDrag { NSItemProvider(object: emoji as NSString) }
        }
      }
    }
  }
}

struct PaletteChooser_Previews: PreviewProvider {
  static var previews: some View {
    PaletteChooser()
  }
}
