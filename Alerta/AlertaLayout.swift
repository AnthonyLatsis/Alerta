//
//  AlertaLayout.swift
//  Alerta
//
//  Created by Anthony Latsis on 4/17/18.
//  Copyright © 2018 Anthony Latsis. All rights reserved.
//

public enum AlertaElement: Hashable {

    public enum AlertaActionElement {

        case `default`
        case destructive
        case cancel
        case any
    }

    case action(AlertaActionElement)
    case title
    case message
    case any
}

public class AlertaLayout {

    static let separatorHeight: CGFloat = 0.5

    var actionHeight: CGFloat?

    public var bodyCornerRadius: CGFloat = 13.0
    public var cancelActionCornerRadius: CGFloat = 13.0

    var textColors: [AlertaElement : UIColor] = [

        .message              : UIColor.init(red: 0.56, green: 0.56, blue: 0.56),
        .title                : UIColor.init(red: 0.56, green: 0.56, blue: 0.56),
        .action(.cancel)      : UIColor.init(red: 0, green: 0.478431, blue: 1),
        .action(.default)     : UIColor.init(red: 0, green: 0.478431, blue: 1),
        .action(.destructive) : UIColor.init(red: 1, green: 0.231373, blue: 0.188235)
    ]

    var fonts: [AlertaElement : UIFont] = [

        .message              : UIFont.systemFont(ofSize: 13, weight: .regular),
        .title                : UIFont.systemFont(ofSize: 13, weight: .semibold),
        .action(.cancel)      : UIFont.systemFont(ofSize: 20, weight: .semibold),
        .action(.default)     : UIFont.systemFont(ofSize: 20, weight: .regular),
        .action(.destructive) : UIFont.systemFont(ofSize: 20, weight: .regular)
    ]

    public init() {}

    public func set(textColor: UIColor, for element: AlertaElement) {

        if case .any = element {

            textColors[.message] = textColor
            textColors[.title] = textColor
            textColors[.action(.cancel)] = textColor
            textColors[.action(.destructive)] = textColor
            textColors[.action(.default)] = textColor

        } else if case .action(.any) = element {

            textColors[.action(.cancel)] = textColor
            textColors[.action(.destructive)] = textColor
            textColors[.action(.default)] = textColor
        } else {
            textColors[element] = textColor
        }
    }

    public func set(font: UIFont, for element: AlertaElement) {

        if case .any = element {

            fonts[.message] = font
            fonts[.title] = font
            fonts[.action(.cancel)] = font
            fonts[.action(.destructive)] = font
            fonts[.action(.default)] = font

        } else if case .action(.any) = element {

            fonts[.action(.cancel)] = font
            fonts[.action(.destructive)] = font
            fonts[.action(.default)] = font
        } else {
            fonts[element] = font
        }
    }
}
