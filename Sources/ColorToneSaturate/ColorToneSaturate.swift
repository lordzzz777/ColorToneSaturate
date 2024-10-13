//
//  ColorToneSaturateCore.swift
//  ColorToneSaturate
//
// The Swift Programming Language
// Created by Esteban Pérez Castillejo on 13/10/24.

import CoreGraphics
import SwiftUI
import Observation

@Observable
public class ColorToneSaturate: ClusterColorsProtocol {    
    
    /// Enum que representa los colores detectados.
    /// Cada caso almacena un color específico detectado.
    public enum DetectedColor {
        case color1(Color)
        case color2(Color)
        case color3(Color)
        case color4(Color)
        case color5(Color)
        
        /// Propiedad que devuelve el valor `Color` correspomdiente a cada caso
        public var color: Color {
            switch self {
            case .color1(let color),
                 .color2(let color),
                 .color3(let color),
                 .color4(let color),
                 .color5(let color):
                return color
            }
        }
    }
    
    /// Enum que representa los errores que pueden ocurrir al procesar la imagen o detectar colores.
    /// Hereda de `Error` y `LocalizedError` para permitir la localización de mensajes de error.
    public enum ColorToneError: Error, LocalizedError {
        case invalidImageSize(String) // Error cuando el tamaño de la imagen es inválido
        case imageProcessingFailed(String) // Error cuando falla el procesamiento de la imagen
        
        /// Proporciona una descripción localizada del error.
        public var errorDescription: String? {
            switch self {
            case .invalidImageSize(let message):
                return NSLocalizedString(message, comment: "")
            case .imageProcessingFailed(let message):
                return NSLocalizedString(message, comment: "")
            }
        }
    }
    
    /// Una lista de los colores dominantes detectados en la imagen.
    /// Se inicializa vacía, pero se llenará con los colores dominantes después de que se procese una imagen.
    public var dominantColors: [Color] = []
    
    /// Un array que contiene los colores detectados en forma de `DetectedColor`.
    /// Se inicializa con colores claros por defecto.
    public var detectedColors: [DetectedColor] = [
        .color1(Color.clear), .color2(Color.clear), .color3(Color.clear), .color4(Color.clear), .color5(Color.clear)
    ]
    
    /// Propiedad calculada que devuelve una lista de colores.
    /// Esta propiedad transforma los colores almacenados en `detectedColors` en una lista de valores `Color`.
    public var colors: [Color] {
        return detectedColors.map { $0.color }
    }
    
    /// El color más vibrante detectado en la imagen.
    /// Se inicializa con `Color.clear` como valor por defecto.
    public var mostVibrantColor: Color = Color.clear
    
    /// Inicializador de la clase.
    public init() {}
    
    /// Función que carga una imagen desde los assets y detecta los colores dominantes.
    /// - Parameter name: El nombre de la imagen en los assets.
    /// Esta función intenta cargar la imagen con el nombre proporcionado, y si se carga correctamente,
    /// se llama a `detectColors` para analizar la imagen y detectar los colores dominantes.
    public func getColorUIImage(_ name: String) {
        if let uiImage = UIImage(named: name) {
            do{
                // Intentar detectar los colores de la imagen
                try detectColors(in: uiImage)
            }catch{
                // Manejo de errores si la detección falla
                print("Error", error.localizedDescription)
            }
        }
    }
    
    /// Detecta los colores dominantes en una imagen.
    /// - Parameters:
    ///   - image: La imagen a procesar.
    ///   - targetSize: El tamaño al que se redimensionará la imagen.
    ///   - maxColors: El número máximo de colores que se detectarán.
    /// - Throws: `ColorToneError` si ocurre un error durante el procesamiento.
    public func detectColors(in image: UIImage, targetSize: CGSize = CGSize(width: 50, height: 50), maxColors: Int = 5) throws {
        // Redimensionar la imagen
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        let resizedImage = renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: targetSize))
        }

        guard let inputImage = resizedImage.cgImage else {
            throw ColorToneError.imageProcessingFailed("No se pudo convertir la imagen redimensionada a CGImage")
        }

        // Procesar la imagen y detectar colores

        do {
            try processImage(cgImage: inputImage, targetSize: targetSize, maxColors: maxColors)
        } catch let error as ColorToneError {
            // Manejar errores específicos relacionados con la imagen
            print("Error en el procesamiento de colores: \(error.localizedDescription)")
        } catch {
            // Manejar cualquier otro tipo de error
            print("Error inesperado: \(error)")
        }
    }
    
    /// Procesa la imagen y detecta los colores dominantes.
    /// - Parameters:
    ///   - cgImage: Imagen en formato CGImage.
    ///   - targetSize: El tamaño de la imagen.
    ///   - maxColors: El número máximo de colores que se detectarán.
    private func processImage(cgImage: CGImage, targetSize: CGSize, maxColors: Int) throws {
        let width = Int(targetSize.width)
        let height = Int(targetSize.height)

        guard width > 0 && height > 0 else {
            throw ColorToneError.invalidImageSize("El tamaño de la imagen es inválido.")
        }

        let bytesPerRow = width * 4
        var bitmapData = Data(count: width * height * 4)
        
        bitmapData.withUnsafeMutableBytes { ptr in
            guard let baseAddress = ptr.baseAddress else {
                print("Error: No se pudo obtener la base address de los bytes")
                return
            }

            guard let colorSpace = CGColorSpace(name: CGColorSpace.sRGB),
                  let context = CGContext(data: baseAddress,
                                          width: width,
                                          height: height,
                                          bitsPerComponent: 8,
                                          bytesPerRow: bytesPerRow,
                                          space: colorSpace,
                                          bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else {
                print("Error: No se pudo crear el contexto gráfico")
                return
            }

            // Dibujar la imagen en el contexto gráfico
            context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))

            let ptr = ptr.bindMemory(to: UInt8.self)
            var colorCounts: [UIColor: Int] = [:]

            // Procesar los píxeles de la imagen
            for y in 0..<height {
                for x in 0..<width {
                    let pixelIndex = ((width * y) + x) * 4
                    let r = CGFloat(ptr[pixelIndex]) / 255.0
                    let g = CGFloat(ptr[pixelIndex + 1]) / 255.0
                    let b = CGFloat(ptr[pixelIndex + 2]) / 255.0
                    let color = UIColor(red: r, green: g, blue: b, alpha: 1.0)
                    colorCounts[color, default: 0] += 1
                }
            }

            // Detectar los colores dominantes
            let colorClusters = clusterColors(colorCounts: colorCounts, maxClusters: maxColors)
            dominantColors = colorClusters.map { Color($0) }
            mostVibrantColor = findMostVibrantColor(from: colorClusters)

            // Asignar los colores detectados al enum
            detectedColors = dominantColors.enumerated().map { index, color in
                switch index {
                case 0: return .color1(color)
                case 1: return .color2(color)
                case 2: return .color3(color)
                case 3: return .color4(color)
                case 4: return .color5(color)
                default: return .color1(color) // Fallback, aunque no debería alcanzar este punto
                }
            }
        }
    }
}
