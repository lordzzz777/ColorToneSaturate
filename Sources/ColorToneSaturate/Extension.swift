//
//  File.swift
//  ColorToneSaturate
//
//  Created by Esteban Pérez Castillejo on 13/10/24.
//

import SwiftUI

/// Extensión del protocolo `ClusterColorsProtocol` que proporciona funciones auxiliares para agrupar colores, calcular distancias y mezclar colores.
extension ClusterColorsProtocol {
    
    /// Agrupa colores similares basándose en la proximidad en el espacio de color.
    /// - Parameters:
    ///   - colorCounts: Un diccionario que contiene colores (`UIColor`) como claves y la cantidad de veces que aparecen como valores.
    ///   - maxClusters: El número máximo de grupos (clusters) que se deben crear.
    /// - Returns: Un array de colores (`UIColor`) representando los clusters más dominantes.
    ///
    /// Este método recorre los colores detectados y agrupa aquellos que están cerca en términos de distancia de color.
    /// Si el número de clusters es menor que `maxClusters`, simplemente se añade el color al array.
    /// Si ya se alcanzó el límite, se encuentra el color en el cluster más cercano y se combina con él.
    func clusterColors(colorCounts: [UIColor: Int], maxClusters: Int) -> [UIColor] {
        var cluster: [UIColor] =  []
        
        /// Recorre todo los colores detectados en `colorCounts`.
        for (color, _) in colorCounts{
            if cluster.count < maxClusters {
                // si no se  han alcanzado los  clusters, máximos, añadir el color directamente.
                cluster.append(color)
            }else {
                // Encontrar el cluster más cercano y mezclar colores si ya alcanzó el máximo de clusters.
                var minDistance = CGFloat.greatestFiniteMagnitude
                var closestClusterIndex = 0
                for (index, clusterColor) in cluster.enumerated() {
                    let distance = colorDistance(from: color, to: clusterColor)
                    if distance < minDistance {
                        minDistance = distance
                        closestClusterIndex = index
                    }
                }
                cluster[closestClusterIndex] = mixColors(color1: cluster[closestClusterIndex], color2: color)
            }
        }
        return cluster
    }
    
    /// Encuentra el color más vibrante a partir de un array de colores.
    /// - Parameter colors: Un array de colores (`UIColor`) de los que se seleccionará el más vibrante.
    /// - Returns: El color más vibrante en forma de `Color`.
    ///
    /// Este método ordena los colores por saturación y selecciona el que tiene la mayor saturación.
    func findMostVibrantColor(from colors: [UIColor]) -> Color {
        // Ordenar los colores por saturación en orden descendente y devolver el primero.
        let sortedColors = colors.sorted { colorSaturation(from: $0) > colorSaturation(from: $1) }
        return Color(sortedColors.first ?? UIColor.white)
    }
    
    /// Calcula la saturación de un color dado.
    /// - Parameter color: Un color (`UIColor`) cuya saturación se calculará.
    /// - Returns: El valor de saturación del color como un valor `CGFloat` entre 0 y 1.
    ///
    /// Este método extrae los componentes rojo, verde y azul de un color y calcula la diferencia entre
    /// el color más fuerte y el más débil para determinar la saturación.
    func colorSaturation(from color: UIColor) -> CGFloat {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        // Extraer los componentes de color RGBA.
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        // Calcular la saturación como la diferencia entre el color máximo y mínimo.
        let maxColor = max(r, g, b)
        let minColor = min(r, g, b)
        let saturation = maxColor - minColor
        
        return saturation
    }
    
    /// Calcula la distancia entre dos colores en el espacio RGB.
    /// - Parameters:
    ///   - color1: El primer color (`UIColor`).
    ///   - color2: El segundo color (`UIColor`).
    /// - Returns: Un valor `CGFloat` que representa la distancia entre los dos colores.
    ///
    /// La distancia entre dos colores se calcula utilizando la diferencia de sus componentes rojo, verde y azul.
    func colorDistance(from color1: UIColor, to color2: UIColor) -> CGFloat {
        var r1: CGFloat = 0
        var g1: CGFloat = 0
        var b1: CGFloat = 0
        var a1: CGFloat = 0
        var r2: CGFloat = 0
        var g2: CGFloat = 0
        var b2: CGFloat = 0
        var a2: CGFloat = 0
        
        // Extraer los componentes RGBA de ambos colores.
        color1.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        color2.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)
        
        // Calcular las diferencias en cada canal de color.
        let dr = r1 - r2
        let dg = g1 - g2
        let db = b1 - b2
        
        // Retornar la suma de las diferencias cuadradas como distancia.
        return dr * dr + dg * dg + db * db
    }

    /// Mezcla dos colores en partes iguales.
    /// - Parameters:
    ///   - color1: El primer color (`UIColor`).
    ///   - color2: El segundo color (`UIColor`).
    /// - Returns: Un nuevo color (`UIColor`) que es el promedio de los dos colores mezclados.
    ///
    /// Este método combina dos colores al promediar sus componentes rojo, verde y azul.
    func mixColors(color1: UIColor, color2: UIColor) -> UIColor {
        var r1: CGFloat = 0
        var g1: CGFloat = 0
        var b1: CGFloat = 0
        var a1: CGFloat = 0
        var r2: CGFloat = 0
        var g2: CGFloat = 0
        var b2: CGFloat = 0
        var a2: CGFloat = 0
        
        // Extraer los componentes RGBA de ambos colores.
        color1.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        color2.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)
        
        // Promediar los componentes de color.
        let r = (r1 + r2) / 2
        let g = (g1 + g2) / 2
        let b = (b1 + b2) / 2
        
        // Devolver el color mezclado con los valores promediados.
        return UIColor(red: r, green: g, blue: b, alpha: 1.0)
    }
}
