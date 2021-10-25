#Funcion que lee el archivo de los vuelos
leerarchivo <- function(){
    archivo <- read.csv("dataset1.csv")
    return (archivo)
}
#Filtra el archivo usando solo los vuelos en origen y destino
filtrarviajes <- function(arc){
filtro1 <- head(arc[,c("origin","destination")],nrow(arc),row.names=FALSE)
return (filtro1)
}
#Funcion que filtra los vuelos repetidos haciendo aparecer una vez
filtrar <- function(archi){
filtro <- head(archi[,c("origin","destination")],nrow(archi),row.names=FALSE)
t1 <- filtro %>% distinct(origin,destination)

return (t1)
}
#Filtra todos los vuelos tanto de origen como destino para facilitar la peticion del clima
unirFiltrarLista <- function(t1){
t1 <- as.list(t1)
listavuelos <- append(t1$origin,t1$destination)
listabuena <- data.frame(listavuelos)
vuelossinrep <- listabuena %>% group_by(listavuelos) %>% filter (!duplicated(listavuelos))

aero <- read.csv("Aeropuertos.csv")

vuelossinrep <- as.list(vuelossinrep)
veconabr <-vector("list",length=2)
vueconabr <- list(Ciudad=veconabr[[1]],Detalles=veconabr[[2]])

a <- length(aero[[1]])
b <- length(vuelossinrep[[1]])
print(a)
print(b)

vuelossinrep <- data.frame(vuelossinrep)
for(i in 1:b){
for(j in 1:a){
if(aero$X...Abreviatura[j]==vuelossinrep$listavuelos[i]){
vueconabr[1]$Ciudad[i] <-vuelossinrep$listavuelos[i]
vueconabr[2]$Detalles[i] <-aero$Ubicaci..n[j]
break
}

}
}
vueconabr <- data.frame(vueconabr)
vueconabr[is.na(vueconabr)] <- "Not Found"
print(vueconabr)
vueconabr <- data.frame(vueconabr)
write.csv(vueconabr,"VuelosDescripcionFiltrados.csv",row.names=FALSE)
return (vueconabr)
}

#Funcion que crea una tabla para poder añadir la informacion del clima de cada ciudad
crearTablaClima <- function(algo){
nuevo <-add_column(algo,Descripcion="",Temp.min="",Temp.max="",Sens.Termica="",Humedad="",Presion="",.after="Ciudad")
return (nuevo)
}

#Funcion que obtiene realiza la peticion para obtener los datos del clima
obtenerDatosClima <- function(a)
{
if (a == 'warning')
    {
        val < - 'It is a warning'
        warning("warning message")
    }
    else if (a == 'error')
    {
        val < - 'It is an error'
        stop("error!!")
    }
    else
    {
        val <- fromJSON(a)
    }
    return (val)
}
