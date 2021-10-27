# OpenWeatherMap App
Programa para visualizar el clima de los vuelos hacia diferentes aereopuertos.

# 1. Ejecución del programa

Para proceder a ejecutar el programa, se requerirá primeramente que se descargue la carpeta OpenWeatherMap adjunto a su contenido.

Posteriormente, se ejecutará el archivo LokiWeatherApp.R localizado en OpenWeatherMap/LokiWeatherApp/, éste archivo se puede ejecutar ya sea dentro de una terminal
(esto se puede realizar con el comando "Rscript LokiWeatherApp.R", asegúrate de que la terminal se encuentre en la carpeta donde se ubica "LokiWeatherApp.R" usando el comando cd, de lo contrario te marcará el error de archivo no encontrado) o a partir de alguna aplicación para archivos en R (como lo es el caso del programa RStudio disponible para Windows, Linux y Mac, puedes consultar el método de instalación en el siguiente enlace: https://www.uv.es/vcoll/primeros-pasos.html)

Con lo anterior realizado, usted verá que se iniciará el programa mostrando en pantalla una lista de carga con los datos a obtener para después mostrar en terminal
una tabla donde se visualizará los siguientes datos del clima junto a su respectivo lugar: 

1. Descripción
2. Temp.min
3. Temp.max
4. Sens.Térmica
5. Humedad
6. Presión

Nótese que, debido a que la terminal resulta ser reducida en cuanto la cantidad de información mostrada de manera simultanea, se optó por primeramente mostrar los datos
del clima de la ciudad de origen y luego los datos del clima de la ciudad de destino.

# 2. Información del contenido

A continuación se mostrará la lista de elementos contenidos en OpenWeatherMap junto a una somera descripción de los mismos:

OpenWeatherMap/

1. Proyecto_Aguirre_Leonardo_Valencia_Jonathan.pdf: Se trata de un archivo en formato pdf que explica en mayor profundidad lo realizado en el proyecto
2. README.md: Es el archivo que está leyendo en este momento

  OpenWeatherMap/LokiWeatherApp/
  
  1. LokiWeatherApp.R: Es el archivo principal para la ejecución del programa
  2. VuelosFiltrados.R: En este archivo se declaran las funciones y variables utilizadas en "LokiWeatherApp.R"

  OpenWeatherMap/LokiWeatherApp/Filtros/
  
  1. Aeropuertos.csv: Contiene una tabla de los diferentes aeropuertos ubicados en México, muestra la ciudad de localización de cada aeropuerto
  2. dataset1.csv: Contiene la tabla de vuelos realizados en México, contiene los lugares de origen y destino de los respectivos vuelos
