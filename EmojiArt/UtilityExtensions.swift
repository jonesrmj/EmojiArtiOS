//
//  UtilityExtensions.swift
//  EmojiArt
//
//  Created by Ryan Jones on 9/11/21.
//

import SwiftUI

// in a Collection of Identifiables
// we often might want to find the element that has the same id
// as an Indentifiable we already have in hand
// we name this index(matching:) instead of firstIndex(matching:)
// because we assume that someone creating a Collection of Identifiable
// is usually going to have only one of each Identifiable thing in there
// (though there's nothing to restrict them from doing so; it's just a naming choice)

extension Collection where Element: Identifiable {
  func index(matching element: Element) -> Self.Index? {
    firstIndex(where: { $0.id == element.id })
  }
}

// we could do the same thing when it comes to removing an element
// but we have to add that to a different protocol
// because Collection works for immutable collections of things
// the "mutable" one is RangeReplaceableCollection
// not only could we add remove
// but we could add a subscript which takes a copy of one of the elements
// and uses its Identifiable-ness to subscript into the Collection
// this is an awesome way to create Bindings into an Array in a ViewModel
// (since any Published var or subscripts on that var)
// (or subscripts on vars on that var, etc.)

// might come in handy when doing gesture handling
// because we do a lot of converting between coordinate systems and such
// notice that type types of the lhs and rhs arguments vary below
// thus you can offset a CGPoint by the width and height of a CGSize, for example

extension CGRect {
  var center: CGPoint {
    CGPoint(x: midX, y: midY)
  }
}

extension Character {
  var isEmoji: Bool {
    // Swift does not have a way to ask if a Character isEmoji
    // but it does let us check to see if our component scalars isEmoji
    // unfortunately unicode allows certain scalars (like 1)
    // to be modified by another scalar to become emoji (e.g. 1️⃣)
    // so the scalar "1" will report isEmoji = true
    // so we can't just check to see if the first scalar isEmoji
    // the quick and dirty here is to see if the scalar is at least the first true emoji we know of
    // (the start of the "miscellaneous items" section)
    // or check to see if this is a multiple scalar unicode sequence
    // (e.g. a 1 with a unicode modifier to force it to be presented as emoji 1️⃣)
    if let firstScalar = unicodeScalars.first, firstScalar.properties.isEmoji {
      return (firstScalar.value >= 0x238d || unicodeScalars.count > 1)
    } else {
      return false
    }
  }
}

// you can tell by its very name (starts with NS)
// so unfortunately, dealing with this API is a little bit crufty
// thus I recommend you just accept that these loadObjects functions will work and move on
// it's a rare case where trying to dive in and understand what's going on here
// would probably not be a very efficient use of your time
// (though I'm certainly not going to say you shouldn't!)
// (just trying to help you optimize your valuable time this quarter)

extension Array where Element == NSItemProvider {
  func loadObjects<T>(ofType theType: T.Type, firstOnly: Bool = false, using load: @escaping (T) -> Void) -> Bool where T: NSItemProviderReading {
    if let provider = first(where: { $0.canLoadObject(ofClass: theType) }) {
      provider.loadObject(ofClass: theType) { object, error in
        if let value = object as? T {
          DispatchQueue.main.async {
            load(value)
          }
        }
      }
      return true
    }
    return false
  }
  func loadObjects<T>(ofType theType: T.Type, firstOnly: Bool = false, using load: @escaping (T) -> Void) -> Bool where T: _ObjectiveCBridgeable, T._ObjectiveCType: NSItemProviderReading {
    if let provider = first(where: { $0.canLoadObject(ofClass: theType) }) {
      let _ = provider.loadObject(ofClass: theType) { object, error in
        if let value = object {
          DispatchQueue.main.async {
            load(value)
          }
        }
      }
      return true
    }
    return false
  }
  func loadFirstObject<T>(ofType theType: T.Type, using load: @escaping (T) -> Void) -> Bool where T: NSItemProviderReading {
    loadObjects(ofType: theType, firstOnly: true, using: load)
  }
  func loadFirstObject<T>(ofType theType: T.Type, using load: @escaping (T) -> Void) -> Bool where T: _ObjectiveCBridgeable, T._ObjectiveCType: NSItemProviderReading {
    loadObjects(ofType: theType, firstOnly: true, using: load)
  }
}
