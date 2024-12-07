
# ColorToneSaturate

![Swift](https://img.shields.io/badge/swift-5.9-orange)
![Platform](https://img.shields.io/badge/platform-iOS-lightgrey)
![Platform](https://img.shields.io/badge/platform-macOS-lightgrey)
![License](https://img.shields.io/badge/license-MIT-green)

## Description

**ColorToneSaturate** is a Swift library designed to detect dominant and vibrant colors in images. Through a set of image processing functions, you can identify the most prominent colors and their saturation levels. It’s perfect for applications requiring color analysis, palette creation, or interface adjustments based on image tones.

## Features

- Detects up to 5 dominant colors in an image.
- Identifies the most vibrant color.
- Auxiliary functions for color blending and distance calculations.
- Easy integration with SwiftUI.

## Requirements

- iOS 17.0+ / macOS 14.0+
- Swift 5.9+

## Installation

### Swift Package Manager

You can add **ColorToneSaturate** to your project using [Swift Package Manager](https://swift.org/package-manager/).

1. In Xcode, go to your project and select `Swift Packages`.
2. Click the `+` button and paste the following URL:

 ```html
https://github.com/your-username/ColorToneSaturate.git
```

3. Select the desired version and add the package to your project.

## Usage

### Initialization

Create an instance of **`ColorToneSaturateCore2`** to manage color detection in your app:

```swift
import ColorToneSaturate

let colorToneSaturate = ColorToneSaturateCore2()
```

## Basic Example

To detect colors in an image and retrieve the dominant ones, follow this example in SwiftUI:

```swift
import SwiftUI
import ColorToneSaturate

struct TestImageView: View {
    @State private var colorToneSaturate = ColorToneSaturateCore2()

    var body: some View {
        VStack {
            Image("exampleImage")
                .resizable()
                .scaledToFit()
                .frame(width: 300, height: 300)
                .onAppear {
                   colorToneSaturate.getColorUIImage("exampleImage")
                }

            HStack {
                ForEach(colorToneSaturate.colors, id: \.self) { color in
                    Rectangle()
                        .fill(color)
                        .frame(width: 50, height: 50)
                }
            }
        }
        .background(Color(colorToneSaturate.mostVibrantColor), in: RoundedRectangle(cornerRadius: 10))
        .padding()
    }
}
```

## Example: Using Detected Colors in Text

```swift
// Display the detected colors in a simplified way
Text("Detected Color 1")
    .foregroundStyle(colorToneSaturate.colors[0])

Text("Detected Color 2")
    .foregroundStyle(colorToneSaturate.colors[1])

Text("Detected Color 3")
    .foregroundStyle(colorToneSaturate.colors[2])

Text("Detected Color 4")
    .foregroundStyle(colorToneSaturate.colors[3])

Text("Detected Color 5")
    .foregroundStyle(colorToneSaturate.colors[4])
```

### Access the Most Vibrant Color

You can access the most vibrant color detected using the `mostVibrantColor` property:

```swift
let vibrantColor = colorToneSaturate.mostVibrantColor
```

### Mix Colors

The library includes helper functions to mix colors and calculate distances between them:

```swift
let mixedColor = colorToneSaturate.mixColors(color1: .red, color2: .blue)
```

## Detailed API

### Main Class
`ColorToneSaturateCore2`

#### Properties

- **`colors: [Color]`**  
  List of dominant colors detected in the image.

- **`mostVibrantColor: Color`**  
  The most vibrant color detected.

#### Methods

- **`getColorUIImage(_ name: String)`**  
  Loads and processes an image from the project assets.  
  - **Parameters**:
    - `name`: The name of the image in the assets.

- **`detectColors(in image: UIImage)`**  
  Processes an image and detects the dominant colors.

## Customization

You can adjust the maximum number of colors to detect by modifying the `maxColors` parameter in the `detectColors` method.  
By default, up to 5 dominant colors are detected.

## Error Handling

The class internally handles errors related to image processing and color detection.  
Error messages are printed to the console for debugging purposes.

## Contribution

**Contributions are welcome!** If you want to improve this library:

1. Fork the project.
2. Create a branch for your feature (`git checkout -b new-feature`).
3. Make your changes and commit them with descriptive messages.
4. Submit a pull request explaining the changes made.

## License

This project is licensed under the MIT license. See the [LICENSE](https://github.com/lordzzz777/ColorToneSaturate?tab=License-1-ov-file#) file for details.

## Authors

- Lordzzz: [https://github.com/lordzzz777](url)

- Yeikobu: [https://github.com/yeikobu](url)
