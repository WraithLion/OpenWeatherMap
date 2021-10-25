source("micodigo.R",chdir=TRUE)
library(testthat)
library(curl)
library(jsonlite)
library(dplyr)
library("tibble")
test_that("un número", {

    archivo <- leerarchivo()
    filtrados <- filtrarviajes(archivo)

    filtrad <- filtrar(archivo)
    ListaFiltrada <- unirFiltrarLista(filtrad)
    nuevo <- crearTablaClima(ListaFiltrada)
    largo <- length(nuevo[[1]])

    #Iterador para realizar cada peticion de cada ciudad para almacenarlo en la tabla
    for(i in 1:largo){
Clima <- paste("http://api.openweathermap.org/data/2.5/weather?q=", nuevo$Detalles[i],"&appid=7e10bbf74759c0ce960752bd913f4223&lang=es&units=metric", sep="")
revisar <- tryCatch({
DatosClima <- obtenerDatosClima(Clima)

},
warning=function(war)
{print(paste("Cuidado: ", war))
},
error=function(err)
{
print("Error: Pasando al siguiente vuelo ")

},
finally=function(f)
{
})
Clima_filtro <- merge(DatosClima[["main"]],DatosClima[["weather"]][["description"]])

#Se rescatan los datos solicitados para descartar cualquier informacion ajena a lo solicitado.

Clima_filtro$temp=NULL
Clima_filtro$sea_level=NULL
Clima_filtro$grnd_level=NULL

nuevo$Descripcion[i] <- Clima_filtro$y[1]
nuevo$Temp.min[i] <- Clima_filtro$temp_min[1]
nuevo$Temp.max[i] <- Clima_filtro$temp_max[1]
nuevo$Sens.Termica[i] <- Clima_filtro$feels_like[1]
nuevo$Humedad[i] <- Clima_filtro$humidity[1]
nuevo$Presion[i] <- Clima_filtro$pressure[1]
}
write.csv(nuevo,"VueloDatosClima.csv",row.names=FALSE)
print(nuevo)

#Agrega columnas para poder agregar los datos solicitados para conocer el estado del tiempo de la ciudad a arrivar

filtrados <- add_column(filtrados,Descripcion="",Temp.min="",Temp.max="",Sens.Termica="",Humedad="",Presion="",.after="origin")

filtrados <- add_column(filtrados,Descripcion.Des="",Temp.min.Des="",Temp.max.Des="",Sens.Termica.Des="",Humedad.Des="",Presion.Des="",.after="destination")
longitud <- nrow(nuevo)
longitud2 <- nrow(filtrados)

#Se realiza la asignacion de los datos en su respectivo campo antes de poder mostrar en pantalla

for(i in 1:longitud){
for(j in 1:longitud2){
if(nuevo$Ciudad[i]==filtrados$origin[j]){
filtrados$Descripcion[j] <- nuevo$Descripcion[i]
filtrados$Temp.min[j] <- nuevo$Temp.min[i]
filtrados$Temp.max[j] <- nuevo$Temp.max[i]
filtrados$Sens.Termica[j] <- nuevo$Sens.Termica[i]
filtrados$Humedad[j] <- nuevo$Humedad[i]
filtrados$Presion[j] <- nuevo$Presion[i]
}else if(nuevo$Ciudad[i]==filtrados$destination[j]){
filtrados$Descripcion.Des[j] <- nuevo$Descripcion[i]
filtrados$Temp.min.Des[j] <- nuevo$Temp.min[i]
filtrados$Temp.max.Des[j] <- nuevo$Temp.max[i]
filtrados$Sens.Termica.Des[j] <- nuevo$Sens.Termica[i]
filtrados$Humedad.Des[j] <- nuevo$Humedad[i]
filtrados$Presion.Des[j] <- nuevo$Presion[i]
}
}
}

#Se guarda el archivo para poder tener un respaldo

write.csv(filtrados, "ClimaTodosLosVuelos.csv",row.names=FALSE)

#Se muestra la informacion solicitada de los respectivos vuelos

write.csv(filtrados)



    })
