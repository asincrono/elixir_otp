# Supervisor
Sería interesante ver de qué va [_Poolboy_](https://elixirschool.com/en/lessons/libraries/poolboy/).

## Comportamiento `Supervisor`
Puntos similares a `GenServer`. También tendrá un `start_link/1` que será un _wrapper_ a `Supervisor.start_link/2` que a su vez invocará a `init/3`.

El valor devuelto por  `init/1` ha de ser una _supervisor specification_. Para ello hemos de usar la función `Supervisor.Spec.supervise/2` (automáticamente importada por el  _comportamiento_ Supervisor).

`supervise/2` acepta dos argumentos: una lista de procesos _hijos_ y una _keyword list_ de opciones.

### Opciones de supervisión
* `strategy`:  define la estrategia de reinicio. Las estrategias posibles son:
    * `:one_by_one`: Si el proceso muere solo se reinicia dicho proceso
    * `:one_for_all`: Si un proceso muere, todos los procesos del árbol serán terminados y reiniciados
    * `:rest_for_one`: Si un proceso muere, todos los precesos iniciados **después** del mismo serán reiniciados
    * `:simple_one_for_one`: En los casos anteriores hay que especificar cada unos de los hijos con antelación. En este caso hay una única especificación para todos los hijos ya que serán todos iguales (misma función, etc.).
* `max_restarts` y `max_seconds`: Indican el número máximo de reinicios tolerados en el espacio de `max_seconds` segundos. En caso de que se soliciten más, el supervisor finaliza.

### Definición de los hijos
La función `worker/3` crea una **especificación** de proceso hijo (_worker_, de manera análoga a `supervisor/3`). Si el proceso a supervisar es un supervisor, en lugar de `worker/3` deberíamos de usar `supervisor/3`. Los tres argumentos son que aceptan son: módulo, argumentos y **opciones**.  Veamos para qué sirven las opcines.

#### Opciones
Las opciones por defecto que aplica Elixir son: 
```elixir
[id: module, 
  function: :start_link,
  restart: :permanent,
  shutdown: :infinity,
  modules: [module]]
```
`function` es la función de m**f**a. No siempre tiene por qué ser `start_link`. `restart` `:permanent` siempre se reiniciará mientras que `:temporary` nunca lo hará.




