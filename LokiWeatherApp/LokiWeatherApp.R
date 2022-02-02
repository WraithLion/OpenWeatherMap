source("VuelosFiltrados.R",chdir=TRUE)
library(curl)
library(jsonlite)
library(dplyr)
library(DT)
library(knitr)
library("tibble")

    #Variable que guardará el archivo leido
    archivo <- leerarchivo()
    #Variable que guarda todos los vuelos de origen y destino
    filtrados <- filtrarviajes(archivo)
    #Variable que guarda las modificaciones del archivo sin repeticiones
    VuelosSinRepetir <- filtrarVuelosRepetidos(archivo)
    #Variable que guarda las modificaciones para realizar las peticiones
    ListaFiltrada <- unirFiltrarLista(VuelosSinRepetir)
    #Variable que añade las columnas
    TablaClima <- crearTablaClima(ListaFiltrada)
    #Variable que guarda el número de renglones
    tamano <- length(TablaClima[[1]])

#Iterador para realizar cada petición de cada ciudad para almacenarlo en la tabla
for(i in 1:tamano){
    print(paste("Obteniendo datos del clima...",i,"de",tamano))
    #Variable que guarda el enlace con el nombre de la ciudad para realizar la petición
    Clima <- paste("http://api.openweathermap.org/data/2.5/weather?q=", TablaClima$Detalles[i],"&appid=7e10bbf74759c0ce960752bd913f4223&lang=es&units=metric", sep="")
        
    #Función que realiza la peticion y envía un mensaje si existe una advertencia o error, en caso contrario sigue
    revisar <- tryCatch({
        DatosClima <- obtenerDatosClima(Clima)
        },
        warning=function(advertencia)
        {print(paste("Cuidado: ", advertencia))
        },
        error=function(error)
        {print("Error: Obteniendo el clima del siguiente... ")
        },
        finally=function(seguir)
        {}
    )
    
    #Guarda los datos obtenidos de la petición
    Clima_filtro <- merge(DatosClima[["main"]],DatosClima[["weather"]][["description"]])
    
    #Se rescatan los datos solicitados para descartar cualquier información ajena a lo solicitado.
    Clima_filtro$temp=NULL
    Clima_filtro$sea_level=NULL
    Clima_filtro$grnd_level=NULL
        
    #Almacena los datos en la tabla de clima del respectivo lugar
    #Descripción del clima si es nuboso, soleado, lluvioso...
    TablaClima$Descripcion[i] <- Clima_filtro$y[1]
    #Temperatura mínima del lugar
    TablaClima$Temp.min[i] <- Clima_filtro$temp_min[1]
    #Temperatura máxima del lugar
    TablaClima$Temp.max[i] <- Clima_filtro$temp_max[1]
    #Sensacion térmica del lugar
    TablaClima$Sens.Termica[i] <- Clima_filtro$feels_like[1]
    #Indica la Humedad del lugar
    TablaClima$Humedad[i] <- Clima_filtro$humidity[1]
    #Señala la presión del lugar
    TablaClima$Presion[i] <- Clima_filtro$pressure[1]
        
}

#Guarda la información capturada en un archivo csv.
write.csv(TablaClima,"Filtros/CiudadesDatosClima.csv",row.names=FALSE)

#Agrega columnas para poder agregar los datos solicitados para conocer el estado del tiempo de la ciudad de salida
filtrados <- add_column(filtrados,Descripcion="",Temp.min="",Temp.max="",Sens.Termica="",Humedad="",Presion="",.after="origin")

#Agrega columnas para poder agregar los datos solicitados para conocer el estado del tiempo de la ciudad a arrivar
filtrados <- add_column(filtrados,Descripcion.Des="",Temp.min.Des="",Temp.max.Des="",Sens.Termica.Des="",Humedad.Des="",Presion.Des="",.after="destination")

#Variable que guarda el número de vuelos que se tienen
NumerodeVuelos <- nrow(filtrados)

#Se realiza la asignación de los datos en su respectivo campo antes de poder mostrar en pantalla

for(i in 1:tamano){
    for(j in 1:NumerodeVuelos){
        if(TablaClima$Ciudad[i]==filtrados$origin[j]){
        filtrados$Descripcion[j] <- TablaClima$Descripcion[i]
        filtrados$Temp.min[j] <- TablaClima$Temp.min[i]
        filtrados$Temp.max[j] <- TablaClima$Temp.max[i]
        filtrados$Sens.Termica[j] <- TablaClima$Sens.Termica[i]
        filtrados$Humedad[j] <- TablaClima$Humedad[i]
        filtrados$Presion[j] <- TablaClima$Presion[i]
        }
        else if(TablaClima$Ciudad[i]==filtrados$destination[j]){
        filtrados$Descripcion.Des[j] <- TablaClima$Descripcion[i]
        filtrados$Temp.min.Des[j] <- TablaClima$Temp.min[i]
        filtrados$Temp.max.Des[j] <- TablaClima$Temp.max[i]
        filtrados$Sens.Termica.Des[j] <- TablaClima$Sens.Termica[i]
        filtrados$Humedad.Des[j] <- TablaClima$Humedad[i]
        filtrados$Presion.Des[j] <- TablaClima$Presion[i]
        }
    }
}

#Se guarda el archivo para poder tener un respaldo
write.csv(filtrados, "Filtros/VuelosconClima.csv",row.names=FALSE)
filtrados <- read.csv("Filtros/VuelosconClima.csv")
#Se muestra la información solicitada de los respectivos vuelos en una pestaña de navegador
knitr::kable(filtrados)



