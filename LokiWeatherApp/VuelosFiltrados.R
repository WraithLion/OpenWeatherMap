#Leonardo Aguirre Munoz
#Jonathan Josue Valencia Cruz
#Funcion que lee el archivo de los vuelos
leerarchivo <- function(){
    #Devuelve la variable con la información leida del archivo
    archivo <- read.csv("Filtros/dataset1.csv")
    return (archivo)
}
#Filtra el archivo usando solo los vuelos en origen y destino
filtrarviajes <- function(arc){
#Filtra la informacion obteniendo las ciudades de los vuelos en origen y destino
filtro1 <- head(arc[,c("origin","destination")],nrow(arc),row.names=FALSE)
#Devuelve la variable con la informacion mencionada
return (filtro1)
}
#Funcion que filtra los vuelos repetidos
filtrarVuelosRepetidos <- function(archi){
#Revisa que cada renglon de las columnas con "origin" y "destination" si estan repetidas
filtro <- head(archi[,c("origin","destination")],nrow(archi),row.names=FALSE)
#En caso de ser así los elimina de manera que solo quede 1
ciudadesSinRepeticion <- filtro %>% distinct(origin,destination)
#Devuelve la variable con los cambios realizados
return (ciudadesSinRepeticion)
}
#Filtra todos los vuelos tanto de origen como destino para facilitar la peticion del clima
unirFiltrarLista <- function(ciudadesSinRepeticion){
#Convierte la tabla en una lista de manera que se obtendran dos listas
ciudadesSinRepeticion <- as.list(ciudadesSinRepeticion)
#Concatena los elementos a manera de hacer una única lista
listavuelos <- append(ciudadesSinRepeticion$origin,ciudadesSinRepeticion$destination)
#Ahora pasa los datos de la lista a manera de una tabla
listabuena <- data.frame("Ciudad"=listavuelos)
#Usando la tabla se realiza de nuevo un filtro que los elementos repetidos solo se muestren una vez
vuelossinrep <- listabuena %>% group_by(Ciudad) %>% filter (!duplicated(Ciudad))
#Lee un archivo donde viene la informacion de los aeropuertos
aeropuertos <- read.csv("Filtros/Aeropuertos.csv")

#numero de renglones que tiene el archivo de aeropuertos
a <- length(aeropuertos[[1]])
#Número de renglones que tiene el archivo de ciudades
b <- length(vuelossinrep[[1]])

#Agrega una columna a las ciudades sin repetidos con el nombre Detalles
vuelossinrep <- add_column(vuelossinrep,Detalles="")

for(i in 1:b){
for(j in 1:a){
#Revisa si la abreviacion está en el archivo de los aeropuertos
if(aeropuertos$Abreviatura[j]==vuelossinrep$Ciudad[i]){

#Asigna el espacio en Detalles el nombre del aeropuerto
vuelossinrep$Detalles[i] <-aeropuertos$Ubicaci..n[j]
}
}
}
#Quita los espacios que tenga y los remplaza con %20 para realizar las peticiones
vuelossinrep$Detalles <- gsub( " ", "%20", vuelossinrep$Detalles)
#Guarda los datos en un archivo csv.
write.csv(vuelossinrep,"Filtros/VuelosDescripcionFiltrados.csv",row.names=FALSE)
#Devuelve la variable con la nueva información
return (vuelossinrep)
}

#Funcion que crea una tabla para poder añadir la informacion del clima de cada ciudad
#Parametros
#Vuelos Es el archivo que tiene la informacion de la anterior función
crearTablaClima <- function(Vuelos){
#Añade 6 columnas para poder almacenar los datos del clima una vez realizada la petición.
vuelosSinDatosClima <-add_column(Vuelos,Descripcion="",Temp.min="",Temp.max="",Sens.Termica="",Humedad="",Presion="",.after="Ciudad")
#Regresa la variable con las modificaciones para almacenar los datos al realizar la peticion
return (vuelosSinDatosClima)
}

#Funcion que obtiene realiza la peticion para obtener los datos del clima
obtenerDatosClima <- function(Aviso)
{
#Alerta de un aviso en caso de una advertencia o de un error
if (Aviso == 'warning')
    {
        respuesta < - 'It is a warning'
        warning("warning message")
    }
    else if (Aviso == 'error')
    {
        respuesta < - 'It is an error'
        stop("error!!")
    }
    else
    {
        respuesta <- fromJSON(Aviso)
    }
    return (respuesta)
}
