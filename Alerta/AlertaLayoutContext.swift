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
            .message: {
                if #available(iOS 13.0, *) {
                    return .label
                } else {
                    return .black
                }
            }(),
            .title: {
                if #available(iOS 13.0, *) {
                    return .label
                } else {
                    return .black
                }
            }(),
            .action(.cancel): .systemBlue,
            .action(.default): .systemBlue,
            .action(.destructive): .systemRed,
        ],
        .actionSheet: [
            .message: UIColor(white: 0.56, alpha: 1),
            .title: UIColor(white: 0.56, alpha: 1),
            .action(.cancel): .systemBlue,
            .action(.default): .systemBlue,
            .action(.destructive): .systemRed,
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
