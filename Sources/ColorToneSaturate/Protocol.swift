//
//  File.swift
//  ColorToneSaturate
//
//  Created by Esteban Pérez Castillejo on 13/10/24.
//

import SwiftUI

protocol ClusterColorsProtocol {
    
    /// Agrupa colores similares en función de la proximidad de sus valores RGB.
    /// - Parameters:
    ///   - colorCounts: Un diccionario que contiene colores (`UIColor`) como claves y la cantidad de veces que aparecen como valores.
    ///   - maxClusters: El número máximo de clusters o grupos de colores a crear.
    /// - Returns: Un array de colores (`UIColor`) representando los grupos más dominantes.
    ///
    /// Esta función permite identificar los colores dominantes en una imagen al agrupar colores cercanos en el espacio de color.
    func clusterColors(colorCounts: [UIColor: Int], maxClusters: Int) -> [UIColor]
    
    /// Encuentra el color más vibrante a partir de un array de colores.
    /// - Parameter colors: Un array de colores (`UIColor`) de los que se seleccionará el más vibrante.
    /// - Returns: El color más vibrante en forma de `Color`.
    ///
    /// Esta función identifica el color más saturado de un conjunto, que puede ser útil para resaltar el color más llamativo de una imagen.
    func findMostVibrantColor(from colors: [UIColor]) -> Color
    
    /// Calcula la saturación de un color dado.
    /// - Parameter color: Un color (`UIColor`) cuya saturación se calculará.
    /// - Returns: El valor de saturación del color como un valor `CGFloat` entre 0 y 1.
    ///
    /// La saturación mide la intensidad o pureza de un color. Este método permite determinar la saturación de un color específico.
    func colorSaturation(from colors: UIColor ) -> CGFloat
    
    /// Calcula la distancia entre dos colores en el espacio RGB.
    /// - Parameters:
    ///   - color1: El primer color (`UIColor`).
    ///   - color2: El segundo color (`UIColor`).
    /// - Returns: Un valor `CGFloat` que representa la distancia entre los dos colores.
    ///
    /// Este método calcula la distancia entre dos colores en el espacio de color RGB. Cuanto menor sea la distancia, más similares serán los colores.
    func colorDistance(from color1: UIColor, to color2: UIColor) -> CGFloat
    
    /// Mezcla dos colores en partes iguales.
    /// - Parameters:
    ///   - color1: El primer color (`UIColor`).
    ///   - color2: El segundo color (`UIColor`).
    /// - Returns: Un nuevo color (`UIColor`) que es el promedio de los dos colores mezclados.
    ///
    /// Este método combina dos colores promediando sus componentes RGB, creando un nuevo color que es el resultado de la mezcla.
    func mixColors(color1: UIColor, color2: UIColor) -> UIColor
}
