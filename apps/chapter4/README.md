# `GenServer`  callbacks
## Init
`init(args)`
### Invocación
En respuesta a `GenServer.start_link/3` o `start/3`.
### Valor devuelto
* `{:ok, estado}`: Estado será el primer estado del proceso.
* `{:ok, estado, tiempo_muerto}`:  Si en `tiempo_de_espera` milisegundos no recibe ningún mensaje, se invocará a `handle_info(:timeout, estado)`
* `{:ok, estado, :hibernate}` el proceso entra en _hibernación_ antes de comenzar el bucle.
* `:ignore`: Hará que `start_link/3` devuelve también `:ignore` y el proceso terminará normalmente (sin invocar a `terminate/2`).

## Terminate
`terminate(razón, estado)`
### Invocación
Cuando el proceso (servidor) está a punto de terminar.
`razón` es el motivo de la finalización del proceso y `estado` el estado actual.

Será invocado si alguna función de devolución de llamada (_callback_) devuelve alguno de los siguientes valores:
* `:stop`
* se produce un error (raises) (llamada a `raise/1`)
* llama a `Kernel.exit/1`
* devuelve un valor no válido
* el `GenServer` recibe una señal que puede capturar (_trap_) (usando `Process.flag/2`) _y_ el proceso padre envía una señal de salida

**No hay seguridad de que `terminate` sea llamado.** Si hay que liberar recursos importantes ha de hacerse en procesos independientes que controlen dichos recursos.

## Handle call
`handle_call(mensaje, desde, estado)`
### Invocación
Será llamada para manejar mensajes síncronos `call/3`. `call/3` se bloqueará hasta que reciba una respuesta.
* `mensaje` es el mensaje enviado mediante `call/3`
* `desde` es una tupla con dos elementos: el `pid` del proceso y un valor que indentifique unívocamente la llamada
* `estado` es el estado actual del servidor

### Valor devuelto
* `{:reply, respuesta, nuevo_estado}`:
* `{:reply, respuesta, nuevo_estado, timeout() | :hibernate}`:
* `{:noreply, nuevo_estado}`:
* `{:noreply, nuevo_estado, timeout() | :hibernate}`:
*  `{:stop, reason, reply, new_state}`:
*  `{:stop, reason, new_state}`:



