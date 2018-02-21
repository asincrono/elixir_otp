# Chapter5

## Link
Link permite enlazar dos procesos de modo que cualquiera de ellos falla, también fallará el otro. Los enlaces que se crean con `link/1` entre procesos son **bidireccionales**.

La función `Process.link/1` enlazará el proceso actual con el proceso cuyo `PID` se pase como argumento.

La función `Process.info/1` devolverá una _keyword list_ con información sobre el proceso. Uno de estos datos será el campo de clave`:links`.

## Flag
Flag permite capturar señales de terminación (`:trap_exit`). Si llamamos a `Process.flag/2` transforma un proceso normal en un proceso _de sistema_ de tal manera que, si alguno de los procesos a los que se encuentra enlazado falla, el proceso de sistema, en lugar de fallar también, recibirá el mensaje `{:EXIT, pid, razón}`.

`Process.flag(:trap_exit, true)`

## Spawn & Link
La función `spawn_link/3` permite realizar simultaneamente la creación de un proceso y su _linkado_ con otro. `spawn_link` enlazará el nuevo proceso con el proceso desde el que se invoca la función.

## Mensajes de terminación
### Normal
Cuando un proceso termina normalmente porque no tiene más código que ejecutar.

Los procesos enlazados a un que termina normalmente recibirán el mensaje `{:EXIT, pid, :normal}`. Y el proceso que recibe el mensaje no se finalizará.

### Forzosa
Estas señales no pueden ser capturadas: `Process.exit(pid, :kill)`. Los procesos enlazados también terminarán salvo que tengan capturada la señal de terminación (`Process.flag(pid, :trap_exit`). En dicho caso recibirán el mensaje `{:EXIT, pid, :killed}`.


## Monitores
Permite que un proceso esté al tanto de si otro proceso termina, sin necesidad que estén enlazados.

Para lograr esto se utiliza la función `Process.monitor(pid)`. Esta función devuelve una referencia (_reference_) que identifica unívocamente al proceso.

Cuando el proceso monitorizado _muere_, el monitor recibirá el mensaje `{:DOWN, referencia, :process, objeto, razón}` donde:
* `referencia` es una referencia al monitor.
* `objeto` es o bien el  `pid` del proceso monitorizado o `{nombre, nodo}` si el proceso es remoto
* `razón` es el motivo de la terminación

Se puede _monitorizar_ procesos que no están vivos. Esto generará el mensaje `{:DOWN, referencia, :process, pid, :noproc}`

## Supervisor
Un supervisor es un proceso que monitoriza otros procesos o supervisores. Esto se puede representar mediante un _árbol de supervisión_.
### Api de `Supervisor`
* `start_link(child_spec_list)`: A partir de la lista de especificaciones del hijo, inical el proceso supervisor y sus hijos
* `start_child(supervisor, child_spec)`: Dado un supervisor (pid) y la especificación de procesos hijos, iniciar y enlazar los hijos al supervisor
* `terminate_child(supervisor, pid)`: Termina el hijo del supervisor
* `restart_child(supervisor, pid, child_spec)`: Reinicia el proceso hijo y lo inicia con las especificaciones indicadas
* `count_children(supervisor)`: Devuelve el nombre de procesos hijos
* `wich_children(supervisor)`: Devuelve el estado del supervisor

