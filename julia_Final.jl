
miVariable = 1

miVariable = miVariable + 5

δ = 0.00001

δ = "Hola a todos y todas"

# Constantes matemáticas
π

miVariable = 2*π + 0.12

miVariable = miVariable + Inf

miVariable = miVariable + -Inf

# soporte para números irracionales
res = (1 + 4im)*(2 - 3im)

cos(res)

π = 3.14

tup = (1, 2, 3) 
length(tup)

in(4, tup) # => true

d, e, f = 4, 5, 6 

e, d = d, e
e, d

# números racionales
1//3

float(1//3)

x = "Soy un string"

y::Int64
y = x

tup[1] # => 1
try:
    tup[1] = 3 # MethodError
catch e
    println(e)
end

ampliacion_sqrt(x) =

x >= 0 ? sqrt(x) : error("Valor de x negativo es inválido")

ampliacion_sqrt(100)

ampliacion_sqrt(-6)

(x -> x^2 + 2x - 1)(2)

map(x -> x^2 + 2x - 1, [1,3,-1])

function foo(a,b)
           a+b, a*b
end
x, y = foo(2,3)

function default(a,b,x=5,y=6)
    return "$a $b and $x $y"
end

default('h','g')

default('h', 'g', 'i')

f2(x) = x^2

f2(2)

Ad = rand(3, 3)
f2(Ad)

f2("hola") #La multiplicacion de este parametro implica una concatenacion

v = rand(3)
f2(v) # DimensionMismatch

v = [4, 7, 1]

sort(v)

v

sort!(v)

v

Am = [i + 3*j for j in 0:2, i in 1:3]

f2(Am)  #Esto seria A^2 = A*A

f2.(Am) #Esto en cambio aplica x^2 a cada elemento de la matriz

#Para entender el despacho multiple en Julia, observemos el operador +
#Si llamamos a la funcion methods() sobre +, podemos ver todas las definiciones de +
methods(+)

#Podemos definir mas metodos. Para esto primero tenemos que importar + de Base
import Base: +

#Por ejemplo si queremos concatenar elementos con +. Sin extender el metodo, no funciona.
# (No esta entre esos 180 anteriores)
+(x::String, y::String) = string(x, y)

"Hello" + " world!"

foo(x, y) = println("duck-typed foo!")
foo(x::Int, y::Float64) = println("foo con entero y flotante!")
foo(x::Float64, y::Float64) = println("foo con dos flotantes!")
foo(x::Int, y::Int) = println("foo con dos enteros") 

foo(1, 1)

foo(1. , 1.)

foo(1, 1.0)

foo(true, false)

map(x -> x^3, (1:5))

filter(isprime, (1:50))

type Tigre
  largo_de_cola::Float64
  color_de_pelaje
end

abstract Felino # Declaramos una clase abstracta sin comportamiento

type Pantera <: Felino
    color_de_ojos
    color_de_pelaje
  Pantera() = new("verde", "negro")
end

type Leon <: Felino 
  color_de_melena
  roar::AbstractString
end

tigger = Tigre(3.5,"naranja")

function meow(animal::Leon)
  animal.roar
end

function meow(animal::Pantera)
  "grrr"
end

function meow(animal::Tigre)
  "rawwwr"
end

meow(tigger)

meow(Leon("marrón","ROAAR"))

meow(Pantera())

println(nprocs())
addprocs(1)
println(nprocs())

for w in workers()
    rref=remotecall(myid, w)
    sleep(1)
    println(fetch(rref))
end

@everywhere function random_num(n)
    c::Int = 0
    for i = 1:n
        c += rand(Bool)
    end
    c
end

a = @spawn random_num(100000000)

b = @spawn random_num(10000000)

println(fetch(a)+fetch(b)) #reducción

# Se genera la lista de tasks
t = @task Any[ for x in [1,2,4] println(x) end ]

# No hay tasks?
println(istaskdone(t))

# Cual es la siguiente task?
println(current_task())

# Ejecutar task
println(consume(t))

c1 = Channel(32)
put!(c1,3)
put!(c1,4)
c2 = Channel(32)

# foo() lee un item de c1, lo imprime y lo escribe en c2
function foo()
    while true
        data = take!(c1)
        println(data)
        result = data + 2
        put!(c2, result)   
    end
end

# con @schedule podemos hacer que varias instancias de foo() estén activas concurrentemente.
for i in 1:3
    @schedule foo()
end

for i in 1:3
    data= take!(c2)
    println(data)
end

c = Channel(0)

task = @schedule foreach(i->put!(c, i), 1:4)

bind(c,task)

for i in c
    @show i
end

isopen(c)

using RDatasets
xclara = dataset("cluster", "xclara")
size(xclara)

x = xclara[:V1]
y = xclara[:V2]
using Plots
scatter(x, y ,alpha=0.5)

using Clustering

xclara = convert(Array, xclara)
xclara = xclara'
xclara_kmeans = kmeans(xclara, 3)

using Distances
dclara = pairwise(SqEuclidean(), xclara);

# parametros: matriz de distancias, el radio de un cluster, 
# mínimo número de puntos que forman un cluster
xclara_dbscan = dbscan(dclara, 10, 40);

# devuelve cantidad de puntos para cada cluster encontrado
xclara_dbscan.counts 

using Distributions
m = 10000
matrix = rand(Uniform(0.0, 10.0), m, m)

n = 0;
for i in [1:100]
    tic()
    trace(matrix)
    aux = toq()
    n = n + aux
end

n/100
