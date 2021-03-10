//
//  Constants.swift
//  ChatApp
//
//  Created by Ilnur Mugaev on 10.03.2021.
//  Copyright © 2021 Ilnur Mugaev. All rights reserved.
//

import UIKit

struct Constants {
    
    static let classicTheme = ColorsModel(backgroundColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0),
                                          onlineConversationColor: #colorLiteral(red: 1, green: 0.9882352941, blue: 0.8588235294, alpha: 1),
                                          outgoingMessageViewColor: #colorLiteral(red: 0.862745098, green: 0.968627451, blue: 0.7725490196, alpha: 1),
                                          outgoingMessageFontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),
                                          incomingMessageViewColor: #colorLiteral(red: 0.8745098039, green: 0.8745098039, blue: 0.8745098039, alpha: 1),
                                          incomingMessageFontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),
                                          UIElementColor: #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1),
                                          tintColor: #colorLiteral(red: 0.3294117647, green: 0.3294117647, blue: 0.3490196078, alpha: 1),
                                          mainFontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),
                                          utilityFontColor: #colorLiteral(red: 0.2392156863, green: 0.2392156863, blue: 0.2588235294, alpha: 1),
                                          userInterfaceStyle: .light,
                                          barStyle: .default)
    
    static let dayTheme = ColorsModel(backgroundColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0),
                                      onlineConversationColor: #colorLiteral(red: 1, green: 0.9882352941, blue: 0.8588235294, alpha: 1),
                                      outgoingMessageViewColor: #colorLiteral(red: 0.2588235294, green: 0.5411764706, blue: 0.9803921569, alpha: 1),
                                      outgoingMessageFontColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0),
                                      incomingMessageViewColor: #colorLiteral(red: 0.9215686275, green: 0.9215686275, blue: 0.9294117647, alpha: 1),
                                      incomingMessageFontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),
                                      UIElementColor: #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1),
                                      tintColor: #colorLiteral(red: 0.3294117647, green: 0.3294117647, blue: 0.3490196078, alpha: 1),
                                      mainFontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),
                                      utilityFontColor: #colorLiteral(red: 0.2392156863, green: 0.2392156863, blue: 0.2588235294, alpha: 1),
                                      userInterfaceStyle: .light,
                                      barStyle: .default)
    
    static let nightTheme = ColorsModel(backgroundColor: #colorLiteral(red: 0.01960784314, green: 0.01960784314, blue: 0.01960784314, alpha: 1),
                                        onlineConversationColor: #colorLiteral(red: 0.831372549, green: 0.831372549, blue: 0.7215686275, alpha: 1),
                                        outgoingMessageViewColor: #colorLiteral(red: 0.3607843137, green: 0.3607843137, blue: 0.3607843137, alpha: 1),
                                        outgoingMessageFontColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),
                                        incomingMessageViewColor: #colorLiteral(red: 0.1803921569, green: 0.1803921569, blue: 0.1803921569, alpha: 1),
                                        incomingMessageFontColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0),
                                        UIElementColor: #colorLiteral(red: 0.1215686275, green: 0.1215686275, blue: 0.1215686275, alpha: 1),
                                        tintColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0),
                                        mainFontColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0),
                                        utilityFontColor: #colorLiteral(red: 0.5490196078, green: 0.5490196078, blue: 0.5803921569, alpha: 1),
                                        userInterfaceStyle: .dark,
                                        barStyle: .black)
}
