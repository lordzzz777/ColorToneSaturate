# ColorToneSaturate

![Swift](https://img.shields.io/badge/swift-5.9-orange)
![Platform](https://img.shields.io/badge/platform-iOS-lightgrey)
![Platform](https://img.shields.io/badge/platform-macOS-lightgrey)
![License](https://img.shields.io/badge/license-MIT-green)

## Descripción

**ColorToneSaturate** es una biblioteca en Swift diseñada para detectar colores dominantes y vibrantes en imágenes. A través de una serie de funciones de procesamiento de imágenes, puedes identificar los colores más prominentes y sus niveles de saturación. Es ideal para aplicaciones que necesitan análisis de color, creación de paletas, o ajuste de interfaz según el tono de la imagen.

## Características

- Detecta hasta 5 colores dominantes en una imagen.
- Identifica el color más vibrante.
- Funciones auxiliares para calcular distancias y mezclar colores.
- Fácil integración con SwiftUI.
  
## Requisitos

- iOS 17.0+ / macOS 14.0+
- Swift 5.9+

## Instalación

### Swift Package Manager

Puedes añadir **ColorToneSaturate** a tu proyecto utilizando [Swift Package Manager](https://swift.org/package-manager/).

1. En Xcode, ve a tu proyecto y selecciona `Swift Packages`.
2. Haz clic en el botón `+` y pega el siguiente URL:
´´´html
https://github.com/tu-usuario/ColorToneSaturate.git
´´´
      <input type="text" value="https://github.com/tu-usuario/ColorToneSaturate.git" readonly>

4. Selecciona la versión y agrega el paquete a tu proyecto.

## Uso

### Inicialización

Crea una instancia de **`ColorToneSaturateCore`** para manejar la detección de colores en tu aplicación:

```swift
import ColorToneSaturate

let colorToneSaturate = ColorToneSaturateCore2()
```
## Ejemplo básico

Para detectar colores en una imagen y obtener los colores dominantes, sigue este ejemplo de uso en SwiftUI:

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
                    if let uiImage = UIImage(named: "exampleImage") {
                        colorToneSaturate.detectColors(in: uiImage)
                    }
                }

            HStack {
                ForEach(colorToneSaturate.colors, id: \.self) { color in
                    Rectangle()
                        .fill(color)
                        .frame(width: 50, height: 50)
                }
            }
        }
        .background(colorToneSaturate.mostVibrantColor)
    }
}
```
###  Obtener el color más vibrante

Puedes acceder al color más vibrante detectado utilizando la propiedad mostVibrantColor:

```swift
let vibrantColor = colorToneSaturate.mostVibrantColor
```

###  Mezclar colores

La biblioteca incluye funciones auxiliares para mezclar colores y calcular distancias entre ellos:

```swift
let mixedColor = colorToneSaturate.mixColors(color1: .red, color2: .blue)
```

## API Detallada

### Clase principal
`ColorToneSaturateCore2`

#### Propiedades

- **`colors: [Color]`**  
  Lista de colores dominantes detectados en la imagen.

- **`mostVibrantColor: Color`**  
  El color más vibrante detectado.

#### Métodos

- **`getColorUIImage(_ name: String)`**  
  Carga y procesa una imagen desde los assets del proyecto.  
  - **Parámetros**:
    - `name`: El nombre de la imagen en los assets.

- **`detectColors(in image: UIImage)`**  
  Procesa una imagen y detecta los colores dominantes.

## Personalización

Puedes ajustar el número máximo de colores a detectar modificando el parámetro `maxColors` en el método `detectColors`.  
Por defecto, se detectan hasta 5 colores dominantes.

## Manejo de errores

La clase maneja internamente los errores relacionados con el procesamiento de imágenes y la detección de colores.  
Los mensajes de error se imprimen en la consola para fines de depuración.

## Contribución

**¡Las contribuciones son bienvenidas!** Si deseas mejorar esta librería:

1. Haz un fork del proyecto.
2. Crea una rama para tu funcionalidad (`git checkout -b nueva-funcionalidad`).
3. Realiza tus cambios y haz commits descriptivos.
4. Envía una pull request explicando los cambios realizados.

## Licencia

Este proyecto está licenciado bajo la licencia MIT. Consulta el archivo [[LICENSE](https://github.com/lordzzz777/ColorToneSaturate?tab=License-1-ov-file#)](utl) para más detalles.

## Autores

- Lordzzz: [https://github.com/lordzzz777](url)

- Yeikobu: [https://github.com/yeikobu](url)
