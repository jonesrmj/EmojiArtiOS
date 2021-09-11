//
//  UtilityViews.swift
//  EmojiArt
//
//  Created by Ryan Jones on 9/11/21.
//

import SwiftUI

// syntactic sure to be able to pass an optional UIImage to Image
// (normally it would only take a non-optional UIImage)

struct OptionalImage: View {
  var uiImage: UIImage?
  
  var body: some View {
    if uiImage != nil {
      Image(uiImage: uiImage!)
    }
  }
}

// syntactic sugar
// lots of times we want a simple button
// with just text or a lable or a systemImage
// but we want the action it performs to be animated
// (i. e. withAnimation)
// this just makes it easy to create such a button
// and thus cleans us our code

