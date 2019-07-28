//
//  AlertaLayoutContext.swift
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

public final class AlertaLayoutContext {

    static let separatorHeight: CGFloat = 0.5

    var actionHeight: CGFloat?

    public var cancelActionSpacing: CGFloat = 8.0

    public var bodyCornerRadius: CGFloat = 13.0
    public var cancelActionCornerRadius: CGFloat = 13.0

    var textColors: [ActionControllerStyle : [AlertaElement : UIColor]] = [
        .alert: [
            .message             : .black,
            .title               : .black,
            .action(.cancel)     : UIColor(red: 0, green: 0.478431, blue: 1),
            .action(.default)    : UIColor(red: 0, green: 0.478431, blue: 1),
            .action(.destructive): UIColor(red: 1, green: 0.231373,
                                           blue: 0.188235),
        ],
        .actionSheet: [
            .message             : UIColor(white: 0.56, alpha: 1.0),
            .title               : UIColor(white: 0.56, alpha: 1.0),
            .action(.cancel)     : UIColor(red: 0, green: 0.478431, blue: 1),
            .action(.default)    : UIColor(red: 0, green: 0.478431, blue: 1),
            .action(.destructive): UIColor(red: 1, green: 0.231373,
                                           blue: 0.188235),
        ]
    ]

    var fonts: [ActionControllerStyle : [AlertaElement : UIFont]] = [
        .alert: [
            .message             : .systemFont(ofSize: 13, weight: .regular),
            .title               : .systemFont(ofSize: 17, weight: .semibold),
            .action(.cancel)     : .systemFont(ofSize: 17, weight: .semibold),
            .action(.default)    : .systemFont(ofSize: 17, weight: .regular),
            .action(.destructive): .systemFont(ofSize: 17, weight: .regular),
        ],
        .actionSheet: [
            .message             : .systemFont(ofSize: 13, weight: .regular),
            .title               : .systemFont(ofSize: 13, weight: .semibold),
            .action(.cancel)     : .systemFont(ofSize: 20, weight: .semibold),
            .action(.default)    : .systemFont(ofSize: 20, weight: .regular),
            .action(.destructive): .systemFont(ofSize: 20, weight: .regular),
        ]
    ]

    public init() {}

    public func set(textColor: UIColor, for element: AlertaElement) {
        for style in [.alert, .actionSheet] as [ActionControllerStyle] {
            if case .any = element {
                textColors[style]?[.message] = textColor
                textColors[style]?[.title] = textColor
                textColors[style]?[.action(.cancel)] = textColor
                textColors[style]?[.action(.destructive)] = textColor
                textColors[style]?[.action(.default)] = textColor
            } else if case .action(.any) = element {
                textColors[style]?[.action(.cancel)] = textColor
                textColors[style]?[.action(.destructive)] = textColor
                textColors[style]?[.action(.default)] = textColor
            } else {
                textColors[style]?[element] = textColor
            }
        }
    }

    public func set(font: UIFont, for element: AlertaElement) {
        for style in [.alert, .actionSheet] as [ActionControllerStyle] {
            if case .any = element {
                fonts[style]?[.message] = font
                fonts[style]?[.title] = font
                fonts[style]?[.action(.cancel)] = font
                fonts[style]?[.action(.destructive)] = font
                fonts[style]?[.action(.default)] = font
            } else if case .action(.any) = element {
                fonts[style]?[.action(.cancel)] = font
                fonts[style]?[.action(.destructive)] = font
                fonts[style]?[.action(.default)] = font
            } else {
                fonts[style]?[element] = font
            }
        }
    }

    func actionCountLimit(_ style: ActionControllerStyle) -> Int {

        return (style == .alert) ? 2 : 6
    }
}
