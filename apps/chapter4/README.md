# GenServer
## Callbacks
### Init
| **Callback**                           |**Valor de retorno**         |
| ---------------------------------------|-----------------------------|
| `init(args)`                           |`{:ok, estado}`              |
|                                        |`{:ok, estado, tiempo_espera`|
|                                        |`:ignore`                    |
|                                        |`{:stop, razón}`             |


### Llamada síncrono
| **Callback**  |**Valor de retorno**                        |
| ------------  |--------------------------------------------|
| `handle_call(msg, {from, ref}, estado)`|`{:reply, respuesta, estado}`               |
|               |`{:reply, respuesta, estado}`               |
|               |`{:reply, respuesta, estado, tiempo_espera}`|
|               |`{:reply, respuesta, estado, :hibernate}`   |
|               |`{:noreply, estado}`                        |
|               |`{:noreply, estado, tiempo_epera}`          |
|               |`{:noreply, estado, :hibernate}`            |
|               |`{:stop, razón, respuesta, estado}`         |
|               |`{:stop, razón, estado}`                    |

### Llamada asíncrona
| **Callback**               | **Valor de retorno**                |
| -------------------------- | ----------------------------------- |
| `handle_info(msg, estado)` | `{:noreply, estado}`                |
|                            | `{:noreply, estado, tiempo_espera}` |
|                            | `{:stop, razón, estado}`            |

### Terminación
| **Callback**                             | **Valor de retorno**                |
| ---------------------------------------- | ----------------------------------- |
| `terminate(razón, estado)`               | `:ok`                               |

### Cambio de código (fuente)
| **Calback**                           | **Valor de retorno**|
| ------------------------------------- | --------------------|
| `code_change(old_vsn, estado, extra)` | `{:ok, estado}`     |
|                                       | `{:error, razón}`   |




